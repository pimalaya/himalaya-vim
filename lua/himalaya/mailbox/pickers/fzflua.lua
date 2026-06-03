local M = {}

local fzf_lua = require("fzf-lua")

M.select = function(cb, mailboxes)
	local mailbox_names = {}
	for _, item in ipairs(mailboxes) do
		table.insert(mailbox_names, item.name)
	end

	local opts = {}
	opts.prompt = "Mailboxes> "
	opts.actions = {
		["default"] = function(selected)
			vim.fn[cb](selected[1])
		end,
	}
	fzf_lua.fzf_exec(mailbox_names, opts)
end

return M
