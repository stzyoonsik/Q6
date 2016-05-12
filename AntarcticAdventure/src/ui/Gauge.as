package ui
{
	import trolling.object.GameObject;
	
	public class Gauge extends GameObject
	{
		protected const DEFAULT_WIDTH:Number = 100;
		protected const DEFAULT_HEIGHT:Number = 10;
		
		protected var _total:Number;
		protected var _current:Number;
		
		public function Gauge()
		{
			_total = 0;
			_current = 0;
		}
		
		public virtual function update(current:Number):void
		{
			// empty
		}
		
		public function get total():Number
		{
			return _total;
		}
		
		public function set total(value:Number):void
		{
			_total = value;
		}
		
		public function get current():Number
		{
			return _current;
		}
		
		public function set current(value:Number):void
		{
			_current = value;
		}
	}
}