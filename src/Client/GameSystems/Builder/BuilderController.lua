--[[
	This controller controls building towers on the client
]]

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Roact = require(ReplicatedStorage.Packages.Roact)
local Input = require(ReplicatedStorage.Packages.Input)
local BuildViewModel = require(script.Parent.BuildUI.BuildViewModel)
local BuildGui = require(script.Parent.BuildUI.BuildGui)

local Mouse = Input.Mouse.new()

local params = RaycastParams.new()

local BuilderController = Knit.CreateController({ Name = "BuilderController" })

local buildViewModel = BuildViewModel.new()

function BuilderController:KnitInit()
	Roact.mount(
		Roact.createElement(BuildGui, {
			viewModel = buildViewModel,
		}),
		Players.LocalPlayer.PlayerGui,
		"BuildGui"
	)
end

function BuilderController:KnitStart()
	self:ListenForClick()
end

function BuilderController:MouseClick()
	local result = Mouse:Raycast(params)

	if not result then
		buildViewModel:setBase(nil)
		return
	end

	if CollectionService:HasTag(result.Instance, "Base") then
		self:Clicked(result.Instance)
	else
		buildViewModel:setBase(nil)
	end
end

function BuilderController:ListenForClick()
	Mouse.LeftDown:Connect(function()
		self:MouseClick()
	end)
end

function BuilderController:Clicked(base: BasePart)
	if base:GetAttribute("ActiveTower") then
		return
	end

	buildViewModel:setBase(base)
end

return BuilderController
