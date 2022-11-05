local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local OnlyLocalPlayer = {}

function OnlyLocalPlayer.ShouldConstruct(component)
	local ownerId

	repeat
		ownerId = component.Instance:GetAttribute("OwnerId")
		task.wait()
	until ownerId ~= nil

	return ownerId == Knit.Player.UserId
end

return OnlyLocalPlayer
