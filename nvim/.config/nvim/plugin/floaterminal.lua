local state = {
  floating = {
    buf = -1,
    win = -1,
  },
  bottom = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Define window configuration
  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

local function create_bottom_terminal(opts)
  opts = opts or {}
  local width = opts.width or vim.o.columns
  local height = opts.height or math.floor(vim.o.lines * 0.3)

  -- Position at the bottom of the screen
  local col = 0
  local row = vim.o.lines - height

  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Define window configuration
  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

local function start_insert_mode()
  vim.schedule(function()
    vim.cmd 'startinsert'
  end)
end

local function focus_terminal_window(win_id)
  vim.api.nvim_set_current_win(win_id)
  start_insert_mode()
end

local function toggle_terminal()
  local is_floating_win_valid = vim.api.nvim_win_is_valid(state.floating.win)

  -- If window exists but is not focused, focus it
  if is_floating_win_valid and vim.api.nvim_get_current_win() ~= state.floating.win then
    focus_terminal_window(state.floating.win)
    return
  end

  -- If window doesn't exist, create it
  if not is_floating_win_valid then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
    start_insert_mode()
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

local function toggle_bottom_terminal()
  local is_botton_win_valid = vim.api.nvim_win_is_valid(state.bottom.win)

  -- If window exists but is not focused, focus it
  if is_botton_win_valid and vim.api.nvim_get_current_win() ~= state.bottom.win then
    focus_terminal_window(state.bottom.win)
    return
  end

  -- If window doesn't exist, create it
  if not is_botton_win_valid then
    state.bottom = create_bottom_terminal { buf = state.bottom.buf }
    if vim.bo[state.bottom.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
    start_insert_mode()
  else
    vim.api.nvim_win_hide(state.bottom.win)
  end
end

vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {})
vim.api.nvim_create_user_command('BottomTerminal', toggle_bottom_terminal, {})

vim.keymap.set({ 'n', 't' }, '<C-t>t', toggle_terminal, { desc = '[T]oggle [T]erminaL (floating)' })
vim.keymap.set({ 'n', 't' }, '<C-t>b', toggle_bottom_terminal, { desc = '[T]oggle [B]ottom Terminal (floating)' })
