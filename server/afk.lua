RegisterServerEvent("cl-smallresources:AntiAFK:kick")
AddEventHandler("cl-smallresources:AntiAFK:kick", function()
	DropPlayer(source, Config.Afk.PlayerDroppedmsg)
end)  