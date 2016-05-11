package
{
	
	import starling.display.Sprite;
	import starling.text.TextField;
	import Select.Select;

	public class Main extends Sprite
	{
		private var _select:Select = new Select();
		public function Main()
		{
			addChild(_select);
		}
	}
}