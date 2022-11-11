--[[
	This controller controls all of the UI in the game
]]

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Roact = require(ReplicatedStorage.Packages.Roact)
local InterfaceGui = require(script.Parent.UI.InterfaceGui)
local InterfaceViewModel = require(script.Parent.UI.InterfaceViewModel)

local START_LIVES = 5

local viewModel = InterfaceViewModel.new()
local alarmSound = SoundService.Alarm:Clone()
local alarmPlayed = 0

local InterfaceController = Knit.CreateController({ Name = "InterfaceController" })

function InterfaceController:KnitInit()
	Roact.mount(
		Roact.createElement(InterfaceGui, {
			viewModel = viewModel,
		}),
		Knit.Player.PlayerGui,
		"Interface"
	)

	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end

function InterfaceController:PlayAlarmSound()
	local t = os.clock()
	alarmPlayed = t

	if not alarmSound.Playing then
		alarmSound:Play()
	end

	task.delay(alarmSound.TimeLength, function()
		if alarmPlayed == t then
			alarmSound:Stop()
		end
	end)
end

function InterfaceController:CurrencyChanged(amount)
	viewModel:setCurrency(amount)
end

function InterfaceController:LivesChanged(amount)
	viewModel:setLives(amount)

	if amount < START_LIVES then
		self:PlayAlarmSound()
	end
end

function InterfaceController:WonChanged(didWin)
	viewModel:setShowWin(didWin)
end

function InterfaceController:CurrentLevelUpdated(info)
	viewModel:setCurrentLevel(info.level)
	viewModel:setLevelStartTime(info.startTime)
	viewModel:setWaveRunning(info.running)
end

function InterfaceController:SetupRemotes()
	local CurrencyService = Knit.GetService("CurrencyService")
	local enemyService = Knit.GetService("EnemyService")
	local livesService = Knit.GetService("LivesService")

	CurrencyService.Currency:Observe(function(amount)
		self:CurrencyChanged(amount)
	end)

	livesService.Lives:Observe(function(amount)
		self:LivesChanged(amount)
	end)

	livesService.Won:Observe(function(didWin)
		self:WonChanged(didWin)
	end)

	enemyService.CurrentLevel:Observe(function(info)
		self:CurrentLevelUpdated(info)
	end)
end

function InterfaceController:KnitStart()
	self:SetupRemotes()
	alarmSound.Parent = CollectionService:GetTagged("Door")[1] -- there is only 1 door in the map
end

return InterfaceController
