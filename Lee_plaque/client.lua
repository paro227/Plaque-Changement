--BY LeePong--
ESX = nil
cooldown = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		if cooldown then
			Citizen.Wait(ConfigPlaqueBNJ.cooldown * 60000)
			cooldown = false
		end
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)



-- Ped
Citizen.CreateThread(function()
	RequestModel(GetHashKey(ConfigPlaqueBNJ.pedName))
	while not HasModelLoaded(GetHashKey(ConfigPlaqueBNJ.pedName)) do
		Citizen.Wait(1)
	end
	local ped = CreatePed(4, ConfigPlaqueBNJ.pedHash, ConfigPlaqueBNJ.pedCoords.x, ConfigPlaqueBNJ.pedCoords.y, ConfigPlaqueBNJ.pedCoords.z - 1, ConfigPlaqueBNJ.pedHeading, false, true)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
end)

-- cmd
RegisterNetEvent('BNJpayeE:command')
AddEventHandler('BNJpayeE:command', function()
	BNJPLAQUE()
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped, true)
		while GetDistanceBetweenCoords(coords, ConfigPlaqueBNJ.pedCoords.x, ConfigPlaqueBNJ.pedCoords.y, ConfigPlaqueBNJ.pedCoords.z, false) < 10 do
			Citizen.Wait(0)
			DrawText3D(ConfigPlaqueBNJ.pedCoords.x, ConfigPlaqueBNJ.pedCoords.y, ConfigPlaqueBNJ.pedCoords.z + 1.1, 'Mécano Dealer')
			coords = GetEntityCoords(ped, true)
			if GetDistanceBetweenCoords(coords, ConfigPlaqueBNJ.pedCoords.x, ConfigPlaqueBNJ.pedCoords.y, ConfigPlaqueBNJ.pedCoords.z, false) < 3 then
				Notify('Appuyer sur ~INPUT_PICKUP~ pour peindre la plaque d\'immatriculation. (~g~' .. ConfigPlaqueBNJ.money .. '$~w~)')
				--EN-->	Notify('To push on ~INPUT_PICKUP~ to paint the license plate. (~g~' .. ConfigPlaqueBNJ.money .. '$~w~)')
				if IsControlJustReleased(0, 38) then
					BNJPLAQUE()
				end
			end
		end
	
	end
end)

-- BNJ_plaque
function BNJPLAQUE()
	if cooldown then
		ESX.ShowNotification('Tu dois attendre ' .. ConfigPlaqueBNJ.cooldown .. ' secondes, pour cacher à nouveau la plaque!' )
		--EN--> ESX.ShowNotification('You have to wait ' .. ConfigPlaqueBNJ.cooldown .. ' seconds, to hide the plate again!' )
	end
	if not cooldown then
		cooldown = true
		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(ped, true)
		local plateText = GetVehicleNumberPlateText(veh)
		local plateNew = ' '
		TriggerServerEvent('BNJpayeE:paye')
		DoScreenFadeOut(1500)
			Wait(2000)
			RenderScriptCams(0, 1, 500, 1, 1)
			RenderScriptCams(true, true, 10, true, true)
			DoScreenFadeIn(3500)
		ESX.Scaleform.ShowFreemodeMessage('~g~La plaque est maintenant caché', '', 5) 
		--EN--> ESX.Scaleform.ShowFreemodeMessage('~g~The plate is now hidden', '', 5) 
		ESX.ShowNotification('La plaque est maintenant caché pour ~g~1 Heures~w~ !')
	    --EN--> TriggerEvent("dqP:shownotif",'~r~duration :~w~~g~ ' .. ConfigPlaqueBNJ.czas .. ' ~w~minutes!',18)
		SetVehicleNumberPlateText(veh, plateNew)
		Citizen.Wait(ConfigPlaqueBNJ.czas * 60000)
		SetVehicleNumberPlateText(veh, plateText)
		ESX.ShowNotification('La plaque est maintenant ~g~visible~w~!')
        --EN--> ESX.ShowNotification('he plate is now ~g~visible~w~!')
	end
end

function Notify (text)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, 0, true, -1)
end



function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end


