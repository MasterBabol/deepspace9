require("define")
json = require("utils.json")
linkedList = require("utils.linkedlist")
queue = require("utils.queue")
require("utils.subroutine")
require("controllers.cm_site")
require("controllers.rx_site")
require("controllers.tx_site")
require("controllers.rx_signaler")
require("controllers.tx_signaler")
require("controllers.tech_sync")
require("event")

script.on_init
( -- (on new game start)
    function()
        init_global()
        register_events()
        register_rx_external_provider()
    end
)
script.on_load
( -- (on existing game load)
    function()
        register_events()
        register_rx_external_provider()
    end
)
script.on_configuration_changed
(
    function(f)
        ensure_global()
    end
)

function init_global()
    global.rxsites = {}
    global.txsites = {}
    global.rxsignalers = {}
    global.txsignalers = {}
end

function ensure_global()
    if global.rxsites == nil then
        global.rxsites = {}
    end
    if global.txsites == nil then
        global.txsites = {}
    end
    if global.rxsignalers == nil then
        global.rxsignalers = {}
    end
    if global.txsignalers == nil then
        global.txsignalers = {}
    end
end

function register_rx_external_provider()
    commands.add_command
    (
        "confirm_rx_reservation",
        "/confirm_rx_reservation {json}",
        on_rx_reservation
    )
    commands.add_command
    (
        "set_rx_signals",
        "/set_rx_signals {json}",
        on_rx_set_signals
    )
    commands.add_command
    (
        "add_technologies",
        "/on_add_technologies {json}",
        on_add_technologies
    )
end
