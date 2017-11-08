package com.miniplay.yperatou.screens 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.miniplay.yperatou.core.Screen;

	public class ErrorScreen extends Screen 
	{
		private var infoFormat:TextFormat;
		private var info:TextField;

		private var backTextFormat:TextFormat;
		private var backTextField:TextField;
		private var backButton:Sprite;
		
		public function ErrorScreen() 
		{
			infoFormat = new TextFormat("customFont", 22, 0xFFFFFF, true);
			infoFormat.align = "justify";
			
			info = new TextField();
			info.embedFonts = true;
			info.width = game.stage.stageWidth - 250;
			info.height = game.stage.stageHeight - 250;
			info.x = (game.stage.stageWidth - info.width) / 2;
			info.y = (game.stage.stageHeight - info.height) / 2;
			info.wordWrap = true;
			info.selectable = false;
			info.setTextFormat(infoFormat);
			info.defaultTextFormat = infoFormat;
			info.text = "ΣΦΑΛΜΑ\n\n" + game.error;
			
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
			
			game.error = "";
		} // end constructor
		
		private function onClickBack(e:MouseEvent):void
		{
			backButton.removeEventListener(MouseEvent.CLICK, onClickBack);
			var screen:MenuScreen = new MenuScreen();
		}
		
	} // end class

} // end package