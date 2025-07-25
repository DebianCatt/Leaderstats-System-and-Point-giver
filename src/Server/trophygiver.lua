local playersTouchedTrophy = {

}

local sound = script.Parent.CelebrateSound
local bgmusic = game.Workspace.run1
local play = false
local playerGotIt = {

}


script.Parent.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:FindFirstChild(character.Name)
	if character and player and not playersTouchedTrophy[player] then
		player.leaderstats.Trophy.Value += 1
		print("1 Trophy Recieved!")
		playersTouchedTrophy[player] = true
	end
end)



script.Parent.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:FindFirstChild(character.Name)
	if hit.Parent:FindFirstChild("Humanoid") and play == false and not playerGotIt[player] then
		play = true
		bgmusic.Volume = 0
		task.wait(0.5)
		print("sound played")
		sound:Play()
		playerGotIt[player] = true

		wait(30)
		play = false
		sound:Stop()
	end
end)
