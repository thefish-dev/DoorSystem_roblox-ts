-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier 
local Knit = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "knit", "Knit").KnitServer
local _services = script.Parent
if _services ~= nil then
	_services = _services:FindFirstChild("Services")
	if _services ~= nil then
		_services = _services:GetChildren()
	end
end
local services = _services
if services then
	for _, service in services do
		if service:IsA("ModuleScript") then
			require(service)
		end
	end
end
Knit.Start():andThen():catch(warn)
