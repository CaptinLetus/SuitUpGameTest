local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local BuildViewModel = require(script.Parent.BuildViewModel)

local testBase = workspace.Bases:FindFirstChild("TestBase")

if not testBase then
	warn("No test base found")
	return function() end
end

return function(target)
	local viewModel = BuildViewModel.new()
	viewModel:setBase(testBase)

	local element = Roact.createElement(require(script.Parent.BuildGui), {
		viewModel = viewModel,
	})

	local handler = Roact.mount(element, target)

	return function()
		Roact.unmount(handler)
		viewModel:Destroy()
	end
end
