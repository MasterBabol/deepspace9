
function register_events()
    script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, on_entity_created)
    script.on_event({defines.events.on_pre_player_mined_item, defines.events.on_robot_mined_entity, defines.events.on_entity_died}, on_entity_destroyed)
    script.on_event(defines.events.on_tick, on_tick)
    script.on_event(defines.events.on_rocket_launched, on_rocket_launched)
end

function on_entity_created(event)
    local entity = event.created_entity
    local player_idx = event.player_index
    local surface = entity.surface
    ensure_global()
    
    if entity.name == RXROCKETSILO_NAME or entity.name == TXROCKETSILO_NAME then
        local launch_site_ctx = create_launch_site_entities(entity, player_idx, surface)
        
        if entity.name == RXROCKETSILO_NAME then
            global.rxsites[entity.unit_number] = add_rx_context(launch_site_ctx)
        elseif entity.name == TXROCKETSILO_NAME then
            global.txsites[entity.unit_number] = add_tx_context(launch_site_ctx)
        end
    elseif entity.name == RXSIGNALER_NAME then
        global.rxsignalers[entity.unit_number] = create_rx_signaler(entity, surface)
    elseif entity.name == TXSIGNALER_NAME then
        global.txsignalers[entity.unit_number] = create_tx_signaler(entity)
    elseif entity.name == RXELEC_NAME then
        global.rxelecs[entity.unit_number] = create_rx_elec(entity)
    elseif entity.name == TXELEC_NAME then
        global.txelecs[entity.unit_number] = create_tx_elec(entity)
    elseif entity.name == RXINVENSIG_NAME then
        global.rxinvensigs[entity.unit_number] = create_rx_invensig(entity, surface)
    end
end

function on_entity_destroyed(event)
    local entity = event.entity
    local entity_idx = entity.unit_number
    --local player_idx = event.player_index
    --local surface = entity.surface
    ensure_global()
    
    if entity.name == RXROCKETSILO_NAME or entity.name == TXROCKETSILO_NAME then
        if entity.name == RXROCKETSILO_NAME then
            site = global.rxsites[entity_idx]
            handle_rx_silo_destroy(site)
            
            destroy_launch_site_entities(site)
            global.rxsites[entity_idx] = nil
        elseif entity.name == TXROCKETSILO_NAME then
            site = global.txsites[entity_idx]
            handle_tx_silo_destroy(site)
            
            destroy_launch_site_entities(site)
            global.txsites[entity_idx] = nil
        end
    elseif entity.name == RXSIGNALER_NAME then
        signaler = global.rxsignalers[entity_idx]
        handle_rxsignaler_destroy(signaler)
        
        destroy_rxsignaler_entities(signaler)
        global.rxsignalers[entity_idx] = nil
    elseif entity.name == TXSIGNALER_NAME then
        global.txsignalers[entity_idx] = nil
    elseif entity.name == RXELEC_NAME then
        global.rxelecs[entity_idx] = nil
    elseif entity.name == TXELEC_NAME then
        global.txelecs[entity_idx] = nil
    elseif entity.name == RXINVENSIG_NAME then
        invensig = global.rxinvensigs[entity_idx]
        handle_rxinvensig_destroy(invensig)
        
        destroy_rxinvensig_entities(invensig)
        global.rxinvensigs[entity_idx] = nil
    end
end

function on_server_save(event)
    game.print('Periodical save process is initiated.')
    local name = event.parameter
    if name then
        game.server_save(name)
    else
        game.server_save()
    end
    rcon.print('Save process is complete.');
end

function on_dequeue_rx_queue(event)
	if game.player and DEBUG == false then
		return
	end
    handle_rcon_dequeue_rx_queue(event)
end

function on_dequeue_tx_queue(event)
	if game.player and DEBUG == false then
		return
	end
    handle_rcon_dequeue_tx_queue(event)
end

function on_collect_tx_signals(event)
	if game.player and DEBUG == false then
		return
	end
    handle_rcon_collect_tx_signals(event)
end

