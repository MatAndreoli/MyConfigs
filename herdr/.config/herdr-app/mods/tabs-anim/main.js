import { View, div, svg, image } from "gpui-kit";
import { h_flex } from "gpui-base";
import { props, spaces, panes, run, openOverlay, theme, window, shared, layout, settings, setShared, closeOverlay } from "herdr";

function find(node, id) {
  if (node?.id === id) return node;
  for (const child of node?.children ?? []) {
    const found = find(child, id);
    if (found) return found;
  }
  return null;
}

export default class Tabs extends View {
  init() {
    setShared("flow.popup", { open: false }); // a popup can't outlive the app: clear a stale "open"
    this.pressed = null;
    this.panels = JSON.parse(localStorage.getItem("panels") ?? "{}");
  }

  // The side panel is remembered per space: switching shows that space's choice
  // (closed if it never had one), and opening or closing it records it.
  syncPanel(space, panel, body, enabled) {
    if (!space || !panel) return;
    const now = panel.hidden ? null : body?.active ?? null;
    if (space.id !== this.space) {
      const first = this.space === undefined;
      this.space = space.id; this.pending = null;
      if (!(first && !(space.id in this.panels))) {
        const stored = this.panels[space.id] ?? null, want = enabled.includes(stored) ? stored : null;
        if (want !== now) {
          this.pending = { want, until: Date.now() + 1000 };
          if (want) { run("layout.select", { stack: "panel-body", child: want }); run("layout.show", { id: "panel" }); }
          else run("layout.hide", { id: "panel" });
          return;
        }
      }
    }
    // Until the restore lands (or something else won), the old state isn't a choice.
    if (this.pending) {
      if (this.pending.want !== now && Date.now() < this.pending.until) return;
      this.pending = null;
    }
    if (this.panels[space.id] === now) return;
    this.panels[space.id] = now;
    localStorage.setItem("panels", JSON.stringify(this.panels));
  }

