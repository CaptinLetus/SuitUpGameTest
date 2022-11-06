local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local InterfaceFrame = require(script.Parent.InterfaceFrame)

return function(props)
	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
	}, {
		InterfaceFrame = Roact.createElement(InterfaceFrame, {
			viewModel = props.viewModel,
		}),
	})
end