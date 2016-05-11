package ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import trolling.component.graphic.Image;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.Color;

	public class CursorGauge extends Gauge
	{
		private const DEFAULT_CURSOR_SCALE:Number = 0.05;
		private const BASE:int = 0;
		private const CURSOR:int = 1;
		
		public function CursorGauge(width:Number, height:Number, cursorScale:Number = DEFAULT_CURSOR_SCALE, baseColor:uint = Color.SILVER, cursorColor:uint = Color.BLACK)
		{
			if (width <= 0)
			{
				this.width = DEFAULT_WIDTH;
			}
			
			if (height <= 0)
			{
				this.height = DEFAULT_HEIGHT;
			}
			
			var base:GameObject = new GameObject();
			var cursor:GameObject = new GameObject();
			
			var bitmap:Bitmap = new Bitmap(new BitmapData(width, height, false, baseColor));
			base.addComponent(new Image(new Texture(bitmap)));
			
			bitmap = new Bitmap(new BitmapData(width * cursorScale, height, false, cursorColor));
			cursor.x = -(width * cursorScale / 2);
			cursor.addComponent(new Image(new Texture(bitmap)));
			
			addChild(base);
			addChild(cursor);
		}
		
		public override function update(current:Number):void
		{
			var base:GameObject = getChild(BASE);
			var cursor:GameObject = getChild(CURSOR);
			
			if (!cursor || current < 0)
			{
				return;
			}
			
			_current = current;
			
			if (current != 0)
			{
				cursor.x = base.width - (base.width * _current / _total) - (cursor.width / 2);
			}
			else
			{
				cursor.x = base.width - (cursor.width / 2);
			}
		}
	}
}