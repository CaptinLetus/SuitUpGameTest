--[[
	This component controls the behavior of a walker
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local TroveAdder = require(ReplicatedStorage.ComponentExtensions.TroveAdder)

local nodes = workspace:WaitForChild("Nodes")

local Walker = Component.new({ Tag = "Walker", Extensions = { TroveAdder } })

function Walker:Construct()
	self._previousNode = 0
	self._nextNode = 1

	self._humanoid = self.Instance:WaitForChild("Humanoid")

	self:CreateBodyMovers()
end

function Walker:CreateBodyMovers()
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(2000000, 0, 2000000)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = self.Instance.HumanoidRootPart

	local bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(2000000, 2000000, 2000000)
	bodyGyro.CFrame = self.Instance.HumanoidRootPart.CFrame
	bodyGyro.Parent = self.Instance.HumanoidRootPart

	self._bodyVelocity = bodyVelocity
	self._bodyGyro = bodyGyro

	self._trove:Add(bodyVelocity)
	self._trove:Add(bodyGyro)
end

function Walker:Start()
	task.wait(1) -- gives the physics for the character a chance to initialize
	self:Move()
end

function Walker:UpdateNode()
	self._previousNode += 1
	self._nextNode += 1

	local nextNode = nodes:FindFirstChild(self._nextNode)
	local previousNode = nodes:FindFirstChild(self._previousNode)

	if not nextNode then
		return
	end

	local rootCFrame = self.Instance.HumanoidRootPart.CFrame

	self._bodyGyro.CFrame = CFrame.lookAt(rootCFrame.Position, nextNode.Position)

	-- stop and rotate to face next node
	-- dont play rotation animation if there is hardly any rotation
	local nodeDirection = CFrame.lookAt(previousNode.Position, nextNode.Position).LookVector
	local currentDirection = rootCFrame.LookVector

	local angle = math.acos(nodeDirection:Dot(currentDirection))

	if angle < 0.1 then
		return
	end

	self._bodyVelocity.Velocity = Vector3.new(0, 0, 0)

	task.wait(1)
end

function Walker:Move()
	local nextNode = nodes:FindFirstChild(self._nextNode)

	if not nextNode then
		self.Instance:Destroy()
		warn("DEAL DAMAGE")
		return
	end

	local rootPosition = self.Instance.HumanoidRootPart.Position
	local distance = (rootPosition - nextNode.Position).Magnitude

	local t = distance / self._humanoid.WalkSpeed

	self._bodyVelocity.Velocity = (nextNode.Position - rootPosition) / t

	task.delay(t, function()
		self:UpdateNode()
		self:Move()
	end)
end

return Walker
