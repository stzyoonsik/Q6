package gameData
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	
	import scene.gameScene.util.AesCrypto;

	public class PlayData extends Data
	{
		private const TAG:String = "[PlayData]";
		private const NONE:int = -1;
		private const MAX_STAR:int = 3;
		
		private var _starData:Dictionary; // key: int(Stage ID), value: int(Number of Stars)
		
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

		public function get starData():Dictionary
		{
			return _starData;
		}

		public function set starData(value:Dictionary):void
		{
			_starData = value;
		}
	}
}