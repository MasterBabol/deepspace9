
RXSTATE_LOW_BOUNDARY = 0
RXSTATE_IDLE = 0
RXSTATE_TRANS_RESERVING = 1
RXSTATE_LAUNCH_READY = 2
RXSTATE_LAUNCHED = 3
RXSTATE_HIGH_BOUNDARY = 3

RX_REQTYPE_RESERVE = 1
RX_REQTYPE_REVOKE = 2
RX_REQTYPE_RETURN = 3

function add_rx_context(launch_site_ctx)
    set_rx_site_state(launch_site_ctx, RXSTATE_IDLE)
    launch_site_ctx.last_working_request = nil
    launch_site_ctx.last_worked_request = nil
    return launch_site_ctx
end

function set_rx_site_state(launch_site_ctx, state)
    if (state < RXSTATE_LOW_BOUNDARY) or (state > RXSTATE_HIGH_BOUNDARY) then
        error("[-] Undefined RX launch site state: "..state)
    end
    launch_site_ctx.state = state
    local color = "white"
    if state == RXSTATE_TRANS_RESERVING then
        color = "yellow"
    elseif state == RXSTATE_LAUNCH_READY then
        color = "green"
    elseif state == RXSTATE_LAUNCHED then
        color = "blue"
    elseif state == RXSTATE_TRANS_REVOKING then
        color = "red"
    end
    set_lampctrl(launch_site_ctx.missionctrl_lampctrl, color)
end

function create_rx_reserve_request(launch_site_ctx, request_type)
    local signals = launch_site_ctx.missionctrl.get_merged_signals()
    request =
    {
        id = launch_site_ctx.id,
        items = signal_to_item(signals),
        type = request_type,
        ttl = RX_WAITING_TIMEOUT_INTICKS
    }
    return request
end

function handle_rcon_dequeue_rx_queue(event)
    local rx_req_queue = global.exported_rx_req_queue
    if rx_req_queue == nil then
        rx_req_queue = {}
    end
    rcon.print(json.stringify(rx_req_queue))
    if DEBUG then
        broadcast_msg_all(json.stringify(rx_req_queue).."\n")
    end
    global.exported_rx_req_queue = {}
end

