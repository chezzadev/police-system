 -- Police System --
-- Made By Chezza --

-- { Code } --

local Keys = {
[“ESC”] = 322, [“F1”] = 288, [“F2”] = 289, [“F3”] = 170, [“F5”] = 166, [“F6”] = 167, [“F7”] = 168, [“F8”] = 169,
[“F9”] = 56, [“F10”] = 57, ["~"] = 243, [“1”] = 157, [“2”] = 158, [“3”] = 160, [“4”] = 164, [“5”] = 165,
[“6”] = 159, [“7”] = 161, [“8”] = 162, [“9”] = 163, ["-"] = 84, ["="] = 83, [“BACKSPACE”] = 177, [“TAB”] = 37,
[“Q”] = 44, [“W”] = 32, [“E”] = 38, [“R”] = 45, [“T”] = 245, [“Y”] = 246, [“U”] = 303, [“P”] = 199, ["["] = 39,
["]"] = 40, [“ENTER”] = 18, [“CAPS”] = 137, [“A”] = 34, [“S”] = 8, [“D”] = 9, [“F”] = 23, [“G”] = 47, [“H”] = 74,
[“K”] = 311, [“L”] = 182, [“LEFTSHIFT”] = 21, [“Z”] = 20, [“X”] = 73, [“C”] = 26, [“V”] = 0, [“B”] = 29,
[“N”] = 249, [“M”] = 244, [","] = 82, ["."] = 81, [“LEFTCTRL”] = 36, [“LEFTALT”] = 19, [“SPACE”] = 22,
[“RIGHTCTRL”] = 70, [“HOME”] = 213, [“PAGEUP”] = 10, [“PAGEDOWN”] = 11, [“DELETE”] = 178, [“LEFT”] = 174,
[“RIGHT”] = 175, [“TOP”] = 27, [“DOWN”] = 173, [“NENTER”] = 201, [“N4”] = 108, [“N5”] = 60, [“N6”] = 107,
[“N+”] = 96, [“N-”] = 97, [“N7”] = 117, [“N8”] = 61, [“N9”] = 118
}

cop = 0
onduty = false

AddEventHandler('onClientMapStart', function()
    TriggerServerEvent('onjoin')
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1500)
        TriggerServerEvent('check')
    end
end)

RegisterNetEvent('cl-cop')
AddEventHandler('cl-cop', function(iscop)
    cop = iscop
end)

-- { Menu } --

