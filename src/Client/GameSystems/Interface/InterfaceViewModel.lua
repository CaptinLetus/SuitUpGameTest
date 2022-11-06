local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ViewModel = require(ReplicatedStorage.RoactComponents.ViewModel)

local InterfaceViewModel = {}
InterfaceViewModel.__index = InterfaceViewModel
InterfaceViewModel.className = "InterfaceViewModel"
setmetatable(InterfaceViewModel, ViewModel)

function InterfaceViewModel.new(): table
	local self = ViewModel.new()

	self.currency = 0
	self.lives = 0

	return setmetatable(self, InterfaceViewModel)
end

function InterfaceViewModel:setCurrency(newCurrency: number)
	self.currency = newCurrency
	self:update()
end

function InterfaceViewModel:setLives(newLives: number)
	self.lives = newLives
	self:update()
end

function InterfaceViewModel:Destroy()
	getmetatable(InterfaceViewModel).Destroy(self)
end

return InterfaceViewModel
