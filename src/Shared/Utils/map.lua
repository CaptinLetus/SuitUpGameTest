return function (x, oldMin, oldMax, newMin, newMax)
	return (x - oldMin) * (newMax - newMin) / (oldMax - oldMin) + newMin
end