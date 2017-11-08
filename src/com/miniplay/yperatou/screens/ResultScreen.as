package com.miniplay.yperatou.screens {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import com.miniplay.yperatou.core.Screen;

	public class ResultScreen extends Screen {
		private var box : Sprite;
		private var resultFormat : TextFormat;
		private var result : TextField;

		public function ResultScreen() {
			super();

			box = new Sprite();
			box.graphics.beginFill(0xFFEF23, 1.0);
			box.graphics.drawRect(0, 0, game.stage.stageWidth - 300, game.stage.stageHeight - 300);
			box.graphics.endFill();
			box.x = (game.stage.stageWidth - box.width) / 2;
			box.y = (game.stage.stageHeight - box.height) / 2;
			box.filters = new Array(new DropShadowFilter());

			resultFormat = new TextFormat("customFont", 36, 0x000000, true);
			resultFormat.align = "center";

			var offset : uint = 30;
			result = new TextField();
			result.embedFonts = true;
			// result.border = true;
			result.width = box.width - 2 * offset;
			result.height = box.height - 2 * offset;
			result.selectable = false;
			result.wordWrap = true;
			result.setTextFormat(resultFormat);
			result.defaultTextFormat = resultFormat;
			result.x = offset;
			result.y = offset;

			if (game.winner == null)
				result.text = "Το παιχνίδι έληξε ισόπαλο.";
			else if (game.winner.computer)
				result.text = "Δυστυχώς χάσατε. Νικητής του παιχνιδιού ήταν ο " + game.winner.name + ".";
			else
				result.text = "Είστε ο νικητής του παιχνιδιού!";

			result.appendText("\n\nΚάντε κλικ για μετάβαση στο μενού επιλογών του παιχνιδιού.");

			box.addChild(result);
			addChild(box);

			box.addEventListener(MouseEvent.CLICK, onClickBox);
		}

		private function onClickBox(e : MouseEvent) : void {
			box.removeEventListener(MouseEvent.CLICK, onClickBox);
			var screen : MenuScreen = new MenuScreen();
		}
	}
}