Citizen.CreateThread(function()
    local emotes = { 'Clipboard', 'Notepad', 'Lean', 'Cop Idle', 'Binoculars', 'Camera'}
    local loadouts = { 'LSPD', 'SAHP', 'BCSO', 'SWAT'}
    local currentEmoteIndex = 1
    local selectedEmoteIndex = 1
    local currentLoadIndex = 1
    local selectedLoadIndex = 1

    WarMenu.CreateMenu('menu', 'Police Menu')
    WarMenu.CreateSubMenu('actions', 'menu', 'Actions')
    WarMenu.CreateSubMenu('trafficactions', 'actions', 'Traffic Actions')
    WarMenu.CreateSubMenu('physactions', 'actions', 'Physical Actions')
    WarMenu.CreateSubMenu('jail', 'actions', 'Jail Actions')
    WarMenu.CreateSubMenu('loadouts', 'actions', 'Loadouts')
    WarMenu.CreateSubMenu('emoteMenu', 'menu', 'Emotes')
    WarMenu.CreateSubMenu('placeables', 'menu', 'Placeables')
    WarMenu.CreateSubMenu('polmanage', 'menu', 'Police Management')
    WarMenu.CreateSubMenu('closeMenu', 'menu', 'Are you sure?')
    while true do
        if WarMenu.IsMenuOpened('menu') then
            WarMenu.MenuButton('Actions', 'actions')
            WarMenu.MenuButton('Placeables', 'placeables')
            WarMenu.MenuButton('Emotes', 'emoteMenu')
            if cop == 2 then
                WarMenu.MenuButton('Police Management', 'polmanage')
            end
            WarMenu.MenuButton('Exit', 'closeMenu')
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'menu') then
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('polmanage') then
            if WarMenu.Button('Add Cop') then
                TriggerServerEvent('addcop', KeyboardInput("Enter Player's ID", "", 5))
            elseif WarMenu.Button('Remove Cop') then
                TriggerServerEvent('remcop', KeyboardInput("Enter Player's ID", "", 5))
            elseif WarMenu.MenuButton('←←← Back','menu') then
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('actions') then 
            if onduty == false then
                if WarMenu.Button('Go On-Duty') then
                    onduty = true
                    onDuty()
                    TriggerServerEvent('onduty')
                end
            else
                if WarMenu.Button('Go Off-Duty') then
                    onduty = false
                    offDuty()
                    TriggerServerEvent('offduty')
                end
            end

            if onduty == true then
                if WarMenu.MenuButton('Traffic Actions', 'trafficactions') then
                elseif WarMenu.MenuButton('Physical Actions', 'physactions') then
                elseif WarMenu.MenuButton('Jail Actions', 'jail') then
                elseif WarMenu.MenuButton('Loadouts', 'loadouts') then
                elseif WarMenu.MenuButton('←←← Back','menu') then
                end
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('loadouts') then
            if WarMenu.ComboBox('Select Loadout', loadouts, currentLoadIndex, selectedLoadIndex, function(currentIndexLoad, selectedIndexLoad)
                currentLoadIndex = currentIndexLoad
                selectedLoadIndex = selectedIndexLoad
            end) then
            elseif WarMenu.Button("Set Loadout") then
                if selectedLoadIndex == 1 then
                    setLoadout(1)
                elseif selectedLoadIndex == 2 then 
                    setLoadout(2)
                elseif selectedLoadIndex == 3 then  
                    setLoadout(3) 
                elseif selectedLoadIndex == 4 then
                    setLoadout(4)
                end	
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('trafficactions') then
            if WarMenu.Button('Search Ped') then
                playEmote('PROP_HUMAN_BUM_BIN')
                TriggerServerEvent('searchped', KeyboardInput("Enter Player's ID", "", 5))
            elseif WarMenu.Button('Search Vehicle') then
                playEmote('PROP_HUMAN_BUM_BIN')
                TriggerServerEvent('searchcar', KeyboardInput("Enter Player's ID", "", 5))
            elseif WarMenu.Button('Run Name') then
                TriggerServerEvent('runname', KeyboardInput("Enter Player's ID", "", 5))
            elseif WarMenu.Button('Run Plate') then
                TriggerServerEvent('runplate', KeyboardInput("Enter Player's ID", "", 5))
            elseif WarMenu.MenuButton('←←← Back','actions') then
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('physactions') then
            if WarMenu.Button('Cuff') then
                TriggerEvent('cuff')
            elseif WarMenu.Button("Grab") then
                DragPlayer()
            elseif WarMenu.Button("Place in vehicle") then
                TriggerEvent('Cuff:getSeatedVehicle')
            elseif WarMenu.Button("Remove from vehicle") then
                TriggerEvent('Cuff:getUnseatVehicle')
				Citizen.Wait(500)
		        DragPlayer()
			elseif WarMenu.Button('Crouch') then
                crouch()
            elseif WarMenu.MenuButton('←←← Back','actions') then
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('jail') then
            if WarMenu.Button('Jail') then
                TriggerServerEvent('jail', KeyboardInput("Enter the persons ID", "", 5), KeyboardInput("Enter Jail Time", "", 3))
            elseif WarMenu.Button('Unjail') then
                TriggerServerEvent('unjail', KeyboardInput("Enter the persons ID", "", 5))
            elseif WarMenu.MenuButton('←←← Back','actions') then
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('emoteMenu') then
            if WarMenu.ComboBox('Select Emote', emotes, currentEmoteIndex, selectedEmoteIndex, function(currentIndexEmote, selectedIndexEmote)
                currentEmoteIndex = currentIndexEmote
                selectedEmoteIndex = selectedIndexEmote
            end) then
            elseif WarMenu.Button("Play Emote") then
                if selectedEmoteIndex == 1 then
                    playEmote(1) 
                elseif selectedEmoteIndex == 2 then
                    playEmote(2) 
                elseif selectedEmoteIndex == 3 then
                    playEmote(3) 
                elseif selectedEmoteIndex == 4 then
                    playEmote(4) 
                elseif selectedEmoteIndex == 5 then
                    playEmote(5) 
                elseif selectedEmoteIndex == 6 then
                    playEmote(6) 
                end	
            elseif WarMenu.Button('Cancel Emote') then
                cancelEmoteNow()
            elseif WarMenu.MenuButton('←←← Back','menu') then
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('placeables') then
            if WarMenu.Button('Spawn/Delete Spikestrip') then
                TriggerEvent('police:Deploy')
            elseif WarMenu.Button('Spawn/Delete Cones') then
                TriggerEvent('police:DeployC')
            elseif WarMenu.MenuButton('←←← Back','menu') then
            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 166) then -- F5 by default --
            if cop >= 1 then
                WarMenu.OpenMenu('menu')
            end
        end
        Citizen.Wait(0)
    end
