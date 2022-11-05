local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Comm = require(ReplicatedStorage.Packages.Comm)

local CommAdder = {}
function CommAdder.Constructing(component)
	if RunService:IsClient() then
		component._comm = Comm.ClientComm.new(component.Instance, true)
	else
		component._comm = Comm.ServerComm.new(component.Instance)
	end
end

function CommAdder.Stopped(component)
	component._comm:Destroy()
end

return CommAdder
