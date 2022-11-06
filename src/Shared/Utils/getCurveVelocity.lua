--[[
	From https://devforum.roblox.com/t/modeling-a-projectiles-motion/176677
]]

local t = 0.5

return function(startCFrame, endCFrame)
	local g = Vector3.new(0, -game.Workspace.Gravity, 0)
	local x0 = startCFrame * Vector3.new(0, 2, -2)

	-- calculate the v0 needed to reach mouse.Hit.p
	return (endCFrame.Position - x0 - 0.5 * g * t * t) / t
end
