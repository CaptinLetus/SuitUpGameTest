local bezier = {}

function length(n, func, ...)
	local sum, ranges, sums = 0, {}, {}
	for i = 0, n-1 do
		local p1, p2 = func(i/n, ...), func((i+1)/n, ...)
		local dist = (p2 - p1).magnitude
		ranges[sum] = {dist, p1, p2}
		table.insert(sums, sum)
		sum = sum + dist
	end
	return sum, ranges, sums
end

function bezier.new(func, n, ...)
	local self = setmetatable({}, {__index = bezier})
	local sum, ranges, sums = length(n, func, ...)
	self.func = func
	self.n = n
	self.points = {...}
	self.length = sum
	self.ranges = ranges
	self.sums = sums
	return self
end

function bezier:setPoints(...)
	-- only update the length when the control points are changed
	local sum, ranges, sums = length(self.n, self.func, ...)
	self.points = {...}
	self.length = sum
	self.ranges = ranges
	self.sums = sums
end

function bezier:calc(t)
	-- if you don't need t to be a percentage of distance
	return self.func(t, unpack(self.points))
end

function bezier:calcFixed(t)
	local T, near = t * self.length, 0
	for _, n in next, self.sums do
		if (T - n) < 0 then break end
		near = n
	end
	local set = self.ranges[near]
	local percent = (T - near)/set[1]
	return set[2], set[3], percent
end

return bezier