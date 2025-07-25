


--[[game.Players.PlayerAdded:Connect(function(Player)
	local leaderstats = Instance.new("Folder", Player)
	leaderstats.Name = "leaderstats"
	
	local points = Instance.new("NumberValue", leaderstats)
	points.Name = "Points"
	points.Value = 0
end)]]--


-- ServerScriptService script



local BoardDataStoreService = game:GetService("DataStoreService")
local PointsDataStore = BoardDataStoreService:GetOrderedDataStore("PointsLeaderBoard")
local TrophyDataStore = BoardDataStoreService:GetOrderedDataStore("TrophyLeaderBoard")


game.Players.PlayerAdded:Connect(function(Player)
	-- Create leaderstats folder and Points value
	local leaderstats = Instance.new("Folder", Player)
	leaderstats.Name = "leaderstats"

	local points = Instance.new("NumberValue", leaderstats)
	points.Name = "Points"
	
	local trophy = Instance.new("NumberValue", leaderstats)
	trophy.Name = "Trophy"


	points.Value = 0
	trophy.Value = 0

 --points
	local success, error = pcall(function()
		local savedData = PointsDataStore:GetAsync(tostring(Player.UserId))
		if savedData then
			points.Value = savedData
		end
	end)

	if not success then
		warn("Failed to load saved data for player", Player.Name, "Error:", error)
	end
	
  --trophy
	local success, error = pcall(function()
		local savedData = TrophyDataStore:GetAsync(tostring(Player.UserId))
		if savedData then
			trophy.Value = savedData
		end
	end)

	if not success then
		warn("Failed to load saved data for player", Player.Name, "Error:", error)
	end
	
	
	
end)

