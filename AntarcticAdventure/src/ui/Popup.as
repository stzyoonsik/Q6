package ui
{
	import trolling.component.graphic.Image;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	public class Popup extends GameObject
	{
		private const TAG:String = "[Popup]";
		protected const CANVAS:int = 0;
		
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
		}
		
		public function show():void
		{
			this.visible = true;
		}
		
		public function close():void
		{
			this.visible = false;
		}
	}
}