-- Compiled with roblox-ts v2.2.0
-- eslint-disable prettier/prettier 
local function GetAttribute(object, attribute, defaultAttribute, mustExist)
	local foundAttribute = object:GetAttribute(attribute)
	local _defaultAttribute = defaultAttribute
	local expectedType = typeof(_defaultAttribute)
	local actualType = typeof(foundAttribute)
	if foundAttribute == nil then
		local _arg0 = not mustExist
		local _arg1 = object:GetFullName() .. (" missing attribute " .. (attribute .. (" (must be a " .. (expectedType .. ")!"))))
		assert(_arg0, _arg1)
		object:SetAttribute(attribute, defaultAttribute)
		return defaultAttribute
	end
	local _arg0 = actualType == expectedType
	local _arg1 = object:GetFullName() .. (" " .. (attribute .. (" attribute has type " .. (actualType .. (", expected " .. expectedType)))))
	assert(_arg0, _arg1)
	return foundAttribute
end
return {
	GetAttribute = GetAttribute,
}
