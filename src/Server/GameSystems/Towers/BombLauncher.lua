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
local BOMB_OFFSET = CFrame.new(0, 0, -5) -- shot a bomb a bit in front of the enemy

local assets = ReplicatedStorage:FindFirstChild("Assets")
local weapons = assets:FindFirstChild("Weapons")
local bomb = weapons:FindFirstChild("Bomb")

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

function BombLauncher:Start()
	self._tower.Fire:Connect(function()
		self:ThrowBomb()
	end)
end

function BombLauncher:GetEnemyPrimaryPart()
	local selectedEnemy = self._tower.selectedEnemy
	local primaryPart = self._noob.PrimaryPart

	if not selectedEnemy then
		return
	end

	return selectedEnemy.PrimaryPart
end

function BombLauncher:PointTowardsEnemy()
	local primaryPart = self._noob.PrimaryPart

	local enemyPrimaryPart = self:GetEnemyPrimaryPart()

	if not enemyPrimaryPart then
		return
	end

	local lookAtCF = CFrame.lookAt(primaryPart.Position, enemyPrimaryPart.Position)

	-- make sure we only rotate around the y axis
	local _, y = lookAtCF:ToEulerAnglesYXZ()
	local uprightCFrame = CFrame.new(lookAtCF.Position) * CFrame.Angles(0, y, 0)

	primaryPart.CFrame = uprightCFrame
end

function BombLauncher:ThrowBomb()
	local enemyPrimaryPart = self:GetEnemyPrimaryPart()

	if not enemyPrimaryPart then
		return
	end

	local newBomb = bomb:Clone()

	local goalCFrame = enemyPrimaryPart.CFrame * BOMB_OFFSET

	newBomb.CFrame = self._noob.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)
	newBomb:SetAttribute("End", goalCFrame)
	newBomb.Parent = workspace

	self._trove:Add(newBomb)
end

function BombLauncher:SteppedUpdate()
	self:PointTowardsEnemy()
end

return BombLauncher
