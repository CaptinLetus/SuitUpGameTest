local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)

return function(props)
	return Roact.createElement("Frame", {
		Size = props.size,
		BackgroundColor3 = Color3.fromRGB(7, 57, 151),
		BackgroundTransparency = 0.5,
	}, {
		Title = Roact.createElement("TextLabel", {
			Size = UDim2.fromScale(1, 0.4),
			BackgroundTransparency = 1,
			Text = props.title,
			Font = Enum.Font.SourceSansBold,
			TextScaled = true,
			TextColor3 = Color3.fromRGB(255, 255, 255),
		}),
		Value = Roact.createElement("TextLabel", {
			Size = UDim2.fromScale(1, 0.6),
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			BackgroundTransparency = 1,
			Text = props.value,
			Font = Enum.Font.SourceSansBold,
			TextScaled = true,
			TextColor3 = Color3.fromRGB(255, 255, 255),
		}),
		Corner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0.1, 0),
		}),
		Stroke = Roact.createElement("UIStroke", {
			Thickness = 2,
			Color = Color3.fromRGB(255, 255, 255),
		}),
	})
end
