local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.Packages.Signal)

local ViewModel = {}
ViewModel.__index = ViewModel
ViewModel.className = "ViewModel"

function ViewModel.new(): table
	local instance = {}
	instance.updated = Signal.new()

	return setmetatable(instance, ViewModel)
end

function ViewModel:Destroy()
	self.updated:Destroy()
end

function ViewModel:update()
	self.updated:Fire(self)
end

return ViewModel
