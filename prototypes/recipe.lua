
rx_rocketsilo_recipe = table.deepcopy(data.raw["recipe"]["rocket-silo"])
rx_rocketsilo_recipe.name = RXROCKETSILO_NAME
rx_rocketsilo_recipe.result = RXROCKETSILO_NAME

tx_rocketsilo_recipe = table.deepcopy(data.raw["recipe"]["rocket-silo"])
tx_rocketsilo_recipe.name = TXROCKETSILO_NAME
tx_rocketsilo_recipe.result = TXROCKETSILO_NAME

rx_signaler_recipe = table.deepcopy(data.raw["recipe"]["radar"])
rx_signaler_recipe.name = RXSIGNALER_NAME
rx_signaler_recipe.result = RXSIGNALER_NAME
rx_signaler_recipe.ingredients =
{
    {"radar", 5},
    {"advanced-circuit", 5}
}

tx_signaler_recipe = table.deepcopy(data.raw["recipe"]["radar"])
tx_signaler_recipe.name = TXSIGNALER_NAME
tx_signaler_recipe.result = TXSIGNALER_NAME
tx_signaler_recipe.ingredients =
{
    {"radar", 5},
    {"advanced-circuit", 5}
}

rcunit_tray_pack_recipe = {
    type = "recipe",
    name = ROCKETCONTROLUNIT_TRAY_PACK_NAME,
    enabled = false,
    energy_required = 10,
    ingredients =
    {
        {"rocket-control-unit", 10}
    },
    result = ROCKETCONTROLUNIT_TRAY_NAME
}

rf_tray_pack_recipe = {
    type = "recipe",
    name = ROCKETFUEL_TRAY_PACK_NAME,
    enabled = false,
    energy_required = 10,
    ingredients =
    {
        {"rocket-fuel", 10}
    },
    result = ROCKETFUEL_TRAY_NAME
}

ld_tray_pack_recipe = {
    type = "recipe",
    name = LOWDENSITYSTRUCTURE_TRAY_PACK_NAME,
    enabled = false,
    energy_required = 10,
    ingredients =
    {
        {"low-density-structure", 10}
    },
    result = LOWDENSITYSTRUCTURE_TRAY_NAME
}

rcunit_tray_unpack_recipe = {
    type = "recipe",
    name = ROCKETCONTROLUNIT_TRAY_UNPACK_NAME,
    enabled = false,
    energy_required = 10,
    ingredients =
    {
        {ROCKETCONTROLUNIT_TRAY_NAME, 1}
    },
    result = "rocket-control-unit",
    result_count = 10
}

rf_tray_unpack_recipe = {
    type = "recipe",
    name = ROCKETFUEL_TRAY_UNPACK_NAME,
    enabled = false,
    energy_required = 10,
    ingredients =
    {
        {ROCKETFUEL_TRAY_NAME, 1}
    },
    result = "rocket-fuel",
    result_count = 10
}

ld_tray_unpack_recipe = {
    type = "recipe",
    name = LOWDENSITYSTRUCTURE_TRAY_UNPACK_NAME,
    enabled = false,
    energy_required = 10,
    ingredients =
    {
        {LOWDENSITYSTRUCTURE_TRAY_NAME, 1}
    },
    result = "low-density-structure",
    result_count = 10
}

txelec_recipe = {
    type = "recipe",
    name = TXELEC_NAME,
    energy_required = 10,
    enabled = false,
    ingredients =
    {
        {TXSIGNALER_NAME, 2},
        {RXSIGNALER_NAME, 1},
        {"accumulator", 20}
    },
    result = TXELEC_NAME
}

rxelec_recipe = {
    type = "recipe",
    name = RXELEC_NAME,
    energy_required = 10,
    enabled = false,
    ingredients =
    {
        {TXSIGNALER_NAME, 1},
        {RXSIGNALER_NAME, 2},
        {"accumulator", 20}
    },
    result = RXELEC_NAME
}

if DEBUG then
    -- technology required
    rx_rocketsilo_recipe.enabled = true
    tx_rocketsilo_recipe.enabled = true
    rx_signaler_recipe.enabled = true
    tx_signaler_recipe.enabled = true
    
    txelec_recipe.enabled = true
    rxelec_recipe.enabled = true
else
    rx_rocketsilo_recipe.enabled = false
    tx_rocketsilo_recipe.enabled = false
    rx_signaler_recipe.enabled = false
    tx_signaler_recipe.enabled = false
    
    txelec_recipe.enabled = false
    rxelec_recipe.enabled = false
end

rcunit_tray_pack_recipe.enabled = true
rf_tray_pack_recipe.enabled = true
ld_tray_pack_recipe.enabled = true
rcunit_tray_unpack_recipe.enabled = true
rf_tray_unpack_recipe.enabled = true
ld_tray_unpack_recipe.enabled = true
    
data:extend({
    rx_rocketsilo_recipe,
    tx_rocketsilo_recipe,
    rx_signaler_recipe,
    tx_signaler_recipe,
    rcunit_tray_pack_recipe,
    rf_tray_pack_recipe,
    ld_tray_pack_recipe,
    rcunit_tray_unpack_recipe,
    rf_tray_unpack_recipe,
    ld_tray_unpack_recipe,
    txelec_recipe,
    rxelec_recipe
})
