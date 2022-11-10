local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Roact = require(ReplicatedStorage.Packages.Roact)
local InterfaceGui = require(script.Parent.UI.InterfaceGui)
local InterfaceViewModel = require(script.Parent.UI.InterfaceViewModel)

local START_LIVES = 5

local InterfaceController = Knit.CreateController({ Name = "InterfaceController" })

local viewModel = InterfaceViewModel.new()

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
	local newAlarm = SoundService.Alarm:Clone()

	newAlarm.PlayOnRemove = true
	newAlarm.Parent = CollectionService:GetTagged("Door")[1]
	newAlarm:Destroy()
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
end

return InterfaceController
