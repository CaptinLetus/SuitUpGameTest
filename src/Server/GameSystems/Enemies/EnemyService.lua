local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local EnemyService = Knit.CreateService {
	Name = "EnemyService";
	Client = {};
}


function EnemyService:KnitStart()
	task.spawn(function ()
		while task.wait(5) do
			if not Knit.GetService("LivesService"):IsAlive() then
				continue
			end

			self:SpawnEnemy()
		end
	end)
end


function EnemyService:KnitInit()
	
end

function EnemyService:SpawnEnemy()
	local newEnemy = ReplicatedStorage.Assets.Enemies.BaconHair:Clone()

	newEnemy.Parent = workspace
	newEnemy:PivotTo(workspace.Nodes["0"].CFrame)
end


return EnemyService
