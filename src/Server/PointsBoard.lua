local BoardDataStoreService = game:GetService("DataStoreService")
local PointsDataStore = BoardDataStoreService:GetOrderedDataStore("PointsLeaderBoard")
local LeaderBoardPart = script.Parent.Parent.Parent
local RefreshRate = 5

local function SavePlayerData(player)
	local success, error = pcall(function()
		PointsDataStore:SetAsync(tostring(player.UserId), player.leaderstats.Points.Value)
		print("Saved data for player", player.Name, "Points:", player.leaderstats.Points.Value)
	end)

	if not success then
		warn("Failed to save data for player", player.Name, "Error:", error)
	end
end

local function LoadLeaderboardData()
	local leaderboardData = {}

	local success, error = pcall(function()
		local Data = PointsDataStore:GetSortedAsync(false, 10)
		local PointsPage = Data:GetCurrentPage()

		for Rank, SavedData in ipairs(PointsPage) do
			local UserId = tonumber(SavedData.key)
			local Username = game.Players:GetNameFromUserIdAsync(UserId)
			local Points = SavedData.value

			table.insert(leaderboardData, { UserId = UserId, Username = Username, Points = Points })
			print("Loaded data for player", Username, "Points:", Points)
		end
	end)

	if not success then
		warn("Failed to load leaderboard data. Error:", error)
	end

	return leaderboardData
end

local function RefreshLeaderboard()
	for i, Frame in pairs(LeaderBoardPart.SurfaceGui.PlayerHolder:GetChildren()) do
		if Frame.Name ~= "Labels" and Frame:IsA("Frame") then
			Frame:Destroy(0.05)
		end
	end

	local leaderboardData = LoadLeaderboardData()

	for Rank, Data in ipairs(leaderboardData) do
		local userId = Data.UserId
		local username = Data.Username
		local points = Data.Points

		local NewLabel = script.Parent.Labels:Clone()
		NewLabel.Visible = true
		NewLabel.Parent = LeaderBoardPart.SurfaceGui.PlayerHolder
		NewLabel.Name = username

		NewLabel.RANK.Text = "#"..Rank
		NewLabel.NAME.Text = username
		NewLabel.POINTS.Text = points
	end
end

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		-- Connect to CharacterAdded to ensure leaderstats is available
		local leaderstats = player:WaitForChild("leaderstats")
		local points = leaderstats:WaitForChild("Points")

		points.Changed:Connect(function(newValue)
			-- When Points change, save the updated data
			SavePlayerData(player)
		end)
	end)
end)

game.Players.PlayerRemoving:Connect(function(player)
	SavePlayerData(player)
end)

while true do
	RefreshLeaderboard()
	wait(RefreshRate)
end
