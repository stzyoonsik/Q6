package gameData
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;

	/**
	 * 스테이지 클리어 정보입니다. (별점) 
	 * @author user
	 * 
	 */
	public class PlayData extends Data
	{
		private const TAG:String = "[PlayData]";
		private const NONE:int = -1;
		private const MAX_STAR:int = 3;
		
		private var _starData:Dictionary;
		
		public function PlayData(name:String, path:File)
		{
			super(name, path);
			
			_starData = null;
		}
		
		public override function dispose():void
		{
		 	if (_starData)
			{
				for (var id:int in _starData)
				{
					delete _starData[id];
				}
			}
			_starData = null;
			
			super.dispose();
		}
		
		/**
		 * PlayData를 AES-128로 암호화하여 JSON 파일로 출력합니다.   
		 * 
		 */
		public override function write():void
		{
			if (!_name || !_path || !_starData)
			{
				if (!_name) trace(TAG + " write : No name.");
				if (!_path) trace(TAG + " write : No path.");				
				if (!_starData) trace(TAG + " write : No data.");
				return;
			}
			
			var star:int;
			var index:int = 0;
			var data:String = "{\n";
			for (var id:int in _starData)
			{
				star = _starData[id];
				
				if (index != 0)
				{
					data += "," + id.toString() + "," + star.toString();	
				}
				else
				{
					data += "\t\"starData\" : [" + id.toString() + "," + star.toString();
					index++;
				}
			}
			data += "]\n}";
			
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
			
			for (var i:int = 0; i < data.starData.length; i += 2)
			{
				addData(data.starData[i], data.starData[i + 1]); 
			}
		}
		
		/**
		 * 스테이지 클리어 정보를 추가합니다. 
		 * @param stageId 클리어한 스테이지의 ID입니다.
		 * @param numStar 해당 스테이지에서 획득한 별의 개수입니다.
		 * 
		 */
		public function addData(stageId:int, numStar:int):void
		{
			if (stageId < 0 || numStar < 0 || numStar > MAX_STAR)
			{
				if (stageId < 0) trace(TAG + " addData : Invaild ID.");
				else trace(TAG + " addData : Invaild number of star.");
				return;
			}
			
			if (!_starData)
			{
				_starData = new Dictionary;
			}
			_starData[stageId] = numStar;
		}
		
		/**
		 * 스테이지 클리어 정보를 제거합니다.
		 * @param stageId 제거하고자 하는 정보에 해당하는 스테이지의 ID입니다.
		 * 
		 */
		public function removeData(stageId:int):void
		{
			if (stageId < 0 || !_starData)
			{
				if (stageId < 0) trace(TAG + " removeData : Invaild ID.");
				if (!_starData) trace(TAG + " removeData : No data.");
				return;
			}
			
			for (var id:int in _starData)
			{
				if (id == stageId)
				{
					delete _starData[id];
					break;
				}
			}
		}
		
		/**
		 * 지정한 스테이지의 클리어 정보(획득한 별의 개수)를 반환합니다. 
		 * @param stageId 스테이지 ID입니다.
		 * @return 해당 스테이지에서 획득한 별의 개수입니다.
		 * 
		 */
		public function getData(stageId:int):int
		{
			if (stageId < 0 || !_starData)
			{
				if (stageId < 0) trace(TAG + " getData : Invaild ID.");
				if (!_starData) trace(TAG + " getData : No data.");
				return NONE;
			}
			
			for (var id:int in _starData)
			{
				if (id == stageId)
				{
					return _starData[id];
					break;
				}
			}
			
			return NONE;
		}

		/**
		 * 스테이지 클리어 데이터입니다. key: int(Stage ID), value: int(Number of Stars) 
		 * @return 
		 * 
		 */
		public function get starData():Dictionary
		{
			return _starData;
		}

		/**
		 * 스테이지 클리어 데이터입니다. key: int(Stage ID), value: int(Number of Stars)
		 * @param value
		 * 
		 */
		public function set starData(value:Dictionary):void
		{
			_starData = value;
		}
	}
}