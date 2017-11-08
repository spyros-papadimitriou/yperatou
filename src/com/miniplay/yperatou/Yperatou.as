package com.miniplay.yperatou {
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	import com.miniplay.yperatou.core.Game;
	import com.miniplay.yperatou.screens.MenuScreen;

	[SWF(width="750", height="700", frameRate="30", backgroundColor="#408447")]
	public class Yperatou extends Sprite {
		private var menu : ContextMenu;

		public function Yperatou() : void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);

			menu = new ContextMenu();
			menu.hideBuiltInItems();

			var menuTitle : ContextMenuItem = new ContextMenuItem("ΥΠΕΡΑΤΟΥ");
			var menuMiniplay : ContextMenuItem = new ContextMenuItem("Miniplay");
			var menuSpyros : ContextMenuItem = new ContextMenuItem("© Spyros Papadimitriou 2013");
			menuSpyros.separatorBefore = true;

			menu.customItems.push(menuTitle, menuMiniplay, menuSpyros);
			contextMenu = menu;

			menuMiniplay.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onClickMiniplay);
			menuSpyros.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onClickSpyros);
		}

		private function onClickMiniplay(e : ContextMenuEvent) : void {
			navigateToURL(new URLRequest("http://www.miniplay.gr"), "_blank");
		}

		private function onClickSpyros(e : ContextMenuEvent) : void {
			navigateToURL(new URLRequest("http://www.spyrospapadimitriou.gr"), "_blank");
		}

		private function init(e : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var game : Game = Game.getInstance();

			game.stage = stage;
			game.root = this;

			// var screen:GameScreen = new GameScreen();
			var screen : MenuScreen = new MenuScreen();
			// var screen:RulesScreen = new RulesScreen();
			// var screen:ResultScreen = new ResultScreen();
			// var screen:CreditsScreen = new CreditsScreen();
			// var screen:CategoryScreen = new CategoryScreen();
			// var screen:ErrorScreen = new ErrorScreen();
		}
	}
}