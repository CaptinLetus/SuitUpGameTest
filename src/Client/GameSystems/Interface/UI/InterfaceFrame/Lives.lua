local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)


return function (props)
	local showUI = props.lives <= 0

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 0.5,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		Visible = showUI
	}, {
		GameOverText = Roact.createElement("TextLabel", {
			Size = UDim2.fromScale(1, 0.5),
			BackgroundTransparency = 1,
			Text = "You lost!",
			Font = Enum.Font.SourceSansBold,
			TextScaled = true,
			TextColor3 = Color3.fromRGB(255, 255, 255),
		}),
		RestartButton = Roact.createElement("TextButton", {
			Size = UDim2.fromScale(0.2, 0.1),
			Position = UDim2.fromScale(0.5, 0.8),
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Text = "Restart",
			Font = Enum.Font.SourceSansBold,
			TextScaled = true,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			[Roact.Event.Activated] = function()
				props.viewModel:restart()
			end,
		}),
		Blur = Roact.createElement(Roact.Portal, {
			target = Lighting,
		}, {
			Blur = Roact.createElement("BlurEffect", {
				Size = 10,
				Enabled = showUI
			}),
		}),
	})
end