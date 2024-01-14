/* eslint-disable prettier/prettier */
import { TweenService } from "@rbxts/services";

// Constants
const ANIMATION_TIME = 1.5;
const EASING_STYLE = Enum.EasingStyle.Linear;
const EASING_DIRECTION = Enum.EasingDirection.InOut;

// Variables
const tweenInfo = new TweenInfo(ANIMATION_TIME, EASING_STYLE, EASING_DIRECTION);
interface CFrameTable {
    [partName: string] : CFrame;
}
const storedCFrames: CFrameTable = {}

// Functions
function SaveCFrame(part: BasePart) {
    const name: string = part.GetFullName();
    if (storedCFrames[name] !== undefined) return;

    storedCFrames[name] = part.CFrame;
    part.Destroying.Once(() => {
        delete storedCFrames[name];
    })
}

// Exports
function OpenDoor(model: Model): Tween {
    const door1 = model.FindFirstChild("Door1") as BasePart;
    const door2 = model.FindFirstChild("Door2") as BasePart;

    // Makes sure door parts exist
    assert(door1 !== undefined, `Door1 was not found in ${model.GetFullName()}`);
    assert(door2 !== undefined, `Door2 was not found in ${model.GetFullName()}`);

    // Plays Open sound
    const sound = door1.FindFirstChild("Open") as Sound;
    sound.Play();
    
    // Saves original CFrame for later use
    SaveCFrame(door1);
    SaveCFrame(door2);

    // Tweens creation and play
    const goal1 = {CFrame: storedCFrames[door1.GetFullName()].mul(new CFrame(4, 0, 0))};
    const goal2 = {CFrame: storedCFrames[door2.GetFullName()].mul(new CFrame(4, 0, 0))};
    const tween1 = TweenService.Create(door1, tweenInfo, goal1);
    const tween2 = TweenService.Create(door2, tweenInfo, goal2);
    tween1.Play();
    tween2.Play();

    return tween1;
}


function CloseDoor(model: Model): Tween {
    const door1 = model.FindFirstChild("Door1") as BasePart;
    const door2 = model.FindFirstChild("Door2") as BasePart;

    // Makes sure door parts exist
    assert(door1 !== undefined, `Door1 was not found in ${model.GetFullName()}`);
    assert(door2 !== undefined, `Door2 was not found in ${model.GetFullName()}`);

      // Plays Close sound
    const sound = door1.FindFirstChild("Close") as Sound;
    sound.Play();
    
    // Saves original CFrame for later use
    SaveCFrame(door1);
    SaveCFrame(door2);

    // Tweens creation and play
    const goal1 = {CFrame: storedCFrames[door1.GetFullName()]};
    const goal2 = {CFrame: storedCFrames[door2.GetFullName()]};
    const tween1 = TweenService.Create(door1, tweenInfo, goal1);
    const tween2 = TweenService.Create(door2, tweenInfo, goal2);
    tween1.Play();
    tween2.Play();

    return tween1;
}

export = [OpenDoor, CloseDoor];