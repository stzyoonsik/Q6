package ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import trolling.component.graphic.Image;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.Color;

	public class BarGauge extends Gauge
	{
		private const DEFAULT_BAR_SCALE:Number = 0.9;
		private const BAR:int = 1;
		
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
				bar.visable = false;
			}
		}
	}
}





