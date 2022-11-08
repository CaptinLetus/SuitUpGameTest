--[[
	This component contains common tower functionality
]]

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Signal = require(ReplicatedStorage.Packages.Signal)
local TroveAdder = require(ReplicatedStorage.ComponentExtensions.TroveAdder)
local Timer = require(ReplicatedStorage.Packages.Timer)

local MIN_PROGRESS = 1
local UPDATE_INTERVAL = 0.2

local Tower = Component.new({ Tag = "Tower", Extensions = { TroveAdder } })

function Tower:Construct()
	self._radius = self.Instance:GetAttribute("Radius")
	self._fireRate = self.Instance:GetAttribute("FireRate")

	self.selectedEnemy = nil
	self._lastShot = 0

	self.Fire = Signal.new()
	self._trove:Add(self.Fire)
	
	self:SetupTimer()
end

function Tower:SetupTimer()
	self._trove:Add(Timer.Simple(UPDATE_INTERVAL, function()
		self:TargetEnemy()
	end))
end

function Tower:GetEnemyPrimaryPart()
	local selectedEnemy = self.selectedEnemy

	if not selectedEnemy then
		return
	end

	return selectedEnemy.PrimaryPart
end

function Tower:SelectEnemy()
	local allEnemies = CollectionService:GetTagged("Enemy")

	local selectedEnemy = nil
	local selectedDistance = 0

	for _, enemy: Model in allEnemies do
		local humanoid = enemy:FindFirstChild("Humanoid")

		if humanoid.Health <= 0 then
			continue
		end

		local distance = (enemy.PrimaryPart.Position - self.Instance.PrimaryPart.Position).Magnitude

		if distance > self._radius then
			continue
		end

		local progress = enemy:GetAttribute("ProgressAlongTrack") or 0

		if progress < MIN_PROGRESS then
			continue
		end

		if progress > selectedDistance then
			selectedEnemy = enemy
			selectedDistance = progress
		end
	end

	return selectedEnemy
end

function Tower:CanFire()
	if not self.selectedEnemy then
		return false
	end

	local now = os.clock()

	return now - self._lastShot >= self._fireRate
end

function Tower:TargetEnemy()
	local selectedEnemy = self:SelectEnemy()

	self.selectedEnemy = selectedEnemy

	if not selectedEnemy then
		return
	end

	if self:CanFire() then
		self.Fire:Fire()
		self._lastShot = os.clock()
	end
end

return Tower
