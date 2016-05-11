package Select
{
	import Select.Objects.Objects;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class Select extends Sprite
	{
		
		private var _Objects:Objects = new Objects();
		
		public function Select()
		{
			addChild(_Objects);
		}
	}
}