local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local gameSystems = script.Parent:WaitForChild("GameSystems")

for _, v in pairs(gameSystems:GetDescendants()) do
	if not v:IsA("ModuleScript") then
		continue
	end

	if not v.Name:find("Controller") then
		continue
	end

	require(v)
end

Knit.Start()
	:andThen(function()
		for _, v in pairs(gameSystems:GetDescendants()) do
			if not v:IsA("ModuleScript") then
				continue
			end

			task.spawn(function()
				debug.setmemorycategory(v.Name)
				require(v)
			end)
		end
	end)
	:catch(warn)
