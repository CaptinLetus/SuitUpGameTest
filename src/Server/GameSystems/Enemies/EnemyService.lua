--[[
	This service controls spawning enemies based on the level file
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local GlobalSettings = require(ReplicatedStorage.Data.GlobalSettings)
local currentLevel = require(ReplicatedStorage.Data.Levels.FirstLevel)
local Enemy = require(script.Parent.Enemy)

local doneWave = false

local EnemyService = Knit.CreateService({
	Name = "EnemyService",
	Client = {
		CurrentLevel = Knit.CreateProperty({
			level = nil,
			startTime = 0,
		}),
	},
})

function EnemyService:KnitStart()
	self:PlayGame()
end

function EnemyService:PlayGame()
	self.Client.CurrentLevel:Set({
		level = currentLevel,
		startTime = workspace:GetServerTimeNow(),
		running = false,
	})

	Knit.GetService("TowerService").TowerBuilt:Wait()

	self:RunLevel()
end

function EnemyService:SpawnEnemiesFromWave(wave, waveNum)
	local enemies = wave.enemies
	local length = wave.length
	local loop = wave.loop or 1

	for loopNum = 1, loop do
		for _, enemy in ipairs(enemies) do
			for _ = 1, enemy.amount do
				task.wait(GlobalSettings.TIME_BETWEEN_ENEMY_AMOUNT)
				self:SpawnEnemy(enemy.enemy)
			end
		end

		local isLastWave = waveNum == #currentLevel
		local isLastLoop = loopNum == loop

		if isLastWave and isLastLoop then
			doneWave = true
		else
			task.wait(length)
		end
	end
end

function EnemyService:RunLevel()
	self._gameThread = task.spawn(function()
		self.Client.CurrentLevel:Set({
			level = currentLevel,
			startTime = workspace:GetServerTimeNow(),
			running = true,
		})

		for waveNum, wave in ipairs(currentLevel) do
			self:SpawnEnemiesFromWave(wave, waveNum)
		end
	end)
end

function EnemyService:SpawnEnemy(enemyName)
	local enemyTemplate: Model = ReplicatedStorage.Assets.Enemies:FindFirstChild(enemyName)

	if not enemyTemplate then
		warn("EnemyService:SpawnEnemy - No enemy template found for " .. enemyName)
		return
	end

	local newEnemy = enemyTemplate:Clone()

	newEnemy.Parent = workspace
	newEnemy:PivotTo(workspace.Nodes["0"].CFrame)
end

function EnemyService:Died()
	local amountOfEnemies = 0

	for _, enemy in Enemy:GetAll() do
		if enemy.Instance.Humanoid.Health > 0 then
			amountOfEnemies = amountOfEnemies + 1
		end
	end

	if amountOfEnemies == 0 and doneWave then
		Knit.GetService("LivesService"):Win()
	end
end

function EnemyService:Reset()
	if self._gameThread then
		task.cancel(self._gameThread)
	end

	doneWave = false

	self:PlayGame()
end

return EnemyService
