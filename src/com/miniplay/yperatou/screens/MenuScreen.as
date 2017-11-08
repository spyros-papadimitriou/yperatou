package com.miniplay.yperatou.screens {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import com.miniplay.yperatou.core.Screen;

	public class MenuScreen extends Screen {
		private var menuTitleTextField : TextField;
		private var menuStart : Sprite;
		private var menuPlayers : Sprite;
		private var menuRules : Sprite;
		private var menuCredits : Sprite;
		private var menuStartTextField : TextField;
		private var menuPlayersTextField : TextField;
		private var menuRulesTextField : TextField;
		private var menuCreditsTextField : TextField;
		private var menuTitleTextFormat : TextFormat;
		private var menuTextFormat : TextFormat;

		// [Embed(source = "/assets/backgrounds/bg.jpg")]
		// private var Background:Class;
		public function MenuScreen() {
			super();

			var offset : uint = 30;

			// Φίλτρα
			var dropShadow : DropShadowFilter = new DropShadowFilter();
			var glowFilter : GlowFilter = new GlowFilter();
			glowFilter.color = 0x333333;

			// var bg:DisplayObject = new Background();
			// addChild(bg);

			menuTextFormat = new TextFormat("customFont", 19, 0x000000, true);
			menuTextFormat.align = "center";

			menuTitleTextFormat = new TextFormat("customFont", 64, 0xDEDEDE, true);
			menuTitleTextFormat.align = "center";

			menuTitleTextField = new TextField();
			menuTitleTextField.width = game.stage.stageWidth;
			menuTitleTextField.selectable = false;
			menuTitleTextField.text = "ΥΠΕΡΑΤΟΥ";
			menuTitleTextField.antiAliasType = AntiAliasType.ADVANCED;
			menuTitleTextField.filters = new Array(dropShadow, glowFilter);
			menuTitleTextField.setTextFormat(menuTitleTextFormat);
			menuTitleTextField.defaultTextFormat = menuTitleTextFormat;
			menuTitleTextField.x = (game.stage.stageWidth - menuTitleTextField.width) / 2;
			menuTitleTextField.y = 80;
			addChild(menuTitleTextField);

			menuStart = new Sprite();
			menuStart.graphics.lineStyle(1.0, 0x777777);
			menuStart.graphics.beginFill(0xFCCD03, 1.0);
			menuStart.graphics.drawRect(0, 0, 230, 50);
			menuStart.graphics.endFill();
			menuStart.x = (game.stage.stageWidth - menuStart.width) / 2;
			menuStart.y = offset + 200;
			menuStart.filters = new Array(dropShadow);

			menuStartTextField = new TextField();
			menuStartTextField.selectable = false;
			menuStartTextField.text = "Έναρξη Παιχνιδιού";
			menuStartTextField.width = menuStart.width;
			menuStartTextField.height = menuStart.height - 10;
			menuStartTextField.y = 10;
			menuStartTextField.embedFonts = true;
			menuStartTextField.defaultTextFormat = menuTextFormat;
			menuStartTextField.setTextFormat(menuTextFormat);

			menuStart.addChild(menuStartTextField);
			addChild(menuStart);

			menuPlayers = new Sprite();
			menuPlayers.graphics.lineStyle(1.0, 0x777777);
			menuPlayers.graphics.beginFill(0xFCCD03, 1.0);
			menuPlayers.graphics.drawRect(0, 0, 230, 50);
			menuPlayers.graphics.endFill();
			menuPlayers.x = menuStart.x;
			menuPlayers.y = menuStart.y + menuStart.height + offset;
			menuPlayers.filters = new Array(dropShadow);

			menuPlayersTextField = new TextField();
			menuPlayersTextField.selectable = false;
			menuPlayersTextField.text = "Αριθμός αντιπάλων: " + (game.numPlayers - 1).toString();
			menuPlayersTextField.width = menuPlayers.width;
			menuPlayersTextField.height = menuPlayers.height - 10;
			menuPlayersTextField.y = 10;
			menuPlayersTextField.embedFonts = true;
			menuPlayersTextField.defaultTextFormat = menuTextFormat;
			menuPlayersTextField.setTextFormat(menuTextFormat);

			menuPlayers.addChild(menuPlayersTextField);
			addChild(menuPlayers);

			menuRules = new Sprite();
			menuRules.graphics.lineStyle(1.0, 0x777777);
			menuRules.graphics.beginFill(0xFCCD03, 1.0);
			menuRules.graphics.drawRect(0, 0, 230, 50);
			menuRules.graphics.endFill();
			menuRules.x = menuPlayers.x;
			menuRules.y = menuPlayers.y + menuPlayers.height + offset;
			menuRules.filters = new Array(dropShadow);

			menuRulesTextField = new TextField();
			menuRulesTextField.selectable = false;
			menuRulesTextField.text = "Κανόνες";
			menuRulesTextField.width = menuPlayers.width;
			menuRulesTextField.height = menuPlayers.height - 10;
			menuRulesTextField.y = 10;
			menuRulesTextField.embedFonts = true;
			menuRulesTextField.defaultTextFormat = menuTextFormat;
			menuRulesTextField.setTextFormat(menuTextFormat);

			menuRules.addChild(menuRulesTextField);
			addChild(menuRules);

			menuCredits = new Sprite();
			menuCredits.graphics.lineStyle(1.0, 0x777777);
			menuCredits.graphics.beginFill(0xFCCD03, 1.0);
			menuCredits.graphics.drawRect(0, 0, 230, 50);
			menuCredits.graphics.endFill();
			menuCredits.x = menuPlayers.x;
			menuCredits.y = menuRules.y + menuRules.height + offset;
			menuCredits.filters = new Array(dropShadow);

			menuCreditsTextField = new TextField();
			menuCreditsTextField.selectable = false;
			menuCreditsTextField.text = "Πληροφορίες";
			menuCreditsTextField.width = menuPlayers.width;
			menuCreditsTextField.height = menuPlayers.height - 10;
			menuCreditsTextField.y = 10;
			menuCreditsTextField.embedFonts = true;
			menuCreditsTextField.defaultTextFormat = menuTextFormat;
			menuCreditsTextField.setTextFormat(menuTextFormat);

			menuCredits.addChild(menuCreditsTextField);
			addChild(menuCredits);

			menuStart.addEventListener(MouseEvent.CLICK, onClickStart);
			menuPlayers.addEventListener(MouseEvent.CLICK, onClickPlayers)
			menuRules.addEventListener(MouseEvent.CLICK, onClickRules);
			menuCredits.addEventListener(MouseEvent.CLICK, onClickCredits);
		}

		private function onClickStart(e : MouseEvent) : void {
			menuStart.removeEventListener(MouseEvent.CLICK, onClickStart);
			// var screen:GameScreen = new GameScreen();
			// screen.alpha = 1.0;
			var screen : CategoryScreen = new CategoryScreen();
		}

		private function onClickPlayers(e : MouseEvent) : void {
			if (game.numPlayers == 4)
				game.numPlayers = 2;
			else
				game.numPlayers++;

			menuPlayersTextField.text = "Αριθμός αντιπάλων: " + (game.numPlayers - 1).toString();
		}

		private function onClickRules(e : MouseEvent) : void {
			menuRules.removeEventListener(MouseEvent.CLICK, onClickRules);
			var screen : RulesScreen = new RulesScreen();
		}

		private function onClickCredits(e : MouseEvent) : void {
			menuCredits.removeEventListener(MouseEvent.CLICK, onClickCredits);
			var screen : CreditsScreen = new CreditsScreen();
		}
	}
}