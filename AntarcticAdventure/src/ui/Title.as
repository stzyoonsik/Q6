package ui
{
	import trolling.component.ComponentType;
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	public class Title extends GameObject
	{
		private const TAG:String = "[Title]";
		private const NUMBER:int = 0;
		private const DEFAULT_INTERVAL:uint = 30;
		
		private var _isFade:Boolean;
		private var _fadeInterval:uint;
		private var _frameCounter:uint;
		
		public function Title(stageWidth:int, stageHeight:int, resources:Vector.<Texture>)
		{
			if (!resources)
			{
				trace(TAG + " ctor : No resources.");
				return;
			}
			
			this.pivot = PivotType.CENTER;
			this.x = stageWidth / 2;
			this.y = stageHeight / 2;
			
			var titleWidth:Number = 0;
			for (var i:int = 0; i < resources.length; i++)
			{
				titleWidth += resources[i].width;
			}
			
			var left:Number = this.x - titleWidth / 2;
			var widthSoFar:Number = 0;
			for (i = 0; i < resources.length; i++)
			{
				var element:GameObject = new GameObject();
				element.x = left + widthSoFar; 
				element.addComponent(new Image(resources[i]));
				addChild(element);
				
				widthSoFar += resources[i].width;
			}
			
			_isFade = false;
			_fadeInterval = 0;
			_frameCounter = 0;
		}
		
		public function addSubTitle(stageWidth:int, stageHeight:int, resources:Vector.<Texture>):void
		{
			if (!resources)
			{
				trace(TAG + " addSubTitle : No resources.");
				return;
			}
			
			var margin:Number = this.height / 5;
			this.y = stageHeight / 2 - this.height - margin / 2;
			
			var titleWidth:Number = 0;
			for (var i:int = 0; i < resources.length; i++)
			{
				titleWidth += resources[i].width;
			}
			
			var left:Number = this.x - titleWidth / 2;
			var widthSoFar:Number = 0;
			for (i = 0; i < resources.length; i++)
			{
				var element:GameObject = new GameObject();
				element.x = left + widthSoFar;
				element.y = this.height + margin;
				element.addComponent(new Image(resources[i]));
				addChild(element);
				
				widthSoFar += resources[i].width;
			}
		}
		
		public function get isFade():Boolean
		{
			return _isFade;
		}
		
		public function set isFade(value:Boolean):void
		{
			if (value)
			{
				addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
				
				if (_fadeInterval == 0)
				{
					_fadeInterval = DEFAULT_INTERVAL;
					_frameCounter = _fadeInterval;
				}
			}
			else
			{
				removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			}

			_isFade = value;
		}
		
		public function get fadeInterval():uint
		{
			return _fadeInterval;
		}

		public function set fadeInterval(value:uint):void
		{
			_fadeInterval = value;
			_frameCounter = _fadeInterval;
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{
			if (!_isFade || !components[ComponentType.IMAGE])
			{
				return;
			}
			
			if (_frameCounter > 0)
			{
				this.alpha = 1 * _frameCounter / _fadeInterval;
				_frameCounter--;
			}
			else
			{
				removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
				dispose();
			}	
		}
	}
}