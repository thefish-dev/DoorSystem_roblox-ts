/* eslint-disable prettier/prettier */
import { GetAttribute } from 'shared/GetAttribute';
import Constants from "shared/DoorConfiguration";

const DoorTweens = {}

class DoorClass {
	// Public Attributes
	autoClose: Boolean;
	accessLevel: Number;
	lockBypassLevel: Number;
	hid: String;

	// Private Attributes
	_model: Model;
	_locked: Boolean;
	_moving: Boolean;
	_debounce: Boolean;
	_closed: Boolean;
	
	constructor(model: Model) {
		this._model = model;
		this.autoClose = GetAttribute(this._model, "AutoClose", Constants.DEFAULT_AUTOCLOSE);
		this.accessLevel = GetAttribute(this._model, "AccessLevel", Constants.DEFAULT_ACCESS_LEVEL);
		this.lockBypassLevel = GetAttribute(this._model, "LockBypassLevel", Constants.DEFAULT_ACCESS_LEVEL);
		this.hid = GetAttribute(this._model, "HID", Constants.DEFAULT_HID);

		this._locked = false;
		this._moving = false;
		this._debounce = true;
		this._closed = true;
	}

	open(): void {
		if (this._moving) return;

		
	}

	ready(): Boolean {
		return this._debounce
	}
}