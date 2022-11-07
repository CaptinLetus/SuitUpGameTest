local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local InterfaceViewModel = require(script.Parent.InterfaceViewModel)

return function(target)
	local viewModel = InterfaceViewModel.new()

	viewModel:setCurrency(100)
	viewModel:setLives(0)
	
	local element = Roact.createElement(require(script.Parent.InterfaceFrame), {
		viewModel = viewModel
	})
	local handler = Roact.mount(element, target)

	return function()
		Roact.unmount(handler)
		viewModel:Destroy()
	end
end