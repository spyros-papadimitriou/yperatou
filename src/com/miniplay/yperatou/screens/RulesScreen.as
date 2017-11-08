package com.miniplay.yperatou.screens 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.miniplay.yperatou.core.Screen;

	public class RulesScreen extends Screen 
	{
		private var infoFormat:TextFormat;
		private var info:TextField;

		private var backTextFormat:TextFormat;
		private var backTextField:TextField;
		private var backButton:Sprite;
		
		public function RulesScreen() 
		{
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
			info.text = "ΚΑΝΟΝΕΣ ΠΑΙΧΝΙΔΙΟΥ\n\nΟι παίκτες μοιράζονται τις κάρτες, οι οποίες τοποθετούνται η μία κάτω από την άλλη. Κάθε κάρτα έχει έναν αριθμό χαρακτηριστικών (ταχύτητα, βάρος, ώθηση κλπ). Επιλέγεται στην τύχη ο παίκτης που θα ξεκινήσει να παίζει. Εξετάζει τα χαρακτηριστικά της πρώτης του κάρτας και καθορίζει το χαρακτηριστικό που κατά τη γνώμη του είναι καλύτερο από των άλλων και όλοι συγκρίνουν τις πρώτες τους κάρτες. Εκείνος που έχει τον καλύτερο αριθμό στο χαρακτηριστικό που καθορίστηκε, κερδίζει όλες τις κάρτες, οι οποίες τοποθετούνται κάτω από τις δικές του και συνεχίζει το παιχνίδι καθορίζοντας εκείνος το επόμενο χαρακτηριστικό. Το ΥΠΕΡΑΤΟΥ κερδίζει όλες τις κάρτες εκτός από τις Α1, Β1 κλπ, οπότε γίνεται σύγκριση των χαρακτηριστικών. Έαν δύο κάρτες έχουν τον ίδιο, παραμένουν όλες κάτω και τις κερδίζει όλες ο νικητής του επόμενου γύρου. Νικητής θα είναι εκείνος που θα συγκεντρώσει όλες τις κάρτες.";
			
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
		
		private function onClickBack(e:MouseEvent):void
		{
			backButton.removeEventListener(MouseEvent.CLICK, onClickBack);
			var screen:MenuScreen = new MenuScreen();
		}
		
	} // end class

} // end package