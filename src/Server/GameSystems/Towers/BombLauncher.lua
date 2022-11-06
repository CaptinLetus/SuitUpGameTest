--[[
	This component manages the bomb launcher tower
]]

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Timer = require(ReplicatedStorage.Packages.Timer)
local TroveAdder = require(ReplicatedStorage.ComponentExtensions.TroveAdder)
local Tower = require(script.Parent.Tower)

local UPDATE_INTERVAL = 0.2
local BombLauncher = Component.new({ Tag = "BombLauncher", Extensions = { TroveAdder } })

function BombLauncher:Construct()
	self._radius = self.Instance:GetAttribute("Radius")
	self._noob = self.Instance:FindFirstChild("Noob")

	self._tower = self:GetComponent(Tower)

	self:SetupTimer()
end

function BombLauncher:SetupTimer()
	self._trove:Add(Timer.Simple(UPDATE_INTERVAL, function()
		self._tower:TargetEnemy()
	end))
end

function BombLauncher:PointTowardsEnemy()
	local selectedEnemy = self._tower.selectedEnemy
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
