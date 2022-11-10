local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local GlobalSettings = require(ReplicatedStorage.Data.GlobalSettings)
local currentLevel = require(ReplicatedStorage.Data.Levels.FirstLevel)

local EnemyService = Knit.CreateService({
	Name = "EnemyService",
	Client = {
		CurrentLevel = Knit.CreateProperty({
			level = nil,
			startTime = 0,
		})
	},
})

function EnemyService:KnitStart()
	task.wait(5) -- TODO replace with onboarding

	self:PlayGame()
end

function EnemyService:PlayGame()
	self.Client.CurrentLevel:Set({
		level = currentLevel,
		startTime = workspace:GetServerTimeNow(),
	})
	self:RunLevel()
end

function EnemyService:RunLevel()
	self._gameThread = task.spawn(function ()
		for i, wave in ipairs(currentLevel) do
			local enemies = wave.enemies
			local length = wave.length
			local loop = wave.loop or 1
	
			for _ = 1, loop do
				for _, enemy in ipairs(enemies) do
					for _ = 1, enemy.amount do
						task.wait(GlobalSettings.TIME_BETWEEN_ENEMY_AMOUNT)
						self:SpawnEnemy(enemy.enemy)
					end
				end
	
				task.wait(length)
			end
		end
	end)
	

	warn("OVER")
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

function EnemyService:Reset()
	if self._gameThread then
		task.cancel(self._gameThread)
	end

	self:PlayGame()
end

return EnemyService
