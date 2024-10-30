# HL7 Language Server for Neovim

This is a plugin for Neovim that provides language server support for HL7 messages. It uses the [hl7-ls](https://github.com/hamaluik/hl7-ls) language server to parse HL7 messages and provides several core LSP features for HL7 messages.

## Installation

### Prerequisites

This plugin requires that you have the `hl7-ls` language server installed. You can install it by following the instructions in the [hl7-ls](https://github.com/hamaluik/hl7-ls) repository.

### Using lazy.nvim

```lua
return {
    {
        "hamaluik/hl7-ls-nvim",
    },
}
```

### Setup options

```lua
require('hl7-ls-nvim').setup({
    verbose = 2, -- 0 = off, 1 = errors, 2 = info, 3 = debug
    log_file = '/tmp/hl7-ls.log', -- log file location, if nil logs to stderr
    on_attach = function(client, bufnr) -- custom on_attach function
        local navic = require('nvim-navic')
        navic.attach(client, bufnr)
    end,
})

```

## Usage

This plugin creates the `hl7` filetype, and will automatically start the language server when you open a file with the `hl7` filetype. The language server will parse the HL7 message and provide diagnostics, hover information, completion suggestions, and more.
