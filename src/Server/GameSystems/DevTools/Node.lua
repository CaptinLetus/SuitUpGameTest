--[[
	Hide nodes when the game starts
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local Node = Component.new({ Tag = "Node", Extensions = {} })

function Node:Start()
	self.Instance.Transparency = 1
end

return Node
