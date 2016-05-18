package loading
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import trolling.component.graphic.Image;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.Color;
	
	import ui.gauge.Gauge;

	public class LoadingBar extends Gauge
	{
		private const DEFAULT_BAR_SCALE:Number = 0.01;
		private const BAR:int = 0;
		
		private var _base:GameObject;
		
		public function LoadingBar(width:Number, height:Number, barScale:Number = DEFAULT_BAR_SCALE,
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
			
			_base = new GameObject();
			var bar:GameObject = new GameObject();
			
			var bitmap:Bitmap = new Bitmap(new BitmapData(width, height, false, baseColor));
			_base.addComponent(new Image(new Texture(bitmap)));
			
			bitmap = new Bitmap(new BitmapData(width, height, false, barColor));
			bar.scaleX = DEFAULT_BAR_SCALE;
			bar.addComponent(new Image(new Texture(bitmap)));
			
			addChild(_base);
			_base.addChild(bar);
		}
		
		public override function update(current:Number):void
		{
			var bar:GameObject = _base.getChild(BAR);
			
			if (!bar || current < 0)
			{
				return;
			}
			
			_current = current;
			
			if (current != 0)
			{
				bar.scaleX = _current / _total;
//				bar.scaleX = 1;
				trace("bar.scaleX = " + bar.scaleX);
			}
		}
	}
}