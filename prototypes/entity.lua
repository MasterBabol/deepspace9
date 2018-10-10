local rx_rocketsilo_entity = table.deepcopy(data.raw["rocket-silo"]["rocket-silo"])
rx_rocketsilo_entity.name = RXROCKETSILO_NAME
rx_rocketsilo_entity.minable.result = RXROCKETSILO_NAME
rx_rocketsilo_entity.rocket_parts_required = ROCKETPARTS_REQUIRED
rx_rocketsilo_entity.rocket_result_inventory_size = ROCKETINV_SIZE + 1
rx_rocketsilo_entity.collision_box = {{-4.2, -4.7}, {4.0, 4.7}}
rx_rocketsilo_entity.rocket_entity = RXROCKET_NAME
--rx_rocketsilo_entity.module_specification = { module_slots = 0, module_info_icon_shift = {0, 0} }

local tx_rocketsilo_entity = table.deepcopy(data.raw["rocket-silo"]["rocket-silo"])
tx_rocketsilo_entity.name = TXROCKETSILO_NAME
tx_rocketsilo_entity.minable.result = TXROCKETSILO_NAME
tx_rocketsilo_entity.rocket_parts_required = ROCKETPARTS_REQUIRED
tx_rocketsilo_entity.rocket_result_inventory_size = 1
tx_rocketsilo_entity.collision_box = {{-4.2, -4.7}, {4.0, 4.7}}
tx_rocketsilo_entity.rocket_entity = TXROCKET_NAME
--tx_rocketsilo_entity.module_specification = { module_slots = 0, module_info_icon_shift = {0, 0} }

local rx_rocket_entity = table.deepcopy(data.raw["rocket-silo-rocket"]["rocket-silo-rocket"])
rx_rocket_entity.name = RXROCKET_NAME
rx_rocket_entity.inventory_size = 0

local tx_rocket_entity = table.deepcopy(data.raw["rocket-silo-rocket"]["rocket-silo-rocket"])
tx_rocket_entity.name = TXROCKET_NAME
tx_rocket_entity.inventory_size = ROCKETINV_SIZE

local rocketinv_monitor_entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
rocketinv_monitor_entity.name = ROCKETINV_MONITOR_NAME
rocketinv_monitor_entity.selection_priority = 51
rocketinv_monitor_entity.collision_box = {{-0.0, -0.0}, {0.0, 0.0}}
rocketinv_monitor_entity.item_slot_count = ROCKETINV_SIZE + 1

local missionctrl_entity = table.deepcopy(data.raw["lamp"]["small-lamp"])
missionctrl_entity.name = MISSIONCTRL_NAME
missionctrl_entity.selection_priority = 51
missionctrl_entity.collision_box = {{-0.0, -0.0}, {0.0, 0.0}}

local missionctrl_lampctrl_entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
missionctrl_lampctrl_entity.name = MISSIONCTRL_LAMPCTRL_NAME
missionctrl_lampctrl_entity.selection_priority = 0
missionctrl_lampctrl_entity.minable = nil
missionctrl_lampctrl_entity.selection_box = {{-0.0, -0.0}, {0.0, 0.0}}
missionctrl_lampctrl_entity.collision_box = {{-0.0, -0.0}, {0.0, 0.0}}
missionctrl_lampctrl_entity.collision_mask = { "resource-layer" }
missionctrl_lampctrl_entity.flags = {"not-blueprintable", "not-deconstructable"}
empty_sprite =
{
    filename = "__"..MOD_NAME.."__/graphics/entity/empty.png",
    x = 0,
    y = 0,
    width = 1,
    height = 1,
    frame_count = 1,
    shift = {0, 0},
}
missionctrl_lampctrl_entity.sprites =
{
    north = empty_sprite,
    east = empty_sprite,
    south = empty_sprite,
    west = empty_sprite
}

local rx_signaler_entity = table.deepcopy(data.raw["decider-combinator"]["decider-combinator"])
rx_signaler_entity.name = RXSIGNALER_NAME
rx_signaler_entity.icon = "__base__/graphics/icons/radar.png"
rx_signaler_entity.icon_size = 32
rx_signaler_entity.corpse = "big-remnants"
rx_signaler_entity.collision_box = {{-1.2, -1.2}, {1.2, 1.2}}
rx_signaler_entity.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
rx_signaler_entity.energy_usage = "900KW"
rx_signaler_entity.minable.result = RXSIGNALER_NAME
rx_signaler_entity.item_slot_count = RXSIGNALER_MAX_ITEM_SLOTS
rx_signaler_entity.sprites = 
{
    layers =
    {
        {
            filename = "__base__/graphics/entity/radar/radar.png",
            priority = "low",
            width = 98,
            height = 128,
            apply_projection = false,
            direction_count = 64,
            line_length = 8,
            shift = util.by_pixel(1, -16),
            hr_version =
            {
                filename = "__base__/graphics/entity/radar/hr-radar.png",
                priority = "low",
                width = 196,
                height = 254,
                apply_projection = false,
                direction_count = 64,
                line_length = 8,
                shift = util.by_pixel(1, -16),
                scale = 0.5
            }
        },
        {
            filename = "__base__/graphics/entity/radar/radar-shadow.png",
            priority = "low",
            width = 172,
            height = 94,
            apply_projection = false,
            direction_count = 64,
            line_length = 8,
            shift = util.by_pixel(39,3),
            draw_as_shadow = true,
            hr_version =
            {
                filename = "__base__/graphics/entity/radar/hr-radar-shadow.png",
                priority = "low",
                width = 343,
                height = 186,
                apply_projection = false,
                direction_count = 64,
                line_length = 8,
                shift = util.by_pixel(39.25,3),
                draw_as_shadow = true,
                scale = 0.5
            }
        }
    }
}

