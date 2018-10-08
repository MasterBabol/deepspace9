
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

function collect_tx_signals()
    local acc_sigs = {}
    if global.txsignalers then
        for key, ctx in pairs(global.txsignalers) do
            signaler_entity = ctx.signaler
            local cur_signals = signaler_entity.get_merged_signals()
            if cur_signals then
                for _, cur_signal in pairs(cur_signals) do
                    local found = false
                    for idx = 1, #acc_sigs do
                        if cur_signal.signal.name == acc_sigs[idx].name then
                            found = true
                            acc_sigs[idx].count = acc_sigs[idx].count + cur_signal.count
                            break
                        end
                    end
                    if found == false then
                        acc_sigs[#acc_sigs + 1] =
                        {
                            name = cur_signal.signal.name,
                            type = cur_signal.signal.type,
                            count = cur_signal.count
                        }
                    end
                end
            end
        end
    end
    return acc_sigs
end

function handle_rcon_collect_tx_signals(event)
    local tx_sigs = collect_tx_signals()
    if tx_sigs then
        rcon.print(json.stringify(tx_sigs))
        
        if DEBUG then
            broadcast_msg_all(json.stringify(tx_sigs))
        end
    end
end

