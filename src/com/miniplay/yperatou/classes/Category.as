package com.miniplay.yperatou.classes 
{
	import flash.display.Sprite;

	public class Category extends Sprite
	{

		private var _id:uint;
		private var _properties:Array; // Τα χαρακτηριστικά της κατηγορίας
		
		public function Category() 
		{
			_properties = new Array();
		}
		
		// Getters and Setters
		public function get properties():Array 
		{
			return _properties;
		}
		
		public function get id():uint 
		{
			return _id;
		}
		
		public function set id(value:uint):void 
		{
			_id = value;
		}
		
	} // end class

} // end package