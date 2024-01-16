/* eslint-disable prettier/prettier */

// Door system configuration, fully customizable values without the need of editing any script
export const Constants = {
    // Default attributes
    DEFAULT_AUTOCLOSE: true, // wether the door closes by itself or not
    DEFAULT_CLOSURE_DELAY: 3, // if AutoClose enabled, the delay before doors close
    DEFAULT_ACCESS_LEVEL: -1, // there is a level 0, so no keycard = -1 by default
    DEFAULT_LOCKDOWN_BYPASS_LEVEL: 6, // levels wich can bypass locked doors (it can differ on doors if custom attribute added)
    LOCKDOWN_BUTTON_ACCESS_LEVEL: 6, // level to toggle full lockdown
    DEFAULT_HID: "Button",
    DEFAULT_DOOR_TYPE: "Standard", // default door animation, custom ones can be made with module scripts in the ReplicatedStorage DoorTypes folder.

    // Component tags
    CARD_TAG: "DoorSystem_Card",
    DOOR_TAG: "DoorSystem_Door",
    LOCKDOWN_BUTTON_TAG: "DoorSystem_LockdownButton"
};