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
require("controllers.rx_elec")
require("controllers.tx_elec")
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
    global.rxelecs = {}
    global.txelecs = {}
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
    if global.rxelecs == nil then
        global.rxelecs = {}
    end
    if global.txelecs == nil then
        global.txelecs = {}
    end
end

function register_rx_external_provider()
    commands.add_command
    (
        "dequeue_rx_queue",
        "/dequeue_rx_queue",
        on_dequeue_rx_queue
    )
    
    commands.add_command
    (
        "dequeue_tx_queue",
        "/dequeue_tx_queue",
        on_dequeue_tx_queue
    )

    commands.add_command
    (
        "collect_tx_signals",
        "/collect_tx_signals",
        on_collect_tx_signals
    )

    commands.add_command
    (
        "collect_rx_signal_reqs",
        "/collect_rx_signal_reqs",
        on_collect_rx_signal_reqs
    )

    commands.add_command
    (
        "collect_rx_elec_reqs",
        "/collect_rx_elec_reqs",
        on_collect_rx_elec_reqs
    )

    commands.add_command
    (
        "collect_tx_elecs",
        "/collect_tx_elecs",
        on_collect_tx_elecs
    )

    commands.add_command
    (
        "set_rx_elecs",
        "/set_rx_elecs",
        on_set_rx_elecs
    )

    commands.add_command
    (
        "collect_technology_researches",
        "/collect_technology_researches",
        on_collect_technology_researches
    )

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
        "set_technologies",
        "/set_technologies {json}",
        on_set_technologies
    )
    commands.add_command
    (
        "add_technologies",
        "/add_technologies {json}",
        on_add_technologies
    )
end
