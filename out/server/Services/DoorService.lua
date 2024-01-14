-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier 
local CollectionService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService
local DoorClass = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystem", "DoorClass")
local Constants = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystem", "DoorConfiguration").default
local _HIDOperation = TS.import(script, game:GetService("ReplicatedStorage"), "DoorSystem", "HIDOperation")
local createButtons = _HIDOperation.createButtons
local createScanners = _HIDOperation.createScanners
-- Variables
local lockdown = false
local doors = {}
-- Lockdown button
local _exp = CollectionService:GetTagged(Constants.LOCKDOWN_BUTTON_TAG)
local _arg0 = function(button)
	createButtons(button, Constants.LOCKDOWN_BUTTON_ACCESS_LEVEL):Connect(function()
		lockdown = not lockdown
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
-- Doors
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
		createButtons(doorClass:getModel(), doorClass.accessLevel):Connect(function()
			if doorClass:isRunning() then
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
