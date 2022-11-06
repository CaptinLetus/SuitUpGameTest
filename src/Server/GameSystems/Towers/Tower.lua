--[[
	This component contains common tower functionality
]]

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local MIN_PROGRESS = 1

local Tower = Component.new({ Tag = "Tower", Extensions = {} })

function Tower:Construct()
	self._radius = self.Instance:GetAttribute("Radius")

	self.selectedEnemy = nil
end

function Tower:SelectEnemy()
	local allEnemies = CollectionService:GetTagged("Enemy")

	local selectedEnemy = nil
	local selectedDistance = 0

	for _, enemy: Model in allEnemies do
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

function Tower:TargetEnemy()
	local selectedEnemy = self:SelectEnemy()

	if not selectedEnemy then
		return
	end

	self.selectedEnemy = selectedEnemy
end

return Tower