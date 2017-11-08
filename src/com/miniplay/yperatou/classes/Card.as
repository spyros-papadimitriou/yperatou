package com.miniplay.yperatou.classes {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import com.miniplay.yperatou.core.Game;

	public class Card extends Sprite {
		private var game : Game = Game.getInstance();
		private var _id : uint; // Id (βοηθάει και στις φωτογραφίες)
		private var _code : String; // Κωδικός
		private var _title : String; // Τίτλος
		private var _subtitle : String; // Υπότιτλος
		private var _yperatou : Boolean; // Αν είναι υπερατού
		private var _canBeatYperatou : Boolean // Αν μπορεί να γίνει σύγκριση με κάρτα υπερατού
		private var _hidden : Boolean; // Αν εμφανίζεται
		private var _properties : Array; // Τα χαρακτηριστικά της κάρτας
		private var _values : Array; // Οι τιμές για κάθε χαρακτηριστικό
		private var _player : Player; // Ο παίκτης που έχει την κάρτα στην κατοχή του (null αν δεν την έχει κανείς)
		private var back : Shape; // Το πίσω μέρος
		private var _ellipse : Shape // Έλλειψη που κυκλώνει ένα χαρακτηριστικό
		private var _propertiesArea : Sprite; // Η περιοχή με τα properties (βοηθάει στα listeners)
		private var imageContainer : Sprite;
		private var loader : Loader;
		private var textFormatTop : TextFormat;
		private var textFormatUnit : TextFormat;

		// Γραφικά
		[Embed(source="/../assets/back3.png")]
		private var BackImage : Class;

		[Embed(source="/../assets/front2.png")]
		private var FrontImage : Class;
		private var frontImageBitmap : DisplayObject;
		private var frontImageBitmapData : BitmapData;
		private var backImageBitmap : DisplayObject;
		private var backImageBitmapData : BitmapData;

		public function Card() {
			_properties = new Array();
			_values = new Array();
			hidden = true;
			canBeatYperatou = false;
			imageContainer = new Sprite();
			ellipse = new Shape();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onRemovedFromStage(e : Event) : void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			while (numChildren)
				removeChildAt(0);

			hidden = true;
			ellipse.visible = false;
		}

		private function onAddedToStage(e : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			backImageBitmap = new BackImage();
			backImageBitmapData = new BitmapData(backImageBitmap.width, backImageBitmap.height, true);
			backImageBitmapData.draw(backImageBitmap);

			frontImageBitmap = new FrontImage();
			frontImageBitmapData = new BitmapData(frontImageBitmap.width, frontImageBitmap.height, true);
			frontImageBitmapData.draw(frontImageBitmap);
			addChild(frontImageBitmap);

			textFormatTop = new TextFormat();
			textFormatTop.font = "customFont";
			textFormatTop.bold = true;
			textFormatTop.size = 13;

			textFormatUnit = new TextFormat();
			textFormatUnit.font = "customFont";
			textFormatUnit.bold = true;
			textFormatUnit.size = 13;
			textFormatUnit.align = "right";

			var tfCode : TextField = new TextField();
			tfCode.text = code.toString();
			tfCode.selectable = false;
			// tfCode.border = true;
			tfCode.width = 30;
			tfCode.height = 16;
			tfCode.x = 15;
			tfCode.y = 13;
			tfCode.embedFonts = true;
			tfCode.setTextFormat(textFormatTop);
			addChild(tfCode);

			var tfTitle : TextField = new TextField();
			tfTitle.text = title;
			tfTitle.selectable = false;
			// tfTitle.border = true;
			tfTitle.width = 150;
			tfTitle.height = tfCode.height;
			tfTitle.x = tfCode.x + tfCode.width;
			tfTitle.y = tfCode.y;
			tfTitle.embedFonts = true;
			tfTitle.setTextFormat(textFormatTop);
			addChild(tfTitle);

			var tfSubtitle : TextField = new TextField();
			tfSubtitle.text = subtitle;
			tfSubtitle.selectable = false;
			// tfSubtitle.border = true;
			tfSubtitle.width = tfCode.width + tfTitle.width;
			tfSubtitle.height = tfCode.height;
			tfSubtitle.x = tfCode.x;
			tfSubtitle.y = tfCode.y + tfCode.height;
			tfSubtitle.embedFonts = true;
			tfSubtitle.setTextFormat(textFormatTop);
			addChild(tfSubtitle);

			imageContainer.graphics.lineStyle(1.0, 0xa6a6a6, 1.0);
			// imageContainer.graphics.beginFill(0xFFFFFF, 1.0);
			imageContainer.graphics.drawRect(0, 0, 187, 147);
			// imageContainer.graphics.endFill();
			imageContainer.x = 11;
			imageContainer.y = tfSubtitle.y + tfSubtitle.height + 10;
			addChild(imageContainer);

			propertiesArea = new Sprite();

			var propertiesLength : uint = properties.length;
			var tfLeft : TextField;
			var tfRight : TextField;
			var shapeProperty : Shape;
			for (var i : uint = 0; i < propertiesLength; i++) {
				shapeProperty = new Shape();
				shapeProperty.graphics.lineStyle(1.0, 0x000000);
				shapeProperty.graphics.drawRect(0, 0, tfSubtitle.width, tfSubtitle.height);
				// propertiesArea.addChild(shapeProperty);

				tfLeft = new TextField();
				tfLeft.text = properties[i].name;
				tfLeft.selectable = false;
				tfLeft.width = 125;
				tfLeft.height = 16;
				tfLeft.x = tfCode.x;
				tfLeft.y = i * tfLeft.height;
				tfLeft.embedFonts = true;
				tfLeft.setTextFormat(textFormatTop);
				// tfLeft.border = true;
				shapeProperty.y = tfLeft.y;
				propertiesArea.addChild(tfLeft);

				tfRight = new TextField();
				tfRight.text = values[i].toString() + " " + properties[i].unit.toString();
				tfRight.selectable = false;
				tfRight.width = 54;
				tfRight.height = tfLeft.height;
				tfRight.x = tfLeft.x + tfLeft.width;
				tfRight.y = tfLeft.y;
				tfRight.embedFonts = true;
				// tfRight.border = true;
				tfRight.setTextFormat(textFormatUnit);
				propertiesArea.addChild(tfRight);
			}

			propertiesArea.y = imageContainer.y + imageContainer.height + 12;
			addChild(propertiesArea);

			back = new Shape();
			back.graphics.beginFill(0xFF0000, 1.0);
			back.graphics.drawRect(0, 0, width, height);
			back.graphics.endFill();
			back.visible = hidden;
			// addChild(back);
			backImageBitmap.visible = hidden;
			addChild(backImageBitmap);

			var offset : uint = 20;
			switch (player.num) {
				case 1:
					x = width + 2 * offset;
					y = game.stage.stageHeight - height - offset;
					break;
				case 2:
					if (game.numPlayers > 2) {
						x = offset;
						y = (game.stage.stageHeight - height) / 2;
					} else {
						x = width + 2 * offset;
						y = offset;
					}
					break;
				case 3:
					x = width + 2 * offset;
					y = offset;
					break;
				case 4:
					x = 2 * width + 3 * offset;
					y = (game.stage.stageHeight - height) / 2;
					break;
			}

			ellipse.graphics.lineStyle(2.0, 0x000000);
			ellipse.graphics.drawEllipse(0, 0, 200, 19);
			ellipse.x = 5;
			ellipse.visible = false;
			addChild(ellipse);

			// player.x = x;
			// player.y = y;
			player.x = 25;
			player.y = 30 + (player.num - 1) * 20;
		}

		private function onLoadComplete(e : Event) : void {
			loader.x = 1;
			loader.y = 1;
			imageContainer.addChild(loader);
		}

		private function onErrorLoad(e : IOErrorEvent) : void {
			trace("Can't load image card with id " + id);
		}

		// Getters and Setters
		public function get code() : String {
			return _code;
		}

		public function set code(value : String) : void {
			_code = value;
		}

		public function get title() : String {
			return _title;
		}

		public function set title(value : String) : void {
			_title = value;
		}

		public function get subtitle() : String {
			return _subtitle;
		}

		public function set subtitle(value : String) : void {
			_subtitle = value;
		}

		public function get yperatou() : Boolean {
			return _yperatou;
		}

		public function set yperatou(value : Boolean) : void {
			_yperatou = value;
			if (yperatou)
				canBeatYperatou = true;
		}

		public function get properties() : Array {
			return _properties;
		}

		public function set properties(value : Array) : void {
			_properties = value;
			values = new Array();
			var len : uint = value.length;
			for (var i : uint = 0; i < len; i++)
				values.push(game.randomNumbers(1, 100));
		}

		public function get values() : Array {
			return _values;
		}

		public function set values(value : Array) : void {
			for (var i : uint = 0; i < value.length; i++)
				value[i] = Number(value[i]);
			_values = value;
		}

		public function get hidden() : Boolean {
			return _hidden;
		}

		public function set hidden(value : Boolean) : void {
			_hidden = value;
			if (back != null)
				back.visible = value;
			if (backImageBitmap != null)
				backImageBitmap.visible = value;
		}

		public function get player() : Player {
			return this._player;
		}

		public function set player(value : Player) : void {
			this._player = value;
		}

		public function get propertiesArea() : Sprite {
			return this._propertiesArea;
		}

		public function set propertiesArea(value : Sprite) : void {
			this._propertiesArea = value;
		}

		public function get canBeatYperatou() : Boolean {
			return _canBeatYperatou;
		}

		public function set canBeatYperatou(value : Boolean) : void {
			_canBeatYperatou = value;
		}

		public function get id() : uint {
			return _id;
		}

		public function set id(value : uint) : void {
			_id = value;
			loader = new Loader();

			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoad);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);

			var url : String = game.url + "images/categories/" + game.categoryId + "/" + id + ".jpg";
			var urlRequest : URLRequest = new URLRequest(url);
			loader.load(urlRequest);
		}

		public function get ellipse() : Shape {
			return _ellipse;
		}

		public function set ellipse(value : Shape) : void {
			_ellipse = value;
		}
	}
}