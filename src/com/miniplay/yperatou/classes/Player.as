package com.miniplay.yperatou.classes 
{
	import flash.display.Sprite;
	
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Player extends Sprite
	{
		private var _cards:Array; // Οι κάρτες στην κατοχή του παίκτη
		private var _currentCard:Card; // Η κάρτα με την οποία παίζει
		private var _computer:Boolean; // Αν τον χειρίζεται ο υπολογιστής
		private var _isPlaying:Boolean; // Αν είναι η σειρά του να επιλέξει
		private var _num:uint; // Αρίθμηση
		private var _next:Player; // Ο επόμενος παίκτης στη σειρά
		private var _previous:Player; // Ο προηγούμενος παίκτης στη σειρά
		
		private var shape:Sprite = new Sprite();
		private var shapeText:TextField;
		private var shapeTextFormat:TextFormat;
		
		public function Player()
		{
			cards = new Array();
			computer = false;
			isPlaying = false;
			next = null;
			
			shape.graphics.beginFill(0x333333, 0.6);
			shape.graphics.drawCircle(0, 0, 20);
			shape.graphics.endFill();
			
			shapeTextFormat = new TextFormat();
			shapeTextFormat.font = "customFont";
			shapeTextFormat.size = 14;
			shapeTextFormat.bold = true;
			shapeTextFormat.align = "left";
			shapeTextFormat.color = 0xFFFFFF;
			
			shapeText = new TextField();
			shapeText.width = 200;
			shapeText.height = shape.height;
			shapeText.selectable = false;
			shapeText.setTextFormat(shapeTextFormat);
			shapeText.defaultTextFormat = shapeTextFormat;
			shapeText.x = -shape.width / 4;
			shapeText.y = -shape.height / 4;
			shapeText.embedFonts = true;
			num = 0;
			
			//shape.addChild(shapeText);
			//addChild(shape);
			addChild(shapeText);
		}
		
		public function giveCard(card:Card, player:Player):void
		{
			var position:int = cards.indexOf(card);

			if (position >= 0)
			{
				cards.splice(position, 1); // Αφαίρεση της κάρτας
				if (card == currentCard)
					if (cards.length > 0)
						currentCard = cards[cards.length - 1];
					else
						currentCard = null;
				
				card.player = player;
				if (player != null)
				{
					player.cards.unshift(card);
					player.currentCard = player.cards[player.cards.length - 1];
				}
			}
		}
		
		public function updateCards():void
		{
			shapeText.text = "Παίκτης " + num.toString() + ": ";
			if (cards.length > 1)
				shapeText.appendText(cards.length.toString() + " κάρτες.");
			else if(cards.length == 1)
				shapeText.appendText("1 κάρτα.");
			else
				shapeText.appendText("καμία κάρτα.");
		}
		
		public function traceCards():void
		{
			if (cards.length > 0)
				for (var i:uint = 0; i < cards.length; i++)
					trace(name + ": " + cards[i].code + " " + cards[i].subtitle);
			trace("-----------------------------------------------------------");
		}
		
		// Getters and Setters		
		public function get computer():Boolean
		{
			return this._computer;
		}
		
		public function set computer(value:Boolean):void
		{
			this._computer = value;
		}
		
		public function get isPlaying():Boolean
		{
			return this._isPlaying;
		}
		
		public function set isPlaying(value:Boolean):void
		{
			this._isPlaying = value;
		}
		
		public function get num():uint
		{
			return this._num;
		}
		
		public function set num(value:uint):void
		{
			this._num = value;			
		}
		
		public function get currentCard():Card
		{
			return this._currentCard;
		}
		
		public function set currentCard(value:Card):void
		{
			this._currentCard = value;
		}
		
		public function get cards():Array 
		{
			return _cards;
		}
		
		public function set cards(value:Array):void 
		{
			_cards = value;
		}
		
		public function get next():Player 
		{
			return _next;
		}
		
		public function set next(value:Player):void 
		{
			_next = value;
		}
		
		public function get previous():Player 
		{
			return _previous;
		}
		
		public function set previous(value:Player):void 
		{
			_previous = value;
		}
		
	} // end class

} // end package
