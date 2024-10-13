local M = {}

M.display = function()
	-- vim.api.nvim_command('botright vnew')
	-- local buf = vim.api.nvim_get_current_buf()
	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_name(buf, "BufferList #" .. buf)
	vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
	vim.api.nvim_buf_set_option(buf, 'swapfile', false)
	vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
	vim.api.nvim_buf_set_option(buf, 'filetype', 'nvim-bufferlist')


	vim.api.nvim_buf_set_option(buf, 'modifiable', true)
	-- local buffer_count = vim.api.nvim_win_get_height(win) - 1
	-- print("BufferList" .. vim.inspect(Buffers))
	-- print("Keys" .. vim.inspect(Keys))

	-- Highlights
	vim.api.nvim_set_hl(0, "PedanticTabsLetter",
		{ fg = '#ff007c', bold = true, ctermfg = 198, cterm = { bold = true }, default = true });
	vim.api.nvim_set_hl(0, "PedanticTabsPath",
		{ bg = '#FFFFFF', fg = '#0C1B33', bold = true, ctermfg = 198, cterm = { bold = true }, default = true });

	local buffer_details = {}
	local buffer_count = 0
	local max_chars = 0
	for bufnr, values in pairs(Buffers) do
		local detail = "" .. values["buffername"] .. "		" .. bufnr
		table.insert(buffer_details, detail)

		if string.len(detail) > max_chars then
			max_chars = string.len(detail)
		end

		local filepath = "" .. values["bufferpath"] .. ""
		table.insert(buffer_details, filepath)

		if string.len(filepath) > max_chars then
			max_chars = string.len(filepath)
		end

		table.insert(buffer_details, "")

		vim.api.nvim_buf_set_lines(buf, 0, -1, false, buffer_details)

		buffer_count = buffer_count + 1
	end
	vim.api.nvim_buf_set_option(buf, 'modifiable', false)

	local ui = vim.api.nvim_list_uis()[1]
	local width = max_chars + 2
	local height = buffer_count * 3
	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		col = (ui.width / 2) + (width / 2),
		row = (ui.height / 2) + (height / 2),
		anchor = "SE",
		title = "BufferList",
		style = "minimal",
		border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, 1, win_opts)
	vim.api.nvim_win_set_config(win, win_opts)


	local i = 0
	for _, values in pairs(Buffers) do
		vim.api.nvim_buf_add_highlight(buf, 0, "PedanticTabsLetter", i, values["key_idx"] - 1, values["key_idx"])
		vim.api.nvim_buf_add_highlight(buf, 0, "PedanticTabsPath", i + 1, 0, -1)
		i = i + 3
	end
end

return M
