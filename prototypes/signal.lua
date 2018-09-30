data:extend(
    {
        {
            type = "item-subgroup",
            name = MOD_NAME.."_signal",
            group = "signals",
            order = "z["..MOD_NAME.."-signal]"
        },
        
        {
            type = "virtual-signal",
            name = LAUNCH_SIGNAL_NAME,
            icon = "__"..MOD_NAME.."__/graphics/icons/launch-rocket.png",
            icon_size = 32,
            subgroup = MOD_NAME.."_signal",
            order = "z["..MOD_NAME.."-signal]-aa["..MOD_NAME.."-launch-rocket]"
        }
    }
)