package com.miniplay.yperatou.screens 
{
	import com.miniplay.yperatou.classes.Card;
	import com.miniplay.yperatou.classes.Category;
	import com.miniplay.yperatou.classes.Player;
	import com.miniplay.yperatou.classes.Property;
	import flash.events.SecurityErrorEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.miniplay.yperatou.core.Screen;

	public class GameScreen extends Screen 
	{
		private var category:Category;
		private var cards:Array;
		private var tempCards:Array = new Array(); // Κάρτες μετά από ισοπαλία
		private var removedCards:Array = new Array(); // Κάρτες που αφαιρούνται μετά από κάθε γύρο
		private var players:Array;
		private var currentPlayer:Player;
		private var yperatouFound:Boolean;
		private var debug:TextField;
		private var debugFormat:TextFormat;
		
		private var nextButton:Sprite;
		private var exitButton:Sprite;
		
		private var loader:URLLoader;
		private var request:URLRequest;
		private var variables:URLVariables;
		
		public function GameScreen() 
		{
			super();
			
			// Φίλτρα
			var dropShadow:DropShadowFilter = new DropShadowFilter();
			
			// Δημιουργία της κατηγορίας
			loadCategory(game.categoryId);

			// Προσωρινό box για trace
			debugFormat = new TextFormat();
			debugFormat.font = "customFont";
			debugFormat.size = 18;
			debugFormat.bold = true;
			debugFormat.color = 0xDEDEDE;
			
			debug = new TextField;
			debug.border = false;
			debug.width = 230;
			debug.height = 150;
			debug.selectable = false;
			debug.x = game.stage.stageWidth - debug.width - 10;
			debug.y = 10;
			debug.wordWrap = true;
			debug.embedFonts = true;
			debug.setTextFormat(debugFormat);
			debug.defaultTextFormat = debugFormat;
			addChild(debug);
			
			// Δημιουργία button για επόμενη ενέργεια
			nextButton = new Sprite();
			nextButton.graphics.lineStyle(1.0, 0x777777);
			nextButton.graphics.beginFill(0xFCCD03, 1.0);
			nextButton.graphics.drawRect(0, 0, 100, 50);
			nextButton.graphics.endFill();
			nextButton.x = game.stage.stageWidth - nextButton.width - 10;
			nextButton.y = game.stage.stageHeight - 2 * (nextButton.height + 10);
			nextButton.filters = new Array(dropShadow);
			nextButton.visible = false;
			
			var tfNextFormat:TextFormat = new TextFormat();
			tfNextFormat.font = "customFont";
			tfNextFormat.size = 20;
			tfNextFormat.bold = true;
			tfNextFormat.align = "center";
			
			var tfNext:TextField = new TextField();
			tfNext.selectable = false;
			tfNext.text = "Επόμενο";
			tfNext.width = nextButton.width;
			tfNext.height = nextButton.height - 10;
			tfNext.y = 10;
			tfNext.embedFonts = true;
			tfNext.defaultTextFormat = tfNextFormat;
			tfNext.setTextFormat(tfNextFormat);
			nextButton.addChild(tfNext);
			
			addChild(nextButton);
		
			// Δημιουργία button για έξοδο στο κυρίως μενού
			exitButton = new Sprite();
			exitButton.graphics.lineStyle(1.0, 0x777777);
			exitButton.graphics.beginFill(0x9F183A, 1.0);
			exitButton.graphics.drawRect(0, 0, 100, 50);
			exitButton.graphics.endFill();
			exitButton.filters = new Array(dropShadow);
			exitButton.x = game.stage.stageWidth - nextButton.width - 10;
			exitButton.y = game.stage.stageHeight - nextButton.height - 10;
			
			var tfExit:TextField = new TextField();
			tfExit.selectable = false;
			tfExit.text = "Έξοδος";
			tfExit.width = exitButton.width;
			tfExit.height = exitButton.height - 10;
			tfExit.y = 10;
			tfExit.embedFonts = true;
			tfExit.defaultTextFormat = tfNextFormat;
			tfExit.setTextFormat(tfNextFormat);
			
			exitButton.addEventListener(MouseEvent.CLICK, onClickExit);
			
			exitButton.addChild(tfExit);
			addChild(exitButton);
		}
		
		// Δημιουργία κατηγορίας
		private function loadCategory(id:uint):void
		{
			variables = new URLVariables();
			variables.id = id;
			
			loader = new URLLoader();
			
			request = new URLRequest(game.url + "category.php");
			request.method = URLRequestMethod.POST;
			request.data = variables;

			loader.addEventListener(Event.COMPLETE, onLoadCategory);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoad);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.load(request);
		}
		
		private function onErrorLoad(e:IOErrorEvent):void
		{
			game.error = "Προέκυψε σφάλμα κατά τη φόρτωση της κατηγορίας, των χαρακτηριστικών και των καρτών από τη βάση δεδομένων.";
			var screen:ErrorScreen = new ErrorScreen();
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			game.error = "Προέκυψε σφάλμα ασφαλείας κατά τη φόρτωση της κατηγορίας, των χαρακτηριστικών και των καρτών από τη βάση δεδομένων.";
			var screen:ErrorScreen = new ErrorScreen();
		}
		
		private function onLoadCategory(e:Event):void
		{
			var data:String = e.target.data;
			if (data != "")
			{
				var temp:Array = data.split("|");
				category = new Category();
				category.id = temp[0];
				category.name = temp[1];

				loadProperties(category.id); // Δημιουργία των αντίστοιχων properties
				return;
			} else {
				game.error = "Προέκυψε σφάλμα κατά της φόρτωση της κατηγορίας.";
				var screen:ErrorScreen = new ErrorScreen();
			}
		}
		
		// Δημιουργία των properties
		private function loadProperties(categoryId:uint):void
		{
			variables = new URLVariables();
			variables.categoryId = categoryId;
			
			loader = new URLLoader();
			
			request = new URLRequest(game.url + "properties.php");
			request.method = URLRequestMethod.GET;
			request.data = variables;

			loader.addEventListener(Event.COMPLETE, onLoadProperties);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoad);
			loader.load(request);			
		}
		
		private function onLoadProperties(e:Event):void
		{
			var data:String = e.target.data;
			
			var properties:Array = data.split("&");
			var property:Property;

			if (properties.length)
			{
				var fields:Array;

				for (var i:uint = 0; i < properties.length; i++)
				{
					fields = properties[i].split("|");
					if (fields.length > 1)
					{
						property = new Property();
						property.category = category;
						property.name = fields[1];
						property.unit = "";
					}
				}
				
				loadCards(category.id); // Δημιουργία των καρτών
				return;
			} else {
				game.error = "Προέκυψε σφάλμα κατά της φόρτωση των χαρακτηριστικών της κατηγορίας.";
				var screen:ErrorScreen = new ErrorScreen();
			}
		}
		
		// Δημιουργία των καρτών
		private function loadCards(categoryId:uint):void
		{
			variables = new URLVariables();
			variables.categoryId = categoryId;
			
			loader = new URLLoader();
			
			request = new URLRequest(game.url + "cards.php");
			request.method = URLRequestMethod.POST;
			request.data = variables;

			loader.addEventListener(Event.COMPLETE, onLoadCards);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoad);
			loader.load(request);
		}
		
		private function onLoadCards(e:Event):void
		{
			var data:String = e.target.data;
			var cardsSplit:Array = data.split("&");
			
			cards = new Array();
			
			if (cardsSplit.length)
			{
				var fields:Array;
				var card:Card;
				var values:Array;
				
				for (var i:uint = 0; i < cardsSplit.length; i++)
				{
					fields = cardsSplit[i].split("|");
					
					card = new Card();
					card.id = fields[0];
					card.code = fields[1];
					card.title = fields[2];
					card.subtitle = fields[3];
					if (fields[4] == 1)
					{
						card.yperatou = true;
						card.canBeatYperatou = true;
					}

					card.properties = category.properties;
					if (card.code == "Α1" || card.code == "Β1" || card.code == "Γ1" || card.code == "Δ1" || card.code == "Ε1" || card.code == "Ζ1" || card.code == "Η1" || card.code == "Θ1")
						card.canBeatYperatou = true;
   
					values = fields[5].split("-");

					if (values.length == category.properties.length)
					{
						card.values = values;
						cards.push(card);
					} // end if
				} // end for
				
				if (cards.length >= game.numPlayers)
				{
					trace ("Φορτώθηκαν " + cards.length + " κάρτες.");
					cards = game.shuffleArray(cards);
					createPlayers(); // Δημιουργία παικτών
					return;
				}
			} else {
				game.error = "Προέκυψε σφάλμα κατά της φόρτωση των καρτών της κατηγορίας.";
				var screen:ErrorScreen = new ErrorScreen();
			}
		}
		
		// Δημιουργία παικτών
		private function createPlayers():void
		{
			var cardsDeal:uint = (uint)(cards.length / game.numPlayers);

			players = new Array();
			var player:Player;

			// Μοίρασμα των καρτών σε κάθε παίκτη
			for (var i:uint = 0; i < game.numPlayers; i++)
			{
				player = new Player();
				player.name = "Παίκτης " + (i + 1);
				player.num = i + 1;
				players.push(player);
				
				if (i > 0 )
				{
					player.previous = players[i - 1];
					players[i - 1].next = player;
					player.computer = true;
				}
				
				for (var j:uint = i * cardsDeal; j < ((i + 1) * cardsDeal); j++)
				{
					cards[j].player = player;
					player.cards.push(cards[j]);
				}
				player.currentCard = cards[j - 1];
				player.updateCards();
				
				addChild(player);
			}
			
			players[0].previous = players[players.length - 1];
			players[players.length - 1].next = players[0];
			
			currentPlayer = players[game.randomNumbers(0, players.length - 1)];
			currentPlayer.isPlaying = true;
			play();
		}
		
		// Η διαδικασία που ακολουθείται όταν παίζει ένας παίκτης
		private function play():void
		{
			if (currentPlayer.currentCard == null)
			{
				trace(currentPlayer.name + ": Πού είναι η κάρτα? Οέο!")
				return;
			}
			currentPlayer.currentCard.hidden = false;
			if (currentPlayer.computer)
				debug.text = "Παίζει ο αντίπαλος " + currentPlayer.num + ".\n\nΚάνε κλικ στο επόμενο να δεις τι θα επιλέξει.\n\n";
			else
				debug.text = "Είναι η σειρά σου να παίξεις.\n\nΔιάλεξε ένα χαρακτηριστικό από την κάρτα σου.\n\n";
			//showInfo();

			trace("\n\nΝΕΟΣ ΓΥΡΟΣ");
			trace("--------------------------------");
			for (var i:uint = 0; i < players.length; i++)
			{
				addChild(players[i].currentCard);
				//players[i].traceCards();
			}
			
			if (!currentPlayer.computer)
				currentPlayer.currentCard.addEventListener(MouseEvent.CLICK, onClick);
			else // Παίζει ο υπολογιστής
			{
				nextButton.visible = true;
				nextButton.addEventListener(MouseEvent.CLICK, onClickComputer);
			}
		}
		
		private function onClickComputer(e:MouseEvent):void
		{
			nextButton.removeEventListener(MouseEvent.CLICK, onClickComputer);
			var num:uint = game.randomNumbers(0, category.properties.length - 1);
			selectProperty(num);
		}
		
		private function onClickExit(e:MouseEvent):void
		{
			exitButton.removeEventListener(MouseEvent.CLICK, onClickExit);
			var screen:MenuScreen = new MenuScreen();			
		}
		
		private function selectProperty(num:uint):void
		{
			var max:Number;
			var winners:Array = new Array();
			var currentWinner:Player;
			
			currentPlayer.currentCard.removeEventListener(MouseEvent.CLICK, onClick);
			max = currentPlayer.currentCard.values[num];
			winners.push(currentPlayer);
			removedCards = new Array();
			currentWinner = currentPlayer;
			
			if (currentPlayer.computer)
				debug.text = "Ο αντίπαλος " + currentPlayer.num + " διάλεξε να παίξει με '" + category.properties[num].name + "'.\n\n";
			else
				debug.text = "Διάλεξες να παίξεις με '" + category.properties[num].name + "'.\n\n";
			
			yperatouFound = false;
			// Βρίσκουμε αν έχει κάποιος από τους παίκτες κάρτα υπερατού
			for (var i:uint = 0; i < players.length; i++)
				if (players[i].currentCard.yperatou)
					yperatouFound = true;
			
			for (i = 0; i < players.length; i++)
			{
				removedCards.push(players[i].currentCard);
				players[i].currentCard.ellipse.y = players[i].currentCard.propertiesArea.y + num * 16;
				players[i].currentCard.ellipse.visible = true;
				
				// Σύγκριση των καρτών
				if (players[i] != currentPlayer)
				{
					players[i].currentCard.hidden = false;
					
					currentWinner = compareCards(currentWinner.currentCard, players[i].currentCard, num)
					

					if (currentWinner == null)
					{
						winners.push(players[i]);
						currentWinner = players[i];
					} else {
						winners = new Array(currentWinner);
					}
					/*					
					if (players[i].currentCard.values[num] > max)
					{
						max = players[i].currentCard.values[num];
						winners = new Array(players[i]);
					} // end if
					else if (players[i].currentCard.values[num] == max)
						winners.push(players[i]);
					*/
				} // end if
			} // end for
			
			// Ισοπαλία
			if (winners.length > 1)
			{
				for (i = 0; i < winners.length; i++)
				{
					tempCards.push(players[i].currentCard);
					players[i].giveCard(players[i].currentCard, null);
				}

			} else if (winners.length == 1) { // κερδίζει ένας παίκτης
				trace("Κέρδισε ο " + winners[0].name);
				currentPlayer = currentWinner;
				
				debug.appendText("Κέρδισε ο " + winners[0].name + ".");
				debug.appendText("\nΚάνε κλικ στο επόμενο.");
				for (i = 0; i < players.length; i++)
					players[i].giveCard(players[i].currentCard, winners[0]);
				
				while (tempCards.length)
					winners[0].cards.unshift(tempCards.pop());
			} else {
				trace("Οι κάρτες τελείωσαν! Ισοπαλία!");
			}
			
			nextButton.addEventListener(MouseEvent.CLICK, onClickNext);
		}
		
		private function compareCards(card1:Card, card2:Card, num:uint):Player
		{
			trace("Σύγκριση καρτών");
			trace(card1.player.name + ": " + card1.yperatou + " " + card1.canBeatYperatou + " " + card1.values[num]);
			trace(card2.player.name + ": " + card2.yperatou + " " + card2.canBeatYperatou + " " + card2.values[num]);
			trace("**************************");
			
			if (card1.player == null || card2.player == null)
				return null;
			
			if (card1.yperatou && !card2.canBeatYperatou)
				return card1.player;
			
			if (!card1.canBeatYperatou && card2.yperatou)
				return card2.player;
			
			if (yperatouFound)
				if (card1.canBeatYperatou && !card2.canBeatYperatou)
					return card1.player;
				else if (!card1.canBeatYperatou && card2.canBeatYperatou)
					return card2.player;
			
			if ((card1.yperatou && card2.canBeatYperatou) || (card1.canBeatYperatou && card2.yperatou) || (!card1.yperatou && !card2.yperatou))
				if (card1.values[num] > card2.values[num])
					return card1.player;
				else if (card1.values[num] < card2.values[num])
					return card2.player;
				else
					return null;
			
			return null;
		}
		
		private function onClick(e:MouseEvent):void
		{
			var card:Card = e.currentTarget as Card;
			var num:int = Math.floor(card.propertiesArea.mouseY / 16);
			
			nextButton.visible = true;

			if (num >= 0)
				selectProperty(num);
		}
		
		private function onClickNext(e:MouseEvent):void
		{
			nextButton.removeEventListener(MouseEvent.CLICK, onClickNext);
			nextButton.visible = false;
			
			currentPlayer.isPlaying = false; // Αφαιρούμε την ένδειξη ότι παίζει ο προηγούμενος παίκτης

			// Αφαιρούμε από το stage τις παλιές κάρτες
			while (removedCards.length)
				removeChild(removedCards.pop());
			
			// Έλεγχος αν τελείωσαν οι κάρτες κάποιων παικτών
			var player:Player;
			for (var i:uint = 0; i < players.length; i++)
			{
				player = players[i];
				player.updateCards();

				if (player.cards.length == 0)
				{
					players.splice(i, 1);
					i--;

					if (player == currentPlayer)
						currentPlayer = player.previous;
					
					player.previous.next = player.next;
					player.next.previous = player.previous;
					player.next = null;
					player.previous = null;					

					
					//trace("Βγαίνει από το παιχνίδι o " + player.name);					
					//trace("Η σειρά γίνεται");
					//for (var j:uint = 0; j < players.length; j++)
					//{
						//trace(players[j].name);
						//trace("previous = " + players[j].previous.name);
						//trace("next = " + players[j].next.name);
					//}
					//trace("-------------");
				}
			}
			
			switch (players.length)
			{
				case 0:
					trace("Ισοπαλία!");
					game.winner = null;
					var resultScreen:ResultScreen = new ResultScreen();
				break;
				
				case 1:
					trace("Νικητής: " + players[0].name);
					game.winner = players[0];
					var screen:ResultScreen = new ResultScreen();
				break;
				
				default:
					//currentPlayer = currentPlayer.next;
					currentPlayer.isPlaying = true;
					play();
				break;
			} // end switch

		}
		
		private function showInfo():void
		{
			if (players.length > 0)
			{
				var output:String = "";

				for (var i:uint = 0; i < players.length; i++)
				{
					if (players[i].cards.length == 1)
						output += players[i].name + ": 1 κάρτα.\n";
					else
						output += players[i].name + ": " + players[i].cards.length + " κάρτες.\n";
				}
				
				debug.appendText(output);
			}
		}
		
	} // end class

} // end package
