local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Panel = require(script.Parent.Panel)
local GlobalSettings = require(ReplicatedStorage.Data.GlobalSettings)

local OFFSET_PER_SECOND = 10

local Waves = Roact.Component:extend("Waves")

function Waves:init()
	self._position, self._updatePosition = Roact.createBinding(0)
end

function Waves:didMount()
	self._renderEvent = RunService.RenderStepped:Connect(function()
		if not self.props.viewModel.waveRunning then
			return
		end

		local now = workspace:GetServerTimeNow()
		local elapsed = now - self.props.viewModel.levelStartTime

		local scale = elapsed * OFFSET_PER_SECOND
		self._updatePosition(scale)
	end)
end

--[[
	Create points on the wave UI for each enemy
]]
function Waves:getWaveElements()
	local currentLevel = self.props.viewModel.currentLevel

	if not currentLevel then
		return
	end

	local elements = {}

	local offset = 0
	for i, wave in ipairs(currentLevel) do
		local enemies = wave.enemies
		local length = wave.length
		local loop = wave.loop or 1

		for _ = 1, loop do
			for _, enemy in ipairs(enemies) do
				for _ = 1, enemy.amount do
					table.insert(
						elements,
						Roact.createElement("Frame", {
							Size = UDim2.fromScale(0.5, 0.5),
							Position = UDim2.new(1, -offset, 0.5, 0),
							AnchorPoint = Vector2.new(1, 0.5),
							SizeConstraint = Enum.SizeConstraint.RelativeYY,
							BackgroundColor3 = Color3.fromRGB(255, 0, 0),
						}, {
							Corner = Roact.createElement("UICorner", {
								CornerRadius = UDim.new(0.5, 0),
							}),
						})
					)
					offset += OFFSET_PER_SECOND * GlobalSettings.TIME_BETWEEN_ENEMY_AMOUNT
				end
			end

			offset += OFFSET_PER_SECOND * length
		end
	end

	return elements
end

function Waves:willUnmount()
	self._renderEvent:Disconnect()
end

function Waves:render()
	local waveElements = self:getWaveElements()

	return Roact.createElement(Panel, {
		size = UDim2.fromScale(0.2, 0.1),
		position = UDim2.fromScale(0.005, 0.01),
		title = "Enemies",
		value = "",
		titleSize = UDim2.fromScale(1, 0.4),
	}, {
		SpawnLine = Roact.createElement("Frame", {
			Size = UDim2.fromScale(0.01, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.5,
			Position = UDim2.fromScale(0.8, 0),
		}),
		Enemies = Roact.createElement("Frame", {
			Size = UDim2.fromScale(0.8, 1),
			Position = self._position:map(function(value)
				return UDim2.new(0, value, 0, 0)
			end),
			BackgroundTransparency = 1,
		}, waveElements),
	})
end

return Waves
