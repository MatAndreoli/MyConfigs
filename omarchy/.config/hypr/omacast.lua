o.bind("SUPER + SPACE", "omacast launcher", hl.dsp.global("omacast:toggle"), { submap_universal = true })
-- While omacast is open it switches Hyprland to this submap, so Super+J/K reach the launcher.
hl.define_submap("omacast", function()
	hl.bind("SUPER + F24", hl.dsp.no_op()) -- a submap needs one bind to exist
end)
-- Blur behind the launcher under Glassy Windows.
hl.layer_rule({ match = { namespace = "^omacast$" }, blur = true, ignore_alpha = 0.3 })
