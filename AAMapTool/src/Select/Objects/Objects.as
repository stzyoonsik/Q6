package Select.Objects
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Objects extends Sprite
	{
		[Embed(source="ellipseCrater0.png")]
		public static const CraterEllipse:Class;
		
		[Embed(source="flag0.png")]
		public static const Flag:Class;
		
		[Embed(source="home0.png")]
		public static const Home:Class;
		
		[Embed(source="rectCrater0.png")]
		public static const CraterRect:Class;		
		
		private var _homeButton:Button;
		private var _emptyButton:Button;
		private var _ellipseButton:Button;
		private var _rectButton:Button;
		private var _flagButton:Button;
		
		private var objectVector:Vector.<Image> = new Vector.<Image>();
		
		public function Objects()
		{			
			init();
		
		}
		
		private function init():void
		{
			//-1 집
			
			var texture:Texture = Texture.fromEmbeddedAsset(Home);
			_homeButton = new Button(texture);
			addChild(_homeButton);
			
			texture = Texture.fromEmbeddedAsset(CraterEllipse);
			_ellipseButton = new Button(texture);
			_ellipseButton.x = 50;
			_ellipseButton.y = 50;
			addChild(_ellipseButton);
			
//			image = new Image(texture);
//			image.x = 100;
//			image.y = 100;
//			addChild(image);
			
//			texture = Texture.fromEmbeddedAsset(Flag);
//			image = new Image(texture);
//			addChild(image);
//			
//			
//			
//			texture = Texture.fromEmbeddedAsset(CraterRect);
//			image = new Image(texture);
//			addChild(image);
		}
	}
}