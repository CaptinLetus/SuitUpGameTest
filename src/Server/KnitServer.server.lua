local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)

for _, v in pairs(ServerScriptService.GameSystems:GetDescendants()) do
	if not v:IsA("ModuleScript") then
		continue
	end

	if not v.Name:find("Service") then
		continue
	end

	require(v)
end

Knit.Start():catch(warn):await()

for _, v in pairs(ServerScriptService.GameSystems:GetDescendants()) do
	if not v:IsA("ModuleScript") then
		continue
	end

	task.spawn(function()
		debug.setmemorycategory(v.Name)
		require(v)
	end)
end
