/* eslint-disable prettier/prettier */
import { CollectionService, ReplicatedStorage } from "@rbxts/services";
import { GetAttribute } from 'shared/GetAttribute';
import Constants from "shared/DoorConfiguration";
import DoorClass from "./DoorClass";

// Variables
const HID_Devices = ReplicatedStorage.FindFirstChild("HID_Devices");
assert(HID_Devices, "Couldn't find HID_Devices in ReplicatedStorage");

// Retrieves an array of HID attachments found in an instance
function getHIDAttachments(instance: Instance): Attachment[] {
    const hids: Attachment[] = [];

    instance.GetDescendants().forEach(att => {
        if (!att.IsA("Attachment") || att.Name !== "HIDAtt") return;

        hids.insert(hids.size(), att);
    });

    return hids;
}


// Creates scanners at HID attachments, returns an event that fires when that HID is activated
export function createScanners(door: DoorClass): RBXScriptSignal {
    const event = new Instance("BindableEvent");

    getHIDAttachments(door.getModel()).forEach(hid => {
        const scannerClone = HID_Devices?.FindFirstChild("Scanner")?.Clone() as BasePart;
        scannerClone.PivotTo(hid.WorldCFrame);
        scannerClone.Parent = door.getModel();

        let debounce = true;
        scannerClone.Touched.Connect(card => {
            if (!debounce) return;
            if (!CollectionService.HasTag(card, Constants.CARD_TAG)) return;

            debounce = false;

            const permission = GetAttribute(card, "Permission", Constants.DEFAULT_ACCESS_LEVEL);
            const isLocked: Boolean = permission < door.lockBypassLevel && door.isLocked();
            const doorPermission = door.accessLevel;

            if (permission < doorPermission || door.isRunning() || isLocked) {
                const sound = scannerClone.FindFirstChild("KeycardDenied") as Sound;
                sound?.Play();
            } else {
                const sound = scannerClone.FindFirstChild("KeycardAccepted") as Sound;
                sound?.Play();
                event.Fire();
            }

            task.wait(1);
            debounce = true;
        })
    })

    return event.Event;
}


// Creates buttons at HID attachments, returns an event that fires when that HID is activated
export function createButtons(model: Instance): RBXScriptSignal {
    const event = new Instance("BindableEvent");

    getHIDAttachments(model).forEach(hid => {
        const buttonClone = HID_Devices?.FindFirstChild("Button")?.Clone() as BasePart;
        buttonClone.PivotTo(hid.WorldCFrame);
        buttonClone.Parent = model;

        let debounce = true;
        const clickDetector = buttonClone.FindFirstChild("ClickDetector") as ClickDetector;
        clickDetector?.MouseClick.Connect(player => {
            if (!debounce) return;

            debounce = false;

            const sound = buttonClone.FindFirstChild("Push") as Sound;
            sound?.Play();

            event.Fire(player);

            task.wait(1);
            debounce = true;
        })
    })

    return event.Event;
}