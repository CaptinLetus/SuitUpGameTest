local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local BuildFrame = require(script.Parent.BuildFrame)

local BuildGui = Roact.Component:extend("BuildGui")

function BuildGui:init()
	self:setState({
		base = self.props.viewModel.base,
	})
end

function BuildGui:didMount()
	self.props.viewModel.updated:Connect(function(viewModel)
		self:setState({
			base = viewModel.base or Roact.None,
		})
	end)
end

function BuildGui:render()
	return Roact.createElement("BillboardGui", {
		ResetOnSpawn = false,
		Active = true,
		Size = UDim2.fromOffset(200, 80),
		ExtentsOffset = Vector3.new(2, 0, 0),
		AlwaysOnTop = true,
		Adornee = self.state.base,
	}, {
		BuildFrame = Roact.createElement(BuildFrame, {
			viewModel = self.props.viewModel,
		}),
	})
end

return BuildGui
