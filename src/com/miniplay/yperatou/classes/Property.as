package com.miniplay.yperatou.classes {
	import flash.display.Sprite;

	public class Property extends Sprite {
		private var _category : Category; // Η κατηγορία στην οποία ανήκει
		private var _unit : String; // Η μονάδα μέτρησης
		private var _index : int; // Η θέση που κατέχει στην κατηγορία

		public function Property() {
			unit = "";
			index = -1;
		}

		// Getters and Setters
		public function get unit() : String {
			return _unit;
		}

		public function set unit(value : String) : void {
			_unit = value;
		}

		public function get index() : int {
			return _index;
		}

		public function set index(value : int) : void {
			_index = value;
		}

		public function get category() : Category {
			return _category;
		}

		public function set category(value : Category) : void {
			_category = value;
			index = value.properties.length;
			value.properties.push(this);
		}
	}
}