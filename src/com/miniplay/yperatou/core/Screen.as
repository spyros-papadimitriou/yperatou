package com.miniplay.yperatou.core {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.net.navigateToURL;

	public class Screen extends Sprite {
		private var _game : Game = Game.getInstance();
		private var developerTextFormat : TextFormat;
		private var developer : TextField;

		public function Screen() {
			if (game.currentScreen != null)
				game.currentScreen.destroy();

			developerTextFormat = new TextFormat("customFont", 15, 0xDEDEDE, true);

			developer = new TextField();
			developer.selectable = false;
			developer.setTextFormat(developerTextFormat);
			developer.defaultTextFormat = developerTextFormat;
			developer.wordWrap = true;
			developer.width = 300;
			developer.height = 20;
			developer.text = "Υλοποίηση: Σπύρος Παπαδημητρίου";
			developer.embedFonts = true;
			developer.x = 4;
			developer.y = game.stage.stageHeight - developer.height - 4;
			addChild(developer);

			game.currentScreen = this;
			alpha = 0;
			game.root.addChild(this);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			if (!developer.hasEventListener(MouseEvent.CLICK))
				developer.addEventListener(MouseEvent.CLICK, onClickDeveloper);
		}

		public function destroy() : void {
			while (numChildren)
				removeChildAt(0);

			while (game.root.numChildren)
				game.root.removeChildAt(0);

			developer.removeEventListener(MouseEvent.CLICK, onClickDeveloper);
		}

		private function onEnterFrame(e : Event) : void {
			alpha += 0.1;
			if (alpha >= 1.0) {
				alpha = 1.0;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		private function onClickDeveloper(e : MouseEvent) : void {
			navigateToURL(new URLRequest("http://www.spyrospapadimitriou.gr"), "_blank");
		}

		// Getters and Setters
		public function get game() : Game {
			return _game;
		}

		public function set game(value : Game) : void {
			_game = value;
		}
	}
}