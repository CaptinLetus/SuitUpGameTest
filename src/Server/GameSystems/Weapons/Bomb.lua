local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Component = require(ReplicatedStorage.Packages.Component)
local getCurveVelocity = require(ReplicatedStorage.Utils.getCurveVelocity)
local Enemy = require(ServerScriptService.GameSystems.Enemies.Enemy)

local EXPLODE_TIME = 2
local DAMAGE = 20
local RADIUS = 15

local Bomb = Component.new({ Tag = "Bomb", Extensions = {} })

function Bomb:Construct()
	self._targeted = false
end

function Bomb:Start()
	local v0 = getCurveVelocity(self.Instance.CFrame, self.Instance:GetAttribute("End"))

	self.Instance.Velocity = v0

	task.delay(EXPLODE_TIME, function()
		if self._targeted then
			return
		end

		self:Explode()
	end)
end

function Bomb:DamageEnemies()
	for _, enemyComp in Enemy:GetAll() do
		local enemy = enemyComp.Instance

		local distance = (enemy.PrimaryPart.Position - self.Instance.Position).Magnitude

		if distance > RADIUS then
			continue
		end

		local humanoid = enemy:FindFirstChildWhichIsA("Humanoid")

		if not humanoid then
			continue
		end

		humanoid:TakeDamage(DAMAGE)
	end
end

function Bomb:Target()
	self._targeted = true
end

function Bomb:Explode()
	local explosion = Instance.new("Explosion")
	explosion.BlastPressure = 0
	explosion.BlastRadius = 0
	explosion.Position = self.Instance.Position
	explosion.Parent = workspace

	self.Instance:Destroy()

	self:DamageEnemies()

	task.wait(1)
	explosion:Destroy()
end

return Bomb
