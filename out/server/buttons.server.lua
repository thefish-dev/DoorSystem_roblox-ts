-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier 
local Workspace = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local colors = {
	StateButton = { Color3.fromRGB(180, 0, 0), Color3.fromRGB(0, 180, 0) },
	TripleStateButton = { Color3.fromRGB(180, 0, 0), Color3.fromRGB(200, 200, 0), Color3.fromRGB(0, 180, 0) },
}
local function updateColor(button, number)
	button.Color = colors[button.Name][number + 1]
end
local buttonActions = {
	StateButton = function(button)
		local enabled = Instance.new("BoolValue")
		enabled.Name = "Enabled"
		enabled.Parent = button
		local number = function()
			if enabled.Value then
				return 1
			else
				return 0
			end
		end
		updateColor(button, number())
		local click = Instance.new("ClickDetector")
		click.Parent = button
		click.MouseClick:Connect(function()
			enabled.Value = not enabled.Value
			updateColor(button, number())
		end)
	end,
	TripleStateButton = function(button)
		local range = Instance.new("NumberValue")
		range.Name = "Range"
		range.Parent = button
		local number = function()
			if range.Value > 1 then
				range.Value = 0
			else
				range.Value += 1
			end
		end
		updateColor(button, range.Value)
		local click = Instance.new("ClickDetector")
		click.Parent = button
		click.MouseClick:Connect(function()
			number()
			updateColor(button, range.Value)
		end)
	end,
}
local _Buttons = Workspace:FindFirstChild("Buttons")
if _Buttons ~= nil then
	_Buttons = _Buttons:GetChildren()
end
local Buttons = _Buttons
if Buttons then
	for _, button in Buttons do
		if not button:IsA("BasePart") then
			continue
		end
		buttonActions[button.Name](button)
	end
end
