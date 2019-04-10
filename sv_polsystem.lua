 -- Police System --
-- Made By Chezza --

local maxsecs = 500 -- Max seconds police can put people in jail for --

-- { Code } --

cop = 0

RegisterServerEvent('check')
AddEventHandler('check', function()
	steamhex = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchAll("SELECT * FROM `police` WHERE `identifier` = @identifier", {["@identifier"] = steamhex}, function(result)
		local iscop = result[1].rank
		TriggerClientEvent('cl-cop', -1, iscop)
		cop = iscop
	end)
end)


RegisterServerEvent('onjoin')
AddEventHandler('onjoin', function()
	steamhex = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchAll("SELECT * FROM `police` WHERE `identifier` = @identifier", {["@identifier"] = steamhex}, function(result)
		local identi = result[1]
		if identi == nil then
			MySQL.Async.execute("INSERT INTO police (identifier, rank) VALUES (@identifier, @rank)", {["@identifier"] = steamhex, ["@rank"] = 0})
		end
	end)
end)

RegisterServerEvent('onduty')
AddEventHandler('onduty', function()
	TriggerClientEvent('chatMessage', -1, '', {255,255,255}, "(( ^1" .. GetPlayerName(source) .. " ^7has gone On-Duty as a ^4Law Enforement Officer^7 ))")
end)

RegisterServerEvent('offduty')
AddEventHandler('offduty', function()
	TriggerClientEvent('chatMessage', -1, '', {255,255,255}, "(( ^1" .. GetPlayerName(source) .. " ^7has gone Off-Duty ))")
end)

RegisterServerEvent('searchped')
AddEventHandler('searchped', function(pid)
	pid = tonumber(pid)
	TriggerClientEvent('chatMessage', -1, '', {255,255,255}, "(( ^4Officer ^1" .. GetPlayerName(source) .. " ^7searches ^1" .. GetPlayerName(pid) .. "'s^7 Person, What does he Find? ))")
end)

RegisterServerEvent('searchcar')
AddEventHandler('searchcar', function(pid)
	pid = tonumber(pid)
	TriggerClientEvent('chatMessage', -1, '', {255,255,255}, "(( ^4Officer ^1" .. GetPlayerName(source) .. " ^7searches ^1" .. GetPlayerName(pid) .. "'s^7 Vehicle, What does he Find? ))")
end)

RegisterServerEvent('runname')
AddEventHandler('runname', function(pid)
	pid = tonumber(pid)
	TriggerClientEvent('chatMessage', -1, '', {255,255,255}, "(( ^4Officer ^1" .. GetPlayerName(source) .. " ^7runs ^1" .. GetPlayerName(pid) .. "'s^7 ^4ID ^7through the System, What does he see? ))")
end)

RegisterServerEvent('runplate')
AddEventHandler('runplate', function(pid)
	pid = tonumber(pid)
	TriggerClientEvent('chatMessage', -1, '', {255,255,255}, "(( ^4Officer ^1" .. GetPlayerName(source) .. " ^7runs ^1" .. GetPlayerName(pid) .. "'s^7 ^4License Plate ^7through the System, What does he see? ))")
end)

RegisterServerEvent('addcop')
AddEventHandler('addcop', function(pid)
	addCop(pid)
	TriggerClientEvent('chatMessage', -1, '^4Police', {255,255,255}, '^7You have added a Cop ^1' .. GetPlayerName(pid))
end)

RegisterServerEvent('remcop')
AddEventHandler('remcop', function(pid)
	removeCop(pid)
	TriggerClientEvent('chatMessage', -1, '^4Police', {255,255,255}, '^7You have removed a Cop ^1' .. GetPlayerName(pid))
end)


RegisterServerEvent("cuffNear")
AddEventHandler("cuffNear", function(id)
	print("cuffing "..id)
	TriggerClientEvent("cuff1", id)
end)

RegisterServerEvent('Cuff:getUnseatServer')
AddEventHandler('Cuff:getUnseatServer', function(t, v)
    TriggerClientEvent('Cuff:unseatme', t, v)
end)

RegisterServerEvent('Cuff:getSeatedServer')
AddEventHandler('Cuff:getSeatedServer', function(t)
    TriggerClientEvent('Cuff:forcedEnteringVeh', t)
end)

RegisterServerEvent('police:dragRequest')
AddEventHandler('police:dragRequest', function(t)
	TriggerClientEvent('police:toggleDrag', t, source)
end)

RegisterServerEvent('police:spikes')
AddEventHandler('police:spikes', function(currentVeh, peeps)
	TriggerClientEvent("police:dietyres", peeps, currentVeh)
	--TriggerClientEvent("police:dietyres", -1, currentVeh)
	TriggerClientEvent("police:dietyres2", peeps)
end)

RegisterServerEvent('jail')
AddEventHandler('jail', function(id1, time1)
	local pid = tonumber(id1)
	local time = tonumber(time1)
	if time > maxsecs then
		time = maxsecs
	end
	if GetPlayerName(pid) ~= nil then
		local playername = GetPlayerName(pid)
		TriggerClientEvent("jail", pid, time)
		TriggerClientEvent('chatMessage', -1, 'Jail', { 255, 0, 0 }, playername ..' has been jailed for '.. time ..' seconds.')
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID")
	end
end)

RegisterServerEvent('unjail')
AddEventHandler('unjail', function(id1)
	local pid = tonumber(id1)
	if GetPlayerName(pid) ~= nil then
		local playername = GetPlayerName(pid)
		TriggerClientEvent("unjail", pid)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID")
	end
end)

-- { Functions } --

function addCop(id)
	steamhex = GetPlayerIdentifiers(id)[1]
	MySQL.Async.fetchAll("SELECT * FROM `police` WHERE `identifier` = @identifier", {["@identifier"] = steamhex}, function(result)
		local identi = result[1]
		if identi == nil then 
			MySQL.Async.execute("INSERT INTO police (identifier, rank) VALUES (@identifier, @rank)", {["@identifier"] = steamhex, ["@rank"] = 1})
		else
			if cop == 2 then
				MySQL.Async.execute("UPDATE police SET rank=@rank WHERE `identifier` = @identifier", {["@identifier"] = steamhex, ["@rank"] = 2})
			else
				MySQL.Async.execute("UPDATE police SET rank=@rank WHERE `identifier` = @identifier", {["@identifier"] = steamhex, ["@rank"] = 1})
			end
		end
	end)
end

function removeCop(id)
	steamhex = GetPlayerIdentifiers(id)[1]
	MySQL.Async.execute("UPDATE police SET rank=@rank WHERE `identifier` = @identifier", {["@identifier"] = steamhex, ["@rank"] = 0})
end
