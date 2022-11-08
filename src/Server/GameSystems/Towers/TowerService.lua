--[[
	This service is responsible for building new towers in the game
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local assets = ReplicatedStorage:FindFirstChild("Assets")
local towers = assets:FindFirstChild("Towers")

local TowerService = Knit.CreateService({
	Name = "TowerService",
	Client = {},
})

function TowerService.Client:BuildTower(player: Player, towerName: string, base: BasePart)
	local CurrencyService = Knit.GetService("CurrencyService")

	local towerTemplate: Model = towers:FindFirstChild(towerName)

	if not towerTemplate then
		warn("Tower", towerName, "not found")
		return false, "ERROR"
	end

	if base:GetAttribute("ActiveTower") then
		warn("Base already has a tower")
		return false, "ERROR"
	end

	local price = towerTemplate:GetAttribute("Price")

	if not CurrencyService:CanAfford(player, price) then
		warn("Player", player, "cannot afford", towerName)
		return false, "NOT ENOUGH MONEY"
	end

	CurrencyService:Increment(player, -price)

	local newTower = towerTemplate:Clone()

	newTower.Parent = workspace
	newTower:PivotTo(base.CFrame)

	base:SetAttribute("ActiveTower", newTower.Name)

	return true
end

return TowerService