  render() {
    const t = theme();
    const variant = props()?.variant ?? "slide";
    this.tabW ??= {};
    const chip = variant === "stretch", gap = chip ? 0 : 3;
    const space = spaces().find(p => p.active);
    const shown = space?.tabs ?? [];
    const stop = (_e, cx) => cx.stop_propagation();
    const button = (id, label, action) => div().id(id).size(26).flex_none().flex().items_center().justify_center().rounded(6).text_color(t.dim).hover(s => s.bg(t.hover).text_color(t.foreground))
      .on_mouse_down("left", stop).on_click(action).child(label);
    // Where the active tab sits in the strip, from the widths each tab reported.
    const spot = () => {
      const i = shown.findIndex(c => c.active);
      if (i < 0 || shown.slice(0, i + 1).some(c => this.tabW[c.id] === undefined)) return null;
      return { left: shown.slice(0, i).reduce((x, c) => x + this.tabW[c.id] + gap, 0), width: this.tabW[shown[i].id] };
    };
    // Two springs per pill, one per edge: the edge facing the direction of travel is stiff, the other soft,
    // so the pill stretches toward the new tab and then pulls its tail in. Native springs only reach `left`
    // and `width`, so the right edge is an outer box (`width` = right edge) and the left edge is the inner
    // pill's `left`, which runs to the outer's right side. Values are the Tab Pill's 620/40 and 170/19
    // (stiffness/damping) as response (2π/√k ms) and damping ratio (c/2√k).
    const stretch = () => {
      const at = spot();
      if (!at) return null;
      const activeId = shown.find(c => c.active)?.id;
      if (activeId !== this.activeId) {
        const from = shown.findIndex(c => c.id === this.activeId), to = shown.findIndex(c => c.id === activeId);
        if (from >= 0) this.dir = to > from ? 1 : -1;
        this.activeId = activeId;
      }
      const lead = { response: 252, damping: 0.8 }, trail = { response: 482, damping: 0.73 };
      const right = (this.dir ?? 1) > 0;
      return div().id("tab-stretch").absolute().left(0).top(0).h(27).w(at.left + at.width)
        .spring("width", right ? lead : trail)
        .child(div().id("tab-stretch-pill").absolute().left(at.left).right(0).top(0).bottom(0).rounded(999)
          .bg(t.foreground)
          .spring("left", right ? trail : lead));
    };
    const indicator = () => {
      if (variant === "stretch") return stretch();
      const at = spot();
      if (!at || !["slide", "spring", "underline"].includes(variant)) return null;
      const line = variant === "underline";
      const el = div().id("tab-indicator").absolute()
        .left(line ? at.left + 8 : at.left).w(line ? at.width - 16 : at.width)
        .top(line ? 37 : 6).h(line ? 2 : 29).rounded(line ? 1 : 7)
        .bg(line ? t.accent : t.raised);
      if (!line) el.border(1).border_color(t.border);
      if (variant === "spring" || variant === "underline") return el.spring("left", { response: 320, damping: 0.55 }).spring("width", { response: 320, damping: 0.55 });
      const ease = { duration: variant === "underline" ? 260 : 220, easing: "ease-out" };
      return el.transition("left", ease).transition("width", ease);
    };
    // The underline's variant also gets the active tab's background, a pill that travels with it.
    const highlight = () => {
      const at = spot();
      if (!at || variant !== "underline") return null;
      return div().id("tab-highlight").absolute().left(at.left).w(at.width).top(6).h(29).rounded(7).bg(t.selected)
        .spring("left", { response: 320, damping: 0.55 }).spring("width", { response: 320, damping: 0.55 });
    };
    const item = (c, i) => {
      const program = panes().find(p => p.tab === c.id && p.program?.agent)?.program ?? panes().find(p => p.tab === c.id)?.program;
      const name = /^tb\d+$/.test(c.name) ? program?.name ?? "Terminal" : c.name;
      const tab = h_flex().id(`tab-${c.id}`).h(29).px(10).gap(7).rounded(7).items_center().flex_none().text_size(12.8)
        .on_size_change((sz, cx) => { if (this.tabW[c.id] !== sz.width) { this.tabW[c.id] = sz.width; cx.notify(); } })
        .border(1).text_color(c.active ? t.foreground : t.muted);
      if (variant === "fade") {
        // Colors can't animate, so the active look is a layer whose opacity does.
        tab.relative().border_color(t.chrome).bg(t.chrome).hover(s => s.bg(t.hover))
          .child(div().absolute().inset_0().rounded(7).border(1).border_color(t.border).bg(t.raised)
            .opacity(c.active ? 1 : 0).transition("opacity", { duration: 200, easing: "ease-out" }));
      } else if (variant === "grow") {
        tab.h(c.active ? 33 : 25).transition("height", { duration: 180, easing: "ease-out" })
          .border_color(c.active ? t.border : t.chrome).bg(c.active ? t.raised : t.chrome).hover(s => s.bg(t.hover));
      } else if (variant === "stretch") {
        // The pill travels behind the tabs, so they paint nothing of their own (an opaque tab would hide it).
        tab.h(27).px(14).rounded(999).border_color("#00000000").text_color(c.active ? "#07090f" : t.muted)
          .when(!c.active, el => el.hover(s => s.text_color(t.foreground)));
      } else {
        // slide / spring / underline: an indicator travels behind the tabs, the tabs stay bare.
        tab.border_color(t.chrome).bg(t.chrome).hover(s => s.bg(t.hover));
        if (variant === "underline") tab.rounded(7);
      }
      return tab
        .on_mouse_down("left", (e, cx) => { cx.stop_propagation(); this.pressed = i; if (e.click_count === 2) run("tab.rename", { id: c.id }); })
        .on_mouse_up("left", () => {
          const from = this.pressed; this.pressed = null;
          if (from !== null && from !== i) run("tab.move", { id: shown[from].id, index: space.tabs.findIndex(x => x.id === c.id) + 1 });
          else run("tab.select", { id: c.id });
        })
        .on_mouse_down("right", (_e, cx) => { cx.stop_propagation(); openOverlay({ mod: "menu", kind: "popup", width: 200, props: { tab: "tab", target: { id: c.id, space: space.id } } }); })
        .when(Boolean(program?.icon), el => el.child(program.tint ? svg(program.icon).size(14).text_color(chip && c.active ? "#07090f" : t.muted) : image(program.icon).size(14)))
        .child(div().max_w(170).truncate().child(c.zoomed ? `${name} Z` : name))
        .when(c.status === "working", el => el.child(svg("mods/workspace-chrome/spinner.svg").size(12).flex_none().text_color(t.working).spin(900)))
        .when(c.status === "blocked" || c.status === "done", el => el.child(div().size(6).rounded(3).bg(t[c.status])))
        .when(c.active, el => el.child(div().id(`close-${c.id}`).text_color(chip ? "#07090f99" : t.dim).on_mouse_down("left", stop).on_click((_e, cx) => { cx.stop_propagation(); run("tab.close", { id: c.id }); }).child(svg("mods/pane/close.svg").size(12))));
    };
    const root = layout(), sidebar = find(root, "sidebar"), w = window();
    // Old saved rails and a dragged-narrow sidebar can be smaller than the window buttons.
    const lightsPadding = w?.platform === "macos" && w.titlebar === "none" && !w.fullscreen && root?.traffic_lights
      ? Math.max(10, (root.traffic_lights[0] + 64) / settings().zoom - (sidebar?.hidden ? 0 : sidebar?.size?.px ?? 0))
      : 10;
    const panel = find(root, "panel"), body = find(root, "panel-body");
    const enabled = shared("workspace.panels") ?? ["files", "changes"];
    this.syncPanel(space, panel, body, enabled);
    const panelButton = (id, label, icon) => {
      const on = panel && !panel.hidden && body?.active === id;
      return h_flex().id(`panel-${id}`).h(26).px(8).gap(5).flex_none().items_center().rounded(6)
        .text_size(12).bg(on ? t.selected : t.chrome).text_color(on ? t.foreground : t.muted)
        .hover(s => s.bg(t.hover)).on_mouse_down("left", stop)
        .on_click(() => {
          if (on) run("layout.hide", { id: "panel" });
          else { run("layout.select", { stack: "panel-body", child: id }); run("layout.show", { id: "panel" }); }
        }).child(svg(icon).size(14)).child(label);
    };
    return h_flex().id("tabs-root").on_size_change((sz, cx) => { if (sz.width !== this.barW) { this.barW = sz.width; cx.notify(); } }).size_full().min_w(0).px(10).pl(lightsPadding).gap(3).items_center().bg(t.chrome).border_b(1).border_color(t.border)
      .on_mouse_up("left", () => { this.pressed = null; })
      .on_scroll_wheel(e => { if (Math.abs(e.delta.y) >= 1) run(e.delta.y > 0 ? "tab.prev" : "tab.next"); })
      .child(h_flex().id("tab-scroll").flex_1().min_w(0).h_full().items_center().gap(3).overflow_x_scrollbar()
        .child(h_flex().id("tab-chip").items_center().flex_none()
          .when(chip, el => el.p(4).rounded(999).bg(t.background).border(1).border_color(t.border))
          .child(h_flex().id("tab-strip").relative().when(!chip, el => el.h_full()).when(chip, el => el.h(27)).items_center().gap(gap).flex_none()
            .children([highlight(), indicator(), ...shown.map(item)].filter(Boolean)))))
      .child(button("tab-new", "+", () => openOverlay({ mod: "new-menu", kind: "popup", width: 250, height: 512 })))
      .when(enabled.includes("files"), el => el.child(panelButton("files", "Files", "mods/files/file.svg")))
      .when(enabled.includes("changes"), el => el.child(panelButton("changes", "Changes", "mods/changes/changes.svg")))
      .child(h_flex().id("flow-usage").h(26).px(8).gap(5).flex_none().items_center().rounded(6)
        .on_size_change((sz) => { this.flowW = sz.width; })
        .text_size(12).bg(t.chrome).text_color(t.muted).hover(s => s.bg(t.hover)).on_mouse_down("left", stop)
        .on_click(() => {
          // Toggle: an outside click (this one included) dismisses the popup before we run, so a popup that
          // closed a moment ago was closed by this very click and must stay closed.
          const st = shared("flow.popup");
          if (st?.open) { closeOverlay(st.id); return; }
          if (st?.closedAt && Date.now() - st.closedAt < 300) return;
          // Click coordinates don't reach this handler, so anchor from layout facts instead: the bar's measured
          // width plus the sidebar's puts the window's right edge; the popup sits under the bar, right-aligned
          // just inside the window buttons.
          const sb = find(layout(), "sidebar");
          const sidebarW = sb?.hidden ? 0 : sb?.size?.px ?? shared("sidebar.width") ?? 0;
          // The card is the button grown (a morph popover): it opens over the button, right edges aligned.
          // The button's right edge is the bar's, less its padding (10) and the three window buttons (26 + 3 gap each).
          const right = sidebarW + (this.barW ?? 0) - (w?.buttons ? 97 : 10);
          openOverlay({ mod: "flow-usage", kind: "popup", frame: "none", width: 300, height: 168, at: { x: Math.max(8, right - 300), y: 8 },
            props: { from: { w: this.flowW ?? 112, h: 26 } } });
        })
        .child(svg("mods/tabs-anim/usage.svg").size(14)).child("Flow Budget"))
      .when(w?.buttons, el => el.child(button("minimize", w.platform === "windows" ? svg("mods/tabs-anim/win-min.svg").size(16) : "−", () => run("window.minimize")))
        .child(button("maximize", w.platform === "windows" ? svg(`mods/tabs-anim/${w.maximized ? "win-restore" : "win-max"}.svg`).size(16) : "□", () => run("window.maximize")))
        .child(button("close-window", w.platform === "windows" ? svg("mods/tabs-anim/win-close.svg").size(16) : svg("mods/pane/close.svg").size(13), () => run("window.close"))));
  }
}
