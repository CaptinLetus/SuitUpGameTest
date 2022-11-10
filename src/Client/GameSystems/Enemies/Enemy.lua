--[[
	This component control the healthbars on the client for enemies
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local HealthbarGui = require(script.Parent.Healthbar.HealthbarGui)
local HealthbarViewModel = require(script.Parent.Healthbar.HealthbarViewModel)
local TroveAdder = require(ReplicatedStorage.ComponentExtensions.TroveAdder)
local Roact = require(ReplicatedStorage.Packages.Roact)

local Enemy = Component.new({ Tag = "Enemy", Extensions = { TroveAdder } })

function Enemy:Construct()
	local humanoid = self.Instance:WaitForChild("Humanoid")

	local viewModel = HealthbarViewModel.new()

	viewModel:setMaxHealth(humanoid.MaxHealth)
	viewModel:setHealth(humanoid.Health)
	viewModel:setName(self.Instance.Name)

	self.viewModel = viewModel
	self._humanoid = humanoid

	self._trove:Add(viewModel)

	self:MountUI()
end

function Enemy:MountUI()
	local handle = Roact.mount(
		Roact.createElement(HealthbarGui, {
			viewModel = self.viewModel,
			target = self.Instance:WaitForChild("Head"),
		}),
		Players.LocalPlayer.PlayerGui,
		"Healthbar"
	)

	self._trove:Add(function()
		Roact.unmount(handle)
	end)
end

function Enemy:Start()
	self._trove:Connect(self._humanoid.Changed, function()
		self.viewModel:setHealth(self._humanoid.Health)
		self.viewModel:setMaxHealth(self._humanoid.MaxHealth)
	end)
end

return Enemy
