-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier 
local ReplicatedStorage = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local GetAttribute = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystem", "GetAttribute").GetAttribute
local Constants = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystem", "DoorConfiguration").Constants
-- Variables
local DoorTweens = {}
-- Main class
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
		self.lockBypassLevel = GetAttribute(self._model, "LockBypassLevel", Constants.DEFAULT_LOCKDOWN_BYPASS_LEVEL)
		self.closureDelay = GetAttribute(self._model, "ClosureDelay", Constants.DEFAULT_CLOSURE_DELAY)
		self._hid = GetAttribute(self._model, "HID", Constants.DEFAULT_HID)
		self._doorType = GetAttribute(self._model, "DoorType", Constants.DEFAULT_DOOR_TYPE)
		self._locked = false
		self._closed = true
		self._debounce = true
	end
	function DoorClass:getModule()
		local _result = ReplicatedStorage:FindFirstChild("DoorSystem")
		if _result ~= nil then
			_result = _result:FindFirstChild("DoorTypes")
			if _result ~= nil then
				_result = _result:FindFirstChild(self._doorType)
			end
		end
		local module = _result
		local _arg1 = "No type " .. (self._doorType .. (" from door " .. (self._model:GetFullName() .. " was found in DoorTypes.")))
		assert(module, _arg1)
		return module
	end
	function DoorClass:saveTween(tween)
		local __model = self._model
		local _tween = tween
		DoorTweens[__model] = _tween
	end
	function DoorClass:clearTween()
		local __model = self._model
		DoorTweens[__model] = nil
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
		local __model = self._model
		local tween = DoorTweens[__model]
		return not self._debounce or tween ~= nil
	end
	function DoorClass:changeAccess(newLevel)
		self.accessLevel = newLevel
	end
	function DoorClass:changeBehaviour(autoClose)
		self.autoClose = autoClose
	end
	function DoorClass:open()
		if not self._closed then
			self._debounce = true
			self:clearTween()
			return nil
		end
		-- Imports the DoorType module and starts opening tweens.
		local doorModule = require(self:getModule())
		local tween = doorModule:OpenDoor(self._model)
		local _arg1 = "Couldn't get the Opening tween animation of door " .. self._model:GetFullName()
		assert(tween, _arg1)
		self:saveTween(tween)
		self._debounce = false
		self._closed = false
		tween.Completed:Once(function()
			if self.autoClose then
				task.wait(self.closureDelay)
				self:close()
			else
				self._debounce = true
				self:clearTween()
			end
		end)
	end
	function DoorClass:close()
		if self._closed then
			self._debounce = true
			self:clearTween()
			return nil
		end
		-- Imports the DoorType module and starts closing tweens.
		local doorModule = require(self:getModule())
		local tween = doorModule:CloseDoor(self._model)
		local _arg1 = "Couldn't get the Closing tween animation of door " .. self._model:GetFullName()
		assert(tween, _arg1)
		self:saveTween(tween)
		self._debounce = false
		self._closed = true
		tween.Completed:Once(function()
			self._debounce = true
			self:clearTween()
		end)
	end
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
return {
	DoorClass = DoorClass,
}
