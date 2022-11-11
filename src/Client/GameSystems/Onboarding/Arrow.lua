local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local SIN_AMPLITUDE = 1
local SIN_SPEED = 2
local ROTATION_SPEED = 0.5

local Arrow = Component.new({ Tag = "Arrow", Extensions = {} })

function Arrow:Construct()
	self._startCFrame = self.Instance.CFrame

	self._startTime = os.clock()
end

function Arrow:RenderSteppedUpdate()
	local elapsed = os.clock() - self._startTime

	local height = math.sin(elapsed * SIN_SPEED) * SIN_AMPLITUDE
	local rotation = elapsed * ROTATION_SPEED

	self.Instance.CFrame = self._startCFrame * CFrame.new(0, height, 0) * CFrame.Angles(0, rotation, 0)
end

function Arrow:Stop() end

return Arrow
