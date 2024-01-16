/* eslint-disable prettier/prettier */
import { CollectionService } from "@rbxts/services";
import { GetAttribute } from "shared/GetAttribute";
import { createButtons, createScanners } from "shared/HIDOperation";
import { DoorClass } from "shared/DoorClass";
import { Constants } from "shared/DoorConfiguration";


// Variables
let lockdown = false;
const doors: DoorClass[] = [];


// Functions
// Returns the user's access level
function getPlayerAccess(player: Player): number {
    let permission = Constants.DEFAULT_ACCESS_LEVEL;

    const backpack = player.FindFirstChild("Backpack") as Instance;

    for (const card of backpack.GetChildren()) { // loop to get the highest level present in user's backpack
        const handle = card.FindFirstChild("Handle");
        if (handle === undefined) continue;
        if (!CollectionService.HasTag(handle, Constants.CARD_TAG)) continue;

        const access = GetAttribute(handle, "Permission", Constants.DEFAULT_ACCESS_LEVEL); // get keycard access
        if (access > permission) permission = access;
    }

    return permission;
}


// Main
// Lockdown button
CollectionService.GetTagged(Constants.LOCKDOWN_BUTTON_TAG).forEach(button => {
    createButtons(button).Connect((player: Player) => { // when button is pressed
        const permission = getPlayerAccess(player);
        if (permission < Constants.LOCKDOWN_BUTTON_ACCESS_LEVEL) return;

        lockdown = !lockdown; // toggle lockdown
        print(`Lockdown: ${lockdown}`);
        if (lockdown) {
            doors.forEach(door => door.lock()); // lock doors and close opened ones
        } else {
            doors.forEach(door => door.unlock()); // unlock doors
        }
    })
});

// Doors handler
CollectionService.GetTagged(Constants.DOOR_TAG).forEach(door => {
    const doorClass = new DoorClass(door as Model);
    doors.insert(doors.size(), doorClass);

    if (doorClass.getHID() === "Scanner") {
        createScanners(doorClass).Connect(() => { // scanner touched and access granted
            if (doorClass.isRunning()) return;

            if (doorClass.isClosed()) doorClass.open();
            else doorClass.close();
        });
    } else {
        createButtons(doorClass.getModel()).Connect((player: Player) => { // buttons pushed, access not checked yet
            if (doorClass.isRunning()) return;

            const permission = getPlayerAccess(player);
            const isLocked: Boolean = permission < doorClass.lockBypassLevel && doorClass.isLocked(); // if door is locked, can the user bypass ?
            if (permission < doorClass.accessLevel || isLocked) return;

            if (doorClass.isClosed()) doorClass.open();
            else doorClass.close();
        });
    }
});

print("DoorService successfully loaded.");