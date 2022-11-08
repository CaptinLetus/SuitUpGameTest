local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local BulletService = Knit.CreateService({
	Name = "BulletService",
	Client = {
		RenderBullet = Knit.CreateSignal(),
	},
})

function BulletService:RenderBullet(startPos: Vector3, endPos: Vector3, bulletName: string)
	self.Client.RenderBullet:FireAll(startPos, endPos, bulletName)
end

return BulletService
