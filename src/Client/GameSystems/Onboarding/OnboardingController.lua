--[[
	This controller controls the onboarding experience	
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local OnboardingUI = require(script.Parent.OnboardUI)
local Roact = require(ReplicatedStorage.Packages.Roact)

local OnboardingController = Knit.CreateController({ Name = "OnboardingController" })

function OnboardingController:KnitInit()
	local handle

	local element = Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
	}, {
		Roact.createElement(OnboardingUI, {
			playClicked = function()
				Roact.unmount(handle)
			end,
		}),
	})

	handle = Roact.mount(element, Players.LocalPlayer.PlayerGui, "Onboarding")
end

return OnboardingController
