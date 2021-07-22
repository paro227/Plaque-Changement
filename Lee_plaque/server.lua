--BY LeePong--
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('BNJpayeE:paye')
AddEventHandler('BNJpayeE:paye', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(ConfigPlaqueBNJ.money)
end)
