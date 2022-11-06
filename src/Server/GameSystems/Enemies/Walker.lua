--[[
	This component controls the behavior of a walker
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local TroveAdder = require(ReplicatedStorage.ComponentExtensions.TroveAdder)

local HIP_HEIGHT = 1.8

local nodes = workspace:WaitForChild("Nodes")

local Walker = Component.new({ Tag = "Walker", Extensions = { TroveAdder } })

function Walker:Construct()
	self._previousNode = 0
	self._nextNode = 1

	self._humanoid = self.Instance:WaitForChild("Humanoid")
	self._humanoid.HipHeight = HIP_HEIGHT -- for some reason, setting this in studio doesn't work

	self:UpdateAttributes()
end

function Walker:UpdateAttributes()
	self.Instance:SetAttribute("PreviousNode", self._previousNode)
	self.Instance:SetAttribute("NextNode", self._nextNode)
end

function Walker:Start()
	self._humanoid.MoveToFinished:Connect(function(reached)
		if not reached then
			warn("There was an issue")
			self.Instance:Destroy()
			return
		end

		self:UpdateNode()
	end)
end

function Walker:UpdateNode()
	self._previousNode += 1
	self._nextNode += 1

	self:UpdateAttributes()
end

function Walker:HeartbeatUpdate()
	local nextNode: BasePart = nodes:FindFirstChild(self._nextNode)
	local previousNode: BasePart = nodes:FindFirstChild(self._previousNode)

	if not nextNode then
		self.Instance:Destroy()
		warn("DO DAMAGE")
		return
	end

	local currentPosition = self.Instance.PrimaryPart.Position

	local totalDistanceBetweenNodes = (nextNode.Position - previousNode.Position).Magnitude
	local distanceToNext = (nextNode.Position - currentPosition).Magnitude

	local percent = distanceToNext / totalDistanceBetweenNodes

	self.Instance:SetAttribute("ProgressAlongTrack", self._previousNode + percent)

	self._humanoid:MoveTo(nextNode.Position)
end

return Walker
