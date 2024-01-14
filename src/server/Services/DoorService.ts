/* eslint-disable prettier/prettier */
import { CollectionService } from "@rbxts/services";
import DoorClass from "shared/DoorClass";
import Constants from "shared/DoorConfiguration";
import { createButtons, createScanners } from "shared/HIDOperation";


// Variables
let lockdown = false;
const doors: DoorClass[] = [];

// Lockdown button
CollectionService.GetTagged(Constants.LOCKDOWN_BUTTON_TAG).forEach(button => {
    createButtons(button, Constants.LOCKDOWN_BUTTON_ACCESS_LEVEL).Connect(() => {
        lockdown = !lockdown;
        
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
        createButtons(doorClass.getModel(), doorClass.accessLevel).Connect(() => {
            if (doorClass.isRunning()) return;
    
            if (doorClass.isClosed()) doorClass.open();
            else doorClass.close();
        });
    }
});

print("DoorService successfully loaded.");