local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local currentLevel = require(ReplicatedStorage.Data.Levels.FirstLevel)

local EnemyService = Knit.CreateService {
	Name = "EnemyService";
	Client = {};
}


function EnemyService:KnitStart()
	task.wait(5) -- TODO replace with onboarding

	self:RunLevel()
end


function EnemyService:RunLevel()
	for i, wave in ipairs(currentLevel) do
		print("wave", i)
		local enemies = wave.enemies
		local length = wave.length
		local loop = wave.loop or 1


		print("enemies", enemies)
		print("length", length)
		print("loop", loop)

		for _ = 1, loop do
			for _, enemy in ipairs(enemies) do
				for _ = 1, enemy.amount do
					task.wait(1)
					self:SpawnEnemy(enemy.enemy)
				end
			end

			task.wait(length)
		end
	end

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


return EnemyService
