
function create_tx_elec(entity)
    local ctx = {
        id = entity.unit_number,
        elec = entity
    }
    return ctx
end

function collect_tx_elecs()
    local acc_elec = {}
    if global.txelecs then
        for key, ctx in pairs(global.txelecs) do
            local elec = ctx.elec.energy
            acc_elec[#acc_elec + 1] =
            {
                id = key,
                amount = elec
            }
            ctx.elec.energy = 0
        end
    end
    return acc_elec
end

function handle_rcon_collect_tx_elecs(event)
    local tx_elec = collect_tx_elecs()
    if tx_elec then
        rcon.print(json.stringify(tx_elec))
        
        if DEBUG then
            broadcast_msg_all(json.stringify(tx_elec))
        end
    end
end
