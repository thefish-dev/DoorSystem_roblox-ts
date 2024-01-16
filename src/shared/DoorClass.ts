/* eslint-disable prettier/prettier */
import { ReplicatedStorage } from "@rbxts/services";
import { GetAttribute } from 'shared/GetAttribute';
import { Constants } from "shared/DoorConfiguration";


// Variables
const DoorTweens: Map<Instance, Tween> = new Map();

interface DoorModule {
	OpenDoor(model: Model): Tween;
	CloseDoor(model: Model): Tween;
}


// Main class
export class DoorClass {
	// Public Attributes
	public autoClose: Boolean;
	public accessLevel: number;
	public lockBypassLevel: number;
	public closureDelay: number;

	// Private Attributes
	private _hid: String;
	private _locked: Boolean;
	private _doorType: string;
	private _model: Model;
	private _closed: Boolean;
	private _debounce: Boolean;

	// Constructor
	constructor(model: Model) {
		this._model = model; // GetAttribute(instance, attribute, default) is a custom function to get a default value when attribute is not found
		this.autoClose = GetAttribute(this._model, "AutoClose", Constants.DEFAULT_AUTOCLOSE);
		this.accessLevel = GetAttribute(this._model, "AccessLevel", Constants.DEFAULT_ACCESS_LEVEL);
		this.lockBypassLevel = GetAttribute(this._model, "LockBypassLevel", Constants.DEFAULT_LOCKDOWN_BYPASS_LEVEL);
		this.closureDelay = GetAttribute(this._model, "ClosureDelay", Constants.DEFAULT_CLOSURE_DELAY);

		this._hid = GetAttribute(this._model, "HID", Constants.DEFAULT_HID);
		this._doorType = GetAttribute(this._model, "DoorType", Constants.DEFAULT_DOOR_TYPE);
		this._locked = false;
		this._closed = true;
		this._debounce = true;
	}

	// Private methods
	// method to import a DoorType
	private getModule(): ModuleScript {
		const module = ReplicatedStorage.FindFirstChild("DoorSystem")?.FindFirstChild("DoorTypes")?.FindFirstChild(this._doorType) as ModuleScript;
		assert(module, `No type ${this._doorType} from door ${this._model.GetFullName()} was found in DoorTypes.`);
		return module;
	}

	// Saves tween in a map to keep track of door's state
	private saveTween(tween: Tween): void {
		DoorTweens.set(this._model, tween);
	}

	private clearTween(): void {
		DoorTweens.delete(this._model);
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
		const tween = DoorTweens.get(this._model);
		return (!this._debounce || tween !== undefined);
	}

	// Customization methods
	changeAccess(newLevel: number): void {
		this.accessLevel = newLevel;
	}

	changeBehaviour(autoClose: Boolean): void {
		this.autoClose = autoClose;
	}

	// Action methods
	open(): void {
		if (!this._closed) { // additional security to make sure the door isn't somehow already open
			this._debounce = true;
			this.clearTween();
			return
		};

		// Imports the DoorType module and starts opening tweens.
		const doorModule = require(this.getModule()) as DoorModule;
		const tween = doorModule.OpenDoor(this._model);
		assert(tween, `Couldn't get the Opening tween animation of door ${this._model.GetFullName()}`)

		this.saveTween(tween);
		this._debounce = false
		this._closed = false;

		tween.Completed.Once(() => { // when door is fully open
			if (this.autoClose) {
				task.wait(this.closureDelay);
				this.close();
			} else {
				this._debounce = true;
				this.clearTween();
			}
		});
	}

	close(): void {
		if (this._closed) { // additional security to make sure the door isn't somehow already closed
			this._debounce = true;
			this.clearTween();
			return
		};

		// Imports the DoorType module and starts closing tweens.
		const doorModule = require(this.getModule()) as DoorModule;
		const tween = doorModule.CloseDoor(this._model);
		assert(tween, `Couldn't get the Closing tween animation of door ${this._model.GetFullName()}`)

		this.saveTween(tween);
		this._debounce = false
		this._closed = true;

		tween.Completed.Once(() => { // when door is fully closed
			this._debounce = true;
			this.clearTween();
		});
	}

	// If door is opened when gets locked, it closes immediately
	lock(): void {
		this._locked = true;
		if (!this._closed) this.close();
	}

	unlock(): void {
		this._locked = false;
	}
}