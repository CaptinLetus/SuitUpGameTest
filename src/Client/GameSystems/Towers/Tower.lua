--[[
	This component plays effects on the client when a tower is built
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Component = require(ReplicatedStorage.Packages.Component)

local voiceLines = SoundService:WaitForChild("VoiceLinesNoobs")

local Tower = Component.new({ Tag = "Tower", Extensions = {} })

local random = Random.new()

function Tower:Start()
	self:PlayIntroSound()
end

function Tower:PlayIntroSound()
	local sounds = voiceLines:GetChildren()
	local randomSoundIndex = random:NextInteger(1, #sounds)
	local sound = sounds[randomSoundIndex]

	sound:Play()
end

return Tower
