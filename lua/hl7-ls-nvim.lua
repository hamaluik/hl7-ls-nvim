---@class Config
---@field cmd string The command to run the language server. Default: "hl7-ls"
---@field verbose number The verbosity level. Default: 0
---@field log_file string The log file. Default: nil
---@field on_attach function The on_attach function. Default: nil
local config = {
    cmd = "hl7-ls",
    verbose = 0,
    log_file = nil,
    on_attach = nil
}

---@class MyModule
local M = {}

---@type Config
M.config = config

---@param args Config?
M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
    
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'hl7',
        callback = function(args)
            local cmd = {}
            table.insert(cmd, M.config.cmd)

            if M.config.verbose == 1 then
                table.insert(cmd, '-v')
            elseif verbose == 2 then
                table.insert(cmd, '-vv')
            end

            if M.config.log_file then
                table.insert(cmd, 'log-to-file')
                table.insert(cmd, M.config.log_file)
            end

            vim.lsp.start({
                name = 'hl7-ls',
                cmd = cmd,
                root_dir = vim.fn.getcwd(),
                offset_encoding = 'utf-8',
                on_attach = function(client, bufnr)
                    if M.config.on_attach then
                        M.config.on_attach(client, bufnr)
                    end
                end
            })
        end,
    })
end

return M
