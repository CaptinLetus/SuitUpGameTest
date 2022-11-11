local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)

return function(props)
	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(0.5, 0.8),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BackgroundTransparency = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
	}, {
		Title = Roact.createElement("TextLabel", {
			Text = "Protect the sacred land!",
			Font = Enum.Font.SourceSansBold,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			Size = UDim2.fromScale(0.8, 0.1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0.05),
			AnchorPoint = Vector2.new(0.5, 0),
		}),
		Description = Roact.createElement("TextLabel", {
			Text = [[
				The bacon hairs are invading!

				Use your Noob army to build towers and defend our home!
			]],
			Font = Enum.Font.SourceSans,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			Size = UDim2.fromScale(0.8, 0.3),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0.3),
			AnchorPoint = Vector2.new(0.5, 0),
		}),
		Play = Roact.createElement("TextButton", {
			Text = "Play",
			Font = Enum.Font.SourceSansBold,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			Size = UDim2.fromScale(0.4, 0.1),
			Position = UDim2.fromScale(0.5, 0.7),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = Color3.fromRGB(36, 151, 228),
			BorderSizePixel = 0,
			[Roact.Event.Activated] = props.playClicked,
		}),
		Blur = Roact.createElement(Roact.Portal, {
			target = Lighting,
		}, {
			Blur = Roact.createElement("BlurEffect", {
				Size = 24,
			}),
		}),
	})
end
