--[[
	
ModelWrapper API
	sircfenner


-- Constructors
	> ModelWrapper.new(Model)
		Returns a ModelWrapper object for the Model
		Model must have a PrimaryPart set
	 
		
-- Methods
	> ModelWrapper:SetCFrame(CFrame `DesiredCFrame`)
		Sets the Model's CFrame
		
	> ModelWrapper:SetScale(Number `DesiredScale`)
		Sets the Model's scale
		This is a number, not a Vector3
		This works relative to the original scale (which is 1)
		
	> ModelWrapper:ResetScale()
		Resets the Model's scale
		
	> ModelWrapper:SetColor(Color3 `DesiredColor`)
		Sets the Model's color
		
	> ModelWrapper:ResetColor()
		Resets the Model's color
		
	> ModelWrapper:SetTransparency(Number `DesiredTransparency`)
		Sets the Model's transparency
		
	> ModelWrapper:ResetTransparency()
		Resets the Model's transparency
		
	> ModelWrapper:SetMaterial(Enum.Material `DesiredMaterial`)
		Sets the Model's material
		
	> ModelWrapper:ResetMaterial()
		Resets the Model's material
		
	> ModelWrapper:Reset()
		Resets the Model's scale, color, transparency, and material
				
]]

local ModelWrapper = {}
ModelWrapper.__index = ModelWrapper

local function ScaleCFrame(Value, Scale)
	return Value + Value.p * (Scale - 1)
end

function ModelWrapper.new(Model)
	local self = setmetatable({}, ModelWrapper)

	self.Model = Model
	self.Primary = Model.PrimaryPart or error("ModelWrapper: no PrimaryPart")
	self.Scale = 1
	self.CFrame = self.Primary.CFrame

	local Cache = {}
	local Inverse = self.CFrame:Inverse()
	for _, Descendant in next, Model:GetDescendants() do
		if Descendant:IsA("BasePart") then
			local Matrix = Inverse * Descendant.CFrame
			local Size = Descendant.Size
			local Color = Descendant.Color
			local Transparency = Descendant.Transparency
			local Material = Descendant.Material
			Cache[Descendant] = { Matrix, Size, Color, Transparency, Material }
		end
	end
	self.Cache = Cache

	return self
end

function ModelWrapper:SetCFrame(DesiredCFrame)
	local DesiredScale = self.Scale
	for BasePart, Data in next, self.Cache do
		BasePart.CFrame = DesiredCFrame * ScaleCFrame(Data[1], DesiredScale)
	end
	self.CFrame = DesiredCFrame
end

function ModelWrapper:SetScale(DesiredScale)
	local DesiredCFrame = self.CFrame
	for BasePart, Data in next, self.Cache do
		BasePart.Size = Data[2] * DesiredScale
		BasePart.CFrame = DesiredCFrame * ScaleCFrame(Data[1], DesiredScale)
	end
	self.Scale = DesiredScale
end

function ModelWrapper:ResetScale()
	self:SetScale(1)
end

function ModelWrapper:SetColor(DesiredColor)
	for BasePart in next, self.Cache do
		BasePart.Color = DesiredColor
	end
end

function ModelWrapper:ResetColor()
	for BasePart, Data in next, self.Cache do
		BasePart.Color = Data[3]
	end
end

function ModelWrapper:SetTransparency(DesiredTransparency)
	for BasePart in next, self.Cache do
		BasePart.Transparency = DesiredTransparency
	end
end

function ModelWrapper:ResetTransparency()
	for BasePart, Data in next, self.Cache do
		BasePart.Transparency = Data[4]
	end
end

function ModelWrapper:SetMaterial(DesiredMaterial)
	for BasePart in next, self.Cache do
		BasePart.Material = DesiredMaterial
	end
end

function ModelWrapper:ResetMaterial()
	for BasePart, Data in next, self.Cache do
		BasePart.Material = Data[5]
	end
end

function ModelWrapper:Reset()
	self:ResetScale()
	self:ResetColor()
	self:ResetTransparency()
	self:ResetMaterial()
end

return ModelWrapper
