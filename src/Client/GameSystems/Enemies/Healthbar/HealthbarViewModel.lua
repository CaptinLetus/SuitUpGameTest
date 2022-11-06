local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ViewModel = require(ReplicatedStorage.RoactComponents.ViewModel)

local HealthbarViewModel = {}
HealthbarViewModel.__index = HealthbarViewModel
HealthbarViewModel.className = "HealthbarViewModel"
setmetatable(HealthbarViewModel, ViewModel)

function HealthbarViewModel.new(): table
	local self = ViewModel.new()

	self.health = 0
	self.maxHealth = 0
	self.name = ""

	return setmetatable(self, HealthbarViewModel)
end

function HealthbarViewModel:setHealth(newHealth: number)
	self.health = newHealth
	self:update()
end

function HealthbarViewModel:setMaxHealth(newMaxHealth: number)
	self.maxHealth = newMaxHealth
	self:update()
end

function HealthbarViewModel:setName(newName: string)
	self.name = newName
	self:update()
end

function HealthbarViewModel:Destroy()
	getmetatable(HealthbarViewModel).Destroy(self)
end

return HealthbarViewModel
