--[[Wave Menu -- Admin Menu
    Copyright (C) 2022  Mosheba

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>. ]]--

-- Created by Mosheba || https://discord.gg/xP67BKbk6A



local artofc = [[
_      _____ _   ______  __  ________  ____  __
| | /| / / _ | | / / __/ /  |/  / __/ |/ / / / /
| |/ |/ / __ | |/ / _/  / /|_/ / _//    / /_/ /
|__/|__/_/ |_|___/___/ /_/  /_/___/_/|_/\____/

]]

local art2ofc = [[
^1__          __     _____  _   _ _____ _   _  _____
^1\ \        / /\   |  __ \| \ | |_   _| \ | |/ ____|
 ^1\ \  /\  / /  \  | |__) |  \| | | | |  \| | |  __
  ^1\ \/  \/ / /\ \ |  _  /| . ` | | | | . ` | | |_ |
   ^1\  /\  / ____ \| | \ \| |\  |_| |_| |\  | |__| |
    ^1\/  \/_/    \_\_|  \_\_| \_|_____|_| \_|\_____|


]]

ESX = nil

if Config.Using_ESX then
  Citizen.CreateThread(function()
  while ESX == nil do
    Citizen.Wait(0)
    TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
    end)
  end

  while ESX.GetPlayerData().job == nil do
    Citizen.Wait(10)
  end

  ESX.PlayerData = ESX.GetPlayerData()
  end)
end
local serverSessionManager = {}

Citizen.CreateThread(function()
while true do
  Wait(500)
  for k,v in pairs(GetActivePlayers()) do
    local found = false
    for _,j in pairs(serverSessionManager) do
      if GetPlayerServerId(v) == j then
        found = true
      end
    end
    if not found then
      table.insert(serverSessionManager, GetPlayerServerId(v))
    end
  end
end
end)

function setInvincibility()
  timers.invincibility = cooldowns.invincibility
end


local timers = {
  bus = 0,
  invincibility = 0,
}

local cooldowns = {
  bus = 60,
  invincibility = 5
}



RegisterNetEvent('mDWaveMenu:checkinifadmin')
AddEventHandler('mDWaveMenu:checkinifadmin', function()
isPlayerAdmin = true
end)



RMenu.Add('wavemenu', 'main', RageUI.CreateMenu("~r~Wave Admin Menu", "Wave Admin Menu | ~g~By Mosheba: dsc.gg/mdev"))
RMenu.Add('wavemenu', 'second', RageUI.CreateSubMenu(RMenu:Get('wavemenu', 'main'), "Wave Admin Menu", "Manage Server Players"))
RMenu.Add('wavemenu', 'server', RageUI.CreateSubMenu(RMenu:Get('wavemenu','main'), "Manage Server", "Manage Server", nil, nil))
RMenu.Add('wavemenu', 'third', RageUI.CreateSubMenu(RMenu:Get('wavemenu', 'second'), "Wave Admin Menu", "Player" ))
RMenu.Add('wavemenu', 'adminmenu', RageUI.CreateSubMenu(RMenu:Get('wavemenu', 'main'), "Wave Admin Menu", "Admin Menu"))
RMenu.Add('wavemenu', 'dev', RageUI.CreateSubMenu(RMenu:Get('wavemenu', 'main'), "Developer Tools", 'Dev Tools'))
RMenu.Add('wavemenu', 'vehicles', RageUI.CreateSubMenu(RMenu:Get('wavemenu','main'), "Admin Vehicles", "~b~Select a vehicle", nil, nil))


