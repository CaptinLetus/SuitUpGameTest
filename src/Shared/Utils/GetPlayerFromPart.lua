local Players = game:GetService("Players")
return function (part: BasePart): Player?
	for _, player: Player in pairs (Players:GetChildren()) do
		if not player.Character then
			continue
		end

		if part:IsDescendantOf(player.Character) then
			return player
		end
	end
end