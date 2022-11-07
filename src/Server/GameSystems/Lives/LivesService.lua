local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local START_LIVES = 1

local LivesService = Knit.CreateService({
	Name = "LivesService",
	Client = {
		Lives = Knit.CreateProperty(START_LIVES),
	},
})

function LivesService:Lost()
	for _, tower in pairs(CollectionService:GetTagged("Tower")) do
		if not tower:IsDescendantOf(workspace) then
			continue
		end

		tower:Destroy()
	end

	for _, enemy in pairs(CollectionService:GetTagged("Enemy")) do
		if not enemy:IsDescendantOf(workspace) then
			continue
		end

		enemy:Destroy()
	end
end

function LivesService:RemoveLive()
	local current = self.Client.Lives:Get()

	local newAmount = current - 1

	self.Client.Lives:Set(newAmount)

	if newAmount <= 0 then
		self:Lost()
		return
	end
end

return LivesService
