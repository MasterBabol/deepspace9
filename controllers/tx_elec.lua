
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
            if elec > 1000000 then
                acc_elec[#acc_elec + 1] =
                {
                    id = key,
                    amount = 1
                }
                ctx.elec.energy = ctx.elec.energy - 1000000
            end
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
