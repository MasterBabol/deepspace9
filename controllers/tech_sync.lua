
function collect_technology_researches()
    local tech_status = {}
    local pfc = game.forces["player"]
    if pfc then
        -- work only for the default force, "player"
        for tech_name, tech in pairs(pfc.technologies) do
            local new_idx = #tech_status + 1
            local cur_tech_status =
            {
                name = tech_name,
                researched = tech.researched,
                progress = 0,
                level = tech.level
            }
            saved_tech_prog = pfc.get_saved_technology_progress(tech_name)
            if saved_tech_prog then
                cur_tech_status.progress = saved_tech_prog
            elseif pfc.current_research and pfc.current_research.name == tech_name then
                cur_tech_status.progress = pfc.research_progress
            end
            
            if (cur_tech_status.researched == true) or (cur_tech_status.progress > 0) or (cur_tech_status.level > 0) then
                tech_status[new_idx] = cur_tech_status
            end
        end
    end
    return tech_status
end

function handle_rcon_collect_technology_researches(event)
    local techs = collect_technology_researches()
    if techs then
        rcon.print(json.stringify(techs))
        
        if DEBUG then
            broadcast_msg_all(json.stringify(techs))
        end
    end
end

function add_technologies(decoded_response)
    local pfc = game.forces["player"]
    if pfc then
        for _, tech in pairs(decoded_response) do
            local tech_name = tech.name
            if pfc.technologies[tech_name] then
                local cur_saved_tech_prog = pfc.get_saved_technology_progress(tech_name)
                
                if cur_saved_tech_prog then
                    -- paused research
                    local cur_saved_tech = pfc.technologies[tech_name]
                    if tech.level > cur_saved_tech.level then
                        -- external research progress is superior than here, so apply the tech as is, but do not save the progress
                        pfc.set_saved_technology_progress(tech_name, 0)
                        if is_tech_level_valid(cur_saved_tech) then
                            cur_saved_tech.level = tech.level
                        end
                    elseif tech.level == cur_saved_tech.level then
                        local new_prog = cur_saved_tech_prog + tech.progress
                        if new_prog >= 1 then
                            -- accumulated progress exceeds 1, so target tech research is done
                            cur_saved_tech.researched = true
                        end
                    end
                elseif pfc.current_research and pfc.current_research.name == tech_name then
                    -- current research
                    local cur_tech = pfc.current_research
                    if tech.level > cur_tech.level then
                        pfc.research_progress = 0
                        if is_tech_level_valid(cur_tech) then
                            cur_tech.level = tech.level + 1
                        end
                    elseif tech.level == cur_tech.level then
                        local cur_tech_prog = pfc.research_progress
                        local new_prog = cur_tech_prog + tech.progress
                        if new_prog >= 1 then
                            -- research complete
                            cur_tech.researched = true
                        end
                    end
                else
                    -- external research progress is superior than here, so apply the tech as is, but do not save the progress
                    pfc.set_saved_technology_progress(tech_name, 0)
                    local having_tech = pfc.technologies[tech_name]
                    if is_tech_level_valid(having_tech) then
                        having_tech.level = tech.level
                    end
                    having_tech.researched = tech.researched
                end
            end
        end
    end
end

function set_technologies(decoded_response)
    local pfc = game.forces["player"]
    if pfc then
        for _, tech in pairs(decoded_response) do
            local tech_name = tech.name
            local local_tech = pfc.technologies[tech_name]
            if local_tech then
                if (local_tech.researched == false) and tech.researched == true then
                    local_tech.researched = tech.researched
                end
                if is_tech_level_valid(local_tech) and (local_tech.level < tech.level) then
                    local_tech.level = tech.level
                end
            end
        end
    end
end
