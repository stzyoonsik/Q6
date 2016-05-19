package ui
{
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	public class Popup extends GameObject
	{
		public static const END_SHOW:String = "endShow";
		private const TAG:String = "[Popup]";
		
		private var _delay:uint;
		private var _frameCounter:uint;
		
		private var _originScaleX:Number;
		private var _originScaleY:Number;
		private var _originAlpha:Number;
		
		public function Popup(canvas:Texture)
		{
			if (!canvas)
			{
				trace(TAG + " ctor : No texture.");
				return;
			}
			addComponent(new Image(canvas));
			
			this.pivot = PivotType.CENTER;
			this.visible = false;
			
			_delay = 5;
			_frameCounter = 0;
			
			_originScaleX = this.scaleX;
			_originScaleY = this.scaleY;
			_originAlpha = this.alpha;
		}
		
		public function show():void
		{
			_originScaleX = this.scaleX;
			_originScaleY = this.scaleY;
			_originAlpha = this.alpha;
			
			this.scaleX = 0.01;
			this.scaleY = 0.01;
			this.alpha = 0;
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			this.visible = true;
		}
		
		public function close():void
		{
			this.visible = false;
		}
		
		public function get delay():Number
		{
			return _delay;
		}
		
		public function set delay(value:Number):void
		{
			if (value < 1)
			{
				value = 1;
			}
			_delay = value;
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{
			if (!this.visible)
			{
				return;
			}
			
			_frameCounter++;
				
			if (_frameCounter <= _delay)
			{
				this.scaleX = _originScaleX * _frameCounter / _delay;
				this.scaleY = _originScaleY * _frameCounter / _delay;
				this.alpha = _originAlpha * _frameCounter / _delay;
				
				if (_frameCounter == delay)
				{
					removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
					_frameCounter = 0;
					
					if (parent)
					{
						parent.dispatchEvent(new TrollingEvent(END_SHOW));
					}
				}
			}
		}
	}
}