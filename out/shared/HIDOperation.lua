-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier 
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService = _services.CollectionService
local ReplicatedStorage = _services.ReplicatedStorage
local GetAttribute = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystem", "GetAttribute").GetAttribute
local Constants = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystem", "DoorConfiguration").Constants
-- Variables
local HID_Devices = ReplicatedStorage:FindFirstChild("HID_Devices")
assert(HID_Devices, "Couldn't find HID_Devices in ReplicatedStorage")
-- Functions
-- Retrieves an array of HID attachments found in an instance
local function getHIDAttachments(instance)
	local hids = {}
	local _exp = instance:GetDescendants()
	local _arg0 = function(att)
		if not att:IsA("Attachment") or att.Name ~= "HIDAtt" then
			return nil
		end
		local _arg0_1 = #hids
		local _att = att
		table.insert(hids, _arg0_1 + 1, _att)
	end
	for _k, _v in _exp do
		_arg0(_v, _k - 1, _exp)
	end
	return hids
end
-- Creates scanners at HID attachments position, returns an event that fires when HID is activated
local function createScanners(door)
	local event = Instance.new("BindableEvent")
	local _exp = getHIDAttachments(door:getModel())
	local _arg0 = function(hid)
		-- Scanner clone creation and placement
		local _result = HID_Devices
		if _result ~= nil then
			_result = _result:FindFirstChild("Scanner")
			if _result ~= nil then
				_result = _result:Clone()
			end
		end
		local scannerClone = _result
		scannerClone:PivotTo(hid.WorldCFrame)
		scannerClone.Parent = door:getModel()
		local debounce = true
		scannerClone.Touched:Connect(function(card)
			if not debounce then
				return nil
			end
			if not CollectionService:HasTag(card, Constants.CARD_TAG) then
				return nil
			end
			debounce = false
			-- Permission checking
			local permission = GetAttribute(card, "Permission", Constants.DEFAULT_ACCESS_LEVEL)
			local isLocked = permission < door.lockBypassLevel and door:isLocked()
			local doorPermission = door.accessLevel
			-- I chose to put door.isRunning() in here to make access denied sound, but it can be put above to prevent the following from running
			if permission < doorPermission or (door:isRunning() or isLocked) then
				local sound = scannerClone:FindFirstChild("KeycardDenied")
				local _result_1 = sound
				if _result_1 ~= nil then
					_result_1:Play()
				end
			else
				local sound = scannerClone:FindFirstChild("KeycardAccepted")
				local _result_1 = sound
				if _result_1 ~= nil then
					_result_1:Play()
				end
				event:Fire()
			end
			task.wait(1)
			debounce = true
		end)
	end
	for _k, _v in _exp do
		_arg0(_v, _k - 1, _exp)
	end
	return event.Event
end
-- Creates buttons at HID attachments position, returns an event that fires when HID is activated
local function createButtons(model)
	local event = Instance.new("BindableEvent")
	local _exp = getHIDAttachments(model)
	local _arg0 = function(hid)
		-- Scanner clone creation and placement
		local _result = HID_Devices
		if _result ~= nil then
			_result = _result:FindFirstChild("Button")
			if _result ~= nil then
				_result = _result:Clone()
			end
		end
		local buttonClone = _result
		buttonClone:PivotTo(hid.WorldCFrame)
		buttonClone.Parent = model
		local debounce = true
		local clickDetector = buttonClone:FindFirstChild("ClickDetector")
		local _result_1 = clickDetector
		if _result_1 ~= nil then
			_result_1 = _result_1.MouseClick:Connect(function(player)
				if not debounce then
					return nil
				end
				debounce = false
				local sound = buttonClone:FindFirstChild("Push")
				local _result_2 = sound
				if _result_2 ~= nil then
					_result_2:Play()
				end
				event:Fire(player)
				task.wait(1)
				debounce = true
			end)
		end
	end
	for _k, _v in _exp do
		_arg0(_v, _k - 1, _exp)
	end
	return event.Event
end
return {
	createScanners = createScanners,
	createButtons = createButtons,
}
