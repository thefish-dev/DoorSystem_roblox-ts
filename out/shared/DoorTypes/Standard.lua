-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier 
local TweenService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService
-- Constants
local ANIMATION_TIME = 1.5
local EASING_STYLE = Enum.EasingStyle.Linear
local EASING_DIRECTION = Enum.EasingDirection.InOut
-- Variables
local tweenInfo = TweenInfo.new(ANIMATION_TIME, EASING_STYLE, EASING_DIRECTION)
local storedCFrames = {}
-- Functions
local function saveCFrame(part)
	local _part = part
	if storedCFrames[_part] ~= nil then
		return nil
	end
	local _part_1 = part
	local _cFrame = part.CFrame
	storedCFrames[_part_1] = _cFrame
	part.Destroying:Once(function()
		local _part_2 = part
		storedCFrames[_part_2] = nil
	end)
end
local function getSavedCFrame(part)
	local _part = part
	return storedCFrames[_part]
end
-- Exports
local function OpenDoor(_, model)
	local door1 = model:FindFirstChild("Door1")
	local door2 = model:FindFirstChild("Door2")
	-- Makes sure door parts exist
	local _arg0 = door1 ~= nil
	local _arg1 = "Door1 was not found in " .. model:GetFullName()
	assert(_arg0, _arg1)
	local _arg0_1 = door2 ~= nil
	local _arg1_1 = "Door2 was not found in " .. model:GetFullName()
	assert(_arg0_1, _arg1_1)
	-- Plays Open sound
	local sound = door1:FindFirstChild("Open")
	sound:Play()
	-- Saves original CFrame for later use
	saveCFrame(door1)
	saveCFrame(door2)
	-- Tweens creation and play
	local _object = {}
	local _left = "CFrame"
	local _exp = getSavedCFrame(door1)
	local _cFrame = CFrame.new(4, 0, 0)
	_object[_left] = _exp * _cFrame
	local goal1 = _object
	local _object_1 = {}
	local _left_1 = "CFrame"
	local _exp_1 = getSavedCFrame(door2)
	local _cFrame_1 = CFrame.new(4, 0, 0)
	_object_1[_left_1] = _exp_1 * _cFrame_1
	local goal2 = _object_1
	local tween1 = TweenService:Create(door1, tweenInfo, goal1)
	local tween2 = TweenService:Create(door2, tweenInfo, goal2)
	tween1:Play()
	tween2:Play()
	-- Returns tween1 to keep track of the door animation
	return tween1
end
local function CloseDoor(_, model)
	local door1 = model:FindFirstChild("Door1")
	local door2 = model:FindFirstChild("Door2")
	-- Makes sure door parts exist
	local _arg0 = door1 ~= nil
	local _arg1 = "Door1 was not found in " .. model:GetFullName()
	assert(_arg0, _arg1)
	local _arg0_1 = door2 ~= nil
	local _arg1_1 = "Door2 was not found in " .. model:GetFullName()
	assert(_arg0_1, _arg1_1)
	-- Plays Close sound
	local sound = door1:FindFirstChild("Close")
	sound:Play()
	-- Saves original CFrame for later use
	saveCFrame(door1)
	saveCFrame(door2)
	-- Tweens creation and play
	local goal1 = {
		CFrame = getSavedCFrame(door1),
	}
	local goal2 = {
		CFrame = getSavedCFrame(door2),
	}
	local tween1 = TweenService:Create(door1, tweenInfo, goal1)
	local tween2 = TweenService:Create(door2, tweenInfo, goal2)
	tween1:Play()
	tween2:Play()
	return tween1
end
return {
	OpenDoor = OpenDoor,
	CloseDoor = CloseDoor,
}
