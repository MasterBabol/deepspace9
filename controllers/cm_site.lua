
function create_launch_site_entities(silo_entity, player_idx, surface)
    local invmonitor_entity, missionctrl_entity, missionctrl_lampctrl_entity
    
    local site_entities = surface.find_entities(
        {
            {
                silo_entity.position.x - 4.5,
                silo_entity.position.y - 5
            },
            {
                silo_entity.position.x + 4.5,
                silo_entity.position.y + 5
            }
        }
    )
    
    for key, entity in pairs(site_entities) do
        if entity.valid then
            if (entity.name == ROCKETINV_MONITOR_NAME) then
                invmonitor_entity = entity
            elseif (entity.name == MISSIONCTRL_NAME) then
                missionctrl_entity = entity
            elseif (entity.name == MISSIONCTRL_LAMPCTRL_NAME) then
                missionctrl_lampctrl_entity = entity
            elseif (entity.name == "entity-ghost" and entity.ghost_name == ROCKETINV_MONITOR_NAME) then
                _, invmonitor_entity = entity.revive()
            elseif (entity.name == "entity-ghost" and entity.ghost_name == MISSIONCTRL_NAME) then
                _, missionctrl_entity = entity.revive()
            elseif (entity.name == "entity-ghost" and entity.ghost_name == MISSIONCTRL_LAMPCTRL_NAME) then
                _, missionctrl_lampctrl_entity = entity.revive()
            end
        end
    end
    
    --silo_entity.operable = false
    
    invmonitor_entity = (invmonitor_entity) or
    surface.create_entity
    (
        {
            name = ROCKETINV_MONITOR_NAME,
            player = player_idx,
            force = silo_entity.force,
            position =
            {
                silo_entity.position.x+4.0,
                silo_entity.position.y-1.5
            }
        }
    )
    invmonitor_entity.operable = false
    invmonitor_entity.minable = false
    invmonitor_entity.destructible = false
    
    missionctrl_entity = (missionctrl_entity) or
    surface.create_entity
    (
        {
            name = MISSIONCTRL_NAME,
            player = player_idx,
            force = silo_entity.force,
            position =
            {
                silo_entity.position.x+4.0,
                silo_entity.position.y-0.5
            }
        }
    )
    missionctrl_entity.operable = false
    missionctrl_entity.minable = false
    missionctrl_entity.destructible = false
    
    missionctrl_lampctrl_entity = (missionctrl_lampctrl_entity) or
    surface.create_entity
    (
        {
            name = MISSIONCTRL_LAMPCTRL_NAME,
            player = player_idx,
            force = silo_entity.force,
            position =
            {
                silo_entity.position.x+4.0,
                silo_entity.position.y-0.5
            }
        }
    )
    missionctrl_lampctrl_entity.operable = false
    missionctrl_lampctrl_entity.minable = false
    missionctrl_lampctrl_entity.destructible = false
    
    missionctrl_entity.connect_neighbour
    (
        {
            target_entity = missionctrl_lampctrl_entity,
            wire = defines.wire_type.green
        }
    )
    missionctrl_entity.get_or_create_control_behavior().use_colors = true
    missionctrl_entity.get_or_create_control_behavior().circuit_condition =
    {
        condition =
        {
            comparator = ">",
            first_signal = 
            {
                type="virtual",
                name="signal-anything"
            }
        }
    }
    
    local launch_site_ctx =
    {
        id = silo_entity.unit_number,
        silo = silo_entity,
        invmonitor = invmonitor_entity,
        missionctrl = missionctrl_entity,
        missionctrl_lampctrl = missionctrl_lampctrl_entity
    }
    
    return launch_site_ctx
end

function destroy_launch_site_entities(launch_site_ctx)
    launch_site_ctx.invmonitor.destroy()
    launch_site_ctx.missionctrl.destroy()
    launch_site_ctx.missionctrl_lampctrl.destroy()
end

function update_launch_site_invmonitor(launch_site_ctx, inv_type)
    local inv_to_signal = inventory_to_signals(launch_site_ctx.silo.get_inventory(inv_type))
    launch_site_ctx.invmonitor.get_control_behavior().parameters = { parameters = inv_to_signal }
end
