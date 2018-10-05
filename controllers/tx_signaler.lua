
function create_tx_signaler(signaler_entity)
    local ctx =
    {
        id = signaler_entity.unit_number,
        signaler = signaler_entity
    }
    signaler_entity.get_or_create_control_behavior().circuit_condition =
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
    signaler_entity.operable = false
    return ctx
end

function handle_tx_signaler(signaler_id, signaler_entity)
    local acc_sigs = global.txsignals_accum

    local cur_signals = signaler_entity.get_merged_signals()
    if cur_signals then
        for _, cur_signal in pairs(cur_signals) do
            local found = false
            for idx = 1, #acc_sigs do
                if cur_signal.signal.name == acc_sigs[idx].signal.name then
                    found = true
                    acc_sigs[idx].count = acc_sigs[idx].count + cur_signal.count
                    break
                end
            end
            if found == false then
                acc_sigs[#acc_sigs + 1] =
                {
                    index = #acc_sigs + 1,
                    signal = cur_signal.signal,
                    count = cur_signal.count
                }
            end
        end
    end
end

function handle_rcon_collect_tx_signals(event)
    local tx_sigs = global.exported_tx_sigs
    if tx_sigs then
        rcon.print(json.stringify(tx_sigs).."\n")
        
        if DEBUG then
            broadcast_msg_all(json.stringify(tx_sigs).."\n")
        end
    end
end

function dispatch_tx_signalers()
    local acc_sigs = global.txsignals_accum
    if acc_sigs and #acc_sigs > 0 then
        global.exported_tx_sigs = acc_sigs
    end
end
