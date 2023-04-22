local ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local pauseMenuOpen = false


CreateThread(function()
	while true do
		SetPauseMenuActive(false)
		Wait(1)
	end
end)

local function closePauseMenu()
	if pauseMenuOpen then
		local ped = PlayerPedId()
		ClearPedTasks(ped)
		DeleteObject(prop)

		TransitionFromBlurred(1000)
		pauseMenuOpen = false
		SetNuiFocus(false, false)
		SendNUIMessage({
			action = 'close'
		})
	end
end


local function requestAnimDict(animDict)
	if HasAnimDictLoaded(animDict) then return animDict end

    RequestAnimDict(animDict)

    if coroutine.running() then
        timeout = tonumber(timeout) or 500

        for _ = 1, timeout do
            if HasAnimDictLoaded(animDict) then
                return animDict
            end

            Wait(0)
        end
    end

    return animDict
end

local function requestModel(model)
    if not tonumber(model) then model = joaat(model) end

    if HasModelLoaded(model) then return model end

    RequestModel(model)

    if coroutine.running() then
        timeout = tonumber(timeout) or 500

        for _ = 1, timeout do
            if HasModelLoaded(model) then
                return model
            end

            Wait(0)
        end

    end

    return model
end


local function openPauseMenu()
	if IsPauseMenuActive() then return closePauseMenu() end
	if IsPedFalling(PlayerPedId()) then return closePauseMenu() end
	if IsPauseMenuActive() then return closePauseMenu() end
	
	if LocalPlayer.state.invOpen then return closePauseMenu() end


	if not pauseMenuOpen then
		local ped = PlayerPedId()

		local dictName = "amb@world_human_tourist_map@male@base"
		local set = "base"

		local propModel = "prop_tourist_map_01"

		local pedCoords = GetEntityCoords(ped)

		local dict = requestAnimDict(dictName)
		local propModel = requestModel(propModel)
		
		prop = CreateObject(propModel, pedCoords + vector3(0.0,0.0,0.2),  true,  true, true)
		
		AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
		SetModelAsNoLongerNeeded(propModel)

		TaskPlayAnim(ped, dict, set, 2.0, 2.0, -1, 58, 0, false, false, false)
		
		ESX.TriggerServerCallback('ars_pausemenu:getData', function(data)

			local playerName = data.name
			local playerMoney = data.money or 0
			local playerJob = ESX.PlayerData.job.label

			pauseMenuOpen = true
			SetNuiFocus(true, true)
			SendNUIMessage({
				action = 'open',
				name = playerName,
				money = playerMoney,
				job = playerJob,
			})
		end)
	end
end


RegisterCommand("pauseMenu", openPauseMenu)
RegisterKeyMapping("pauseMenu", "Open pausemenu", "keyboard", "ESCAPE")

RegisterNUICallback('close', function(data, cb)
	closePauseMenu()
	cb('ok')
end)

RegisterNUICallback('openMap', function(data, cb)
	closePauseMenu()
	ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'),0,-1)
	cb('ok')
end)

RegisterNUICallback('openSettings', function(data, cb)
	closePauseMenu()
	ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'),0,-1)
	cb('ok')
end)

RegisterNUICallback('disconnect', function(data, cb)
	closePauseMenu()
	TriggerServerEvent("ars_pausemenu:disconnectPlayer")
	cb('ok')
end)
