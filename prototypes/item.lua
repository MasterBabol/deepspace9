rx_rocketsilo_item = table.deepcopy(data.raw["item"]["rocket-silo"])
rx_rocketsilo_item.icon = "__"..MOD_NAME.."__/graphics/icons/rx-rocket-silo.png"
rx_rocketsilo_item.name = RXROCKETSILO_NAME
rx_rocketsilo_item.place_result = RXROCKETSILO_NAME

tx_rocketsilo_item = table.deepcopy(data.raw["item"]["rocket-silo"])
tx_rocketsilo_item.icon = "__"..MOD_NAME.."__/graphics/icons/tx-rocket-silo.png"
tx_rocketsilo_item.name = TXROCKETSILO_NAME
tx_rocketsilo_item.place_result = TXROCKETSILO_NAME

rocketinv_monitor_item = table.deepcopy(data.raw["item"]["constant-combinator"])
rocketinv_monitor_item.name = ROCKETINV_MONITOR_NAME
rocketinv_monitor_item.place_result = ROCKETINV_MONITOR_NAME
table.insert(rocketinv_monitor_item.flags, "hidden")

missionctrl_item = table.deepcopy(data.raw["item"]["small-lamp"])
missionctrl_item.name = MISSIONCTRL_NAME
missionctrl_item.place_result = MISSIONCTRL_NAME
table.insert(missionctrl_item.flags, "hidden")

missionctrl_lampctrl_item = table.deepcopy(data.raw["item"]["constant-combinator"])
missionctrl_lampctrl_item.name = MISSIONCTRL_LAMPCTRL_NAME
missionctrl_lampctrl_item.place_result = MISSIONCTRL_LAMPCTRL_NAME
table.insert(missionctrl_lampctrl_item.flags, "hidden")

rx_signaler_item = table.deepcopy(data.raw["item"]["decider-combinator"])
rx_signaler_item.icon = "__"..MOD_NAME.."__/graphics/icons/rx-signaler.png"
rx_signaler_item.icon_size = 32
rx_signaler_item.name = RXSIGNALER_NAME
rx_signaler_item.place_result = RXSIGNALER_NAME
rx_signaler_item.order = "c[combinators]-d[signaler-rx]"

rx_signalerctrl_item = table.deepcopy(data.raw["item"]["constant-combinator"])
rx_signalerctrl_item.name = RXSIGNALERCTRL_NAME
rx_signalerctrl_item.place_result = RXSIGNALERCTRL_NAME
table.insert(rx_signalerctrl_item.flags, "hidden")

tx_signaler_item = table.deepcopy(data.raw["item"]["small-lamp"])
tx_signaler_item.icon = "__"..MOD_NAME.."__/graphics/icons/tx-signaler.png"
tx_signaler_item.icon_size = 32
tx_signaler_item.name = TXSIGNALER_NAME
tx_signaler_item.place_result = TXSIGNALER_NAME
tx_signaler_item.order = "c[combinators]-d[signaler-tx]"

data.raw["item"]["satellite"].rocket_launch_product = nil

rcunit_tray_item = table.deepcopy(data.raw["item"]["rocket-control-unit"])
rcunit_tray_item.name = ROCKETCONTROLUNIT_TRAY_NAME
rcunit_tray_item.icon = "__"..MOD_NAME.."__/graphics/icons/rocket-control-unit-tray.png"

rf_tray_item = table.deepcopy(data.raw["item"]["rocket-fuel"])
rf_tray_item.name = ROCKETFUEL_TRAY_NAME
rf_tray_item.fuel_value = "2.25GJ"
rf_tray_item.icon = "__"..MOD_NAME.."__/graphics/icons/rocket-fuel-tray.png"

ld_tray_item = table.deepcopy(data.raw["item"]["low-density-structure"])
ld_tray_item.name = LOWDENSITYSTRUCTURE_TRAY_NAME
ld_tray_item.icon = "__"..MOD_NAME.."__/graphics/icons/low-density-structure-tray.png"

txelec_item = table.deepcopy(data.raw["item"]["accumulator"])
txelec_item.name = TXELEC_NAME
txelec_item.icon = "__"..MOD_NAME.."__/graphics/icons/tx-elec.png"
txelec_item.place_result = TXELEC_NAME

rxelec_item = table.deepcopy(data.raw["item"]["accumulator"])
rxelec_item.name = RXELEC_NAME
rxelec_item.icon = "__"..MOD_NAME.."__/graphics/icons/rx-elec.png"
rxelec_item.place_result = RXELEC_NAME

rx_invensig_item = table.deepcopy(data.raw["item"]["decider-combinator"])
rx_invensig_item.icon = "__"..MOD_NAME.."__/graphics/icons/rx-inven.png"
rx_invensig_item.icon_size = 32
rx_invensig_item.name = RXINVENSIG_NAME
rx_invensig_item.place_result = RXINVENSIG_NAME
rx_invensig_item.order = "c[combinators]-d[inven-rx]"

rx_invensigctrl_item = table.deepcopy(data.raw["item"]["constant-combinator"])
rx_invensigctrl_item.name = RXINVENSIGCTRL_NAME
rx_invensigctrl_item.place_result = RXINVENSIGCTRL_NAME
table.insert(rx_invensigctrl_item.flags, "hidden")

data:extend({
    rx_rocketsilo_item,
    tx_rocketsilo_item,
    rocketinv_monitor_item,
    missionctrl_item,
    missionctrl_lampctrl_item,
    rx_signaler_item,
    tx_signaler_item,
    rx_signalerctrl_item,
    rcunit_tray_item,
    rf_tray_item,
    ld_tray_item,
    txelec_item,
    rxelec_item,
    rx_invensig_item,
    rx_invensigctrl_item
})
