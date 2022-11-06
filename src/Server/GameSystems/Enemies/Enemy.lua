local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local TroveAdder = require(ReplicatedStorage.ComponentExtensions.TroveAdder)

local Enemy = Component.new({ Tag = "Enemy", Extensions = { TroveAdder } })

function Enemy:Construct()
	self._humanoid = self.Instance:WaitForChild("Humanoid")
end

function Enemy:Start()
	self._trove:Connect(self._humanoid.Died, function()
		task.wait(1)
		self.Instance:Destroy()
	end)
end

return Enemy
