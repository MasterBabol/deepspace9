
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
    {"radar", 10},
    {"processing-unit", 5}
}

tx_signaler_recipe = table.deepcopy(data.raw["recipe"]["radar"])
tx_signaler_recipe.name = TXSIGNALER_NAME
tx_signaler_recipe.result = TXSIGNALER_NAME
rx_signaler_recipe.ingredients =
{
    {"radar", 10},
    {"processing-unit", 5}
}

if DEBUG then
    -- technology required
    rx_rocketsilo_recipe.enabled = true
    tx_rocketsilo_recipe.enabled = true
    rx_signaler_recipe.enabled = true
    tx_signaler_recipe.enabled = true
else
    rx_rocketsilo_recipe.enabled = false
    tx_rocketsilo_recipe.enabled = false
    rx_signaler_recipe.enabled = false
    tx_signaler_recipe.enabled = false
end

data:extend({
    rx_rocketsilo_recipe,
    tx_rocketsilo_recipe,
    rx_signaler_recipe,
    tx_signaler_recipe
})
