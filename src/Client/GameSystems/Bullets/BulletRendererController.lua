--[[
	This controller is used to render bullets

	We use PartCache to create object pools for the bullets to reduce the amount of garbage created
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PartCache = require(ReplicatedStorage.Utils.PartCache)

local START_AMOUNT = 50

local assets = ReplicatedStorage:WaitForChild("Assets")
local bullets = assets:WaitForChild("Bullets")

local caches = {}

local bulletFolder = Instance.new("Folder")
bulletFolder.Name = "Bullets"
bulletFolder.Parent = workspace

local BulletRendererController = Knit.CreateController({ Name = "BulletRendererController" })

local function createCacheForBullet(bullet: Instance)
	if caches[bullet.Name] then
		return
	end

	local cache = PartCache.new(bullet, START_AMOUNT, bulletFolder)

	print("created cache for", bullet.Name)
	caches[bullet.Name] = cache
end

-- returns the component module that corresponds to the bullet
local function getComponentForBullet(bulletName: string)
	local componentModule = nil

	for _, module in pairs(script.Parent:GetChildren()) do
		if module:IsA("ModuleScript") and module.Name == bulletName then
			componentModule = require(module)
			break
		end
	end

	return componentModule
end

function BulletRendererController:KnitInit()
	for _, bullet in bullets:GetChildren() do
		createCacheForBullet(bullet)
	end
end

function BulletRendererController:KnitStart()
	local BulletService = Knit.GetService("BulletService")

	BulletService.RenderBullet:Connect(function(startPosition: Vector3, endPosition: Vector3, bulletName: string)
		self:RenderBullet(startPosition, endPosition, bulletName)
	end)
end

function BulletRendererController:RenderBullet(startPosition: Vector3, endPosition: Vector3, bulletName: string)
	local componentModule = getComponentForBullet(bulletName)

	if not componentModule then
		warn("No component module for bullet: " .. bulletName)
		return
	end

	local cache = caches[bulletName]
	local bullet = cache:GetPart()

	componentModule:WaitForInstance(bullet):andThen(function(comp)
		comp:Fire(startPosition, endPosition, cache)
	end)
end

return BulletRendererController
