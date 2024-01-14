/* eslint-disable prettier/prettier */
import { ReplicatedStorage } from "@rbxts/services";
import { GetAttribute } from 'shared/GetAttribute';
import Constants from "shared/DoorConfiguration";

// Interfaces
interface TweenTable{
	[doorName: string]: Tween
}
interface DoorModule {
    OpenDoor(model: Model): Tween;
    CloseDoor(model: Model): Tween;
}

// Variables
const DoorTweens: TweenTable = {}

class DoorClass {
	// Public Attributes
	public autoClose: Boolean;
	public accessLevel: number;
	public lockBypassLevel: number;

	// Private Attributes
	private _hid: String;
	private _locked: Boolean;
	private _doorType: string;
	private _model: Model;
	private _closed: Boolean;
	
	// Constructor
	constructor(model: Model) {
		this._model = model;
		this.autoClose = GetAttribute(this._model, "AutoClose", Constants.DEFAULT_AUTOCLOSE);
		this.accessLevel = GetAttribute(this._model, "AccessLevel", Constants.DEFAULT_ACCESS_LEVEL);
		this.lockBypassLevel = GetAttribute(this._model, "LockBypassLevel", Constants.DEFAULT_ACCESS_LEVEL);

		this._hid = GetAttribute(this._model, "HID", Constants.DEFAULT_HID);
		this._doorType = GetAttribute(this._model, "DoorType", Constants.DEFAULT_DOOR_TYPE);
		this._locked = false;
		this._closed = true;
	}
	
	// Private methods
	private async getModule(): Promise<DoorModule | undefined> {
		try {
			const module = ReplicatedStorage.FindFirstChild("DoorSystem")?.FindFirstChild("DoorTypes")?.FindFirstChild(this._doorType) as ModuleScript;
			return require(module) as DoorModule;
		} catch (error) {
			print(`No type ${this._doorType} was found in door ${this._model.GetFullName()}`);
			return undefined;
		}
	}
	
	private saveTween(tween: Tween): void {
		DoorTweens[this._model.GetFullName()] = tween;
	}

	// Informative methods
	getModel(): Model {
		return this._model;
	}

	getHID(): String {
		return this._hid;
	}

	isLocked(): Boolean {
		return this._locked;
	}

	isClosed(): Boolean {
		return this._closed;
	}

	isRunning(): Boolean {
		const tween = DoorTweens[this._model.GetFullName()];
		if (tween === undefined) return false;
		return tween.PlaybackState === Enum.PlaybackState.Playing;
	}

	// Customization methods
	changeAccess(newLevel: number): void {
		this.accessLevel = newLevel;
	}

	changeBehaviour(autoClose: Boolean): void {
		this.autoClose = autoClose;
	}

	// Action methods
	async open(): Promise<void> {
		const module = await this.getModule();
		const tween = module?.OpenDoor(this._model);
		assert(tween, `Couldn't get the Opening tween animation of door ${this._model.GetFullName()}`)
		this.saveTween(tween);
		this._closed = false;
	}
	
	async close(): Promise<void> {
		const module = await this.getModule();
		const tween = module?.CloseDoor(this._model);
		assert(tween, `Couldn't get the Closing tween animation of door ${this._model.GetFullName()}`)
		this.saveTween(tween);
		this._closed = true;
	}

	lock(): void {
		this._locked = true;
		if (!this._closed) this.close();
	}
	
	unlock(): void {
		this._locked = false;
	}
}

export = DoorClass;