function on_collect_rx_signal_reqs(event)
	if game.player and DEBUG == false then
		return
	end
    handle_rcon_collect_rx_signal_reqs(event)
end

function on_collect_rx_invensig_reqs(event)
	if game.player and DEBUG == false then
		return
	end
    handle_rcon_collect_rx_invensig_reqs(event)
end

function on_collect_rx_elec_reqs(event)
	if game.player and DEBUG == false then
		return
	end
    handle_rcon_collect_rx_elec_reqs(event)
end

function on_collect_tx_elecs(event)
	if game.player and DEBUG == false then
		return
	end
    handle_rcon_collect_tx_elecs(event)
end

function on_collect_technology_researches(event)
	if game.player and DEBUG == false then
		return
	end
    handle_rcon_collect_technology_researches(event)
end

function on_set_rx_elecs(event)
	if game.player and DEBUG == false then
		return
	end
    local param = event.parameter
    if DEBUG then
        broadcast_msg_all("set_rx_elecs command issued with: "..param)
    end
    decoded = json.parse(param)
    set_rx_elecs(decoded)
end

function on_rx_reservation(event)
	if game.player and DEBUG == false then
		return
	end
    local param = event.parameter
    if DEBUG then
        broadcast_msg_all("confirm_rx_reservation command issued with: "..param)
    end
    decoded = json.parse(param)
    confirm_rx_request_dispatch_from_external(decoded)
end

function on_rx_set_signals(event)
	if game.player and DEBUG == false then
		return
	end
    local param = event.parameter
    if DEBUG then
        broadcast_msg_all("set_rx_signals command issued with: "..param)
    end
    decoded = json.parse(param)
    set_rx_signals(decoded)
end

function on_rx_set_invensigs(event)
	if game.player and DEBUG == false then
		return
	end
    local param = event.parameter
    if DEBUG then
        broadcast_msg_all("set_rx_invensigs command issued with: "..param)
    end
    decoded = json.parse(param)
    set_rx_invensigs(decoded)
end

function on_set_technologies(event)
	if game.player and DEBUG == false then
		return
	end
    local param = event.parameter
    if DEBUG then
        broadcast_msg_all("set_technologies command issued with: "..param)
    end
    decoded = json.parse(param)
    local pfc = game.forces["player"]
    if pfc then
        local tech_sync = pfc.technologies[TECH_TECHSYNC_NAME]
        if tech_sync then
            if tech_sync.researched then
                set_technologies(decoded)
            end
        end
    end
end

function on_add_technologies(event)
	if game.player and DEBUG == false then
		return
	end
    local param = event.parameter
    if DEBUG then
        broadcast_msg_all("add_technologies command issued with: "..param)
    end
    decoded = json.parse(param)
    add_technologies(decoded)
end

function on_tick(event)
    if global.rxsites then
        for key, site in pairs(global.rxsites) do            
            handle_rx_silo(key, site)
        end
    end
    
    if global.txsites then
        for key, site in pairs(global.txsites) do
            handle_tx_silo(key, site)
        end
    end
end

function on_rocket_launched(event)
    local rocket = event.rocket
    local silo = event.rocket_silo
    
    if rocket.name == "rocket-silo-rocket" then
        local sates = rocket.get_item_count("satellite")
        if sates > 0 and silo then
            local inv = silo.get_inventory(defines.inventory.rocket_silo_result)
            if (inv) then
                inv.insert
                (
                    {
                        name = "space-science-pack",
                        count = 1000 * sates
                    }
                )
            end
        end
    elseif rocket.name == RXROCKET_NAME and silo then
        local launch_site_id = silo.unit_number
        local launch_site_ctx = global.rxsites[launch_site_id]
        handle_rx_rocket_launched(launch_site_id, launch_site_ctx, rocket)
    elseif rocket.name == TXROCKET_NAME and silo then
        local launch_site_id = silo.unit_number
        local launch_site_ctx = global.txsites[launch_site_id]
        handle_tx_rocket_launched(launch_site_id, launch_site_ctx, rocket)
    end
end