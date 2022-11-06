--[[
	This component contains common tower functionality
]]

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Signal = require(ReplicatedStorage.Packages.Signal)
local TroveAdder = require(ReplicatedStorage.ComponentExtensions.TroveAdder)

local MIN_PROGRESS = 1

local Tower = Component.new({ Tag = "Tower", Extensions = { TroveAdder } })

function Tower:Construct()
	self._radius = self.Instance:GetAttribute("Radius")
	self._fireRate = self.Instance:GetAttribute("FireRate")

	self.selectedEnemy = nil
	self._selectedAt = nil

	self.Fire = Signal.new()

	self._trove:Add(self.Fire)
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
	local now = os.clock()

	if not self._selectedAt then
		return
	end

	return now - self._selectedAt >= self._fireRate
end

function Tower:TargetEnemy()
	local selectedEnemy = self:SelectEnemy()

	if not selectedEnemy then
		self._selectedAt = nil
		return
	end

	if not self._selectedAt then
		self._selectedAt = os.clock()
	end

	if self:CanFire() then
		self.Fire:Fire()
		self._selectedAt = os.clock() -- reset firerate timer
	end

	self.selectedEnemy = selectedEnemy
end

return Tower