end)

-- { End Of Menu } --

-- { Events } --

Citizen.CreateThread(function()
	ped = GetPlayerPed(-1)
	while true do
		Citizen.Wait(0)
		if IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then
			isCuffed = true
		elseif isCuffed then
			TaskPlayAnim(ped, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
			DisableControlAction(1, 24, true)
			DisableControlAction(1, 25, true)
			DisableControlAction(1, 59, true)
			DisableControlAction(1, 63, true)
			DisableControlAction(1, 64, true)
			DisableControlAction(1, 123, true)
			DisableControlAction(1, 124, true)
			DisableControlAction(1, 125, true)
			DisableControlAction(1, 133, true)
			DisableControlAction(1, 134, true)
			SetPedCurrentWeaponVisible(GetPlayerPed(-1), false, true, false, false)
		end
	end
end)

RegisterNetEvent("cuff1")
AddEventHandler("cuff1", function()
	ped = GetPlayerPed(-1)
	if (DoesEntityExist(ped)) then
		Citizen.CreateThread(function()
		RequestAnimDict("mp_arresting")
			while not HasAnimDictLoaded("mp_arresting") do
				Citizen.Wait(0)
			end
			if isCuffed then
				ClearPedSecondaryTask(ped)
				StopAnimTask(ped, "mp_arresting", "idle", 3)
				SetEnableHandcuffs(ped, false)
				isCuffed = false
			else
				TaskPlayAnim(ped, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
				SetEnableHandcuffs(ped, true)
				Citizen.Trace("cuffed")
				isCuffed = true
			end
		end)
	end
end)

RegisterNetEvent("cuff")
AddEventHandler("cuff", function()
	local ped = GetPlayerPed(-1)
	local nearestPlayer = GetNearestPlayerToEntity(ped)
	local entityType = GetEntityType(ped)
	shortestDistance = 2
	closestId = 0
	for id = 0, 32 do
        if NetworkIsPlayerActive( id ) and GetPlayerPed(id) ~= GetPlayerPed(-1) then
            ped1 = GetPlayerPed( id )
            local x,y,z = table.unpack(GetEntityCoords(ped))
            if (GetDistanceBetweenCoords(GetEntityCoords(ped1), x,y,z) <  shortestDistance) then
                shortestDistance = GetDistanceBetweenCoords(GetEntityCoords(ped), x,y,z)
                closestId = GetPlayerServerId(id)		
            end
        end		
	end
	TriggerServerEvent("cuffNear", closestId)
end)

RegisterNetEvent('Cuff:forcedEnteringVeh')
AddEventHandler('Cuff:forcedEnteringVeh', function(veh)
		local pos = GetEntityCoords(PlayerPedId())
		local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
		local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)

		if vehicleHandle ~= nil then
			SetPedIntoVehicle(PlayerPedId(), vehicleHandle, 1)
		end
end)

RegisterNetEvent('Cuff:unseatme')
AddEventHandler('Cuff:unseatme', function(t)
	local ped = GetPlayerPed(t)
	ClearPedTasksImmediately(ped)
	plyPos = GetEntityCoords(PlayerPedId(),  true)
	local xnew = plyPos.x-0
	local ynew = plyPos.y-0

	SetEntityCoords(PlayerPedId(), xnew, ynew, plyPos.z)
end)


RegisterNetEvent('Cuff:getUnseatVehicle')
AddEventHandler('Cuff:getUnseatVehicle', function()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("Cuff:getUnseatServer", GetPlayerServerId(t))
	else
	drawNotification("There is no player nearby to unseat from your car.")
	end
end)

RegisterNetEvent('Cuff:getSeatedVehicle')
AddEventHandler('Cuff:getSeatedVehicle', function()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		local v = GetVehiclePedIsIn(PlayerPedId(), true)
		TriggerServerEvent("Cuff:getSeatedServer", GetPlayerServerId(t), v)
	else
	drawNotification("There is no player nearby to seat into your car.")
	end
end)

-- { End Of Events } --

-- { Functions } --

-- { Getting Players } --

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if target ~= ply then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	return closestPlayer, closestDistance
end

-- { DRAG } --

local drag = false
local officerDrag = -1

function DragPlayer()
	local t, distance = GetClosestPlayer()
	if distance ~= -1 and distance < 3 then
		TriggerServerEvent("police:dragRequest", GetPlayerServerId(t))
	else
		drawNotification("There is no player nearby to drag!")
	end
end

RegisterNetEvent('police:toggleDrag')
AddEventHandler('police:toggleDrag', function(t)
	drag = not drag
	officerDrag = t
end)

Citizen.CreateThread(function()
    while true do  
      Wait(0)
          if drag then
              local ped = GetPlayerPed(GetPlayerFromServerId(officerDrag))
              local myped = PlayerPedId()
              AttachEntityToEntity(myped, ped, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
              playerStillDragged = true
          else
              if(playerStillDragged) then
                  DetachEntity(PlayerPedId(), true, false)
                  playerStillDragged = false
              end
          end	
    end
end)

-- { Crouch } --

local crouched = false

function crouch()
	local ped = GetPlayerPed( -1 )
	RequestAnimSet( "move_ped_crouched" )
	    if ( crouched == true ) then 
            ResetPedMovementClipset( ped, 0 )
            crouched = false 
        elseif ( crouched == false ) then
            SetPedMovementClipset( ped, "move_ped_crouched", 0.25 )
            crouched = true 
        end 
end

-- EMOTES Menu --
-- more emotes available at https://pastebin.com/6mrYTdQv
--local emotes1 
   -- ['smoke'] = "WORLD_HUMAN_SMOKING",
   -- ['cop'] = "WORLD_HUMAN_COP_IDLES",
   -- ['lean'] = "WORLD_HUMAN_LEANING",
  --  ['sit'] = "WORLD_HUMAN_PICNIC",
  --  ['stupor'] = "WORLD_HUMAN_STUPOR",
   -- ['sunbathe2'] = "WORLD_HUMAN_SUNBATHE_BACK",
  --  ['sunbathe'] = "WORLD_HUMAN_SUNBATHE",
   -- ['medic'] = "CODE_HUMAN_MEDIC_TEND_TO_DEAD",
   -- ['clipboard'] = "WORLD_HUMAN_CLIPBOARD",
   -- ['party'] = "WORLD_HUMAN_PARTYING",
  --  ['kneel'] = "CODE_HUMAN_MEDIC_KNEEL",
    --['notepad'] = "CODE_HUMAN_MEDIC_TIME_OF_DEATH",
    --['weed'] = "WORLD_HUMAN_SMOKING_POT",
    --['impatient'] = "WORLD_HUMAN_STAND_IMPATIENT",
    --['fish'] = "WORLD_HUMAN_STAND_FISHING",
    --['weld'] = "WORLD_HUMAN_WELDING",
   -- ['photography'] = "WORLD_HUMAN_PAPARAZZI",
   -- ['film'] = "WORLD_HUMAN_MOBILE_FILM_SHOCKING",
   -- ['cheer'] = "WORLD_HUMAN_CHEERING",
   -- ['binoculars'] = "WORLD_HUMAN_BINOCULARS",
    ---['flex'] = "WORLD_HUMAN_MUSCLE_FLEX",
    --['weights'] = "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS",
    --['yoga'] = "WORLD_HUMAN_YOGA"
--}

local emotePlaying = IsPedActiveInScenario(GetPlayerPed(-1))

function cancelEmote() -- Cancels the emote slowly
    ClearPedTasks(GetPlayerPed(-1))
    emotePlaying = false
end

function cancelEmoteNow() -- Cancels the emote immediately
    ClearPedTasksImmediately(GetPlayerPed(-1))
    emotePlaying = false
end

function playEmote(emoteDic) -- Plays an emote from the given name dictionary
    if not DoesEntityExist(GetPlayerPed(-1)) then -- Return of the ped doesn't exist
        return false
    end

    if IsPedInAnyVehicle(GetPlayerPed(-1)) then -- Returns if the player is in any vehicle
        drawNotification("~r~You must leave the vehicle first")
        return false
    end

    local pedHoldingWeapon = IsPedArmed(GetPlayerPed(-1), 7)
    if pedHoldingWeapon then -- If the player is holding weapon, remove it
        SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263, true)
        drawNotification("Please put away your weapon first next time!")
    end
    if emoteDic == 1 then
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
        emotePlaying = true
    elseif emoteDic == 2 then 
        TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, true)
        emotePlaying = true
    elseif emoteDic == 3 then 
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_LEANING", 0, true)
        emotePlaying = true
    elseif emoteDic == 4 then 
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_COP_IDLES", 0, true)
        emotePlaying = true
    elseif emoteDic == 5 then 
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_BINOCULARS", 0, true)
        emotePlaying = true
    elseif emoteDic == 6 then 
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_PAPARAZZI", 0, true)
        emotePlaying = true
    end

    TaskStartScenarioInPlace(PlayerPedId(), emoteDic, 0, true)
    emotePlaying = true
