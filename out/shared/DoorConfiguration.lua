-- Compiled with roblox-ts v2.2.0
-- eslint-disable prettier/prettier 
-- Door system configuration, fully customizable values without the need of editing any script
local Constants = {
	DEFAULT_AUTOCLOSE = true,
	DEFAULT_CLOSURE_DELAY = 3,
	DEFAULT_ACCESS_LEVEL = -1,
	DEFAULT_LOCKDOWN_BYPASS_LEVEL = 6,
	LOCKDOWN_BUTTON_ACCESS_LEVEL = 6,
	DEFAULT_HID = "Button",
	DEFAULT_DOOR_TYPE = "Standard",
	CARD_TAG = "DoorSystem_Card",
	DOOR_TAG = "DoorSystem_Door",
	LOCKDOWN_BUTTON_TAG = "DoorSystem_LockdownButton",
}
return {
	Constants = Constants,
}
