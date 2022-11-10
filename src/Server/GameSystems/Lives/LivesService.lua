local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local START_LIVES = 5

local LivesService = Knit.CreateService({
	Name = "LivesService",
	Client = {
		Lives = Knit.CreateProperty(START_LIVES),
		Won = Knit.CreateProperty(false),
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

function LivesService:Win()
	self.Client.Won:Set(true)
end

function LivesService.Client:ResetGame()
	self.Lives:Set(START_LIVES)

	local player = Players:GetPlayers()[1]
	Knit.GetService("CurrencyService"):Reset(player)
	Knit.GetService("EnemyService"):Reset()
	Knit.GetService("TowerService"):Reset()

	self.Server:ClearMap()
	self.Won:Set(false)
end


return LivesService
