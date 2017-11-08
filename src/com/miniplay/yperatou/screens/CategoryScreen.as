package com.miniplay.yperatou.screens {
	import com.miniplay.yperatou.classes.Category;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import com.miniplay.yperatou.core.Screen;

	import flash.display.Sprite;

	public class CategoryScreen extends Screen {
		private var categories : Array;
		private var buttons : Array;
		private var backButton : Sprite;
		private var info : TextField;

		public function CategoryScreen() {
			var loader : URLLoader = new URLLoader();
			var request : URLRequest = new URLRequest(game.url + "categories.php");

			loader.addEventListener(Event.COMPLETE, onLoadCategories);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoad);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.load(request);

			var infoFormat : TextFormat = new TextFormat("customFont", 22, 0xFFFFFF, true);
			infoFormat.align = "center";

			info = new TextField();
			info.embedFonts = true;
			info.width = 400;
			info.height = 60;
			info.x = (game.stage.stageWidth - info.width) / 2;
			info.y = 150;
			info.wordWrap = true;
			info.selectable = false;
			info.setTextFormat(infoFormat);
			info.defaultTextFormat = infoFormat;
			info.text = "Παρακαλώ περιμένετε...";

			addChild(info);
		}

		private function onLoadCategories(e : Event) : void {
			var data : String = e.target.data;

			if (data != "") {
				var categoriesLoaded : Array = data.split("&");
				if (categoriesLoaded.length) {
					var fields : Array;
					var category : Category;
					categories = new Array();

					for (var i : uint = 0; i < categoriesLoaded.length; i++) {
						fields = categoriesLoaded[i].split("|");

						if (fields.length > 1) {
							category = new Category();
							category.id = uint(fields[0]);
							category.name = fields[1];

							categories.push(category);
						}
					}
				}
			}

			createButtons();
		}

		private function onErrorLoad(e : IOErrorEvent) : void {
			game.error = "Προέκυψε σφάλμα κατά τη φόρτωση των κατηγοριών από τη βάση δεδομένων.";
			var screen : ErrorScreen = new ErrorScreen();
		}

		private function onSecurityError(e : SecurityErrorEvent) : void {
			game.error = "Προέκυψε σφάλμα ασφαλείας κατά τη φόρτωση των κατηγοριών από τη βάση δεδομένων.";
			var screen : ErrorScreen = new ErrorScreen();
		}

		private function onProgress(e : ProgressEvent) : void {
			info.text = "Φορτώθηκαν " + e.bytesLoaded + " από τα " + e.bytesTotal + " bytes.";
		}

		private function createButtons() : void {
			var i : uint = 0;
			var offset : uint = 20;
			var textFormat : TextFormat = new TextFormat("customFont", 19, 0x000000, true);
			textFormat.align = "center";
			var textField : TextField;

			if (categories.length) {
				info.text = "Παρακαλώ διαλέξτε κατηγορία";
				buttons = new Array();

				for (i = 0; i < categories.length; i++) {
					var button : Sprite = new Sprite();
					button.graphics.lineStyle(1.0, 0x777777);
					button.graphics.beginFill(0xFCCD03, 1.0);
					button.graphics.drawRect(0, 0, 230, 50);
					button.graphics.endFill();
					button.x = (game.stage.stageWidth - button.width) / 2;
					button.y = 200 + i * (button.height + offset);
					button.filters = new Array(new DropShadowFilter());

					textField = new TextField();
					textField.selectable = false;
					textField.text = categories[i].name;
					textField.width = button.width;
					textField.height = button.height - 10;
					textField.y = 10;
					textField.embedFonts = true;
					textField.defaultTextFormat = textFormat;
					textField.setTextFormat(textFormat);

					buttons.push(button);
					button.addChild(textField);
					addChild(button);
					button.addEventListener(MouseEvent.CLICK, onClickButton);
				} // end for
			} // end if 
			else {
				info.text = "Δεν υπάρχουν κατηγορίες!";
			}

			backButton = new Sprite();
			backButton.graphics.lineStyle(1.0, 0x777777);
			backButton.graphics.beginFill(0x9F183A, 1.0);
			backButton.graphics.drawRect(0, 0, 230, 50);
			backButton.graphics.endFill();
			backButton.x = (game.stage.stageWidth - button.width) / 2;
			backButton.y = 200 + i * (button.height + offset);
			backButton.filters = new Array(new DropShadowFilter());
			backButton.x = (game.stage.stageWidth - backButton.width) / 2;
			backButton.y = 200 + i * (backButton.height + offset);

			textFormat.color = 0xFFFFFF;
			textField = new TextField();
			textField.selectable = false;
			textField.text = "Πίσω"
			textField.width = button.width;
			textField.height = button.height - 10;
			textField.y = 10;
			textField.embedFonts = true;
			textField.defaultTextFormat = textFormat;
			textField.setTextFormat(textFormat);

			backButton.addChild(textField);
			addChild(backButton);
			backButton.addEventListener(MouseEvent.CLICK, onClickBack);
		}

		private function disableListeners() : void {
			if (backButton.hasEventListener(MouseEvent.CLICK))
				backButton.removeEventListener(MouseEvent.CLICK, onClickBack);

			if (buttons.length)
				for (var i : uint = 0; i < buttons.length; i++)
					if (buttons[i].hasEventListener(MouseEvent.CLICK))
						buttons[i].removeEventListener(MouseEvent, onClickButton);
		}

		private function onClickBack(e : MouseEvent) : void {
			disableListeners();
			var screen : MenuScreen = new MenuScreen();
		}

		private function onClickButton(e : MouseEvent) : void {
			var button : Sprite = e.currentTarget as Sprite;
			var index : int = buttons.indexOf(button);

			if (index >= 0) {
				game.categoryId = categories[index].id;
				var screen : GameScreen = new GameScreen();
				screen.alpha = 1.0;
			}
		}
	}
}