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

function InterfaceController:KnitStart()
	Knit.GetService("CurrencyService").Currency:Observe(function(amount)
		viewModel:setCurrency(amount)
	end)

	Knit.GetService("LivesService").Lives:Observe(function(amount)
		viewModel:setLives(amount)

		if amount < START_LIVES then
			self:PlayAlarmSound()
		end
	end)

	Knit.GetService("EnemyService").CurrentLevel:Observe(function(info)
		viewModel:setCurrentLevel(info.level)
		viewModel:setLevelStartTime(info.startTime)
	end)

	alarmSound.Parent = CollectionService:GetTagged("Door")[1]
end

return InterfaceController
