
function create_rx_elec(entity)
    local ctx = {
        id = entity.unit_number,
        elec = entity
    }
    return ctx
end

function collect_rx_elec_reqs()
    local acc_elec = {}
    if global.rxelecs then
        for key, ctx in pairs(global.rxelecs) do
            local elec = ctx.elec.electric_buffer_size - ctx.elec.energy
            if elec > 1000000 then
                acc_elec[#acc_elec + 1] =
                {
                    id = key,
                    amount = elec
                }
            end
        end
    end
    return acc_elec
end

function handle_rcon_collect_rx_elec_reqs(event)
    local rx_elec = collect_rx_elec_reqs()
    if (rx_elec) then
        rcon.print(json.stringify(rx_elec))
        
        if DEBUG then
            broadcast_msg_all(json.stringify(rx_elec))
        end
    end
end

function set_rx_elecs(decoded_response)
    local rx_elecs = global.rxelecs
    if rx_elecs then
        for _, rx_elec_req in pairs(decoded_response) do
            local id = rx_elec_req.id
            local rx_elec = rx_elecs[id]
            if rx_elec then
                rx_elec.elec.energy = rx_elec.elec.energy + rx_elec_req.amount
            end
        end
    end
end
