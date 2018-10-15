local version = 1

script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  player.insert{name="iron-plate", count=8}
  player.insert{name="pistol", count=1}
  player.insert{name="firearm-magazine", count=10}
  player.insert{name="burner-mining-drill", count = 1}
  player.insert{name="stone-furnace", count = 1}
  player.force.chart(player.surface, {{player.position.x - 200, player.position.y - 200}, {player.position.x + 200, player.position.y + 200}})
  if event.player_index == 1 then
    player.print("You are the first player in this game. Therefore, some items to launch a first rocket are hereby granted.")
    player.insert{name="green-wire", count=1}
    player.insert{name="constant-combinator", count=1}
    player.insert{name="rx-rocketsilo", count=1}
    player.insert{name="rocket-control-unit", count=100}
    player.insert{name="rocket-fuel", count=100}
    player.insert{name="low-density-structure", count=100}
    player.insert{name="rx-electricity", count=1}
  end
end)

script.on_event(defines.events.on_player_respawned, function(event)
  local player = game.players[event.player_index]
  player.insert{name="pistol", count=1}
  player.insert{name="firearm-magazine", count=10}
end)

script.on_event(defines.events.on_gui_click, function(event)
end)

script.on_init(function()
  global.version = version
end)

script.on_event(defines.events.on_rocket_launched, function(event)
end)

script.on_configuration_changed(function(event)
  if global.version ~= version then
    global.version = version
  end
end)
