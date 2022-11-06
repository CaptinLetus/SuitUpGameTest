local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local HealthbarFrame = require(script.Parent.HealthbarFrame)

return function(props)
	return Roact.createElement("BillboardGui", {
		ExtentsOffset = Vector3.new(0, 2.5, 0),
		Size = UDim2.fromScale(3, 1.5),
		ResetOnSpawn = false,
		Adornee = props.target
	}, {
		HealthbarFrame = Roact.createElement(HealthbarFrame, {
			viewModel = props.viewModel,
		}),
	})
end
