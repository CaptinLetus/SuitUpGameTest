-- https://devforum.roblox.com/t/converting-secs-to-hsec/146352/2

return function(seconds: number): string
	local Minutes = (seconds - seconds % 60) / 60
	local Hours = (Minutes - Minutes % 60) / 60

	local newSeconds = seconds - Minutes * 60
	local newMinutes = Minutes - Hours * 60

	return string.format("%2i", newMinutes) .. ":" .. string.format("%02i", newSeconds)
end
