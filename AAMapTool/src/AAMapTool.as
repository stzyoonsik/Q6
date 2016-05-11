package
{
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	[SWF(width = "1024", height = "768", backgroundColor = "0xffffcc")]	
	public class AAMapTool extends Sprite
	{
		public function AAMapTool()
		{
			var starling:Starling = new Starling(Main, stage);
			starling.start();
		}
	}
}