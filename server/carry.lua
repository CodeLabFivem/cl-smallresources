local carrying = {}
local carried = {}

RegisterServerEvent("CarryPeople:sync")
AddEventHandler("CarryPeople:sync", function(targetSrc)
	local source = source
	if carrying[source] or carried[targetSrc] then return end

	local sourcePed = GetPlayerPed(source)
	local targetPed = GetPlayerPed(targetSrc)

	if #(GetEntityCoords(sourcePed) - GetEntityCoords(targetPed)) <= 3.0 then
		TriggerClientEvent("CarryPeople:syncTarget", targetSrc, source)
		carrying[source] = targetSrc
		carried[targetSrc] = source
	end
end)

RegisterServerEvent("CarryPeople:stop")
AddEventHandler("CarryPeople:stop", function()
	local source = source

	if carrying[source] then
		TriggerClientEvent("CarryPeople:cl_stop", carrying[source])
		carried[carrying[source]] = nil
		carrying[source] = nil
	elseif carried[source] then
		TriggerClientEvent("CarryPeople:cl_stop", carried[source])
		carrying[carried[source]] = nil
		carried[source] = nil
	end
end)

AddEventHandler('playerDropped', function()
	local source = source

	if carrying[source] then
		TriggerClientEvent("CarryPeople:cl_stop", carrying[source])
		carried[carrying[source]] = nil
		carrying[source] = nil
	end

	if carried[source] then
		TriggerClientEvent("CarryPeople:cl_stop", carried[source])
		carrying[carried[source]] = nil
		carried[source] = nil
	end
end)
