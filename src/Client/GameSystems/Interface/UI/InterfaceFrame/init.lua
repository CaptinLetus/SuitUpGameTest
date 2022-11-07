local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Panel = require(script.Panel)
local Lives = require(script.Lives)

local InterfaceFrame = Roact.Component:extend("InterfaceFrame")

function InterfaceFrame:init()
	self:setState({
		currency = self.props.viewModel.currency,
		lives = self.props.viewModel.lives,
	})
end

function InterfaceFrame:didMount()
	self.props.viewModel.updated:Connect(function(viewModel)
		self:setState({
			currency = viewModel.currency,
			lives = viewModel.lives,
		})
	end)
end

function InterfaceFrame:render()
	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	}, {
		TopRight = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(0.995, 0.01),
			Size = UDim2.fromScale(0.2, 0.1),
			BackgroundTransparency = 1,
		}, {
			AspectRatio = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 5,
			}),
			Currency = Roact.createElement(Panel, {
				size = UDim2.fromScale(0.5, 1),
				layoutOrder = 1,
				title = "Currency",
				value = self.state.currency,
			}),
			Lives = Roact.createElement(Panel, {
				size = UDim2.fromScale(0.25, 1),
				layoutOrder = 2,
				title = "Lives",
				value = "x" .. self.state.lives,
			}),
			List = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = UDim.new(0.1, 0),
			}),
		}),
		Lives = Roact.createElement(Lives, {
			lives = self.state.lives,
			viewModel = self.props.viewModel,
		}),
	})
end

return InterfaceFrame