end



Citizen.CreateThread(function()
    while true do
        if emotePlaying then
            if IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35) then
                cancelEmote() -- Cancels the emote if the player is moving
            end
        end
        Citizen.Wait(0)
    end
end)

-- { Keyboard } --
function KeyboardInput(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
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

-- { Jail } --
injail = false
outjail = true

RegisterNetEvent('jail')
AddEventHandler('jail', function(time)
    local ped = GetPlayerPed(-1)
    if DoesEntityExist(ped) then
        Citizen.CreateThread(function()
            local playerOldLoc = GetEntityCoords(ped, true)
            SetEntityCoords(ped, 1677.233, 2658.618, 45.216)
            injail = true
            outjail = false
            while time > 0 and not outjail do
                RemoveAllPedWeapons(ped, true)
                Citizen.Wait(500)
                if time % 30 == 0 then -- Half
                    TriggerEvent('chatMessage', 'Jail', { 255, 0, 0 }, time .." more seconds until release.")
                end
                local p = GetEntityCoords(ped, true)
                local d = Vdist(1677.233, 2658.618, 45.216, p['x'], p['y'], p['z'])
                if d > 90 then
                    SetEntityCoords(ped, 1677.233, 2658.618, 45.216)
                    if d > 100 then
                        time = time + 30
                        if time > 1000 then
                            time = 1000
                        end
                        TriggerEvent('chatMessage', 'Jail', { 255, 0, 0 }, "Your jail time was extended for an unlawful escape attempt.")
                    end
                end
                time = time - 0.5
            end
            TriggerEvent('chatMessage', "Jail", { 255, 0, 0 },"You have been released from jail.")
            SetEntityCoords(ped, 1855.807, 2601.949, 45.323)
            injail = false
            isCuffed = false
        end)
    end

end)

RegisterNetEvent('unjail')
AddEventHandler('unjail', function()
    outjail = true
end)

-- { Spike strips } --

local spikes_deployed = false
local obj1 = nil
local obj2 = nil
local obj3 = nil

--Distance check
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if spikes_deployed then
            for peeps = 0, 32 do
                if NetworkIsPlayerActive(peeps) then                    
                    local currentVeh = GetVehiclePedIsIn(GetPlayerPed(peeps), false)
                    if currentVeh ~= nil and currentVeh ~= false then
                        local currentVehcoords = GetEntityCoords(currentVeh, true)
                        local obj1coords = GetEntityCoords(obj1, true)
                        local obj2coords = GetEntityCoords(obj2, true)
                        local obj3coords = GetEntityCoords(obj3, true)
                        local DistanceBetweenObj1 = Vdist(obj1coords['x'], obj1coords['y'], obj1coords['z'], currentVehcoords['x'], currentVehcoords['y'], currentVehcoords['z'])
                        local DistanceBetweenObj2 = Vdist(obj2coords['x'], obj2coords['y'], obj2coords['z'], currentVehcoords['x'], currentVehcoords['y'], currentVehcoords['z'])
                        local DistanceBetweenObj3 = Vdist(obj3coords['x'], obj3coords['y'], obj3coords['z'], currentVehcoords['x'], currentVehcoords['y'], currentVehcoords['z'])
                        if DistanceBetweenObj1 < 2.2 or DistanceBetweenObj2 < 2.2 or DistanceBetweenObj3 < 2.2 then
                            if IsVehicleTyreBurst(currentVeh, 0, true) and IsVehicleTyreBurst(currentVeh, 1, true) and IsVehicleTyreBurst(currentVeh, 2, true) and IsVehicleTyreBurst(currentVeh, 3, true) and IsVehicleTyreBurst(currentVeh, 4, true) and IsVehicleTyreBurst(currentVeh, 5, true) then
                            elseif IsVehicleTyreBurst(currentVeh, 0, true) and IsVehicleTyreBurst(currentVeh, 1, true) and IsVehicleTyreBurst(currentVeh, 4, true) and IsVehicleTyreBurst(currentVeh, 5, true) then
                            else
                                TriggerServerEvent("police:spikes", currentVeh, GetPlayerServerId(peeps))
                            end
                        end
                    end
                end
            end
        end
    end
end)
--Distance check
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if spikes_deployed then
            local obj1coords = GetEntityCoords(obj1, true)
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), obj1coords.x, obj1coords.y, obj1coords.z, true) > 200 then -- if the player is too far from his Spikes
                SetEntityAsMissionEntity(obj1, false, false)
                SetEntityAsMissionEntity(obj2, false, false)
                SetEntityAsMissionEntity(obj3, false, false)
                SetEntityVisible(obj1, false)
                SetEntityVisible(obj2, false)
                SetEntityVisible(obj3, false)
                DeleteObject(obj1)
                DeleteObject(obj2)
                DeleteObject(obj3)
                DeleteEntity(obj1)
                DeleteEntity(obj2)
                DeleteEntity(obj3)
                obj1 = nil
                obj2 = nil
                obj3 = nil
                spikes_deployed = false
            end
        end
    end
