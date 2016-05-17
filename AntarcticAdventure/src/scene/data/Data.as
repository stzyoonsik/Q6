package scene.data
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Data
	{
		private const TAG:String = "[Data]";
		
		protected var _name:String;
		protected var _path:File;
		
		public function Data(name:String, path:File)
		{
			if (!name || !path)
			{
				if (!name) trace(TAG + " ctor : No name.");
				if (!path) trace(TAG + " ctor : No path.");				
				return;
			}
			
			_name = name;
			_path = path;
		}

		public function dispose():void
		{
			_name = null;
			_path = null;
		}
			
		public function read():void
		{
			if (!_name || !_path)
			{
				if (!_name) trace(TAG + " read : No name.");
				if (!_path) trace(TAG + " read : No path.");				
				return;
			}
			
			var file:File = _path.resolvePath(_name + ".json");
			if (file.exists)
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, onCompleteLoad);
				urlLoader.load(new URLRequest(file.url));
			}
		}
		
		public virtual function write():void
		{
			// empty
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get path():File
		{
			return _path;
		}

		public function set path(value:File):void
		{
			_path = value;
		}
		
		protected function onCompleteLoad(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			if (loader)
			{
				loader.removeEventListener(Event.COMPLETE, onCompleteLoad);
			}
		}
	}
}