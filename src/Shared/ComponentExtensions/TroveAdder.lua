local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Trove = require(ReplicatedStorage.Packages.Trove)

local TroveAdder = {}
function TroveAdder.Constructing(component)
    component._trove = Trove.new()
end

function TroveAdder.Stopped(component)
    component._trove:Destroy()
end

return TroveAdder