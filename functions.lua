local superJump = false
local inininfStamina = false

function userInput(TextEntry, ExampleText, MaxStringLenght)
  AddTextEntry('FMMC_KEY_TIP1', TextEntry)
  DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
  blockinput = true
  while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
    Citizen.Wait(0)
  end
  if UpdateOnscreenKeyboard() ~= 2 then
    local result = GetOnscreenKeyboardResult()
    Citizen.Wait(500)
    blockinput = false
    return result
  else
    Citizen.Wait(500)
    blockinput = false
    return nil
  end
end

function Notify(text)
  SetNotificationTextEntry('STRING')
  AddTextComponentString(text)
  DrawNotification(false, true)
end

function DrawTxt(text,r,z)
  SetTextColour(225, 55, 55, 255)
  SetTextFont(0)
  SetTextProportional(1)
  SetTextScale(0.0,0.4)
  SetTextDropshadow(1,0,0,0,255)
  SetTextEdge(1,0,0,0,255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(r,z)
end






Citizen.CreateThread(function()
while true do
  Wait(1)
  -- controllo del giocatore, se esiste e ha un id.
  for i = 0, 255 do
    if NetworkIsPlayerActive(i) and GetPlayerPed(i) ~= GetPlayerPed(-1) then
      ped = GetPlayerPed(i)
      blip = GetBlipFromEntity(ped)
      -- Crea il nome sulla testa del giocatore
      idTesta = Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, GetPlayerName(i), false, false, "", false)

      if mostranomi then
        Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta, 0, true) -- Aggiunge il nome de giocatore sulla testa
        -- Mostra se il giocatore sta parlando.
        if NetworkIsPlayerTalking(i) then
          Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta, 9, true)
        else
          Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta, 9, false)
        end
      else -- Rimuove tutti i blip se mostranomi = false
        Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta, 9, false)
        Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta, 0, false)
      end

      if mostrablip then
        if not DoesBlipExist(blip) then -- Con questo aggiungo i blip sulla testa dei giocatori.
          blip = AddBlipForEntity(ped)
          SetBlipSprite(blip, 1) -- imposto il blip sulla posizione "blip" con l'id 1
          Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true) -- Aggiunge effettivamente il blip
        else -- se il blip esiste, allora lo aggiorno
          veh = GetVehiclePedIsIn(ped, false) -- questo lo uso per aggiornare ogni volta il veicolo su cui il ped è salito
          blipSprite = GetBlipSprite(blip)
          if not GetEntityHealth(ped) then -- controllo se il giocatore è morto o no
            if blipSprite ~= 274 then
              SetBlipSprite(blip, 274)
              Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) -- Aggiunge effettivamente il blip
            end
          elseif veh then -- controllo se il giocatore è su un veicolo.
            calsseVeicolo = GetVehicleClass(veh)
            modelloVeicolo = GetEntityModel(veh)
            if calsseVeicolo == 15 then -- La classe 15 indica un veicolo volante
              if blipSprite ~= 422 then -- controllo se il blip non è il 422, ovvero l'aereo
                SetBlipSprite(blip, 422) -- se true lo imposto.
                Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) -- Aggiunge effettivamente il blip
              end
            elseif calsseVeicolo == 16 then -- controllo se il ped sta su un aereo
              if modelloVeicolo == GetHashKey("besra") or modelloVeicolo == GetHashKey("hydra") or modelloVeicolo == GetHashKey("lazer") then -- controllo se il modello è un jet militare
                if blipSprite ~= 424 then
                  SetBlipSprite(blip, 424)
                  Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) -- Aggiunge effettivamente il blip
                end
              elseif blipSprite ~= 423 then
                SetBlipSprite(blip, 423)
                Citizen.InvokeNative (0x5FBCA48327B914DF, blip, false) -- Aggiunge effettivamente il blip
              end
            elseif calsseVeicolo == 14 then -- boat
              if blipSprite ~= 427 then
                SetBlipSprite(blip, 427)
                Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) -- Aggiunge effettivamente il blip
              end
            elseif modelloVeicolo == GetHashKey("insurgent") or modelloVeicolo == GetHashKey("insurgent2") or modelloVeicolo == GetHashKey("limo2") then
              if blipSprite ~= 426 then
                SetBlipSprite(blip, 426)
                Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) -- Aggiunge effettivamente il blip
              end
            elseif modelloVeicolo == GetHashKey("rhino") then -- tank
              if blipSprite ~= 421 then
                SetBlipSprite(blip, 421)
                Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) -- Aggiunge effettivamente il blip
              end
            elseif blipSprite ~= 1 then -- default blip
              SetBlipSprite(blip, 1)
              Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true) -- Aggiunge effettivamente il blip
            end
            -- Show number in case of passangers
            passengers = GetVehicleNumberOfPassengers(veh)
            if passengers then
              if not IsVehicleSeatFree(veh, -1) then
                passengers = passengers + 1
              end
              ShowNumberOnBlip(blip, passengers)
            else
              HideNumberOnBlip(blip)
            end
          else
            -- Se nessuno degli else per le auto viene verificato, allora setto il blip normale.
            HideNumberOnBlip(blip)
            if blipSprite ~= 1 then -- il blip default è 1
              SetBlipSprite(blip, 1)
              Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true) -- Aggiunge effettivamente il blip
            end
          end
          SetBlipRotation(blip, math.ceil(GetEntityHeading(veh))) -- con questo aggiorno la rotazione a seconda del veicolo
          SetBlipNameToPlayerName(blip, i) -- aggirono il blip del giocatore
          SetBlipScale(blip, 0.85) -- dimensione
          -- se il menù con la mappa grande è aperto, allora setto il blip con un alpha massimo
          -- con questo poi controllo la distanza dal giocatore per il nome sulla testa
          if IsPauseMenuActive() then
            SetBlipAlpha(blip, 255)
          else -- se la prima non è confermata
            x1, y1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true)) -- non ho messo la z perché non mi serve
            x2, y2 = table.unpack(GetEntityCoords(GetPlayerPed(i), true)) -- uguale qua sotto
            distanza = (math.floor(math.abs(math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))) / -1)) + 900
            -- lo ho fatto così perché si....
            if distanza < 0 then
              distanza = 0
            elseif distanza > 255 then
              distanza = 255
            end
            SetBlipAlpha(blip, distanza)
          end
        end
      else
        RemoveBlip(blip)
      end
    end
  end
