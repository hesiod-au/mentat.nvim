local M = {}
function M.defaults()
    local defaults = {
        mentat_keybind = "<C-m>", -- key combo string
        mentat_start_width = 0, --columns, nil for 50:50 split
    }
    return defaults
end

M.options = {}

function M.setup(options)
    options = options or {}
    M.options = vim.tbl_deep_extend("force", {}, M.defaults(), options)
end

return M
