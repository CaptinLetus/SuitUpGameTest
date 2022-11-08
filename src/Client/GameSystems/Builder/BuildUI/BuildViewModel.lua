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
	self.errorMsg = nil
	self._errorTime = 0

	return setmetatable(self, BuildViewModel)
end

function BuildViewModel:setBase(newBase: any)
	self.base = newBase
	self:update()
end

function BuildViewModel:createErrorMsg(err)
	self.errorMsg = err

	local t = os.clock()
	self._errorTime = t

	task.delay(1, function()
		if self._errorTime == t then
			self.errorMsg = nil
			self:update()
		end
	end)

	self:update()
end

function BuildViewModel:buildTower(tower)
	if not self.base then
		return
	end

	if not Knit then -- for hoarse testing
		warn("Build tower")
		return
	end

	local success, didBuild, err = Knit.GetService("TowerService"):BuildTower(tower.Name, self.base):await()

	if success and didBuild then
		self.base = nil
		self:update()
	else
		self:createErrorMsg(err)
	end
end

function BuildViewModel:Destroy()
	getmetatable(BuildViewModel).Destroy(self)
end

return BuildViewModel
