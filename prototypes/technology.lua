tech_rocket = {
    type = "technology",
    name = TECH_SILO_NAME,
    icon = "__"..MOD_NAME.."__/graphics/technology/rocket-silo.png",
    icon_size = 128,
    prerequisites = {"rocket-silo"},
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = RXROCKETSILO_NAME
        },
        {
            type = "unlock-recipe",
            recipe = TXROCKETSILO_NAME
        }
    },
    unit =
    {
        count = 1500,
        ingredients =
        {
            {"science-pack-1", 1},
            {"science-pack-2", 1},
            {"science-pack-3", 1},
            {"military-science-pack", 1},
            {"production-science-pack", 1},
            {"high-tech-science-pack", 1}
        },
        time = 60
    },
    order = "c-m-a"
}

tech_signal = {
    type = "technology",
    name = TECH_SIGNAL_NAME,
    icon = "__"..MOD_NAME.."__/graphics/technology/rxtxsignaler.png",
    icon_size = 128,
    prerequisites = {"advanced-electronics", "circuit-network"},
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = RXSIGNALER_NAME
        },
        {
            type = "unlock-recipe",
            recipe = TXSIGNALER_NAME
        },
        {
            type = "unlock-recipe",
            recipe = RXINVENSIG_NAME
        }
    },
    unit =
    {
        count = 100,
        ingredients =
        {
            {"science-pack-1", 1},
            {"science-pack-2", 1}
        },
        time = 30
    },
    order = "c-m-a"
}

tech_sync = {
    type = "technology",
    name = TECH_TECHSYNC_NAME,
    icon = "__"..MOD_NAME.."__/graphics/technology/techsync.png",
    icon_size = 128,
    prerequisites = {TECH_SIGNAL_NAME},
    effects = {},
    unit =
    {
        count = 100,
        ingredients =
        {
            {"science-pack-1", 1},
            {"science-pack-2", 1}
        },
        time = 30
    },
    order = "c-m-a"
}

tech_elec = {
    type = "technology",
    name = TECH_ELEC_NAME,
    icon = "__"..MOD_NAME.."__/graphics/technology/rxtxelec.png",
    icon_size = 128,
    prerequisites = {TECH_SIGNAL_NAME, "electric-energy-accumulators-1", "electric-energy-distribution-2"},
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = RXELEC_NAME
        },
        {
            type = "unlock-recipe",
            recipe = TXELEC_NAME
        }
    },
    unit =
    {
        count = 200,
        ingredients =
        {
            {"science-pack-1", 1},
            {"science-pack-2", 1},
            {"science-pack-3", 1}
        },
        time = 30
    },
    order = "c-m-a"
}

data:extend({tech_rocket,tech_signal,tech_sync,tech_elec})