end
end)


local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
  local iter, id = initFunc()
  if not id or id == 0 then
    disposeFunc(iter)
    return
  end

  local enum = {handle = iter, destructor = disposeFunc}
  setmetatable(enum, entityEnumerator)

  local next = true
  repeat
    coroutine.yield(id)
    next, id = moveFunc(iter)
  until not next

  enum.destructor, enum.handle = nil, nil
  disposeFunc(iter)
  end)
end


function DrawPlayerInfo(target)
  drawTarget = target
  drawInfo = true
end

function StopDrawPlayerInfo()
  drawInfo = false
  drawTarget = 0
end
Citizen.CreateThread( function()
while true do
  Citizen.Wait(0)
  if drawInfo then
    local text = {}
    -- cheat checks
    local targetPed = GetPlayerPed(drawTarget)

    table.insert(text,"[E] Stop")

    for i,theText in pairs(text) do
      SetTextFont(0)
      SetTextProportional(1)
      SetTextScale(0.0, 0.30)
      SetTextDropshadow(0, 0, 0, 0, 255)
      SetTextEdge(1, 0, 0, 0, 255)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      AddTextComponentString(theText)
      EndTextCommandDisplayText(0.3, 0.7+(i/30))
    end

    if IsControlJustPressed(0,103) then
      local targetPed = PlayerPedId()
      local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

      RequestCollisionAtCoord(targetx,targety,targetz)
      NetworkSetInSpectatorMode(false, targetPed)

      StopDrawPlayerInfo()

    end

  end
end
end)




