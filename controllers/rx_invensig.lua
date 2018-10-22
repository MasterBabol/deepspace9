
function create_rx_invensig(invensig_entity, surface)
    local rxinvensigctrl_entity

    local invensig_entities = surface.find_entities(
        {
            {
                invensig_entity.position.x - 1.2,
                invensig_entity.position.y - 1.2
            },
            {
                invensig_entity.position.x + 1.2,
                invensig_entity.position.y + 1.2
            }
        }
    )
    
    for key, entity in pairs(invensig_entities) do
        if entity.valid then
            if (entity.name == RXINVENSIGCTRL_NAME) then
                rxinvensigctrl_entity = entity
            elseif (entity.name == "entity-ghost" and entity.ghost_name == RXINVENSIGCTRL_NAME) then
                _, rxinvensigctrl_entity = entity.revive()
            end
        end
    end
    
    rxinvensigctrl_entity = (rxinvensigctrl_entity) or
    surface.create_entity
    (
        {
            name = RXINVENSIGCTRL_NAME,
            player = player_idx,
            force = invensig_entity.force,
            position =
            {
                invensig_entity.position.x,
                invensig_entity.position.y
            }
        }
    )
    rxinvensigctrl_entity.operable = false
    rxinvensigctrl_entity.minable = false
    rxinvensigctrl_entity.destructible = false
    
    rxinvensigctrl_entity.connect_neighbour
    (
        {
            target_entity = invensig_entity,
            wire = defines.wire_type.green,
            target_circuit_id = 1
        }
    )
    
    local ctx =
    {
        id = invensig_entity.unit_number,
        invensig = invensig_entity,
        invensigctrl = rxinvensigctrl_entity
    }
    return ctx
end

function set_rx_invensigs(decoded_response)
    local rxinvensigs = global.rxinvensigs
    if rxinvensigs then
        for _, req in pairs(decoded_response) do
            local id = req.id
            local rxinvensig = rxinvensigs[id]
            if (rxinvensig) then
                rxinvensig.invensigctrl.get_control_behavior().parameters =
                {
                    parameters = 
                    {
                        {
                            index = 1,
                            signal = 
                            {
                                type=req.type,
                                name=req.name
                            },
                            count = req.count
                        }
                    }
                }
            end
        end
    end
end

function collect_rx_invensig_reqs()
    local acc_sigs = {}
    if (global.rxinvensigs) then
        for key, ctx in pairs(global.rxinvensigs) do
            local fs = ctx.invensig.get_or_create_control_behavior().parameters.parameters.first_signal
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

function handle_rcon_collect_rx_invensig_reqs(event)
    local rx_invensigs = collect_rx_invensig_reqs()
    if rx_invensigs then
        rcon.print(json.stringify(rx_invensigs))
        
        if DEBUG then
            broadcast_msg_all(json.stringify(rx_invensigs))
        end
    end
end

function handle_rxinvensig_destroy(rxinvensig_ctx)
end

function destroy_rxinvensig_entities(rxinvensig_ctx)
    rxinvensig_ctx.invensigctrl.destroy()
end
