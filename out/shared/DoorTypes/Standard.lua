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
	local name = part:GetFullName()
	if storedCFrames[name] ~= nil then
		return nil
	end
	storedCFrames[name] = part.CFrame
	part.Destroying:Once(function()
		storedCFrames[name] = nil
	end)
end
-- Exports
local functions = {
	OpenDoor = function(model)
		print(model)
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
		local _exp = storedCFrames[door1:GetFullName()]
		local _cFrame = CFrame.new(4, 0, 0)
		_object[_left] = _exp * _cFrame
		local goal1 = _object
		local _object_1 = {}
		local _left_1 = "CFrame"
		local _exp_1 = storedCFrames[door2:GetFullName()]
		local _cFrame_1 = CFrame.new(4, 0, 0)
		_object_1[_left_1] = _exp_1 * _cFrame_1
		local goal2 = _object_1
		local tween1 = TweenService:Create(door1, tweenInfo, goal1)
		local tween2 = TweenService:Create(door2, tweenInfo, goal2)
		tween1:Play()
		tween2:Play()
		return tween1
	end,
	CloseDoor = function(model)
		print(model)
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
			CFrame = storedCFrames[door1:GetFullName()],
		}
		local goal2 = {
			CFrame = storedCFrames[door2:GetFullName()],
		}
		local tween1 = TweenService:Create(door1, tweenInfo, goal1)
		local tween2 = TweenService:Create(door2, tweenInfo, goal2)
		tween1:Play()
		tween2:Play()
		return tween1
	end,
}
return functions
