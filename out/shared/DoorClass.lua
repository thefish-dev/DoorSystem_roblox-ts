-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier 
local GetAttribute = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystemModules", "GetAttribute").GetAttribute
local Constants = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystemModules", "DoorConfiguration").default
local DoorTweens = {}
local DoorClass
do
	DoorClass = setmetatable({}, {
		__tostring = function()
			return "DoorClass"
		end,
	})
	DoorClass.__index = DoorClass
	function DoorClass.new(...)
		local self = setmetatable({}, DoorClass)
		return self:constructor(...) or self
	end
	function DoorClass:constructor(model)
		self._model = model
		self.autoClose = GetAttribute(self._model, "AutoClose", Constants.DEFAULT_AUTOCLOSE)
		self.accessLevel = GetAttribute(self._model, "AccessLevel", Constants.DEFAULT_ACCESS_LEVEL)
		self.lockBypassLevel = GetAttribute(self._model, "LockBypassLevel", Constants.DEFAULT_ACCESS_LEVEL)
		self.hid = GetAttribute(self._model, "HID", Constants.DEFAULT_HID)
		self._locked = false
		self._moving = false
		self._debounce = true
		self._closed = true
	end
	function DoorClass:open()
		if self._moving then
			return nil
		end
	end
	function DoorClass:ready()
		return self._debounce
	end
end
return nil
