/* eslint-disable prettier/prettier */
import { CollectionService, ReplicatedStorage } from "@rbxts/services";
import { GetAttribute } from 'shared/GetAttribute';
import { Constants } from "shared/DoorConfiguration";
import { DoorClass } from "shared/DoorClass";


// Variables
const HID_Devices = ReplicatedStorage.FindFirstChild("HID_Devices");
assert(HID_Devices, "Couldn't find HID_Devices in ReplicatedStorage");


// Functions
// Retrieves an array of HID attachments found in an instance
function getHIDAttachments(instance: Instance): Attachment[] {
    const hids: Attachment[] = [];

    instance.GetDescendants().forEach(att => {
        if (!att.IsA("Attachment") || att.Name !== "HIDAtt") return;

        hids.insert(hids.size(), att);
    });

    return hids;
}

// Creates scanners at HID attachments position, returns an event that fires when HID is activated
export function createScanners(door: DoorClass): RBXScriptSignal {
    const event = new Instance("BindableEvent");

    getHIDAttachments(door.getModel()).forEach(hid => {
        // Scanner clone creation and placement
        const scannerClone = HID_Devices?.FindFirstChild("Scanner")?.Clone() as BasePart;
        scannerClone.PivotTo(hid.WorldCFrame);
        scannerClone.Parent = door.getModel();

        let debounce = true;
        scannerClone.Touched.Connect(card => { // when scanner gets interacted with
            if (!debounce) return;
            if (!CollectionService.HasTag(card, Constants.CARD_TAG)) return;

            debounce = false;

            // Permission checking
            const permission = GetAttribute(card, "Permission", Constants.DEFAULT_ACCESS_LEVEL);
            const isLocked: Boolean = permission < door.lockBypassLevel && door.isLocked(); // when door is locked, checks if user can bypass
            const doorPermission = door.accessLevel;

            // I chose to put door.isRunning() in here to make access denied sound, but it can be put above to prevent the following from running
            if (permission < doorPermission || door.isRunning() || isLocked) {
                const sound = scannerClone.FindFirstChild("KeycardDenied") as Sound;
                sound?.Play();
            } else {
                const sound = scannerClone.FindFirstChild("KeycardAccepted") as Sound;
                sound?.Play();
                event.Fire(); // toggles the door
            }

            task.wait(1);
            debounce = true;
        })
    })

    return event.Event;
}


// Creates buttons at HID attachments position, returns an event that fires when HID is activated
export function createButtons(model: Instance): RBXScriptSignal {
    const event = new Instance("BindableEvent");

    getHIDAttachments(model).forEach(hid => {
        // Scanner clone creation and placement
        const buttonClone = HID_Devices?.FindFirstChild("Button")?.Clone() as BasePart;
        buttonClone.PivotTo(hid.WorldCFrame);
        buttonClone.Parent = model;

        let debounce = true;
        const clickDetector = buttonClone.FindFirstChild("ClickDetector") as ClickDetector;
        clickDetector?.MouseClick.Connect(player => { // when button gets pushed
            if (!debounce) return;

            debounce = false;

            const sound = buttonClone.FindFirstChild("Push") as Sound;
            sound?.Play();

            event.Fire(player); // checks clearance and toggles door

            task.wait(1);
            debounce = true;
        })
    })

    return event.Event;
}