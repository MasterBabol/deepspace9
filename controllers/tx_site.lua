
function add_tx_context(launch_site_ctx)
    return launch_site_ctx
end

function handle_tx_silo(launch_site_id, launch_site_ctx)
    update_launch_site_invmonitor(launch_site_ctx, defines.inventory.rocket_silo_rocket)
    
    local launch_sig = select_signal(launch_site_ctx.missionctrl.get_merged_signals(), LAUNCH_SIGNAL_NAME)
    if launch_sig and launch_sig.count > 0 then
        launch_site_ctx.last_trans_id = launch_sig.count
        launch_site_ctx.silo.launch_rocket()
    end
end

function create_tx_request(launch_site_ctx, request_items)
    -- TODO: implement
    request =
    {
        id = launch_site_ctx.id,
        items = request_items
    }
    return request
end

function handle_rcon_dequeue_tx_queue(event)
    local tx_req_queue = global.exported_tx_req_queue
    if tx_req_queue == nil then
        tx_req_queue = {}
    end
    rcon.print(json.stringify(tx_req_queue))
    if DEBUG then
        broadcast_msg_all(json.stringify(tx_req_queue))
    end
    global.exported_tx_req_queue = {}
end

function send_tx_request(request)
    local tx_req_queue = global.exported_tx_req_queue
    if tx_req_queue == nil then
        tx_req_queue = {}
    end
    tx_req_queue[#tx_req_queue + 1] = request
    global.exported_tx_req_queue = tx_req_queue
end

function handle_tx_rocket_launched(launch_site_id, launch_site_ctx, rocket)
    local inv = rocket.get_inventory(defines.inventory.rocket)
    if (inv) then
        local request_items = inv.get_contents()
        local request = create_tx_request(launch_site_ctx, request_items)
        send_tx_request(request)
    end
end

function handle_tx_silo_destroy(launch_site_ctx)
end
