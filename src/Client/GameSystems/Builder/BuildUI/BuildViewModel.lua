local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = RunService:IsRunning() and require(ReplicatedStorage.Packages.Knit)
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

function BuildViewModel:buildTower()
	if not self.base then
		return
	end

	if Knit then
		local success, didBuild = Knit.GetService("TowerService"):BuildTower("BombLauncher", self.base):await()

		if not success or not didBuild then
			warn("Failed to build tower:", didBuild)
		end
	else -- for hoarse testing
		warn("Build tower")
	end

	-- remove UI after building
	self.base = nil
	self:update()
end

function BuildViewModel:Destroy()
	getmetatable(BuildViewModel).Destroy(self)
end

return BuildViewModel
