package ui.button
{
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	/**
	 * 버튼 클래스입니다. 터치 시 크기가 작아졌다 다시 커지도록 연출되었습니다. 
	 * @author user
	 * 
	 */
	public class Button extends GameObject
	{
		private const TAG:String = "[Button]";
		
		private var _originScaleX:Number;
		private var _originScaleY:Number;
		private var _isOriginScaleXSet:Boolean;
		private var _isOriginScaleYSet:Boolean;
		
		private var _downScaleX:Number;
		private var _downScaleY:Number;
		private var _scaleDownRatio:Number;
		
		public function Button(texture:Texture)
		{
			if (!texture)
			{
				trace(TAG + " ctor : No texture.");
				return;
			}
			addComponent(new Image(texture));
			
			_scaleDownRatio = 0.9;
			_originScaleX = 1.0;
			_originScaleY = 1.0;
			_downScaleX = _originScaleX * _scaleDownRatio;
			_downScaleY = _originScaleY * _scaleDownRatio;
			
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
		
		/**
		 * 터치 시 작아지는 비율입니다. 0에서 1 사이 값이며 기본값은 0.9입니다. 
		 * @return 
		 * 
		 */
		public function get scaleDownRatio():Number
		{
			return _scaleDownRatio;
		}
		
		/**
		 * 터치 시 작아지는 비율입니다. 0에서 1 사이 값이며 기본값은 0.9입니다.
		 * @param value
		 * 
		 */
		public function set scaleDownRatio(value:Number):void
		{
			_scaleDownRatio = value;
		}
		
		protected function onHover(event:TrollingEvent):void
		{
			if (!_isOriginScaleXSet)
			{
				_originScaleX = this.scaleX;
				_downScaleX = _originScaleX * _scaleDownRatio;
				
				_isOriginScaleXSet = true;
			}
			
			if (!_isOriginScaleYSet)
			{
				_originScaleY = this.scaleY;
				_downScaleY = _originScaleY * _scaleDownRatio;
				
				_isOriginScaleYSet = true;
			}
			
			this.scaleX = _downScaleX;
			this.scaleY = _downScaleY;
		}
		
		protected function onBegan(event:TrollingEvent):void
		{
			if (!_isOriginScaleXSet)
			{
				_originScaleX = this.scaleX;
				_downScaleX = _originScaleX * _scaleDownRatio;
				
				_isOriginScaleXSet = true;
			}
			
			if (!_isOriginScaleYSet)
			{
				_originScaleY = this.scaleY;
				_downScaleY = _originScaleY * _scaleDownRatio;
				
				_isOriginScaleYSet = true;
			}
			
			this.scaleX = _downScaleX;
			this.scaleY = _downScaleY;
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
	}
}