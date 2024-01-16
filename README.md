# DoorSystem_roblox-ts

### Fully customizable
You can go ahead and edit the `DoorConfiguration` constants module at will !

### To enable watch mode
`npx rbxtsc -w`

### How to customize a door ?
You can simply add attributes to the door model. Here's the list of attributes you can add:
- `AccessLevel`: `number`
- `HID`: `string` (must be "Scanner" or "Button")
- `LockBypassLevel`: `number`
- `AutoClose`: `boolean`
- `ClosureDelay`: `number`
- `DoorType`: `string`  (custom door tpyes can be made, check out the DoorTypes folder in ReplicatedStorage and take example on the Standard doortype)