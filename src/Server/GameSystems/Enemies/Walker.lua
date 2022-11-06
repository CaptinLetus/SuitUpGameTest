--[[
	This component controls the behavior of a walker
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local SoundService = game:GetService("SoundService")
local ChatService = game:GetService("Chat")

local Component = require(ReplicatedStorage.Packages.Component)
local TroveAdder = require(ReplicatedStorage.ComponentExtensions.TroveAdder)
local Bomb = require(ServerScriptService.GameSystems.Weapons.Bomb)

local HIP_HEIGHT = 1.8
local BOMB_PICKUP_DISTANCE = 5
local CURIOUS_CHATS = {
	"🙃",
	"😎",
	"🙂",
	"lord bacon will approve",
	"oooh shiny",
	"oh look, a gift!",
	"for me?  thanks!",
}

local nodes = workspace:WaitForChild("Nodes")
local random = Random.new()

local Walker = Component.new({ Tag = "Walker", Extensions = { TroveAdder } })

function Walker:Construct()
	self._previousNode = 0
	self._nextNode = 1

	self._target = workspace.Nodes["1"]
	self._targetBomb = false

	self._humanoid = self.Instance:WaitForChild("Humanoid")
	self._humanoid.HipHeight = HIP_HEIGHT -- for some reason, setting this in studio doesn't work

	self:UpdateAttributes()
end

function Walker:UpdateAttributes()
	self.Instance:SetAttribute("PreviousNode", self._previousNode)
	self.Instance:SetAttribute("NextNode", self._nextNode)
end

function Walker:UpdateProgressAttribute()
	local nextNode: BasePart = nodes:FindFirstChild(self._nextNode)
	local previousNode: BasePart = nodes:FindFirstChild(self._previousNode)

	local currentPosition = self.Instance.PrimaryPart.Position

	local totalDistanceBetweenNodes = (nextNode.Position - previousNode.Position).Magnitude
	local distanceToNext = (nextNode.Position - currentPosition).Magnitude

	local percent = distanceToNext / totalDistanceBetweenNodes

	self.Instance:SetAttribute("ProgressAlongTrack", self._previousNode + percent)
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
	if self._targetBomb then
		return
	end

	self._previousNode += 1
	self._nextNode += 1

	local nextNode: BasePart = nodes:FindFirstChild(self._nextNode)

	if not nextNode then
		self.Instance:Destroy()
		warn("DO DAMAGE")
		return
	end

	self._target = nextNode

	self:UpdateAttributes()
end

function Walker:TargetBomb(bomb)
	local distance = (bomb.Instance.Position - self.Instance.PrimaryPart.Position).Magnitude

	if distance > BOMB_PICKUP_DISTANCE then
		return false
	end

	bomb:Target()

	self._targetBomb = bomb
	self._target = bomb.Instance

	-- play voice line when reaching bomb
	local curiousSound = self:GetRandomAudioFile(SoundService.VoiceLinesBacons.Curious)

	curiousSound.PlayOnRemove = true
	curiousSound.Parent = self.Instance.PrimaryPart
	curiousSound:Destroy()

	local chat = CURIOUS_CHATS[random:NextInteger(1, #CURIOUS_CHATS)]
	ChatService:Chat(self.Instance.Head, chat, Enum.ChatColor.Blue)

	task.delay(2, function()
		bomb:Explode()
		self._humanoid.Health = 0
	end)

	return true
end

function Walker:CheckNearbyBombs()
	if self._targetBomb then
		return
	end

	local bombs = Bomb:GetAll()

	for _, bomb in bombs do
		local targeted = self:TargetBomb(bomb)

		if targeted then
			return
		end

		break
	end
end

function Walker:HeartbeatUpdate()
	if not self._target then
		return
	end

	self:UpdateProgressAttribute()
	self:CheckNearbyBombs()

	self._humanoid:MoveTo(self._target.Position)
end

function Walker:GetRandomAudioFile(parent: Folder): Sound
	local children = parent:GetChildren()

	local index = random:NextInteger(1, #children)

	return children[index]:Clone()
end

return Walker
