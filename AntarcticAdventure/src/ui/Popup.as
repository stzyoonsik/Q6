package ui
{
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	/**
	 * Popup 틀래스입니다. 호출 시 점점 커지며 나타나도록 연출되었습니다. 
	 * @author user
	 * 
	 */
	public class Popup extends GameObject
	{
		public static const END_SHOW:String = "endShow";
		
		private const TAG:String = "[Popup]";
		
		private var _delay:uint;
		private var _frameCounter:uint;
		
		private var _originScaleX:Number;
		private var _originScaleY:Number;
		private var _originAlpha:Number;
		
		/**
		 * Popup을 생성합니다. 기본적으로 visible = false 상태입니다. 
		 * @param canvas Popup으로 표시될 Texture입니다.
		 * 
		 */
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
		
		/**
		 * Popup을 표시합니다. 
		 * 
		 */
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
		
		/**
		 * Popup을 닫습니다. 
		 * 
		 */
		public function close():void
		{
			this.visible = false;
		}
		
		/**
		 * Popup이 표시되는 데에 걸리는 프레임 수입니다.
		 * @return 
		 * 
		 */
		public function get delay():uint
		{
			return _delay;
		}
		
		/**
		 * Popup이 표시되는 데에 걸리는 프레임 수입니다. 값이 클수록 부드럽고 느리게 나타납니다.
		 * @param value Popup의 delay입니다. 최솟값은 1이며 기본값은 5입니다.
		 * 
		 */
		public function set delay(value:uint):void
		{
			if (value < 1)
			{
				value = 1;
			}
			_delay = value;
		}
		
		/**
		 * Popup에 show를 호출할 경우 프레임 수를 카운트하여 Popup의 크기를 조정합니다. 
		 * @param event TrollingEvent.ENTER_FRAME
		 * Popup의 parent는 Popup.END_SHOW 이벤트를 수신하여 Popup의 표시가 끝나는 시점을 파악할 수 있습니다.
		 */
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