# Neovim Mentat Plugin

This Neovim plugin integrates the Mentat CLI programming tool, allowing users to quickly launch Mentat with context from their current editing session. It supports sending either all open files or just the selected text to Mentat for processing.

## Features

- Launch Mentat with all open files in Neovim.
- Launch Mentat with only the selected text.
- Customizable keybindings for both modes of operation.

## Installation

To install the plugin, use your preferred Neovim package manager.

For example, with vim-plug:

```vim
Plug 'hesiod-au/mentat.nvim'
```

Example packer install with config:

```lua
use { "hesiod-au/mentat.nvim/",
    config = function()
        require("mentat").setup(
        {
            mentat_keybind = "<C-m>", -- key combo string
            mentat_start_width = 0, --columns, 0 for 50:50 split
        })
    end
}
```


Then run `:PlugInstall` in Neovim.

## Configuration

The plugin can be configured by setting options in your `init.vim` or `init.lua`. Here are the default options:

```lua
require('mentat').setup({
    mentat_keybind = "<C-m>", -- Keybinding to launch Mentat
    mentat_start_width = 0, -- Width of the Mentat window, 0 for a 50:50 split
})
```

## Usage

After installing and configuring the plugin, you can use the following keybindings:

- `<C-m>` in normal mode to launch Mentat with all open files.
- `<C-m>` in visual mode to launch Mentat with the selected text only.

You can also call the plugin functions directly in your Neovim command line:

```vim
:lua require('mentat').open_terminal_mentat_all_files(size)
:lua require('mentat').open_terminal_mentat_selected_only(size)
```

Replace `size` with the desired width of the Mentat window, or pass 0 to do a 50:50 split.

## Contributing

Contributions are welcome! If you'd like to contribute to the project, please fork the repository and submit a pull request with your changes.

```
