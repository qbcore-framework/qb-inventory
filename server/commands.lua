--- QB Inventory Project
-- Server-side code for the inventory related commands
-- @module commands
-- @author restray

--- Give Command
-- @command giveitem
-- @tparam Player.id id				The player server id
-- @tparam Item.name itemName		The player server id
-- @tparam number amount			The player server id
-- @usage /giveitem {id} {item} {amount}
QBCore.Commands.Add("giveitem", "Give An Item (Admin Only)", {{name="id", help="Player ID"},{name="item", help="Name of the item (not a label)"}, {name="amount", help="Amount of items"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	local amount = tonumber(args[3])
	local itemData = QBCore.Shared.Items[tostring(args[2]):lower()]
	if Player then
		if amount > 0 then
			if itemData then
				-- check iteminfo
				local info = {}
				if itemData["name"] == "id_card" then
					info.citizenid = Player.PlayerData.citizenid
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.gender = Player.PlayerData.charinfo.gender
					info.nationality = Player.PlayerData.charinfo.nationality
				elseif itemData["name"] == "driver_license" then
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.type = "Class C Driver License"
				elseif itemData["type"] == "weapon" then
					amount = 1
					info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
				elseif itemData["name"] == "harness" then
					info.uses = 20
				elseif itemData["name"] == "markedbills" then
					info.worth = math.random(5000, 10000)
				elseif itemData["name"] == "labkey" then
					info.lab = exports["qb-methlab"]:GenerateRandomLab()
				elseif itemData["name"] == "printerdocument" then
					info.url = "https://cdn.discordapp.com/attachments/870094209783308299/870104331142189126/Logo_-_Display_Picture_-_Stylized_-_Red.png"
				end

				if Player.Functions.AddItem(itemData["name"], amount, false, info) then
					TriggerClientEvent('QBCore:Notify', source, "You Have Given " ..GetPlayerName(tonumber(args[1])).." "..amount.." "..itemData["name"].. "", "success")
				else
					TriggerClientEvent('QBCore:Notify', source,  "Can't give item!", "error")
				end
			else
				TriggerClientEvent('QBCore:Notify', source,  "Item Does Not Exist", "error")
			end
		else
			TriggerClientEvent('QBCore:Notify', source,  "Invalid Amount", "error")
		end
	else
		TriggerClientEvent('QBCore:Notify', source,  "Player Is Not Online", "error")
	end
end, "admin")
