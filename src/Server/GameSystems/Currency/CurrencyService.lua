local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local START_AMOUNT = 100

local CurrencyService = Knit.CreateService({
	Name = "CurrencyService",
	Client = {
		Currency = Knit.CreateProperty(START_AMOUNT),
	},
})

function CurrencyService:Increment(player: Player, amount: number)
	local currentAmount = self.Client.Currency:GetFor(player)

	self.Client.Currency:SetFor(player, currentAmount + amount)
end

function CurrencyService:CanAfford(player: Player, amount: number): boolean
	local currentAmount = self.Client.Currency:GetFor(player)

	return currentAmount >= amount
end

return CurrencyService