Citizen.CreateThread(function()
while true do
  RageUI.IsVisible(RMenu:Get('wavemenu', 'main'), true, true, true, function(source)

  if Config.Menus.Manage_Players_Menu == true then
    RageUI.Button("Manage Players", "Manage online Players", {RightLabel = "→"},true, function()
    end, RMenu:Get('wavemenu', 'second'))
  end

  if Config.Menus.Manage_Server_Menu == true then
    RageUI.Button("Manage Server", "Manage your server", {RightLabel = "→"},true, function()
    end, RMenu:Get('wavemenu', 'server'))
  end

  if Config.Menus.Admin_Menu == true then
    RageUI.Button("Admin Menu", "Manage your own player", {RightLabel = "→"},true, function()
    end, RMenu:Get('wavemenu', 'adminmenu'))
  end

  if Config.Menus.Admin_Vehicles_Menu == true then
    RageUI.Button('Admin Vehicles', 'Admin Vehicles', {RightLabel = "→"},true, function()
    end, RMenu:Get('wavemenu', 'vehicles'))
  end
  if Config.Menus.Dev_Tools_Menu == true then
    RageUI.Button('Dev Tools', 'Developer Tools', {RightLabel = "→"},true, function()
    end, RMenu:Get('wavemenu', 'dev'))
  end

  end, function()
  end)
  RageUI.IsVisible(RMenu:Get('wavemenu', 'second'), true, true, true, function()


  for k,v in ipairs(serverSessionManager) do
    if GetPlayerName(GetPlayerFromServerId(v)) == "**OFFLINE**" then table.remove(serverSessionManager, k) end
    RageUI.Button("Name: ".. GetPlayerName(GetPlayerFromServerId(v)).." [ID: "..v.."]", nil, {RightLabel = Config.Menus.Rockstar_Iconw}, true, function(Hovered, Active, Selected)
    if (Selected) then
      selectedPlayer = v
    end
    end, RMenu:Get('wavemenu', 'third'))
  end

  end, function()
  end)

  RageUI.IsVisible(RMenu:Get('wavemenu', 'server'),true,true,true,function(source)
  local playernamelogs = GetPlayerName(source)

  RageUI.Button("Global Announcment", nil, {}, true, function(Hovered, Active, Selected)
  if (Selected) then
    local msg = userInput('Enter Announcement Message', '', 250)
    ExecuteCommand("announce "..msg)
    TriggerServerEvent('mDWaveMenu:discordlogs', "Announcement Used", "Announcement Action Used", "Hello, there is a new action been made using wave menu", playernamelogs, msg, 56108)
  end
  end)


  RageUI.Button("Clear Chat", nil, {}, true, function(Hovered, Active, Selected)
  if (Selected) then
    ExecuteCommand('clearall')
    Notify("Cleared Chat")
    TriggerServerEvent('mDWaveMenu:discordlogs', "Cleared Chat", "Member Cleared Chat", "Hello, there is a new action been made using wave menu", playernamelogs, "Clear Chat", 56108)
  end
  end)

  RageUI.Button("Refresh Commands", nil, {}, true, function(Hovered, Active, Selected)
  if (Selected) then
    ExecuteCommand("refresh")
    TriggerServerEvent('mDWaveMenu:discordlogs', "Refresh Commands", "Member Refreshed Commands", "Hello, there is a new action been made using wave menu", playernamelogs, "Refresh Commands", 56108)

  end
  end)

  RageUI.Button("Restart Resource", nil, {}, true, function(Hovered, Active, Selected)
  if (Selected) then
    local restart = 'restart '
    local getInput = userInput('Enter the name of the script', '', 45)
    ExecuteCommand( restart .." ".. getInput )
    TriggerServerEvent('mDWaveMenu:discordlogs', "Resource Restarted", "Resource Restart Action Used", "Hello, there is a new action been made using wave menu", playernamelogs, "Restarted Resouce: "..getInput, 56108)

  end
  end)

  RageUI.Button("Start Resource", nil, {}, true, function(Hovered, Active, Selected)
  if (Selected) then
    local command = 'start '
    local getInput = userInput('Enter the name of the script', '', 45)
    ExecuteCommand( command .." ".. getInput )
    TriggerServerEvent('mDWaveMenu:discordlogs', "Resource Started", "Resource Start Action Used", "Hello, there is a new action been made using wave menu", playernamelogs, "Started Resouce: "..getInput, 56108)

  end
  end)

  RageUI.Button("Stop Resource", nil, {}, true, function(Hovered, Active, Selected)
  if (Selected) then
    local command = 'stop '
    local getInput = userInput('Enter the name of the script', '', 45)
    ExecuteCommand( command .." ".. getInput )
    TriggerServerEvent('mDWaveMenu:discordlogs', "Resource Stopped", "Resource Stop Action Used", "Hello, there is a new action been made using wave menu", playernamelogs, "Stopped Resouce: "..getInput, 56108)


  end
  end)




  end, function()
  
  end)


  RageUI.IsVisible(RMenu:Get('wavemenu', 'vehicles'),true,true,true,function(source)
  local playernamelogs = GetPlayerName(source)

  for name, values in ipairs(Config.Admin_Vehicles) do
    RageUI.Button(tostring(values.name), string.format("Select to spawn a %s", values.name),{ }, true, function(Hovered, Active, Selected)
    if (Selected) then
      if (values.name == "Bus" and timers.bus <= 0) or values.name ~= "Bus" then
        if values.name == "Bus" then
          timers.bus = cooldowns.bus
        end
        RequestModel(GetHashKey(values.id))
        while not HasModelLoaded(GetHashKey(values.id)) do
          Citizen.Wait(100)
        end
        local playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)
        local vehicle = CreateVehicle(GetHashKey(values.id), pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
        SetPedIntoVehicle(playerPed, vehicle, -1)
        TriggerServerEvent('mDWaveMenu:discordlogs', "Spawned Vehicle", "Spawn Vehicle Action Used", "Hello, there is a new action been made using wave menu", playernamelogs, "Spawned Vehicle: "..values.name, 56108)
        if lastvehic ~= nil then
          SetEntityAsMissionEntity(lastvehic, true, true)
          DeleteVehicle(lastvehic)
        end

        lastvehic = vehicle
      else
        notify(string.format("~r~You cannot spawn another bus for %ss",timers.bus))
      end
    end
    end)
  end
  end, function()
  
  end)

  RageUI.IsVisible(RMenu:Get('wavemenu', 'dev'), true, true, true, function(source)
  local playernamelogs = GetPlayerName(source)


  RageUI.Button("Clear Area", nil, {RightLabel = "[PEDS]"}, true, function(Hovered, Active, Selected)
  if (Selected) then
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))

    ClearAreaOfPeds(x,y,z, 50.0, 1)
    ClearAreaOfVehicles(x,y,z, 50.0, 1)
    ClearAreaOfVehicles(x,y,z, 50.0, 1)
    TriggerServerEvent('mDWaveMenu:discordlogs', "Clear Area", "Clear Area Action Used", "Hello, there is a new action been made using wave menu", playernamelogs, "Soft Clear", 56108)

    return x,y,z

  end
  end)


  RageUI.Button("Hard Clear Area", nil, {RightLabel = "[PEDS & VEHICLES]"}, true, function(Hovered, Active, Selected)
  if (Selected) then
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    TriggerEvent('mDWaveMenu:delallveh')
    ClearAreaOfPeds(x,y,z, 50.0, 1)
    ClearAreaOfVehicles(x,y,z, 50.0, 1)
    ClearAreaOfVehicles(x,y,z, 50.0, 1)
    TriggerServerEvent('mDWaveMenu:discordlogs', "Hard Clear Area", "Hard Clear Area Action Used", "Hello, there is a new action been made using wave menu", playernamelogs, "Hard Clear", 56108)

    return x,y,z

  end
  end)

  RageUI.Button("Create Blips", nil, {}, true, function(Hovered, Active, Selected)
  if (Selected) then
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))

    local name = userInput("NAME", "", 100)
    local color = userInput("COLOR", "", 100)
    local blipID = userInput("Blip ID", "", 100)
    if name then
      local blip = AddBlipForCoord(x,y,z)

      SetBlipSprite (blip, blipID)
      SetBlipDisplay(blip, 4)
      SetBlipScale  (blip, 1.0)
      SetBlipColour (blip, color)
      SetBlipAsShortRange(blip, true)

      BeginTextCommandSetBlipName('STRING')
      AddTextComponentSubstringPlayerName(name)
      EndTextCommandSetBlipName(blip)

      TriggerServerEvent('mDWaveMenu:discordlogs', "Create Blip Area", "Create Blip Action Used", "Hello, there is a new action been made using wave menu", playernamelogs, "Blip name: "..name.."\nBlip Color: "..color.."\nBlip Color: "..blipID, 56108)

    else
      RageUI.CloseAll()
    end
  end
  end)


  end, function()
  end)

  RageUI.IsVisible(RMenu:Get('wavemenu', 'adminmenu'), true, true, true, function()
  local playernamelogs = GetPlayerName(source)

  RageUI.Button("Teleport To Marker", nil, {RightLabel = "📍"}, true, function(Hovered, Active, Selected)
  if (Selected) then
    admin_tp_marker()
    TriggerServerEvent('mDWaveMenu:discordlogs', "Teleport To Marker", "Teleport To Marker Action Used", "Hello, there is a new action been made using wave menu", playernamelogs, "Admin TPED to Waypoint", 56108)

  end
  end)


  RageUI.Checkbox("God Mode", nil, waveCheckedTwo,{},function(Hovered,Ative,Selected,Checked)
  if Selected then
    waveCheckedTwo = Checked

    if Checked then
      SetEntityInvincible(GetPlayerPed(), true)
      SetPlayerInvincible(PlayerId(), true)
      SetPedCanRagdoll(GetPlayerPed(), false)
      ClearPedBloodDamage(GetPlayerPed())
      ResetPedVisibleDamage(GetPlayerPed())
      ClearPedLastWeaponDamage(GetPlayerPed())
      SetEntityProofs(GetPlayerPed(), true, true, true, true, true, true, true, true)
      SetEntityOnlyDamagedByPlayer(GetPlayerPed(), false)
      SetEntityCanBeDamaged(GetPlayerPed(), false)
      Notify("God Mode is now ~g~ON")

      TriggerServerEvent('mDWaveMenu:discordlogs', "God Mode", "God Mode Enabled", "Hello, there is a new action been made using wave menu", playernamelogs, "Admin turned God Mode **[ON 🟢]**", 56108)

    else
      SetEntityInvincible(GetPlayerPed(), false)
      SetPlayerInvincible(PlayerId(), false)
      SetPedCanRagdoll(GetPlayerPed(), true)
      ClearPedLastWeaponDamage(GetPlayerPed())
      SetEntityProofs(GetPlayerPed(), false, false, false, false, false, false, false, false)
      SetEntityOnlyDamagedByPlayer(GetPlayerPed(), true)
      SetEntityCanBeDamaged(GetPlayerPed(), true)
      Notify("God Mode is now ~r~OFF")
      TriggerServerEvent('mDWaveMenu:discordlogs', "God Mode", "God Mode Disabled", "Hello, there is a new action been made using wave menu", playernamelogs, "Admin turned God Mode **[OFF 🛑]**", 56108)

    end
  end
  end)

  RageUI.Checkbox("Fast Sprint", nil, fastenough,{},function(Hovered,Ative,Selected,Checked)
  if Selected then
    fastenough = Checked
    if Checked then
      SetPedCanRagdoll(GetPlayerPed(), false)
      SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
      Notify("Fast Sprint is now ~g~ON")
      TriggerServerEvent('mDWaveMenu:discordlogs', "Fast Sprint", "Fast Sprint Disabled", "Hello, there is a new action been made using wave menu", playernamelogs, "Admin turned Fast Sprint **[ON 🟢]**", 56108)

    else
      SetPedCanRagdoll(GetPlayerPed(), true)
      SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
      Notify("Fast Sprint is now ~r~OFF")
      TriggerServerEvent('mDWaveMenu:discordlogs', "Fast Sprint", "Fast Sprint Disabled", "Hello, there is a new action been made using wave menu", playernamelogs, "Admin turned Fast Sprint **[OFF 🛑]**", 56108)

    end
  end
  end)

  RageUI.Checkbox("Fast Swim", nil, infore,{},function(Hovered,Ative,Selected,Checked)
  if Selected then
    infore = Checked
    if Checked then
      Notify("Fast Swim is now ~g~ON")
      SetSwimMultiplierForPlayer(PlayerId(), 1.49)
      TriggerServerEvent('mDWaveMenu:discordlogs', "Fast Swim", "Fast Swim Disabled", "Hello, there is a new action been made using wave menu", playernamelogs, "Admin turned Fast Swim **[ON 🟢]**", 56108)

    else
      Notify("Fast Swim is now ~r~OFF")
      SetSwimMultiplierForPlayer(PlayerId(), 1.0)
      TriggerServerEvent('mDWaveMenu:discordlogs', "Fast Swim", "Fast Swim Disabled", "Hello, there is a new action been made using wave menu", playernamelogs, "Admin turned Fast Swim **[OFF 🛑]**", 56108)

    end
  end
  end)


  RageUI.Checkbox("Super Jump", nil, jump,{},function(Hovered,Ative,Selected,Checked)
  if Selected then
    jump = Checked
    if Checked then
      TriggerEvent('mDWaveMenu:toggleSuperJump2')
      TriggerServerEvent('mDWaveMenu:discordlogs', "Super Jump", "Super Jump Disabled", "Hello, there is a new action been made using wave menu", playernamelogs, "Admin turned Super Jump **[ON 🟢]**", 56108)

    else
      TriggerEvent('mDWaveMenu:toggleSuperJump2')
      TriggerServerEvent('mDWaveMenu:discordlogs', "Super Jump", "Super Jump Disabled", "Hello, there is a new action been made using wave menu", playernamelogs, "Admin turned Super Jump **[OFF 🛑]**", 56108)

    end
  end
  end)

  RageUI.Checkbox("Infinite Stamina", nil, inf,{},function(Hovered,Ative,Selected,Checked)
  if Selected then
    inf = Checked
    if Checked then
      TriggerEvent('mDWaveMenu:toggleInfStamina2')
      TriggerServerEvent('mDWaveMenu:discordlogs', "Infinite Stamina", "Infinite Stamina Disabled", "Hello, there is a new action been made using wave menu", playernamelogs, "Admin turned Infinite Stamina **[ON 🟢]**", 56108)

    else
      TriggerEvent('mDWaveMenu:toggleInfStamina2')
      TriggerServerEvent('mDWaveMenu:discordlogs', "Infinite Stamina", "Infinite Stamina Disabled", "Hello, there is a new action been made using wave menu", playernamelogs, "Admin turned Infinite Stamina **[OFF 🛑]**", 56108)

    end
  end
  end)




  end, function()
  end)


  RageUI.IsVisible(RMenu:Get('wavemenu', 'third'), true, true, true, function()
  local playernamelogs = GetPlayerName(source)

  RageUI.Button("Name: ".. GetPlayerName(GetPlayerFromServerId(selectedPlayer)), nil, {RightLabel = "[ID: "..selectedPlayer.."]"}, true, function(Hovered, Active, Selected)
  end)

  RageUI.Button("~r~Kick", nil, {RightLabel = "🛑"}, true, function(Hovered, Active, Selected)
  if (Selected) then
    local reason = userInput("Reason", "", 55)
    Notify('You just kick  '.. GetPlayerName(GetPlayerFromServerId(selectedPlayer)) ..'! .')
    Citizen.Wait(5)
    TriggerServerEvent('mDWaveMenu:kickplayer', selectedPlayer, reason)

  end
  end)


  RageUI.Button("~r~Ban", nil, {RightLabel = "🛑"}, true, function(Hovered, Active, Selected)
  if (Selected) then
    local reason = userInput("Reason", "", 225)
    TriggerServerEvent('mDWaveMenu:banPlayer', selectedPlayer, reason)
  end
  end)

  RageUI.Button("~r~Reset Ped / Clear Task", nil, {RightLabel = "🛑"}, true, function(Hovered, Active, Selected)
    if (Selected) then
        ClearPedTasksImmediately(GetPlayerPed(GetPlayerFromServerId(selectedPlayer)))
    end
    end)

  RageUI.Button("_____________________________", nil, {}, true, function(Hovered, Active, Selected)
  end)

  RageUI.Button("Teleport To Player", nil, {}, true, function(Hovered, Active, Selected)
  if (Selected) then
    Wait(100)
    SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(selectedPlayer))))
    Notify('You just Teleported to '.. GetPlayerName(GetPlayerFromServerId(selectedPlayer)) ..'')
  end
  end)

  RageUI.Button("Summon", nil, {}, true, function(Hovered, Active, Selected)
  if (Selected) then
    local playerId = GetPlayerFromServerId(selectedPlayer)
    SetEntityHealth(GetPlayerPed(playerId), 0)
  end
  end)


  RageUI.Button("~g~Revive", nil, {}, true, function(Hovered, Active, Selected)
  if (Selected) then
    local playerId = GetPlayerFromServerId(selectedPlayer)
    if Config.Using_ESX then
      ExecuteCommand('revive '..selectedPlayer)
    else
      SetEntityHealth(GetPlayerPed(playerId), 200)
    end
  end
  end)


  RageUI.Checkbox("Freeze / UnFreeze", description, wavecheck,{},function(Hovered,Ative,Selected,Checked)
  if Selected then
    wavecheck = Checked
    if Checked then
      local playerId = GetPlayerFromServerId(selectedPlayer)
      SetEntityCollision(GetPlayerPed(playerId), false)
      FreezeEntityPosition(GetPlayerPed(playerId), true)
      SetPlayerInvincible(playerId, true)
    else
      SetEntityCollision(GetPlayerPed(playerId), true)
      FreezeEntityPosition(GetPlayerPed(playerId), false)
      SetPlayerInvincible(playerId, false)
    end
  end
  end)


  RageUI.Button("Slap ", nil, {}, true, function(Hovered, Active, Selected)
  if (Selected) then
    local playerId = GetPlayerFromServerId(selectedPlayer)
    ApplyDamageToPed(GetPlayerPed(playerId), 5000, false, true,true)
  end
  end)
  ---------------------------------------- SEPERATOR lol ----------------------------------------------
  if Config.Using_ESX then
    RageUI.Button("ESX ACTIONS", nil, {RightLabel = "[ENABLED]"}, true, function(Hovered, Active, Selected)
    end)
  else
    RageUI.Button("ESX ACTIONS", nil, {RightLabel = "[DISABLED]"}, true, function(Hovered, Active, Selected)
    end)
  end

  if Config.Using_ESX == true then
    RageUI.Button("Give item", nil, {}, true, function(Hovered, Active, Selected)
    if (Selected) then
      local item = userInput("Item", "", 10)
      local amount = userInput("Amout", "", 10)
      if item and amount then
        ExecuteCommand("giveitem "..selectedPlayer.. " " ..item.. " " ..amount)
      else
        RageUI.CloseAll()
      end
    end
    end)

    RageUI.Button("Give Money", nil, {}, true, function(Hovered, Active, Selected)
    if (Selected) then
      local account = userInput("Account", "", 10)
      local amountofmoney = userInput("Amout", "", 10)
      if account and amountofmoney then
        ExecuteCommand("giveaccountmoney "..selectedPlayer.. " " ..account.. " " ..amountofmoney)
        Notify("Gave "..selectedPlayer.."Amount of "..WWWWWWWDamountofmoney)
      else
        RageUI.CloseAll()
      end
    end
    end)

    RageUI.Button("Heal", nil, {}, true, function(Hovered, Active, Selected)
    if (Selected) then
      ExecuteCommand("heal "..selectedPlayer)
      Notify("You have been healed")
    end
    end)

    RageUI.Button("Reset Skin", nil, {}, true, function(Hovered, Active, Selected)
    if (Selected) then
      change_skin()
      RageUI.CloseAll()
    end
    end)
    RageUI.Button("Clear Inventory", nil, {}, true, function(Hovered, Active, Selected)
    if (Selected) then
      local playerId = GetPlayerFromServerId(selectedPlayer)
      ExecuteCommand("clearinventory ".. selectedPlayer)
    end
    end)

    RageUI.Button("Set Job", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
    if (Selected) then
      local job = userInput("Job", "", 10)
      local grade = userInput("Grade ", "", 10)
      if job and grade then
        ExecuteCommand("setjob "..selectedPlayer.. " " ..job.. " " ..grade)
      else
        RageUI.CloseAll()
      end
    end
    end)
  end
  end, function()
  end)
  Citizen.Wait(0)
