package com.miniplay.yperatou.screens {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import com.miniplay.yperatou.core.Screen;

	public class CreditsScreen extends Screen {
		private var infoFormat : TextFormat;
		private var info : TextField;
		private var backTextFormat : TextFormat;
		private var backTextField : TextField;
		private var backButton : Sprite;

		public function CreditsScreen() {
			infoFormat = new TextFormat("customFont", 22, 0xFFFFFF, true);
			infoFormat.align = "justify";

			info = new TextField();
			info.embedFonts = true;
			info.width = game.stage.stageWidth - 150;
			info.height = game.stage.stageHeight - 150;
			info.x = (game.stage.stageWidth - info.width) / 2;
			info.y = (game.stage.stageHeight - info.height) / 2;
			info.wordWrap = true;
			info.selectable = false;
			info.setTextFormat(infoFormat);
			info.defaultTextFormat = infoFormat;

			var output : String = "";
			output += "ΛΙΓΑ ΛΟΓΙΑ ΓΙΑ ΤΟ ΠΑΙΧΝΙΔΙ";
			output += "\n\nΤο παιχνίδι βασίζεται στο ομώνυμο παιχνίδι που παίζαμε τις δεκαεατίες των '80 και '90. Δεν μπορεί να αντικαταστήσει επάξια την κανονική του έκδοση, ωστόσο αποτελεί μία καλή ευκαιρία για να θυμούνται οι 'παλιοί' και να μαθαίνουν οι 'νέοι'.";
			output += " Αυτή τη στιγμή υπάρχει μόνο η κατηγορία με τα πολεμικά αεροπλάνα. Στην πορεία θα προστεθούν και άλλες.";
			output += " Για τυχόν προτάσεις ή αναφορά προβλημάτων, μπορείτε να στείλετε mail στο info@spyrospapadimitriou.gr.";
			output += "\n\nOPEN SOURCE ΕΡΓΑΛΕΙΑ ΥΛΟΠΟΙΗΣΗΣ";
			output += "\n- Flash Builder 4.6 σε περιβάλλον Mac OS";
			output += "\n- FlashDevelop σε περιβάλλον Windows XP";
			output += "\n- gEdit σε περιβάλλον Ubuntu";

			info.text = output;

			addChild(info);

			backButton = new Sprite();
			backButton.graphics.lineStyle(1.0, 0x777777);
			backButton.graphics.beginFill(0xFCCD03, 1.0);
			backButton.graphics.drawRect(0, 0, 150, 50);
			backButton.graphics.endFill();
			backButton.x = (game.stage.stageWidth - backButton.width) / 2;
			backButton.y = info.height + 30;
			backButton.filters = new Array(new DropShadowFilter());

			backTextFormat = new TextFormat("customFont", 19, 0x000000, true);
			backTextFormat.align = "center";

			backTextField = new TextField();
			backTextField.selectable = false;
			backTextField.text = "Πίσω";
			backTextField.width = backButton.width;
			backTextField.height = backButton.height - 10;
			backTextField.y = 10;
			backTextField.embedFonts = true;
			backTextField.defaultTextFormat = backTextFormat;
			backTextField.setTextFormat(backTextFormat);

			backButton.addEventListener(MouseEvent.CLICK, onClickBack);

			backButton.addChild(backTextField);
			addChild(backButton);
		} // end constructor

		private function onClickBack(e : MouseEvent) : void {
			backButton.removeEventListener(MouseEvent.CLICK, onClickBack);
			var screen : MenuScreen = new MenuScreen();
		}
	}
}