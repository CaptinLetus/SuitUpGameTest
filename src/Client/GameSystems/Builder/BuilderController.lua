local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Input = require(ReplicatedStorage.Packages.Input)

local Mouse = Input.Mouse.new()

local params = RaycastParams.new()

local BuilderController = Knit.CreateController({ Name = "BuilderController" })

function BuilderController:KnitInit() end

function BuilderController:KnitStart()
	self:ListenForClick()
end

function BuilderController:ListenForClick()
	Mouse.LeftDown:Connect(function()
		local result = Mouse:Raycast(params)

		if not result then
			return
		end

		if CollectionService:HasTag(result.Instance, "Base") then
			self:Clicked(result.Instance)
		end
	end)
end

function BuilderController:Clicked(base: BasePart)
	base.BrickColor = BrickColor.Random()
end

return BuilderController
