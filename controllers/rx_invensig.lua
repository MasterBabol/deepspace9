
function create_rx_signaler(signaler_entity, surface)
    local rxsignalerctrl_entity

    local signaler_entities = surface.find_entities(
        {
            {
                signaler_entity.position.x - 1.2,
                signaler_entity.position.y - 1.2
            },
            {
                signaler_entity.position.x + 1.2,
                signaler_entity.position.y + 1.2
            }
        }
    )
    
    for key, entity in pairs(signaler_entities) do
        if entity.valid then
            if (entity.name == RXSIGNALERCTRL_NAME) then
                rxsignalerctrl_entity = entity
            elseif (entity.name == "entity-ghost" and entity.ghost_name == RXSIGNALERCTRL_NAME) then
                _, rxsignalerctrl_entity = entity.revive()
            end
        end
    end
    
    rxsignalerctrl_entity = (rxsignalerctrl_entity) or
    surface.create_entity
    (
        {
            name = RXSIGNALERCTRL_NAME,
            player = player_idx,
            force = signaler_entity.force,
            position =
            {
                signaler_entity.position.x,
                signaler_entity.position.y
            }
        }
    )
    rxsignalerctrl_entity.operable = false
    rxsignalerctrl_entity.minable = false
    rxsignalerctrl_entity.destructible = false
    
    rxsignalerctrl_entity.connect_neighbour
    (
        {
            target_entity = signaler_entity,
            wire = defines.wire_type.green,
            target_circuit_id = 1
        }
    )
    
    local ctx =
    {
        id = signaler_entity.unit_number,
        signaler = signaler_entity,
        signalerctrl = rxsignalerctrl_entity
    }
    return ctx
end

function handle_rx_signaler(signaler_id, signaler_ctx)
    --[[local signaler_entity = signaler_ctx.signaler
    local acc_sigs = global.rxsignals_accum
    if acc_sigs then
        local filtered_signals = {}
        local beh = signaler_entity.get_control_behavior()
        local are_there_undefined_sigs = false
        
        for idx = 1, #acc_sigs do
            local sig = acc_sigs[idx].signal
            local is_valid = false
            if sig.type == "item" then
                if game.item_prototypes[sig.name] then
                    is_valid = true
                end
            elseif sig.type == "fluid" then
                if game.fluid_prototypes[sig.name] then
                    is_valid = true
                end
            elseif sig.type == "virtual" then
                if game.virtual_signal_prototypes[sig.name] then
                    is_valid = true
                end
            end
            
            if is_valid then
                are_there_undefined_sigs = true
                new_idx = #filtered_signals + 1
                filtered_signals[new_idx] = acc_sigs[idx]
                filtered_signals[new_idx].index = idx
            end
        end
        if DEBUG and are_there_undefined_sigs == true then
            broadcast_msg_all("[-] Undefined signal received")
        end
        
        beh.parameters = { parameters = filtered_signals }
    else
        signaler_entity.get_control_behavior().parameters =
        {
            parameters = {}
        }
    end]]--
end

function set_rx_signals(decoded_response)
    local rxsignalers = global.rxsignalers
    if rxsignalers then
        for _, signaler_req in pairs(decoded_response) do
            local id = signaler_req.id
            local rxsignaler = rxsignalers[id]
            if (rxsignaler) then
                rxsignaler.signalerctrl.get_control_behavior().parameters =
                {
                    parameters = 
                    {
                        {
                            index = 1,
                            signal = 
                            {
                                type=signaler_req.type,
                                name=signaler_req.name
                            },
                            count = signaler_req.count
                        }
                    }
                }
            end
        end
    end
end

function collect_rx_signal_reqs()
    local acc_sigs = {}
    if (global.rxsignalers) then
        for key, ctx in pairs(global.rxsignalers) do
            local fs = ctx.signaler.get_or_create_control_behavior().parameters.parameters.first_signal
            if (fs.name) then
                acc_sigs[#acc_sigs + 1] =
                {
                    id = key,
                    name = fs.name,
                    type = fs.type
                }
            end
        end
    end
    return acc_sigs;
end

function handle_rcon_collect_rx_signal_reqs(event)
    local rx_sigs = collect_rx_signal_reqs()
    if rx_sigs then
        rcon.print(json.stringify(rx_sigs))
        
        if DEBUG then
            broadcast_msg_all(json.stringify(rx_sigs))
        end
    end
end

function handle_rxsignaler_destroy(rxsignaler_ctx)
end

function destroy_rxsignaler_entities(rxsignaler_ctx)
    rxsignaler_ctx.signalerctrl.destroy()
end
