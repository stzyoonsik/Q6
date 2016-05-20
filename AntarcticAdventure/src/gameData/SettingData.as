/**/package gameData
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;

	/**
	 * 인게임 환경설정 정보입니다. (배경음악, 효과음, 진동, 조작방법)
	 * @author user
	 * 
	 */
	public class SettingData extends Data
	{
		public static const CONTROL_SCREEN:int = 0;
		public static const CONTROL_BUTTON:int = 1;
		
		private const TAG:String = "[SettingData]";
		
		private var _bgm:Boolean;
		private var _sound:Boolean;
		private var _vibration:Boolean;
		private var _control:int;
		
		private var _onReadyToPreset:Function;
		
		public function SettingData(name:String, path:File)
		{
			super(name, path);
			
			_bgm = true;
			_sound = true;
			_vibration = true;
			_control = CONTROL_SCREEN;
		}
		
		/**
		 * SettingData를 AES-128로 암호화하여 JSON 파일로 출력합니다.   
		 * 
		 */
		public override function write():void
		{
			if (!_name || !_path)
			{
				if (!_name) trace(TAG + " write : No name.");
				if (!_path) trace(TAG + " write : No path.");				
				return;
			}
			
			var data:String =	"{\n\t\"bgm\" : "	+	_bgm.toString()			+	",\n"	+
								"\t\"sound\" : "	+	_sound.toString()		+	",\n"	+
								"\t\"vibration\" : "+	_vibration.toString()	+	",\n"	+
								"\t\"control\" : "	+	_control.toString()		+	"\n}";
			
			data = AesCrypto.encrypt(data, "jiminhyeyunyoonsik");
			
			var stream:FileStream = new FileStream();
			var file:File = new File(_path.resolvePath(_name + ".json").url);
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(data);
			stream.close();
			
			data = null;
			stream = null;
			file = null;
		}
		
		protected override function onCompleteLoad(event:Event):void
		{
			super.onCompleteLoad(event);
			
			var loader:URLLoader = event.target as URLLoader;
			if (!loader)
			{
				return;
			}
			
			var data:Object = JSON.parse(AesCrypto.decrypt(loader.data, "jiminhyeyunyoonsik"));
			
			_bgm = data.bgm;
			_sound = data.sound;
			_vibration = data.vibration;
			_control = data.control;
			
			if (_onReadyToPreset)
			{
				_onReadyToPreset();
			}
		}

		public function get bgm():Boolean
		{
			return _bgm;
		}

		public function set bgm(value:Boolean):void
		{
			_bgm = value;
		}

		public function get sound():Boolean
		{
			return _sound;
		}

		public function set sound(value:Boolean):void
		{
			_sound = value;
		}
		
		public function get vibration():Boolean
		{
			return _vibration;
		}
		
		public function set vibration(value:Boolean):void
		{
			_vibration = value;
		}

		public function get control():int
		{
			return _control;
		}

		public function set control(value:int):void
		{
			_control = value;
		}

		public function set onReadyToPreset(value:Function):void
		{
			_onReadyToPreset = value;
		}
	}
}