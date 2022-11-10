--[[
	This service is responsible for building new towers in the game
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local assets = ReplicatedStorage:FindFirstChild("Assets")
local towers = assets:FindFirstChild("Towers")

local basesToTower = {}

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
	basesToTower[base] = newTower

	return true
end

function TowerService.Client:SellTower(player: Player, base: BasePart)
	local CurrencyService = Knit.GetService("CurrencyService")

	local tower = basesToTower[base]

	if not tower then
		warn("No tower found for base", base)
		return false, "ERROR"
	end

	local price = tower:GetAttribute("Price") / 2

	CurrencyService:Increment(player, price)

	tower:Destroy()
	base:SetAttribute("ActiveTower", nil)
	basesToTower[base] = nil

	return true
end

return TowerService
