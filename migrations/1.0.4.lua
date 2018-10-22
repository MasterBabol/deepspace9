for _, force in pairs(game.forces) do 
    force.reset_recipes()
    force.reset_technologies()
  
    if force.technologies["deepspace9-signal"].researched then
        force.recipes["rx-invensig"].enabled = true
    else
        force.recipes["rx-invensig"].enabled = false
    end
end

game.print("[!] DS9 migrated from 1.0.4")
