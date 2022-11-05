local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")

local transparencyCache = {}

local function setCharacterVisible(character, shouldHide)
	for _, v in character:GetDescendants() do
		if not v:IsA("Decal") and not v:IsA("BasePart") then
			continue
		end

		if shouldHide then
			transparencyCache[v] = transparencyCache[v] or v.Transparency
			v.Transparency = 1
		else
			v.Transparency = transparencyCache[v] or 0
		end
	end

	character.HumanoidRootPart.Anchored = shouldHide
	character.Humanoid.WalkSpeed = shouldHide and 0 or StarterPlayer.CharacterWalkSpeed
end

local function playerAdded(player: Player)
	player.CharacterRemoving:Connect(function(character)
		for _, v in character:GetDescendants() do
			if transparencyCache[v] then
				transparencyCache[v] = nil
			end
		end
	end)
end

for _, player in pairs(Players:GetPlayers()) do
	playerAdded(player)
end

Players.PlayerAdded:Connect(playerAdded)

return setCharacterVisible
