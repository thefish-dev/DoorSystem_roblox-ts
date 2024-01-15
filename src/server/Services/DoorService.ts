/* eslint-disable prettier/prettier */
import { CollectionService } from "@rbxts/services";
import DoorClass from "shared/DoorClass";
import Constants from "shared/DoorConfiguration";
import { GetAttribute } from "shared/GetAttribute";
import { createButtons, createScanners } from "shared/HIDOperation";


// Variables
let lockdown = false;
const doors: DoorClass[] = [];

// Function
function getPlayerAccess(player: Player): number {
    let permission = Constants.DEFAULT_ACCESS_LEVEL;
    const backpack = player.FindFirstChild("Backpack") as Instance;

    for (const card of backpack.GetChildren()) {
        const handle = card.FindFirstChild("Handle");
        if (handle === undefined) continue;
        if (!CollectionService.HasTag(handle, Constants.CARD_TAG)) continue;

        const access = GetAttribute(handle, "Permission", Constants.DEFAULT_ACCESS_LEVEL);
        if (access > permission) permission = access;
    }

    return permission;
}


// Lockdown button
CollectionService.GetTagged(Constants.LOCKDOWN_BUTTON_TAG).forEach(button => {
    createButtons(button).Connect((player: Player) => {
        const permission = getPlayerAccess(player);
        if (permission < Constants.LOCKDOWN_BUTTON_ACCESS_LEVEL) return;

        lockdown = !lockdown;
        print(`Lockdown: ${lockdown}`);
        if (lockdown) {
            doors.forEach(door => door.lock());
        } else {
            doors.forEach(door => door.unlock());
        }
    })
});

// Doors
CollectionService.GetTagged(Constants.DOOR_TAG).forEach(door => {
    const doorClass = new DoorClass(door as Model);
    doors.insert(doors.size(), doorClass);

    if (doorClass.getHID() === "Scanner") {
        createScanners(doorClass).Connect(() => {
            if (doorClass.isRunning()) return;

            if (doorClass.isClosed()) doorClass.open();
            else doorClass.close();
        });
    } else {
        createButtons(doorClass.getModel()).Connect((player: Player) => {
            if (doorClass.isRunning()) return;

            const permission = getPlayerAccess(player);
            const isLocked: Boolean = permission < doorClass.lockBypassLevel && doorClass.isLocked();
            if (permission < doorClass.accessLevel || isLocked) return;

            if (doorClass.isClosed()) doorClass.open();
            else doorClass.close();
        });
    }
});

print("DoorService successfully loaded.");