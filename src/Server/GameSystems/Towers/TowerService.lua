local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local assets = ReplicatedStorage:FindFirstChild("Assets")
local towers = assets:FindFirstChild("Towers")

local TowerService = Knit.CreateService {
	Name = "TowerService";
	Client = {};
}


function TowerService:KnitStart()
	
end


function TowerService:KnitInit()
	
end


function TowerService.Client:BuildTower(player: Player, towerName: string, base: BasePart)
	local towerTemplate: Model = towers:FindFirstChild(towerName)

	if not towerTemplate then
		warn("Tower", towerName, "not found")
		return false
	end

	local newTower = towerTemplate:Clone()

	newTower.Parent = workspace
	newTower:PivotTo(base.CFrame)

	return true
end


return TowerService
