-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier 
local _knit = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "knit", "Knit")
local Knit = _knit.KnitServer
local Signal = _knit.Signal
local RemoteProperty = _knit.RemoteProperty
local RemoteSignal = _knit.RemoteSignal
local Players = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local PointsService = Knit.CreateService({
	Name = "PointsService",
	PointsPerPlayer = {},
	PointsChanged = Signal.new(),
	Client = {
		PointsChanged = RemoteSignal.new(),
		GiveMePoints = RemoteSignal.new(),
		MostPoints = RemoteProperty.new(0),
		GetPoints = function(self, player)
			return self.Server:GetPoints(player)
		end,
	},
	AddPoints = function(self, player, amount)
		local points = self:GetPoints(player)
		points += amount
		local _pointsPerPlayer = self.PointsPerPlayer
		local _player = player
		local _points = points
		_pointsPerPlayer[_player] = _points
		if amount ~= 0 then
			self.PointsChanged:Fire(player, points)
			self.Client.PointsChanged:Fire(player, points)
		end
		if points > self.Client.MostPoints:Get() then
			self.Client.MostPoints:Set(points)
		end
	end,
	GetPoints = function(self, player)
		local _pointsPerPlayer = self.PointsPerPlayer
		local _player = player
		local points = _pointsPerPlayer[_player]
		local _condition = points
		if _condition == nil then
			_condition = 0
		end
		return _condition
	end,
	KnitInit = function(self)
		local rng = Random.new()
		self.Client.GiveMePoints:Connect(function(player)
			local points = rng:NextInteger(0, 10)
			self:AddPoints(player, points)
			print("Gave " .. (player.Name .. (" " .. (tostring(points) .. " points"))))
		end)
		Players.PlayerRemoving:Connect(function(player)
			local _pointsPerPlayer = self.PointsPerPlayer
			local _player = player
			-- ▼ Map.delete ▼
			local _valueExisted = _pointsPerPlayer[_player] ~= nil
			_pointsPerPlayer[_player] = nil
			-- ▲ Map.delete ▲
			return _valueExisted
		end)
	end,
})
return PointsService