end)
--Spikes spawn/remove
RegisterNetEvent("police:Deploy")
AddEventHandler("police:Deploy", function()
    Citizen.CreateThread(function()
        if not spikes_deployed then
            local spikes = GetHashKey("p_stinger_04")
            RequestModel(spikes)
            while not HasModelLoaded(spikes) do
                Citizen.Wait(0)
            end
            local playerheading = GetEntityHeading(GetPlayerPed(-1))
            coords1 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 3, 10, -0.7)
            coords2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -5, -0.5)
            obj1 = CreateObject(spikes, coords1['x'], coords1['y'], coords1['z'], true, true, true)
            obj2 = CreateObject(spikes, coords2['x'], coords2['y'], coords2['z'], true, true, true)
            obj3 = CreateObject(spikes, coords2['x'], coords2['y'], coords2['z'], true, true, true)
            SetEntityHeading(obj1, playerheading)
            SetEntityHeading(obj2, playerheading)
            SetEntityHeading(obj3, playerheading)
            AttachEntityToEntity(obj1, GetPlayerPed(-1), 1, 0.0, 4.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
            AttachEntityToEntity(obj2, GetPlayerPed(-1), 1, 0.0, 8.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
            AttachEntityToEntity(obj3, GetPlayerPed(-1), 1, 0.0, 12.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
            Citizen.Wait(10)
            DetachEntity(obj1, true, true)
            DetachEntity(obj2, true, true)
            DetachEntity(obj3, true, true)
            spikes_deployed = true
        else
            spikes_deployed = false
            SetEntityCoords(obj1, -5000.0, -5000.0, 20.0, true, false, false, true)
            SetEntityCoords(obj2, -5000.0, -5000.0, 20.0, true, false, false, true)
            SetEntityCoords(obj3, -5000.0, -5000.0, 20.0, true, false, false, true)
            Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(obj1))
            Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(obj2))
            Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(obj3))
            FIX_DeleteObject(obj1)
            FIX_DeleteObject(obj2)
            FIX_DeleteObject(obj3)
            obj1 = nil
            obj2 = nil
            obj3 = nil
        end
    end)
