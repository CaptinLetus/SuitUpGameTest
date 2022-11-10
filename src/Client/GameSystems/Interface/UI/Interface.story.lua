local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local InterfaceViewModel = require(script.Parent.InterfaceViewModel)
local firstLevel = require(ReplicatedStorage.Data.Levels.FirstLevel)

return function(target)
	local viewModel = InterfaceViewModel.new()

	viewModel:setCurrency(100)
	viewModel:setLives(3)
	viewModel:setCurrentLevel(firstLevel)
	viewModel:setLevelStartTime(workspace:GetServerTimeNow())
	viewModel:setShowWin(true)

	local element = Roact.createElement(require(script.Parent.InterfaceFrame), {
		viewModel = viewModel,
	})
	local handler = Roact.mount(element, target)

	return function()
		Roact.unmount(handler)
		viewModel:Destroy()
	end
end
