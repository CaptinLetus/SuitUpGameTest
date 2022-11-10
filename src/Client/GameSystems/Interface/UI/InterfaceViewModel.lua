local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = RunService:IsRunning() and require(ReplicatedStorage.Packages.Knit)
local ViewModel = require(ReplicatedStorage.RoactComponents.ViewModel)

local InterfaceViewModel = {}
InterfaceViewModel.__index = InterfaceViewModel
InterfaceViewModel.className = "InterfaceViewModel"
setmetatable(InterfaceViewModel, ViewModel)

function InterfaceViewModel.new(): table
	local self = ViewModel.new()

	self.currency = 0
	self.lives = 0
	self.currentLevel = nil
	self.levelStartTime = 0
	self.showWin = false

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

function InterfaceViewModel:setCurrentLevel(newLevel: string)
	self.currentLevel = newLevel
	self:update()
end

function InterfaceViewModel:setLevelStartTime(newLevelStartTime: number)
	self.levelStartTime = newLevelStartTime
	self:update()
end

function InterfaceViewModel:setShowWin(newShowWin: boolean)
	self.showWin = newShowWin
	self:update()
end

function InterfaceViewModel:restart()
	if not Knit then
		self.lives = 3
		self:update()
		return
	end

	Knit.GetService("LivesService"):ResetGame()
end

function InterfaceViewModel:Destroy()
	getmetatable(InterfaceViewModel).Destroy(self)
end

return InterfaceViewModel