function admin_tp_marker()
  local WaypointHandle = GetFirstBlipInfoId(8)

  if DoesBlipExist(WaypointHandle) then
    local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

    for height = 1, 1000 do
      SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

      local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

      if foundGround then
        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

        break
      end

      Citizen.Wait(0)
    end

    Notify("Teleported To Waypoint")
  else
    Notify("There is no waypoint")
  end
end



local noclip = false
local noclip_speed = 1.0



RegisterNetEvent("mDWaveMenu:toggleSuperJump2")
AddEventHandler("mDWaveMenu:toggleSuperJump2", function()
superJump = not superJump
if superJump then
  Notify("Super Jump is now ~g~ON")
else
  Notify("Super Jump is now ~r~OFF")
end
end)

RegisterNetEvent("mDWaveMenu:toggleInfStamina2")
AddEventHandler("mDWaveMenu:toggleInfStamina2", function()
inininfStamina = not inininfStamina
if inininfStamina then
  Notify("Infinite Stamina is now ~g~ON")
else
  Notify("Infinite Stamina is now ~r~OFF")
end
end)

function change_skin()
  TriggerEvent('esx_skin:openSaveableMenu', source)
  Notify("Opening Skin Menu")
end

Citizen.CreateThread(function()

while true do
  Citizen.Wait(0)

  if inininfStamina then
    RestorePlayerStamina(source, 1.0)
  end

  if neverWanted then
    SetPlayerWantedLevel(PlayerId(), 0, false)
    SetPlayerWantedLevelNow(PlayerId(), false)
  end

  if superJump then
    SetSuperJumpThisFrame(PlayerId())
  end
end

end)

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

RegisterNetEvent("mDWaveMenu:delallveh")
AddEventHandler("mDWaveMenu:delallveh", function ()
for vehicle in EnumerateVehicles() do
  if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then
    SetVehicleHasBeenOwnedByPlayer(vehicle, false)
    SetEntityAsMissionEntity(vehicle, false, false)
    DeleteVehicle(vehicle)
    if (DoesEntityExist(vehicle)) then
      DeleteVehicle(vehicle)
    end
  end
end
end)

local mostrablip = false

RegisterNetEvent('mDWaveMenu:masterBlipOn')
AddEventHandler('mDWaveMenu:masterBlipOn', function()
mostrablip = not mostrablip
if mostrablip then
  mostrablip = true
  -- notifica blips abilitati
end
end)


RegisterNetEvent('mDWaveMenu:masterBlipOFF')
AddEventHandler('mDWaveMenu:masterBlipOFF', function()
mostrablip = not mostrablip
if mostrablip then
  mostrablip = false
  -- notifica blips disabilitati
end
end)


-- Announce by Setro
--how long you want the thing to last for. in seconds.
announcestring = false
lastfor = 5

--DO NOT TOUCH BELOW THIS LINE OR YOU /WILL/ FUCK SHIT UP.
--DO NOT BE STUPID AND WHINE TO ME ABOUT THIS BEING BROKEN IF YOU TOUCHED THE LINES BELOW.
RegisterNetEvent('announce')
announcestring = false
AddEventHandler('announce', function(msg)
announcestring = msg
PlaySoundFrontend(-1, "DELETE","HUD_DEATHMATCH_SOUNDSET", 1)
Citizen.Wait(lastfor * 1000)
announcestring = false
end)

function Initialize(scaleform)
  local scaleform = RequestScaleformMovie(scaleform)
  while not HasScaleformMovieLoaded(scaleform) do
    Citizen.Wait(0)
  end
  PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
  PushScaleformMovieFunctionParameterString("~y~Announcement")
  PushScaleformMovieFunctionParameterString(announcestring)
  PopScaleformMovieFunctionVoid()
  return scaleform
end


Citizen.CreateThread(function()
while true do
  Citizen.Wait(0)
  if announcestring then
    scaleform = Initialize("mp_big_message_freemode")
    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
  end
end
end)


