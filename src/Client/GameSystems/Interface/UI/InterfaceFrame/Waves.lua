local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Panel = require(script.Parent.Panel)
local GlobalSettings = require(ReplicatedStorage.Data.GlobalSettings)

local SCALE_PER_SECOND = 0.1

local Waves = Roact.Component:extend("Waves")

function Waves:init() end

function Waves:didMount()
	self._renderEvent = RunService.RenderStepped:Connect(function()
		
	end)
end

function Waves:updateWaveProgression()

end

function Waves:getWaveRoactData()
	local currentLevel = self.props.viewModel.currentLevel

	if not currentLevel then
		return
	end

	print(currentLevel)
end

function Waves:willUnmount()
	self._renderEvent:Disconnect()
end

function Waves:render()
	local waveData = self:getWaveRoactData()

	return Roact.createElement(Panel, {
		size = UDim2.fromScale(0.2, 0.2),
		position = UDim2.fromScale(0.005, 0.01),
		title = "Waves",
		value = "",
		titleSize = UDim2.fromScale(1, 0.2),
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
			BackgroundTransparency = 1,
		}),
	})
end

return Waves
