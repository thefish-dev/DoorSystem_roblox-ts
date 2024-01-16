-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier 
local CollectionService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService
local GetAttribute = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystem", "GetAttribute").GetAttribute
local _HIDOperation = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystem", "HIDOperation")
local createButtons = _HIDOperation.createButtons
local createScanners = _HIDOperation.createScanners
local DoorClass = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystem", "DoorClass").DoorClass
local Constants = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystem", "DoorConfiguration").Constants
-- Variables
local lockdown = false
local doors = {}
-- Functions
-- Returns the user's access level
local function getPlayerAccess(player)
	local permission = Constants.DEFAULT_ACCESS_LEVEL
	local backpack = player:FindFirstChild("Backpack")
	for _, card in backpack:GetChildren() do
		local handle = card:FindFirstChild("Handle")
		if handle == nil then
			continue
		end
		if not CollectionService:HasTag(handle, Constants.CARD_TAG) then
			continue
		end
		local access = GetAttribute(handle, "Permission", Constants.DEFAULT_ACCESS_LEVEL)
		if access > permission then
			permission = access
		end
	end
	return permission
end
-- Main
-- Lockdown button
local _exp = CollectionService:GetTagged(Constants.LOCKDOWN_BUTTON_TAG)
local _arg0 = function(button)
	createButtons(button):Connect(function(player)
		local permission = getPlayerAccess(player)
		if permission < Constants.LOCKDOWN_BUTTON_ACCESS_LEVEL then
			return nil
		end
		lockdown = not lockdown
		print("Lockdown: " .. tostring(lockdown))
		if lockdown then
			local _arg0_1 = function(door)
				return door:lock()
			end
			for _k, _v in doors do
				_arg0_1(_v, _k - 1, doors)
			end
		else
			local _arg0_1 = function(door)
				return door:unlock()
			end
			for _k, _v in doors do
				_arg0_1(_v, _k - 1, doors)
			end
		end
	end)
end
for _k, _v in _exp do
	_arg0(_v, _k - 1, _exp)
end
-- Doors handler
local _exp_1 = CollectionService:GetTagged(Constants.DOOR_TAG)
local _arg0_1 = function(door)
	local doorClass = DoorClass.new(door)
	local _arg0_2 = #doors
	table.insert(doors, _arg0_2 + 1, doorClass)
	if doorClass:getHID() == "Scanner" then
		createScanners(doorClass):Connect(function()
			if doorClass:isRunning() then
				return nil
			end
			if doorClass:isClosed() then
				doorClass:open()
			else
				doorClass:close()
			end
		end)
	else
		createButtons(doorClass:getModel()):Connect(function(player)
			if doorClass:isRunning() then
				return nil
			end
			local permission = getPlayerAccess(player)
			local isLocked = permission < doorClass.lockBypassLevel and doorClass:isLocked()
			if permission < doorClass.accessLevel or isLocked then
				return nil
			end
			if doorClass:isClosed() then
				doorClass:open()
			else
				doorClass:close()
			end
		end)
	end
end
for _k, _v in _exp_1 do
	_arg0_1(_v, _k - 1, _exp_1)
end
print("DoorService successfully loaded.")
return nil
