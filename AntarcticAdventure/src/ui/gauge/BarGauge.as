package ui.gauge
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import trolling.component.graphic.Image;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.Color;

	/**
	 * 가득 찬 상태에서 줄어드는 형태의 BarGauge입니다. (ex. HP 바) 
	 * @author user
	 * 
	 */
	public class BarGauge extends Gauge
	{
		private const DEFAULT_BAR_SCALE:Number = 0.9;
		private const BAR:int = 1;
		
		/**
		 * BarGauge를 생성합니다. 
		 * @param width Gauge의 너비입니다.
		 * @param height Gauge의 높이입니다.
		 * @param barScale Gauge의 크기에 대한 Bar 크기의 비율입니다. 0과 1 사이의 값이며 기본값은 0.9입니다.
		 * @param baseColor 바탕 색상입니다. 기본값은 Silver입니다.
		 * @param barColor Bar의 색상입니다. 기본값은 Lime입니다.
		 * 
		 */
		public function BarGauge(width:Number, height:Number, barScale:Number = DEFAULT_BAR_SCALE,
								 baseColor:uint = Color.SILVER, barColor:uint = Color.LIME)
		{
			if (width <= 0)
			{
				this.width = DEFAULT_WIDTH;
			}
			
			if (height <= 0)
			{
				this.height = DEFAULT_HEIGHT;
			}
			
			if (barScale <= 0 || barScale > 1)
			{
				barScale = DEFAULT_BAR_SCALE;
			}
			
			var base:GameObject = new GameObject();
			var bar:GameObject = new GameObject();
			
			var bitmap:Bitmap = new Bitmap(new BitmapData(width, height, false, baseColor));
			base.addComponent(new Image(new Texture(bitmap)));
			
			bitmap = new Bitmap(new BitmapData(width * barScale, height * barScale, false, barColor));
			bar.x = width * (1 - barScale) / 2;
			bar.y = height * (1 - barScale) / 2;
			bar.addComponent(new Image(new Texture(bitmap)));
			
			addChild(base);
			addChild(bar);
		}
		
		/**
		 * Bar의 크기를 update합니다. 
		 * @param current Gauge로 나타내고자 하는 항목의 현재값입니다.
		 * 
		 */
		public override function update(current:Number):void
		{
			var bar:GameObject = getChild(BAR);
			
			if (!bar || current < 0)
			{
				return;
			}
			
			_current = current;
			
			if (current != 0)
			{
				bar.scaleX = _current / _total;
			}
			else
			{
				bar.visible = false;
			}
		}
	}
}





