local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)

local towers = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Towers")

local BUTTON_HEIGHT = 50
local PADDING = 10

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
		LayoutOrder = props.layoutOrder,
		[Roact.Event.Activated] = props.onClick,
	}, {
		Corner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0.1, 0),
		}),
	})
end

function BuildFrame:init()
	self:setState({
		errorMsg = self.props.viewModel.errorMsg,
	})
end

function BuildFrame:didMount()
	self.props.viewModel.updated:Connect(function(viewModel)
		self:setState({
			errorMsg = viewModel.errorMsg or Roact.None,
		})
	end)
end

function BuildFrame:getTowerButtons()
	local buttons = {}

	for _, tower in towers:GetChildren() do
		local towerName = tower:GetAttribute("GameName")
		local price = tower:GetAttribute("Price")

		table.insert(
			buttons,
			Roact.createElement(button, {
				text = self.state.errorMsg or towerName .. " - " .. price,
				size = UDim2.new(1, -PADDING * 2, 0, BUTTON_HEIGHT),
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5),
				backgroundColor3 = Color3.fromRGB(153, 73, 218),
				onClick = function()
					self.props.viewModel:buildTower(tower)
				end,
				layoutOrder = price
			})
		)
	end

	return buttons
end

function BuildFrame:render()
	local buttons = self:getTowerButtons()
	local totalPaddingBetweenButtons = PADDING * (#buttons - 1)
	local totalPadding = PADDING * 2 + totalPaddingBetweenButtons

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, #buttons * BUTTON_HEIGHT + totalPadding),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(72, 2, 129),
	}, {
		Corner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0.1, 0),
		}),
		Stroke = Roact.createElement("UIStroke", {
			Thickness = 2,
			Color = Color3.fromRGB(255, 255, 255),
		}),
		List = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, PADDING),
		}),
		Buttons = Roact.createFragment(buttons),
	})
end

return BuildFrame
