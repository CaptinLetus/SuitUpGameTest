--[[
	This controller sets up the "Camera" tag on the camera
]]

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local CameraController = Knit.CreateController({ Name = "CameraController" })

function CameraController:KnitInit()
	local camera = workspace:WaitForChild("Camera")

	CollectionService:AddTag(camera, "Camera")
end

return CameraController