end)

RegisterNetEvent("police:dietyres")
AddEventHandler("police:dietyres", function(currentVeh)
    SetVehicleTyreBurst(currentVeh, 0, true, 0)
    SetVehicleTyreBurst(currentVeh, 1, true, 1)
    SetVehicleTyreBurst(currentVeh, 2, true, 1)
    SetVehicleTyreBurst(currentVeh, 3, true, 1)
    SetVehicleTyreBurst(currentVeh, 4, true, 3)
    SetVehicleTyreBurst(currentVeh, 5, true, 4)
end)

RegisterNetEvent("police:dietyres2")
AddEventHandler("police:dietyres2", function(peeps)
    SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 0, true, 0)
    SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 1, true, 1)
    SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 2, true, 1)
    SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 3, true, 1)
    SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 4, true, 3)
    SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 5, true, 4)
end)

-- { Cones } --

local cones_deployed = false
local cobj1 = nil
local cobj2 = nil
local cobj3 = nil
local cobj4 = nil
local cobj5 = nil

RegisterNetEvent("police:DeployC")
AddEventHandler("police:DeployC", function()
    Citizen.CreateThread(function()
        if not cones_deployed then
            local cones = GetHashKey("prop_mp_cone_02")
            RequestModel(cones)
            while not HasModelLoaded(cones) do
                Citizen.Wait(0)
            end
            local playerheading = GetEntityHeading(GetPlayerPed(-1))
            coords1 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 3, 10, -0.7)
            coords2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -5, -0.5)
            cobj1 = CreateObject(cones, coords1['x'], coords1['y'], coords1['z'], true, true, true)
            cobj2 = CreateObject(cones, coords2['x'], coords2['y'], coords2['z'], true, true, true)
            cobj3 = CreateObject(cones, coords2['x'], coords2['y'], coords2['z'], true, true, true)
            cobj4 = CreateObject(cones, coords2['x'], coords2['y'], coords2['z'], true, true, true)
            cobj5 = CreateObject(cones, coords2['x'], coords2['y'], coords2['z'], true, true, true)
            SetEntityHeading(cobj1, playerheading)
            SetEntityHeading(cobj2, playerheading)
            SetEntityHeading(cobj3, playerheading)
            SetEntityHeading(cobj4, playerheading)
            SetEntityHeading(cobj5, playerheading)
            AttachEntityToEntity(cobj1, GetPlayerPed(-1), 1, 0.0, 4.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
            AttachEntityToEntity(cobj2, GetPlayerPed(-1), 1, 0.0, 8.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
            AttachEntityToEntity(cobj3, GetPlayerPed(-1), 1, 0.0, 12.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
            AttachEntityToEntity(cobj4, GetPlayerPed(-1), 1, 0.0, 16.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
            AttachEntityToEntity(cobj5, GetPlayerPed(-1), 1, 0.0, 20.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
            Citizen.Wait(10)
            DetachEntity(cobj1, true, true)
            DetachEntity(cobj2, true, true)
            DetachEntity(cobj3, true, true)
            DetachEntity(cobj4, true, true)
            DetachEntity(cobj5, true, true)
            cones_deployed = true
        else
            cones_deployed = false
            SetEntityCoords(cobj1, -5000.0, -5000.0, 20.0, true, false, false, true)
            SetEntityCoords(cobj2, -5000.0, -5000.0, 20.0, true, false, false, true)
            SetEntityCoords(cobj3, -5000.0, -5000.0, 20.0, true, false, false, true)
            SetEntityCoords(cobj4, -5000.0, -5000.0, 20.0, true, false, false, true)
            SetEntityCoords(cobj5, -5000.0, -5000.0, 20.0, true, false, false, true)
            Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(cobj1))
            Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(cobj2))
            Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(cobj3))
            Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(cobj4))
            Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(cobj5))
            FIX_DeleteObject(cobj1)
            FIX_DeleteObject(cobj2)
            FIX_DeleteObject(cobj3)
            FIX_DeleteObject(cobj4)
            FIX_DeleteObject(cobj5)
            cobj1 = nil
            cobj2 = nil
            cobj3 = nil
            cobj4 = nil
            cobj5 = nil
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if cones_deployed then
            local o1x, o1y, o1z = table.unpack(GetEntityCoords(cobj1, true))
            local cVeh = GetClosestVehicle(o1x, o1y, o1z, 50.1, 0, 70)
            if(IsEntityAVehicle(cVeh)) then
                if IsEntityAtEntity(cVeh, cobj1, 20.0, 20.0, 2.0, 0, 1, 0) then
                    local cDriver = GetPedInVehicleSeat(cVeh, -1)
                    TaskVehicleTempAction(cDriver, cVeh, 6, 1000)
                    SetVehicleHandbrake(cVeh, true)
                end
            end
            local o2x, o2y, o2z = table.unpack(GetEntityCoords(cobj2, true))
            local cVeh2 = GetClosestVehicle(o2x, o2y, o2z, 50.1, 0, 70)
            if(IsEntityAVehicle(cVeh2)) then
                if IsEntityAtEntity(cVeh2, cobj2, 20.0, 20.0, 2.0, 0, 1, 0) then
                    local cDriver = GetPedInVehicleSeat(cVeh2, -1)
                    TaskVehicleTempAction(cDriver, cVeh2, 6, 1000)
                    SetVehicleHandbrake(cVeh2, true)
                end
            end
            local o3x, o3y, o3z = table.unpack(GetEntityCoords(cobj3, true))
            local cVeh3 = GetClosestVehicle(o3x, o3y, o3z, 50.1, 0, 70)
            if(IsEntityAVehicle(cVeh3)) then
                if IsEntityAtEntity(cVeh3, cobj3, 20.0, 20.0, 2.0, 0, 1, 0) then
                    local cDriver = GetPedInVehicleSeat(cVeh3, -1)
                    TaskVehicleTempAction(cDriver, cVeh3, 6, 1000)
                    SetVehicleHandbrake(cVeh3, true)
                end
            end
            local o4x, o4y, o4z = table.unpack(GetEntityCoords(cobj3, true))
            local cVeh4 = GetClosestVehicle(o4x, o4y, o4z, 50.1, 0, 70)
            if(IsEntityAVehicle(cVeh4)) then
                if IsEntityAtEntity(cVeh3, cobj3, 20.0, 20.0, 2.0, 0, 1, 0) then
                    local cDriver = GetPedInVehicleSeat(cVeh4, -1)
                    TaskVehicleTempAction(cDriver, cVeh4, 6, 1000)
                    SetVehicleHandbrake(cVeh4, true)
                end
            end
            local o5x, o5y, o5z = table.unpack(GetEntityCoords(cobj3, true))
            local cVeh5 = GetClosestVehicle(o5x, o5y, o5z, 50.1, 0, 70)
            if(IsEntityAVehicle(cVeh5)) then
                if IsEntityAtEntity(cVeh3, cobj3, 20.0, 20.0, 2.0, 0, 1, 0) then
                    local cDriver = GetPedInVehicleSeat(cVeh5, -1)
                    TaskVehicleTempAction(cDriver, cVeh5, 6, 1000)
                    SetVehicleHandbrake(cVeh5, true)
                end
            end
        end
    end
