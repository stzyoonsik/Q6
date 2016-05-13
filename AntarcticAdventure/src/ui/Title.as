package ui
{
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	public class Title extends GameObject
	{
		private const TAG:String = "[Title]";
		private const MAIN:int = 0;
		private const DEFAULT_INTERVAL:uint = 30;
		
		private var _isFade:Boolean;
		private var _fadeInterval:uint;
		private var _frameCounter:uint;
		
		private var _mainTitleHeight:Number;
		
		public function Title(stageWidth:Number, stageHeight:Number, resources:Vector.<Texture>)
		{
			if (!resources)
			{
				trace(TAG + " ctor : No resources.");
				return;
			}
			
			this.pivot = PivotType.CENTER;
			this.x = stageWidth / 2;
			this.y = stageHeight / 2;
			
			var main:GameObject = new GameObject;
			main.pivot = PivotType.CENTER;
			addChild(main);
			
			var titleWidth:Number = 0;
			_mainTitleHeight = 0;
			for (var i:int = 0; i < resources.length; i++)
			{
				titleWidth += resources[i].width;
				
				if (_mainTitleHeight < resources[i].height)
				{
					_mainTitleHeight = resources[i].height;
				}
			}
			
			var left:Number = -(titleWidth / 2);
			var widthSoFar:Number = 0;
			for (i = 0; i < resources.length; i++)
			{
				var element:GameObject = new GameObject();
				element.addComponent(new Image(resources[i]));
				element.pivot = PivotType.CENTER;
				element.x = -(left + widthSoFar + element.width / 2);
				main.addChild(element);
				
				widthSoFar += resources[i].width;
			}
			
			_isFade = false;
			_fadeInterval = 0;
			_frameCounter = 0;
		}
		
		public override function dispose():void
		{
			removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			
			super.dispose();
		}
		
		public function addSubTitle(stageWidth:int, stageHeight:int, resources:Vector.<Texture>):void
		{
			if (!resources)
			{
				trace(TAG + " addSubTitle : No resources.");
				return;
			}
			
			var main:GameObject = getChild(MAIN);
			main.y = -(_mainTitleHeight / 2);
			
			var titleWidth:Number = 0;
			var titleHeight:Number = 0;
			for (var i:int = 0; i < resources.length; i++)
			{
				titleWidth += resources[i].width;
				
				if (titleHeight < resources[i].height)
				{
					titleHeight = resources[i].height;
				}
			}
			
			var sub:GameObject = new GameObject;
			sub.pivot = PivotType.CENTER;
			sub.y = titleHeight;
			addChild(sub);
			
			var left:Number = -(titleWidth / 2);
			var widthSoFar:Number = 0;
			for (i = 0; i < resources.length; i++)
			{
				var element:GameObject = new GameObject();
				element.addComponent(new Image(resources[i]));
				element.pivot = PivotType.CENTER;
				element.x = left + widthSoFar + element.width / 2;
				sub.addChild(element);
				
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
			if (!_isFade)
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