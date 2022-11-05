local Players = game:GetService("Players")

local function getBikePart(character)
	local bike = character:FindFirstChild("Bike")

	if bike then
		return bike.Value:FindFirstChild("Main")
	end
end

local function getPlayerFromPart(part)
	for _, player in pairs (Players:GetPlayers()) do
		local character = player.Character

		if not character then
			continue
		end

		local bikePart = getBikePart(character)

		if bikePart == part then
			return player
		end

		if part:IsDescendantOf(character) then
			return player
		end
	end
end

local function getAllCharacters(): { [number]: Model }
	local characters: { [number]: Model } = {}

	for _, player: Player in pairs(Players:GetPlayers()) do
		if not player.Character then
			continue
		end

		local bikePart = getBikePart(player.Character)

		if bikePart then
			table.insert(characters, bikePart)
		end

		table.insert(characters, player.Character)
	end

	return characters
end

return function(model: Instance)
	local box: BasePart = model.Middle
	local characters = getAllCharacters()

	local params = OverlapParams.new()
	params.FilterDescendantsInstances = characters
	params.FilterType = Enum.RaycastFilterType.Whitelist

	local allParts = workspace:GetPartsInPart(box, params)
	local playersInZone = {}

	for _, part: BasePart in pairs(allParts) do
		local player = getPlayerFromPart(part)

		if not player then
			continue
		end

		playersInZone[player] = true
	end

	return playersInZone
end
