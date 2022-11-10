local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local HealthbarViewModel = require(script.Parent.HealthbarViewModel)

return function(target)
	local viewModel = HealthbarViewModel.new()

	viewModel:setMaxHealth(100)
	viewModel:setHealth(50)
	viewModel:setName("Test")

	local element = Roact.createElement(require(script.Parent.HealthbarFrame), {
		viewModel = viewModel,
	})
	local handler = Roact.mount(element, target)

	return function()
		Roact.unmount(handler)
		viewModel:Destroy()
	end
end
