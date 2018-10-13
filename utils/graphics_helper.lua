
function make_4way_animation_from_spritesheet(animation)
    local function make_animation_layer(idx, anim)
    return {
        filename = anim.filename,
        priority = anim.priority or "high",
        x = idx * anim.width,
        width = anim.width,
        height = anim.height,
        frame_count = anim.frame_count or 1,
        line_length = anim.line_length,
        shift = anim.shift,
        draw_as_shadow = anim.draw_as_shadow,
        apply_runtime_tint = anim.apply_runtime_tint,
        scale = anim.scale or 1
    }
    end

    local function make_animation_layer_with_hr_version(idx, anim)
        local anim_parameters = make_animation_layer(idx, anim)
        if anim.hr_version and anim.hr_version.filename then
            anim_parameters.hr_version = make_animation_layer(idx, anim.hr_version)
        end
        return anim_parameters
    end

    local function make_animation(idx)
        if animation.layers then
            local tab = { layers = {} }
            for k,v in ipairs(animation.layers) do
                table.insert(tab.layers, make_animation_layer_with_hr_version(idx, v))
            end
            return tab
        else
            return make_animation_layer_with_hr_version(idx, animation)
        end
    end

    return
    {
        north = make_animation(0),
        east = make_animation(1),
        south = make_animation(2),
        west = make_animation(3)
    }
end
