local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
end

function InterfaceController:KnitStart()
	local player = Knit.Player

	player:GetAttributeChangedSignal("Currency"):Connect(function()
		viewModel:setCurrency(player:GetAttribute("Currency") or 0)
	end)

	player:GetAttributeChangedSignal("Lives"):Connect(function()
		viewModel:setLives(player:GetAttribute("Lives") or 0)
	end)
end

return InterfaceController
