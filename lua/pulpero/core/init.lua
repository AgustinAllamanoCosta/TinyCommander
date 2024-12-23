local Runner = require('model_runner')
local Setup = require('setup')
local Logger = require('logger')
local Parser = require('parser')
local app = require('milua')

local runner = nil
local parser = nil
local logger = nil
local setup = nil
local config = {}

local function start()
    logger = Logger.new()
    logger:clear_logs()
    setup = Setup.new(logger)
    config = setup:configure_plugin()
    setup:prepear_env()

    parser = Parser.new(config)
    runner = Runner.new(config, logger, parser)

    app.add_handler(
    "GET",
    "/",
    function()
        return "The server is running"
    end)
    app.add_handler(
    "POST",
    "/explain",
    function (captures, query, headers, body)
        local lang = query.lang
        local success,  error = runner:explain_function(body, lang)
        if success then
            return success
        else
            return error
        end
    end)
    app.start()
end

start()
