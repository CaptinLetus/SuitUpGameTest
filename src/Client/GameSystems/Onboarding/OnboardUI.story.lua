local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)

return function(target)
	local handle

	local element = Roact.createElement(require(script.Parent.OnboardUI), {
		playClicked = function()
			Roact.unmount(handle)
		end,
	})

	handle = Roact.mount(element, target)

	return function()
		Roact.unmount(handle)
	end
end
