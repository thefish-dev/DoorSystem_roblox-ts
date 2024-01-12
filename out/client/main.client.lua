-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier 
local Knit = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "knit", "Knit").KnitClient
Knit.Start():andThen():catch(warn):await()
local PointsService = Knit.GetService("PointsService")
local function PointsChanged(points)
	print("My points:", points)
end
-- Get points and listen for changes:
local initialPoints = PointsService:GetPoints()
PointsChanged(initialPoints)
PointsService.PointsChanged:Connect(PointsChanged)
-- Ask server to give points randomly:
PointsService.GiveMePoints:Fire()
local givingPoints = task.spawn(function()
	local enabled = true
	while enabled do
		PointsService.GiveMePoints:Fire()
		task.wait(5)
	end
end)
task.delay(30, function()
	task.cancel(givingPoints)
end)
-- Grab MostPoints value:
local mostPoints = PointsService.MostPoints:Get()
-- Keep MostPoints value updated:
PointsService.MostPoints.Changed:Connect(function(newMostPoints)
	mostPoints = newMostPoints
end)
-- Advanced example, using promises to get points:
local _exp = PointsService:GetPointsPromise()
local _arg0 = function(points)
	print("Got points:", points)
end
_exp:andThen(_arg0)
