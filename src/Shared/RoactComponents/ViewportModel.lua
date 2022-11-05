local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Roact = require(ReplicatedStorage.Packages.Roact)
local ViewportModel = require(ReplicatedStorage.Utils.ViewportModel)
local Trove = require(ReplicatedStorage.Packages.Trove)

local ALLOWED_INPUTS = {
	Enum.UserInputType.MouseMovement,
	Enum.UserInputType.MouseButton1,
	Enum.UserInputType.Touch,
	Enum.UserInputType.Gamepad1,
}
local e = Roact.createElement

local ModelViewport = Roact.PureComponent:extend("ModelViewport")

function ModelViewport:init()
	self._viewport = Roact.createRef()

	self._autoRotate = true
	self._activeInput = false
	self._inputEndedTime = 0
	self._lastInputPosition = Vector3.new()

	self._trove = Trove.new()
end

function ModelViewport:didMount()
	self._camera = Instance.new("Camera")
	self._camera.FieldOfView = self.props.fov or 70
	self._camera.Parent = self._viewport.current
	self._viewport.current.CurrentCamera = self._camera

	self._model = Instance.new("Model")
	self._model.Parent = self._viewport.current

	self._vpfModel = ViewportModel.new(self._viewport.current, self._camera)

	self:setCameraCFrame()

	if self.props.Rotate then
		self:setupAutoRotate()
	end

	if self.props.Draggable then
		self._trove:Connect(UserInputService.InputChanged, function(input)
			self:dragInput(input)
		end)

		self._trove:Connect(UserInputService.InputEnded, function(input)
			self:stopDragging(input)
		end)
	end
end

function ModelViewport:didUpdate(previousProps)
	self._model:ClearAllChildren()
	self:setCameraCFrame()

	if self.props.ResetRotationOnUpdate then
		self._theta = self.props.StartAngle or 0
	end
end

function ModelViewport:setupAutoRotate()
	self._theta = self.props.StartAngle or 0
	local orientation = CFrame.new()

	self._trove:Connect(game:GetService("RunService").RenderStepped, function(dt)
		if self._autoRotate then
			self._theta = self._theta + math.rad(20 * dt)
		end

		orientation = CFrame.fromEulerAnglesYXZ(math.rad(-20), self._theta, 0)
		self._camera.CFrame = CFrame.new(self._cf.Position) * orientation * CFrame.new(0, 0, self._distance)
	end)
end

function ModelViewport:dragInput(input)
	if not self._activeInput then
		return
	end

	if not table.find(ALLOWED_INPUTS, input.UserInputType) then
		return
	end

	local position = input.Position
	local delta = position - self._lastInputPosition

	self._theta = self._theta - delta.X / 100

	self._lastInputPosition = position
end

function ModelViewport:stopDragging(input)
	if not table.find(ALLOWED_INPUTS, input.UserInputType) then
		return
	end

	self._activeInput = false

	local t = os.clock()
	self._inputEndedTime = t

	task.delay(5, function()
		if t == self._inputEndedTime then
			self._autoRotate = true
		end
	end)
end

function ModelViewport:willUnmount()
	self._trove:Destroy()
end

function ModelViewport:setCameraCFrame()
	if self.props.Instance then
		for _, v in pairs(self.props.Instance:GetChildren()) do
			if v.Name == "Dummy" or v.Name == "PlayerSpot"  then
				continue
			end

			v:Clone().Parent = self._model
		end
	end

	local cf, size = self._model:GetBoundingBox()

	self._vpfModel:SetModel(self._model)

	local orientation = self.props.Orientation or CFrame.fromEulerAnglesYXZ(0, 0, 0)
	local distance = self._vpfModel:GetFitDistance(cf.Position)

	if self.props.DistanceModifier then
		distance *= self.props.DistanceModifier
	end

	self._cf = cf
	self._distance = distance

	if self.props.Rotate then
		return
	end

	self._camera.CFrame = CFrame.new(cf.Position) * orientation * CFrame.new(0, 0, distance)
end

function ModelViewport:render()
	return e("ViewportFrame", {
		[Roact.Ref] = self._viewport,
		Size = self.props.Size,
		Position = self.props.Position,
		AnchorPoint = self.props.AnchorPoint,
		BackgroundTransparency = self.props.BackgroundTransparency or 1,
		ZIndex = self.props.ZIndex or 1,
		BackgroundColor3 = self.props.BackgroundColor3,
		Ambient = self.props.Ambient,
		LightColor = self.props.LightColor,
		ImageTransparency = self.props.ImageTransparency,
		ClipsDescendants = self.props.ClipsDescendants,
	}, {
		InteractionLayer = self.props.Draggable and Roact.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			Text = "",
			BackgroundTransparency = 1,
			[Roact.Event.MouseButton1Down] = function(_, x, y)
				self._activeInput = true
				self._autoRotate = false
				self._lastInputPosition = Vector3.new(x, y, 0)
			end,
		}),
	})
end

return ModelViewport
