package ui.button
{
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	public class Button extends GameObject
	{
		private const TAG:String = "[Button]";
		private const DEFAULT_SCALE_DOWN_RATIO:Number = 0.9;
		
		private var _scaleDownRatio:Number;
		private var _originScaleX:Number;
		private var _originScaleY:Number;
		
		private var _isOriginScaleXSet:Boolean;
		private var _isOriginScaleYSet:Boolean;
		
		public function Button(texture:Texture)
		{
			if (!texture)
			{
				trace(TAG + " ctor : No texture.");
				return;
			}
			addComponent(new Image(texture));
			
			_scaleDownRatio = DEFAULT_SCALE_DOWN_RATIO;
			_originScaleX = 1.0;
			_originScaleY = 1.0;
			
			_isOriginScaleXSet = false;
			_isOriginScaleYSet = false;
			
			this.pivot = PivotType.CENTER;
			
			addEventListener(TrollingEvent.TOUCH_BEGAN, onBegan);
			addEventListener(TrollingEvent.TOUCH_OUT, onOut);
			addEventListener(TrollingEvent.TOUCH_ENDED, onEnded);
			addEventListener(TrollingEvent.TOUCH_HOVER, onHover);
		}
		
		public override function dispose():void
		{
			removeEventListener(TrollingEvent.TOUCH_BEGAN, onBegan);
			removeEventListener(TrollingEvent.TOUCH_OUT, onOut);
			removeEventListener(TrollingEvent.TOUCH_ENDED, onEnded);
			removeEventListener(TrollingEvent.TOUCH_HOVER, onHover);
			
			super.dispose();
		}
		
		public function get scaleDownRatio():Number
		{
			return _scaleDownRatio;
		}
		
		public function set scaleDownRatio(value:Number):void
		{
			_scaleDownRatio = value;
		}
		
		protected function onBegan(event:TrollingEvent):void
		{
			if (!_isOriginScaleXSet)
			{
				_originScaleX = this.scaleX;
				_isOriginScaleXSet = true;
			}
			
			if (!_isOriginScaleYSet)
			{
				_originScaleY = this.scaleY;
				_isOriginScaleYSet = true;
			}
			
			this.scaleX *= _scaleDownRatio;
			this.scaleY *= _scaleDownRatio;
		}
		
		protected function onOut(event:TrollingEvent):void
		{
			this.scaleX = _originScaleX;
			this.scaleY = _originScaleY;
		}
		
		protected function onEnded(event:TrollingEvent):void
		{
			this.scaleX = _originScaleX;
			this.scaleY = _originScaleY;
		}
		
		protected function onHover(event:TrollingEvent):void
		{
			this.scaleX = _scaleDownRatio;
			this.scaleY = _scaleDownRatio;
		}
	}
}