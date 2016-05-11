package Select
{
	import Select.Background.Background;
	import Select.Objects.Objects;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class Select extends Sprite
	{
		
		private var _objects:Objects = new Objects();
		private var _background:Background = new Background();
		
		public function Select()
		{
			_objects.x = 50;
			_objects.y = 50;
			addChild(_objects);
			
			_background.y = 400;
			addChild(_background);
		}
	}
}