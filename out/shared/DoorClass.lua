-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier 
local ReplicatedStorage = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local GetAttribute = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystem", "GetAttribute").GetAttribute
local Constants = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystem", "DoorConfiguration").default
-- Interfaces
-- Variables
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
		self._hid = GetAttribute(self._model, "HID", Constants.DEFAULT_HID)
		self._doorType = GetAttribute(self._model, "DoorType", Constants.DEFAULT_DOOR_TYPE)
		self._locked = false
		self._closed = true
	end
	DoorClass.getModule = TS.async(function(self)
		local _exitType, _returns = TS.try(function()
			local _result = ReplicatedStorage:FindFirstChild("DoorSystem")
			if _result ~= nil then
				_result = _result:FindFirstChild("DoorTypes")
				if _result ~= nil then
					_result = _result:FindFirstChild(self._doorType)
				end
			end
			local module = _result
			return TS.TRY_RETURN, { require(module) }
		end, function(error)
			print("No type " .. (self._doorType .. (" was found in door " .. self._model:GetFullName())))
			return TS.TRY_RETURN, { nil }
		end)
		if _exitType then
			return unpack(_returns)
		end
	end)
	function DoorClass:saveTween(tween)
		DoorTweens[self._model:GetFullName()] = tween
	end
	function DoorClass:getModel()
		return self._model
	end
	function DoorClass:getHID()
		return self._hid
	end
	function DoorClass:isLocked()
		return self._locked
	end
	function DoorClass:isClosed()
		return self._closed
	end
	function DoorClass:isRunning()
		local tween = DoorTweens[self._model:GetFullName()]
		if tween == nil then
			return false
		end
		return tween.PlaybackState == Enum.PlaybackState.Playing
	end
	function DoorClass:changeAccess(newLevel)
		self.accessLevel = newLevel
	end
	function DoorClass:changeBehaviour(autoClose)
		self.autoClose = autoClose
	end
	DoorClass.open = TS.async(function(self)
		local module = TS.await(self:getModule())
		local _tween = module
		if _tween ~= nil then
			_tween = _tween:OpenDoor(self._model)
		end
		local tween = _tween
		local _arg1 = "Couldn't get the Opening tween animation of door " .. self._model:GetFullName()
		assert(tween, _arg1)
		self:saveTween(tween)
		self._closed = false
	end)
	DoorClass.close = TS.async(function(self)
		local module = TS.await(self:getModule())
		local _tween = module
		if _tween ~= nil then
			_tween = _tween:CloseDoor(self._model)
		end
		local tween = _tween
		local _arg1 = "Couldn't get the Closing tween animation of door " .. self._model:GetFullName()
		assert(tween, _arg1)
		self:saveTween(tween)
		self._closed = true
	end)
	function DoorClass:lock()
		self._locked = true
		if not self._closed then
			self:close()
		end
	end
	function DoorClass:unlock()
		self._locked = false
	end
end
return DoorClass
