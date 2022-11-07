local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local START_LIVES = 5

local LivesService = Knit.CreateService({
	Name = "LivesService",
	Client = {
		Lives = Knit.CreateProperty(START_LIVES),
	},
})

function LivesService:ClearMap()
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

	newAmount = math.max(newAmount, 0)

	self.Client.Lives:Set(newAmount)
end

function LivesService:IsAlive()
	return self.Client.Lives:Get() > 0
end

function LivesService.Client:ResetGame()
	self.Lives:Set(START_LIVES)

	local player = Players:GetPlayers()[1]
	Knit.GetService("CurrencyService"):Reset(player)

	self.Server:ClearMap()
end
return LivesService
