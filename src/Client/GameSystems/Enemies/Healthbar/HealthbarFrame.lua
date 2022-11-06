local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)

local HealthbarFrame = Roact.Component:extend("HealthbarFrame")

function HealthbarFrame:init()
	self:setState({
		health = self.props.viewModel.health,
		maxHealth = self.props.viewModel.maxHealth,
		name = self.props.viewModel.name,
	})
end

function HealthbarFrame:didMount()
	self.props.viewModel.updated:Connect(function(viewModel)
		self:setState({
			health = viewModel.health,
			maxHealth = viewModel.maxHealth,
			name = viewModel.name,
		})
	end)
end

function HealthbarFrame:render()
	local percent = self.state.health / self.state.maxHealth

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	}, {
		RigName = Roact.createElement("TextLabel", {
			FontFace = Font.new(
				"rbxasset://fonts/families/SourceSansPro.json",
				Enum.FontWeight.Heavy,
				Enum.FontStyle.Normal
			),
			Text = self.state.name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0.6),
		}, {
			UIStroke = Roact.createElement("UIStroke"),
		}),
		HealthBar = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.fromScale(1, 0.3),
		}, {
			Slider = Roact.createElement("Frame", {
				BackgroundColor3 = Color3.fromRGB(255, 0, 4),
				Size = UDim2.fromScale(percent, 1),
			}),
		}),
	})
end

return HealthbarFrame
