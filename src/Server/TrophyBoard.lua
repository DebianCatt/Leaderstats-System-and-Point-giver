local BoardDataStoreService = game:GetService("DataStoreService")
local TrophyDataStore = BoardDataStoreService:GetOrderedDataStore("TrophyLeaderBoard")
local LeaderBoardPart = script.Parent.Parent.Parent
local RefreshRate = 10

local function SavePlayerData(player)
	local success, error = pcall(function()
		TrophyDataStore:SetAsync(tostring(player.UserId), player.leaderstats.Trophy.Value)
		print("Saved data for player", player.Name, "Trophy:", player.leaderstats.Trophy.Value)
	end)

	if not success then
		warn("Failed to save data for player", player.Name, "Error:", error)
	end
end

local function LoadLeaderboardData()
	local leaderboardData = {}

	local success, error = pcall(function()
		local Data = TrophyDataStore:GetSortedAsync(false, 10)
		local TrophyPage = Data:GetCurrentPage()

		for Rank, SavedData in ipairs(TrophyPage) do
			local UserId = tonumber(SavedData.key)
			local Username = game.Players:GetNameFromUserIdAsync(UserId)
			local Trophy = SavedData.value

			table.insert(leaderboardData, { UserId = UserId, Username = Username, Trophy = Trophy })
			print("Loaded data for player", Username, "Trophy:", Trophy)
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
		local trophy = Data.Trophy

		local NewLabel = script.Parent.Labels:Clone()
		NewLabel.Visible = true
		NewLabel.Parent = LeaderBoardPart.SurfaceGui.PlayerHolder
		NewLabel.Name = username

		NewLabel.RANK.Text = "# "..Rank
		NewLabel.NAME.Text = username
		NewLabel.TROPHY.Text = trophy
	end
end

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		-- Connect to CharacterAdded to ensure leaderstats is available
		local leaderstats = player:WaitForChild("leaderstats")
		local points = leaderstats:WaitForChild("Trophy")
		
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
