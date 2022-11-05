local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
 
local TeleportModule = {}
 
local RETRY_DELAY = 2
local MAX_WAIT = 10
 
-- Create remote event instance
local teleportEvent = Instance.new("RemoteEvent")
teleportEvent.Name = "TeleportEvent"
teleportEvent.Parent = ReplicatedStorage
 
function TeleportModule.teleportWithRetry(targetPlaceID, playersTable, teleportOptions)
	local currentWait = 0
 
	-- Show custom teleport screen to valid players if client event is connected
	teleportEvent:FireAllClients(playersTable, true)
 
	local function doTeleport(players, options)
		if currentWait < MAX_WAIT then
			local success, errorMessage = pcall(function()
				return TeleportService:TeleportAsync(targetPlaceID, players, options)
			end)
			if not success then
				warn(errorMessage)
				-- Retry teleport after defined delay
				wait(RETRY_DELAY)
				currentWait = currentWait + RETRY_DELAY
				doTeleport(players, teleportOptions)
			end
		else
			-- On failure, hide custom teleport screen for remaining valid players
			teleportEvent:FireAllClients(players, false)
			return true
		end
	end
 
	TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
		if teleportResult ~= Enum.TeleportResult.Success then
			warn(errorMessage)
			-- Retry teleport after defined delay
			wait(RETRY_DELAY)
			currentWait = currentWait + RETRY_DELAY
			doTeleport({player}, teleportOptions)
		end
	end)
 
	-- Fire initial teleport
	doTeleport(playersTable, teleportOptions)
end
 
return TeleportModule