end)

-- { On/Off Duty } --

function onDuty()
    Citizen.CreateThread(function()
        local copModel = GetHashKey("s_m_y_cop_01")
        RequestModel(copModel)
        while not HasModelLoaded(copModel) do
            Wait(0)
        end
        if HasModelLoaded(copModel) then
	        drawNotification("You have gone on duty.")
            SetPlayerModel(PlayerId(), copModel)
        end
    end)
    Wait(500)
    local ped = GetPlayerPed(-1)
    GiveWeaponToPed(ped, 'WEAPON_COMBATPISTOL', 200, false, false)
    GiveWeaponToPed(ped, 'WEAPON_FLASHLIGHT', 200, false, false)
    GiveWeaponToPed(ped, 'WEAPON_STUNGUN', 200, false, false)
end


function offDuty()
    Citizen.CreateThread(function()
        local copModel = GetHashKey("u_m_m_aldinapoli")
        RequestModel(copModel)
        while not HasModelLoaded(copModel) do
            Wait(0)
        end
        if HasModelLoaded(copModel) then
	        drawNotification("You have gone off duty.")
            SetPlayerModel(PlayerId(), copModel)
        end
    end)
end

-- { Set Loadout } -

function setLoadout(num)
    Citizen.CreateThread(function()
        if num == 1 then
            local model = GetHashKey("s_m_y_cop_01")
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            if HasModelLoaded(model) then
                SetPlayerModel(PlayerId(), model)
            end
            Wait(500)
            local ped = GetPlayerPed(-1)
            GiveWeaponToPed(ped, 'WEAPON_COMBATPISTOL', 200, false, false)
            GiveWeaponToPed(ped, 'WEAPON_FLASHLIGHT', 200, false, false)
            GiveWeaponToPed(ped, 'WEAPON_STUNGUN', 200, false, false)
        elseif num == 2 then
            local model = GetHashKey("s_m_y_hwaycop_01")
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            if HasModelLoaded(model) then
                SetPlayerModel(PlayerId(), model)
            end
            Wait(500)
            local ped = GetPlayerPed(-1)
            GiveWeaponToPed(ped, 'WEAPON_COMBATPISTOL', 200, false, false)
            GiveWeaponToPed(ped, 'WEAPON_FLASHLIGHT', 200, false, false)
            GiveWeaponToPed(ped, 'WEAPON_STUNGUN', 200, false, false)
        elseif num == 3 then 
            local model = GetHashKey("s_m_y_sheriff_01")
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            if HasModelLoaded(model) then
                SetPlayerModel(PlayerId(), model)
            end
            Wait(500)
            local ped = GetPlayerPed(-1)
            GiveWeaponToPed(ped, 'WEAPON_COMBATPISTOL', 200, false, false)
            GiveWeaponToPed(ped, 'WEAPON_FLASHLIGHT', 200, false, false)
            GiveWeaponToPed(ped, 'WEAPON_STUNGUN', 200, false, false)
        elseif num == 4 then
            local model = GetHashKey("s_m_y_swat_01")
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            if HasModelLoaded(model) then
                SetPlayerModel(PlayerId(), model)
            end
            Wait(500)
            local ped = GetPlayerPed(-1)
            GiveWeaponToPed(ped, 'WEAPON_COMBATPISTOL', 200, false, false)
            GiveWeaponToPed(ped, 'WEAPON_FLASHLIGHT', 200, false, false)
            GiveWeaponToPed(ped, 'WEAPON_STUNGUN', 200, false, false)
            GiveWeaponToPed(ped, 'WEAPON_CARBINERIFLE', 200, false, true)
        end
    end)
end

-- { Notifications } --

function drawNotification(text)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, true)
end

-- { End Of Functions } --
