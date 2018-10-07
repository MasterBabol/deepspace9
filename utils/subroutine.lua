
function table_dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. table_dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function inventory_to_signals(inventory)
    idx = 1
    inv_to_signal = {}
    if (inventory) then
        local inv_content = inventory.get_contents()
        for item_name, item_count in pairs(inv_content) do
            inv_to_signal[idx] =
            {
                index = idx,
                signal =
                {
                    type = "item",
                    name = item_name
                },
                count = item_count
            }
            idx = idx + 1
        end
    end
    return inv_to_signal
end

function select_signal(signals, signal_name)
    local result = nil
    if (signals) then
        for _, signal in pairs(signals) do
            if signal.signal.name == signal_name then
                result = signal
                break
            end
        end
    end
    return result
end

function signal_to_item(signals)
    local result = {}
    if (signals) then
        for _, signal in pairs(signals) do
            local luasig = signal.signal
            if luasig.type == "item" then
                if (result[luasig.name]) then
                    result[luasig.name] = result[luasig.name] + signal.count
                else
                    result[luasig.name] = signal.count
                end
            end
        end
    end
    return result
end

function set_lampctrl(lampctrl_entity, color)
    sig = "signal-white"
    if color == "yellow" then
        sig = "signal-yellow"
    elseif color == "blue" then
        sig = "signal-blue"
    elseif color == "red" then
        sig = "signal-red"
    elseif color == "black" then
        sig = "signal-black"
    elseif color == "green" then
        sig = "signal-green"
    end
    lampctrl_entity.get_control_behavior().parameters =
    {
        parameters = 
        {
            {
                index = 1,
                signal = 
                {
                    type="virtual",
                    name=sig
                },
                count = 1
            }
        }
    }
end

function broadcast_msg_all(message)
    for _, player in pairs(game.players) do
        player.print(message)
    end
end

function is_tech_level_valid(luaTechnology)
    if luaTechnology.research_unit_count_formula then
        return true
    else
        return false
    end
end

function table.shallowcopy(t)
    local nt = {}
    for k,v in pairs(t) do
        nt[k] = v
    end
    return nt
end
