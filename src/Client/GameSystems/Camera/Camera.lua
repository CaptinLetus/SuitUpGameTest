--[[
	This component controls the custom camera movement
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local PlayerModule = require(Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
local Input = require(ReplicatedStorage.Packages.Input)
local TroveAdder = require(ReplicatedStorage.ComponentExtensions.TroveAdder)

local YAW = CFrame.Angles(0, math.rad(-135), 0)
local PITCH = CFrame.Angles(math.rad(-45), 0, 0)
local MOVE_SPEED = 50
local UPDATE_MODIFIER = 0.1
local SCROLL_MODIFIER = 5
local MIN_DISTANCE = 30
local MAX_DISTANCE = 100

local Controls = PlayerModule:GetControls()
local Mouse = Input.Mouse.new()

local cameraStartSpot: BasePart = workspace:WaitForChild("CameraStartSpot")
local startPosition = cameraStartSpot.Position
local startCFrame = CFrame.new(Vector3.new(startPosition.X, 0, startPosition.Z)) * YAW

local Camera = Component.new({ Tag = "Camera", Extensions = { TroveAdder } })

function Camera:Construct()
	self._cframe = startCFrame
	self._distance = (MIN_DISTANCE + MAX_DISTANCE) / 2
end

function Camera:Start()
	self:SetupInputs()
end

function Camera:SetupInputs()
	self._trove:Connect(Mouse.Scrolled, function(delta)
		local adjustedDelta = delta * SCROLL_MODIFIER
		self._distance = math.clamp(self._distance - adjustedDelta, MIN_DISTANCE, MAX_DISTANCE)
	end)
end

function Camera:UpdatePosition(deltaTime)
	local moveVector = Controls:GetMoveVector()
	local velocityVector = moveVector * MOVE_SPEED * deltaTime

	self._cframe *= CFrame.new(velocityVector)
end

function Camera:UpdateCameraCFrame(deltaTime)
	local cameraCFrame = self._cframe * PITCH * CFrame.new(0, 0, self._distance)
	local lerpAlpha = 1 - math.exp(-deltaTime / UPDATE_MODIFIER)

	local lerpedCFrame = self.Instance.CFrame:Lerp(cameraCFrame, lerpAlpha)

	self.Instance.CFrame = lerpedCFrame
end

function Camera:RenderSteppedUpdate(deltaTime)
	-- sometimes, Roblox scripts can set this back to custom
	-- so we need to set it back to scriptable
	self.Instance.CameraType = Enum.CameraType.Scriptable

	self:UpdatePosition(deltaTime)
	self:UpdateCameraCFrame(deltaTime)
end

return Camera
