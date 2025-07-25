local playersTouchedPOINTGIVER = {

}

local sound = script.Parent.GotIt
local play = false
local playerGotIt = {
	
}


script.Parent.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:FindFirstChild(character.Name)
	if character and player and not playersTouchedPOINTGIVER[player] then
		player.leaderstats.Points.Value += 100
		playersTouchedPOINTGIVER[player] = true
	end
end)



script.Parent.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:FindFirstChild(character.Name)
	if hit.Parent:FindFirstChild("Humanoid") and play == false and not playerGotIt[player] then
		play = true
		print("sound played")
		sound:Play()
		playerGotIt[player] = true
		
		wait(5)
		play = false
		sound:Stop()
	end
end)