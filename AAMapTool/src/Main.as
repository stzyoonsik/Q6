package
{
	
	import Select.Select;
	
	import View.View;
	
	import starling.display.Sprite;
	import starling.text.TextField;

	public class Main extends Sprite
	{
		private var _select:Select = new Select();
		private var _view:View = new View();
		
		public function Main()
		{
			addChild(_select);
			
			_view.x = 500;
			addChild(_view);
		}
	}
}