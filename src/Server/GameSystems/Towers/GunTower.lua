local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local TroveAdder = require(ReplicatedStorage.ComponentExtensions.TroveAdder)
local Tower = require(script.Parent.Tower)

local GunTower = Component.new({ Tag = "GunTower", Extensions = {TroveAdder} })

function GunTower:Construct()
	self._radius = self.Instance:GetAttribute("Radius")
	self._gun = self.Instance:FindFirstChild("Gun")

end

function GunTower:Start()
	self._tower = self:GetComponent(Tower)

	self._tower.Fire:Connect(function()
		self:Shoot()
	end)
end

function GunTower:Shoot()
	print("Shoot")
end


function GunTower:PointTowardsEnemy()
	local enemyPrimaryPart = self._tower:GetEnemyPrimaryPart()

	if not enemyPrimaryPart then
		return
	end

	local lookAtCF = CFrame.lookAt(self._gun:GetPivot().Position, enemyPrimaryPart.Position)

	-- make sure we only rotate around the y axis
	local _, y = lookAtCF:ToEulerAnglesYXZ()
	local uprightCFrame = CFrame.new(lookAtCF.Position) * CFrame.Angles(0, y, 0)

	self._gun:PivotTo(uprightCFrame)
end


function GunTower:SteppedUpdate()
	self:PointTowardsEnemy()
end

return GunTower