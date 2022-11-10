local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local PartCache = require(ReplicatedStorage.Utils.PartCache)

local SPEED = 100

local Bullet = Component.new({ Tag = "Bullet", Extensions = {} })

function Bullet:Fire(startPosition: Vector3, endPosition: Vector3, cache: PartCache.PartCache)
	self._startPosition = startPosition
	self._endPosition = endPosition
	self._cache = cache

	local distance = (endPosition - startPosition).Magnitude

	self._travelTime = distance / SPEED
	self._fireTime = os.clock()

	self._lookAtCFrame = CFrame.lookAt(startPosition, endPosition)
	self._endCFrame = self._lookAtCFrame * CFrame.new(0, 0, -distance)

	self.Instance.Shot:Play()
end

function Bullet:RenderSteppedUpdate()
	if not self._startPosition then
		return
	end

	local now = os.clock()
	local elapsed = now - self._fireTime

	if elapsed > self._travelTime then
		self._cache:ReturnPart(self.Instance)
		self._startPosition = nil
		return
	end

	local alpha = elapsed / self._travelTime

	self.Instance.CFrame = self._lookAtCFrame:Lerp(self._endCFrame, alpha)
end

return Bullet
