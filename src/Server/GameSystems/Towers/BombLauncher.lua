--[[
	This component manages the bomb launcher tower
]]

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Timer = require(ReplicatedStorage.Packages.Timer)
local TroveAdder = require(ReplicatedStorage.ComponentExtensions.TroveAdder)

local UPDATE_INTERVAL = 0.2
local BombLauncher = Component.new({ Tag = "BombLauncher", Extensions = { TroveAdder } })

function BombLauncher:Construct()
	self._radius = self.Instance:GetAttribute("Radius")
	self._noob = self.Instance:FindFirstChild("Noob")
	self._selectedEnemy = nil

	self:SetupTimer()
end

function BombLauncher:SetupTimer()
	self._trove:Add(Timer.Simple(UPDATE_INTERVAL, function()
		self:TargetEnemy()
	end))
end

-- target the enemy that is the furthest along the path
function BombLauncher:SelectEnemy()
	local allEnemies = CollectionService:GetTagged("Enemy")

	for _, enemy: Model in allEnemies do
		local distance = (enemy.PrimaryPart.Position - self.Instance.PrimaryPart.Position).Magnitude

		if distance > self._radius then
			continue
		end

		return enemy
	end
end

function BombLauncher:TargetEnemy()
	local selectedEnemy = self:SelectEnemy()

	if not selectedEnemy then
		return
	end

	self._selectedEnemy = selectedEnemy
end

function BombLauncher:PointTowardsEnemy()
	local selectedEnemy = self._selectedEnemy
	local primaryPart = self._noob.PrimaryPart

	if not selectedEnemy then
		return
	end

	local lookAtCF = CFrame.lookAt(primaryPart.Position, selectedEnemy.PrimaryPart.Position)

	-- make sure we only rotate around the y axis
	local _, y = lookAtCF:ToEulerAnglesYXZ()
	local uprightCFrame = CFrame.new(lookAtCF.Position) * CFrame.Angles(0, y, 0)

	primaryPart.CFrame = uprightCFrame
end

function BombLauncher:SteppedUpdate()
	self:PointTowardsEnemy()
end

return BombLauncher
