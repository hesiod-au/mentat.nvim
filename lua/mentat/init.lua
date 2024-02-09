local Config = require("mentat.config")

local M = {}

M.open_terminal_mentat_all_files = function(size, pre_cmd)
    local buffers = vim.api.nvim_list_bufs()
    local active_buffers = {}

    for _, buf in ipairs(buffers) do
        local is_loaded = vim.api.nvim_buf_is_loaded(buf)
        local is_listed = vim.fn.getbufvar(buf, '&buflisted') == 1
        -- Check if the buffer is displayed in any window
        local is_hidden = vim.fn.bufwinid(buf) == -1

        if is_loaded and is_listed and not is_hidden then
            local name = vim.api.nvim_buf_get_name(buf)
            -- Skip unnamed buffers
            if name ~= "" then
                table.insert(active_buffers, vim.fn.shellescape(name))
            end
        end
    end
    if #active_buffers == 0 then
        print("No active buffers found.")
    else
        _G.buf_result = table.concat(active_buffers, " ")
        print("Active buffers: " .. _G.buf_result)
        vim.cmd('vsplit')
        vim.cmd('wincmd l')
        if size ~= 0 then
            vim.api.nvim_win_set_width(0, size)
        end
        if pre_cmd ~= "" then
            vim.cmd('terminal ' .. pre_cmd ..';' .. ' mentat ' .. _G.buf_result)
        else
            vim.cmd('terminal mentat ' .. _G.buf_result)
        end
        vim.cmd('startinsert')
    end
end


M.open_terminal_mentat_selected_only = function(size, pre_cmd)
    -- Get the current window and buffer
    local original_buffer = vim.api.nvim_get_current_buf()

    -- Generate the new file name based on the original file's extension and current timestamp
    local original_extension = vim.fn.expand('%:e')
    local timestamp = os.date('%y%m%d%H%M%S')
    local new_filename = 'snippet-' .. timestamp .. '.' .. original_extension

    -- Get the selected text from the original buffer
    vim.cmd('normal! y')
    local selected_text = vim.fn.getreg('"')
    local lines = vim.split(selected_text, "\n")

    vim.cmd('vsplit')
    vim.cmd('wincmd h')

    -- Split the window and create a new buffer
    vim.cmd('belowright new')
    vim.cmd('wincmd j')
    local new_buffer = vim.api.nvim_get_current_buf()

    -- Put the text into the new buffer
    vim.api.nvim_buf_set_lines(new_buffer, 0, -1, false, lines)


    -- Save the new buffer to the generated filename
    vim.cmd('write ' .. new_filename)
    vim.cmd('wincmd l')
    if size ~= 0 then
        vim.api.nvim_win_set_width(0, size)
    end
    if pre_cmd ~= "" then
        vim.cmd('terminal ' .. pre_cmd ..';' .. ' mentat ' .. new_filename)
    else
       vim.cmd('terminal mentat ' .. new_filename)
    end
    vim.cmd('startinsert')
end

M.init_keys = function()
    if Config.options.mentat_keybind then
        vim.api.nvim_set_keymap("n", Config.options.mentat_keybind, "<Cmd>lua require('mentat').open_terminal_mentat_all_files(" .. Config.options.mentat_start_width .. "," .. "'" .. Config.options.mentat_pre_cmd .. "'" .. ")<CR>", {silent = true})
        vim.api.nvim_set_keymap("v", Config.options.mentat_keybind, "<Cmd>lua require('mentat').open_terminal_mentat_selected_only(" .. Config.options.mentat_start_width .. "," .. "'" .. Config.options.mentat_pre_cmd .. "'" .. ")<CR>", {silent = true})

        -- vim.api.nvim_set_keymap("n", Config.options.mentat_keybind, "<Cmd>lua require('mentat').open_terminal_mentat_all_files(" .. Config.options.mentat_start_width .. ")<CR>", {silent = true})
        -- vim.api.nvim_set_keymap("v", Config.options.mentat_keybind, "<Cmd>lua require('mentat').open_terminal_mentat_selected_only(" .. Config.options.mentat_start_width .. ")<CR>", {silent = true})
    end
end

M.setup = function(options)
    Config.setup(options)
end

return M
