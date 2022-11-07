local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Roact = require(ReplicatedStorage.Packages.Roact)
local InterfaceGui = require(script.Parent.UI.InterfaceGui)
local InterfaceViewModel = require(script.Parent.UI.InterfaceViewModel)

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

function InterfaceController:KnitStart()
	Knit.GetService("CurrencyService").Currency:Observe(function(amount)
		viewModel:setCurrency(amount)
	end)

	Knit.GetService("LivesService").Lives:Observe(function(amount)
		viewModel:setLives(amount)
	end)
end

return InterfaceController
