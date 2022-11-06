local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local getCurveVelocity = require(ReplicatedStorage.Utils.getCurveVelocity)

local EXPLODE_TIME = 2

local Bomb = Component.new({ Tag = "Bomb", Extensions = {} })

function Bomb:Start()
	local v0 = getCurveVelocity(self.Instance.CFrame, self.Instance:GetAttribute("End"))

	self.Instance.Velocity = v0

	task.delay(EXPLODE_TIME, function()
		self:Explode()
	end)
end

function Bomb:Explode()
	self.Instance:Destroy()
end

return Bomb
