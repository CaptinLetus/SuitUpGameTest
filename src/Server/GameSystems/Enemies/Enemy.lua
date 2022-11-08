local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Component = require(ReplicatedStorage.Packages.Component)
local TroveAdder = require(ReplicatedStorage.ComponentExtensions.TroveAdder)

local COINS_PER_KILL = 10

local Enemy = Component.new({ Tag = "Enemy", Extensions = { TroveAdder } })

function Enemy:Construct()
	self._humanoid = self.Instance:WaitForChild("Humanoid")
end

function Enemy:Start()
	self._trove:Connect(self._humanoid.Died, function()
		local player = Players:GetPlayers()[1]

		Knit.GetService("CurrencyService"):Increment(player, COINS_PER_KILL)

		self.Instance:BreakJoints() -- sometimes the joints don't break on their own
		
		task.wait(3)
		self.Instance:Destroy()
	end)
end

return Enemy
