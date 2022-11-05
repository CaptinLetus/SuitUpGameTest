local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.Packages.Promise)

local cache = {}

local function getThumbnail(player, thumbnailType)
	return Promise.new(function (resolve, reject)
		local success, result = pcall(function ()
			return Players:GetUserThumbnailAsync(player.UserId, thumbnailType, Enum.ThumbnailSize.Size180x180)
		end)

		if success then
			resolve(result)
		else
			reject(result)
		end
	end)
end

return function (player, thumbnailType)
	thumbnailType = thumbnailType or Enum.ThumbnailType.AvatarBust

	cache[player] = cache[player] or {}

	local cached = cache[player][thumbnailType]

	if cached then
		return cached
	else
		local newPromise = getThumbnail(player, thumbnailType)

		cache[player][thumbnailType] = newPromise

		return newPromise
	end
end
