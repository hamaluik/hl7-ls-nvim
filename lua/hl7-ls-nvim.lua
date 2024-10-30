---@class Config
---@field cmd string The command to run the language server. Default: "hl7-ls"
---@field verbose number The verbosity level. Default: 0
---@field log_colours string The log colours. Default: nil, possible values: "always", "never", "auto"
---@field log_file string The log file. Default: nil
---@field on_attach function The on_attach function. Default: nil
local config = {
    cmd = "hl7-ls",
    verbose = 0,
    log_colours = nil,
    log_file = nil,
    on_attach = nil,
    default_hostname = "127.0.0.1",
    default_port = 2575,
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
            elseif M.config.verbose >= 2 then
                table.insert(cmd, '-vv')
            end

            if M.config.log_colours ~= nil then
                table.insert(cmd, '--colour')
                table.insert(cmd, M.config.log_colours)
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

local function round(num)
    return math.floor(num + 0.5)
end

---@class SendMessageParams
local sendMessageParams = {
    hostname = nil,
    port = nil,
}

---@param params SendMessageParams
M.sendMessage = function(params)
    local clients = vim.lsp.get_clients({
        bufnr = vim.api.nvim_get_current_buf(),
        name = 'hl7-ls'
    })

    if #clients == 0 then
        vim.notify('No hl7-ls client attached', vim.log.levels.WARN)
        return
    end

    if params == nil then
        params = {}
    end
    local hostname = params.hostname or nil
    local port = params.port or nil

    -- get the hostname from an nvim input if they aren't provided
    if hostname == nil then
        hostname = vim.fn.input('Hostname: ', M.config.default_hostname) -- TODO: keep a record of host names in a table and offer completion for them
    end
    if port == nil then
        port = vim.fn.input('Port: ', M.config.default_port)
    end
    port = tonumber(port)
    if port == nil then
        vim.notify('Invalid port number', vim.log.levels.ERROR)
        return
    end

    local text_document_params = vim.lsp.util.make_text_document_params()

    local client = clients[1]
    client.request('workspace/executeCommand', {
        command = 'hl7.sendMessage',
        arguments = {
            text_document_params.uri,
            hostname,
            port,
        }
    }, function(err, result, ctx, config)
            if err or result == nil then
                vim.notify('Failed to send message: ' .. err.message, vim.log.levels.ERROR)
            else
                -- create an empty scratch buffer to display the response
                local buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, '\n'))
                vim.api.nvim_buf_set_option(buf, 'filetype', 'hl7')

                -- size the window appropriately (half the size of the current window, but at least 80x20)
                ui = vim.api.nvim_list_uis()[1]
                local width = round(ui.width * 0.5)
                local height = round(ui.height * 0.5)
                if width < 80 then
                    width = ui.width - 4
                end
                if height < 20 then
                    height = ui.height - 4
                end

                -- finally, open the window with the response
                local win = vim.api.nvim_open_win(buf, true, {
                    relative = 'editor',
                    width = width,
                    height = height,
                    row = (ui.height - height) / 2,
                    col = (ui.width - width) / 2,
                    style = 'minimal',
                    border = 'double',
                    title = 'HL7 Message Response',
                })
            end
        end)
end

return M