local tx_signaler_entity = table.deepcopy(data.raw["lamp"]["small-lamp"])
tx_signaler_entity.name = TXSIGNALER_NAME
tx_signaler_entity.icon = "__base__/graphics/icons/radar.png"
tx_signaler_entity.icon_size = 32
tx_signaler_entity.corpse = "big-remnants"
tx_signaler_entity.collision_box = {{-1.2, -1.2}, {1.2, 1.2}}
tx_signaler_entity.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
tx_signaler_entity.energy_usage = "900KW"
tx_signaler_entity.minable.result = TXSIGNALER_NAME
tx_signaler_entity.light = {intensity = 0, size = 0, color = {r=0.0, g=0.0, b=0.0}}
tx_signaler_entity.light_when_colored = {intensity = 0, size = 0, color = {r=0.0, g=0.0, b=0.0}}
tx_signaler_entity.glow_size = 0
tx_signaler_entity.glow_color_intensity = 0
tx_signaler_entity.picture_off = 
{
    layers =
    {
        {
            filename = "__base__/graphics/entity/radar/radar.png",
            priority = "low",
            width = 98,
            height = 128,
            apply_projection = false,
            direction_count = 64,
            line_length = 8,
            shift = util.by_pixel(1, -16),
            hr_version =
            {
                filename = "__base__/graphics/entity/radar/hr-radar.png",
                priority = "low",
                width = 196,
                height = 254,
                apply_projection = false,
                direction_count = 64,
                line_length = 8,
                shift = util.by_pixel(1, -16),
                scale = 0.5
            }
        },
        {
            filename = "__base__/graphics/entity/radar/radar-shadow.png",
            priority = "low",
            width = 172,
            height = 94,
            apply_projection = false,
            direction_count = 64,
            line_length = 8,
            shift = util.by_pixel(39,3),
            draw_as_shadow = true,
            hr_version =
            {
                filename = "__base__/graphics/entity/radar/hr-radar-shadow.png",
                priority = "low",
                width = 343,
                height = 186,
                apply_projection = false,
                direction_count = 64,
                line_length = 8,
                shift = util.by_pixel(39.25,3),
                draw_as_shadow = true,
                scale = 0.5
            }
        }
    }
}
tx_signaler_entity.picture_on = tx_signaler_entity.picture_off

local rx_signalerctrl_entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
rx_signalerctrl_entity.name = RXSIGNALERCTRL_NAME
rx_signalerctrl_entity.selection_priority = 0
rx_signalerctrl_entity.minable = nil
rx_signalerctrl_entity.selection_box = {{-0.0, -0.0}, {0.0, 0.0}}
rx_signalerctrl_entity.collision_box = {{-0.0, -0.0}, {0.0, 0.0}}
rx_signalerctrl_entity.collision_mask = { "resource-layer" }
rx_signalerctrl_entity.flags = {"not-blueprintable", "not-deconstructable"}
empty_sprite =
{
    filename = "__"..MOD_NAME.."__/graphics/entity/empty.png",
    x = 0,
    y = 0,
    width = 1,
    height = 1,
    frame_count = 1,
    shift = {0, 0},
}
rx_signalerctrl_entity.sprites =
{
    north = empty_sprite,
    east = empty_sprite,
    south = empty_sprite,
    west = empty_sprite
}

local txelec_entity = table.deepcopy(data.raw["accumulator"]["accumulator"])
txelec_entity.name = TXELEC_NAME
txelec_entity.energy_source = {
    type = "electric",
    buffer_capacity = "5MJ",
    usage_priority = "terciary",
    input_flow_limit = "300kW",
    output_flow_limit = "0kW"
}

local rxelec_entity = table.deepcopy(data.raw["accumulator"]["accumulator"])
rxelec_entity.name = RXELEC_NAME
rxelec_entity.energy_source = {
    type = "electric",
    buffer_capacity = "5MJ",
    usage_priority = "secondary-output",
    input_flow_limit = "0kW",
    output_flow_limit = "300kW"
}

data:extend({
    rx_rocketsilo_entity,
    tx_rocketsilo_entity,
    rx_rocket_entity,
    tx_rocket_entity,
    rocketinv_monitor_entity,
    missionctrl_entity,
    missionctrl_lampctrl_entity,
    rx_signaler_entity,
    tx_signaler_entity,
    rx_signalerctrl_entity,
    txelec_entity,
    rxelec_entity
})