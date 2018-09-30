
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

function send_tx_request(request)
    if DEBUG then
        game.write_file(TXQUEUE_FILENAME, json.stringify(request).."\n", true)
    else
        game.write_file(TXQUEUE_FILENAME, json.stringify(request), true, 0)
    end
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
