package com.miniplay.yperatou.core {
	import com.miniplay.yperatou.classes.Player;

	import flash.display.Sprite;
	import flash.display.Stage;

	public class Game {
		private static var instance : Game = null;
		// public const url : String = "http://localhost/yper/";
		// public const url:String = "http://localhost/yperatou/";
		public const url : String = "http://www.miniplay.gr/yperatou/";
		private var _stage : Stage;
		private var _root : Sprite;
		private var _currentScreen : Screen;
		private var _error : String = "";
		private var _numPlayers : uint;
		private var _winner : Player;
		private var _categoryId : uint;

		[Embed(source="/../assets/fonts/UbuntuMono-Bold.ttf", fontName="customFont", mimeType="application/x-font", fontWeight="bold", fontStyle="normal", unicodeRange="U+0020,U+0041-005A, U+0020,U+0061-007A, U+0030-0039,U+002E, U+0020-002F,U+003A-0040,U+005B-0060,U+007B-007E, U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E, U+0374-03F2,U+1F00-1FFE,U+2000-206F,U+20A0-20CF,U+2100-2183", advancedAntiAliasing="true", embedAsCFF="false")]
		public static const CustomFont : Class;

		public function Game() {
			numPlayers = 2;
			categoryId = 1;
		}

		public static function getInstance() : Game {
			if (instance == null)
				instance = new Game();

			return instance;
		}

		public function randomNumbers(min : int, max : int) : int {
			return Math.round(min + (max - min) * Math.random());
		}

		public function shuffleArray(array : Array) : Array {
			var shuffledArray : Array = new Array(array.length);
			var randomPos : uint;

			for (var i : uint = 0; i < shuffledArray.length; i++) {
				randomPos = (uint)(Math.random() * array.length);
				shuffledArray[i] = array.splice(randomPos, 1)[0];
			}

			return shuffledArray;
		}

		// Getters and Setters
		public function get stage() : Stage {
			return _stage;
		}

		public function set stage(value : Stage) : void {
			_stage = value;
		}

		public function get root() : Sprite {
			return _root;
		}

		public function set root(value : Sprite) : void {
			_root = value;
		}

		public function get numPlayers() : uint {
			return _numPlayers;
		}

		public function set numPlayers(value : uint) : void {
			_numPlayers = value;
		}

		public function get currentScreen() : Screen {
			return this._currentScreen;
		}

		public function set currentScreen(value : Screen) : void {
			this._currentScreen = value;
		}

		public function get winner() : Player {
			return _winner;
		}

		public function set winner(value : Player) : void {
			_winner = value;
		}

		public function get categoryId() : uint {
			return _categoryId;
		}

		public function set categoryId(value : uint) : void {
			_categoryId = value;
		}

		public function get error() : String {
			return _error;
		}

		public function set error(value : String) : void {
			_error = value;
		}
	}
}