
function create_rx_signaler(signaler_entity)
    local ctx =
    {
        id = signaler_entity.unit_number,
        signaler = signaler_entity
    }
    signaler_entity.operable = false
    return ctx
end

function handle_rx_signaler(signaler_id, signaler_entity)
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
    end
end

function set_rx_signals(decoded_response)
    global.rxsignals_accum = decoded_response.signals
end
