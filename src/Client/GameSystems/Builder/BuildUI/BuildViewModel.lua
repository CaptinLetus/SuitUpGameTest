local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ViewModel = require(ReplicatedStorage.RoactComponents.ViewModel)

local BuildViewModel = {}
BuildViewModel.__index = BuildViewModel
BuildViewModel.className = "BuildViewModel"
setmetatable(BuildViewModel, ViewModel)

function BuildViewModel.new(): table
	local self = ViewModel.new()

	self.base = nil

	return setmetatable(self, BuildViewModel)
end

function BuildViewModel:setBase(newBase: any)
	self.base = newBase
	self:update()
end

function BuildViewModel:Destroy()
	getmetatable(BuildViewModel).Destroy(self)
end

return BuildViewModel