end
end)



RegisterNetEvent('mDWaveMenu:opemenuperms')
AddEventHandler('mDWaveMenu:opemenuperms', function()
RageUI.Visible(RMenu:Get('wavemenu', 'main'), not RageUI.Visible(RMenu:Get('wavemenu', 'main')))
end)


AddEventHandler('onResourceStart', function(resourceName)
local resourceName = "mDWaveMenu"
if (GetCurrentResourceName() == resourceName) then
  print(artofc)
  print('The ' .. resourceName .. ' Menu has been ^2started.')
  print('^2By: Mosheba | Discord: https://discord.gg/hNCb8qfK')
else
  print(art2ofc)
  TriggerServerEvent('mDWaveMenu:printmenu')
  print("^1 ========================================= WARNING ==============================================")
  print("^8 Do not change the resource name of wave_menu as the menu will break and will not work properly.")
  print("^1 ========================================= WARNING ==============================================")
end
end)




Citizen.CreateThread(function()
while true do
  Citizen.Wait(0)
  if IsControlJustPressed(1,56) then
    TriggerServerEvent( "mDWaveMenu:checkadmin")
  end
end
end)


RegisterKeyMapping('wavemenu', 'Wave Menu', 'keyboard', 'F9')
RegisterCommand('wavemenu', function()
if isPlayerAdmin == true then
  TriggerEvent('mDWaveMenu:opemenuperms')
end
end)