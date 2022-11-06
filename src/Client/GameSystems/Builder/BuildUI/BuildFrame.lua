local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)

local BuildFrame = Roact.Component:extend("BuildFrame")


local function button(props)
	return Roact.createElement("TextButton", {
		Size = props.size,
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		Text = props.text,
		BackgroundColor3 = props.backgroundColor3,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true,
		BorderSizePixel = 0,
	}, {
		Corner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0.1, 0),
		}),
	})
end

function BuildFrame:init()
	self:setState({
		value = self.props.viewModel.value,
	})
end

function BuildFrame:didMount()
	self.props.viewModel.updated:Connect(function(viewModel)
		self:setState({
			value = viewModel.value,
		})
	end)
end

function BuildFrame:render()
	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(72, 2, 129),
	}, {
		Corner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0.1, 0),
		}),
		Stroke = Roact.createElement("UIStroke", {
			Thickness = 2,
			Color = Color3.fromRGB(255, 255, 255),
		}),
		Spawn = Roact.createElement(button, {
			text = "Spawn",
			size = UDim2.fromScale(0.8, 0.7),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			backgroundColor3 = Color3.fromRGB(153, 73, 218),
		}),
	})
end

return BuildFrame