function send_rx_request(request)
    local rx_req_queue = global.exported_rx_req_queue
    if rx_req_queue then
        rx_req_queue[#rx_req_queue + 1] = request
    else
        global.exported_rx_req_queue = {}
    end
end

function enqueue_rx_request_dispatch(request)
    if global.rxqueue_req == nil then
        global.rxqueue_req = linkedList.newNode(request)
    else
        linkedList.insert(global.rxqueue_req.prev, request) -- push last
    end
end

function enqueue_rx_request_completion(request)
    if global.rxqueue_comp == nil then
        global.rxqueue_comp = linkedList.newNode(request)
    else
        linkedList.insert(global.rxqueue_comp.prev, request) -- push last
    end
end

function remove_rx_request_dispatch(request)
    local target_node
    if global.rxqueue_req then
        local rxq = global.rxqueue_req
        local it = rxq
        
        repeat
            if it.value.id == request.id then
                -- found target request
                target_node = it
                break
            end
            
            it = it.next
        until it == rxq
        
        if target_node then
            if linkedList.erase(target_node) == nil then
                global.rxqueue_req = nil
            end
        end
    end
    local removed_val
    if target_node then
        removed_val = target_node.value
    end
    return removed_val
end

function cancel_rx_request_dispatch(request)
    remove_rx_request_dispatch(request)
end

function complete_rx_request_dispatch(request)
    local target_node = nil
    if global.rxqueue_comp then
        local rxq = global.rxqueue_comp
        local it = rxq
        
        repeat
            if it.value.id == request.id then
                -- found target request
                target_node = it
                break
            end
            
            it = it.next
        until it == rxq
        
        if target_node then
            if linkedList.erase(target_node) == nil then
                global.rxqueue_comp = nil
            end
        end
    end
    local found_req_val
    if target_node then
        found_req_val = target_node.value
    end
    return found_req_val
end

function confirm_rx_request_dispatch_from_external(decoded_response)
    if global.rxqueue_req then
        target_req = remove_rx_request_dispatch(decoded_response)
        if target_req then
            enqueue_rx_request_completion(decoded_response)
            return
        else
            if DEBUG then
                broadcast_msg_all("[!] A RX reservation has arrived, but there is no target request")
            end
        end
    end
    -- there is no rxqueue_req and the request but a response has arrived, so revoke
    decoded_response.type = RX_REQTYPE_REVOKE
    send_rx_request(decoded_response)
end

function handle_rx_silo(launch_site_id, launch_site_ctx)
    update_launch_site_invmonitor(launch_site_ctx, defines.inventory.rocket_silo_result)
    
    local cur_state = launch_site_ctx.state
    
    if (game.tick % TICK_HANDLER_PERIOD) ~= 0 then
        -- beelike process
        if cur_state == RXSTATE_IDLE then
            local missionctrl_sigs = launch_site_ctx.missionctrl.get_merged_signals()
            launch_sig = select_signal(missionctrl_sigs, LAUNCH_SIGNAL_NAME)
            if launch_sig then
                local request = create_rx_reserve_request(launch_site_ctx, RX_REQTYPE_RESERVE)
                send_rx_request(request)
                enqueue_rx_request_dispatch(request)
                launch_site_ctx.last_working_request = request
                set_rx_site_state(launch_site_ctx, RXSTATE_TRANS_RESERVING)
            end
        elseif cur_state == RXSTATE_LAUNCH_READY then
            if launch_site_ctx.silo.launch_rocket() then -- auto launch
                set_rx_site_state(launch_site_ctx, RXSTATE_LAUNCHED)
            end
        end
    else
        -- lazy process
        if cur_state == RXSTATE_TRANS_RESERVING then
            local req = launch_site_ctx.last_working_request
            local comp = complete_rx_request_dispatch(req)
            if comp then
                launch_site_ctx.last_worked_request = comp
                set_rx_site_state(launch_site_ctx, RXSTATE_LAUNCH_READY)
            else
                req.ttl = req.ttl - TICK_HANDLER_PERIOD
                if req.ttl < 0 then
                    cancel_rx_request_dispatch(req)
                    req.type = RX_REQTYPE_REVOKE
                    req.ttl = nil
                    send_rx_request(req) -- revoke previous request
                    set_rx_site_state(launch_site_ctx, RXSTATE_IDLE)
                end
            end
        -- elseif cur_state == RXSTATE_LAUNCHED then
            -- Do nothing here, on_rocket_launched handler (handle_rx_rocket_launched) will do work instead
        end
    end
    
    if (cur_state < RXSTATE_LOW_BOUNDARY) or (cur_state > RXSTATE_HIGH_BOUNDARY) then
        error("[-] Undefined RX launch site state: "..cur_state)
    end
end

function handle_rx_rocket_launched(launch_site_id, launch_site_ctx, rocket)
    if launch_site_ctx.state == RXSTATE_LAUNCHED then
        local rocket_result_inv = launch_site_ctx.silo.get_inventory(defines.inventory.rocket_silo_result)
        local comp = launch_site_ctx.last_worked_request
        if comp then
            if comp.items then
                if DEBUG then
                    broadcast_msg_all("[+] A RX rocket is launched, received "..#comp.items.." items")
                end
                for _, item in pairs(comp.items) do
                    local to_insert_count = item.count
                    local inserted_count = rocket_result_inv.insert(item)
                    local not_inserted_count = to_insert_count - inserted_count
                    item.count = not_inserted_count
                end
                comp.type = RX_REQTYPE_RETURN
                comp.ttl = nil
                send_rx_request(comp) -- return not inserted items
                set_rx_site_state(launch_site_ctx, RXSTATE_IDLE)
            end
        else
            broadcast_msg_all("[!] A RX rocket is wasted: rocket was launched, but there was no target request")
        end
    else
        broadcast_msg_all("[!] A RX rocket is wasted: rocket was launched without a launch signal and requests")
    end
end

function handle_rx_silo_destroy(launch_site_ctx)
    if launch_site_ctx.state ~= RXSTATE_IDLE then
        local req = launch_site_ctx.last_working_request
        if req then
            req.type = RX_REQTYPE_REVOKE
            req.ttl = nil
            send_rx_request(req) -- revoke previous request
        else
            error("[-] Unexpected RX launch site state: last_working_request is nil")
        end
    end
end
