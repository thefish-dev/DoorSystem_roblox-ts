/* eslint-disable prettier/prettier */
import { TweenService } from "@rbxts/services";

// Constants
const ANIMATION_TIME = 1.5;
const EASING_STYLE = Enum.EasingStyle.Linear;
const EASING_DIRECTION = Enum.EasingDirection.InOut;

// Variables
const tweenInfo = new TweenInfo(ANIMATION_TIME, EASING_STYLE, EASING_DIRECTION);
const storedCFrames: Map<Instance, CFrame> = new Map();


// Functions
function saveCFrame(part: BasePart) {
    if (storedCFrames.get(part) !== undefined) return;

    storedCFrames.set(part, part.CFrame);
    part.Destroying.Once(() => {
        storedCFrames.delete(part);
    })
}

function getSavedCFrame(part: BasePart): CFrame {
    return storedCFrames.get(part) as CFrame;
}

// Exports
export function OpenDoor(_: unknown, model: Model): Tween {
    const door1 = model.FindFirstChild("Door1") as BasePart;
    const door2 = model.FindFirstChild("Door2") as BasePart;

    // Makes sure door parts exist
    assert(door1 !== undefined, `Door1 was not found in ${model.GetFullName()}`);
    assert(door2 !== undefined, `Door2 was not found in ${model.GetFullName()}`);

    // Plays Open sound
    const sound = door1.FindFirstChild("Open") as Sound;
    sound.Play();

    // Saves original CFrame for later use
    saveCFrame(door1);
    saveCFrame(door2);

    // Tweens creation and play
    const goal1 = { CFrame: getSavedCFrame(door1).mul(new CFrame(4, 0, 0)) };
    const goal2 = { CFrame: getSavedCFrame(door2).mul(new CFrame(4, 0, 0)) };
    const tween1 = TweenService.Create(door1, tweenInfo, goal1);
    const tween2 = TweenService.Create(door2, tweenInfo, goal2);
    tween1.Play();
    tween2.Play();

    return tween1;
}
export function CloseDoor(_: unknown, model: Model): Tween {
    const door1 = model.FindFirstChild("Door1") as BasePart;
    const door2 = model.FindFirstChild("Door2") as BasePart;

    // Makes sure door parts exist
    assert(door1 !== undefined, `Door1 was not found in ${model.GetFullName()}`);
    assert(door2 !== undefined, `Door2 was not found in ${model.GetFullName()}`);

    // Plays Close sound
    const sound = door1.FindFirstChild("Close") as Sound;
    sound.Play();

    // Saves original CFrame for later use
    saveCFrame(door1);
    saveCFrame(door2);

    // Tweens creation and play
    const goal1 = { CFrame: getSavedCFrame(door1) };
    const goal2 = { CFrame: getSavedCFrame(door2) };
    const tween1 = TweenService.Create(door1, tweenInfo, goal1);
    const tween2 = TweenService.Create(door2, tweenInfo, goal2);
    tween1.Play();
    tween2.Play();

    return tween1;
}