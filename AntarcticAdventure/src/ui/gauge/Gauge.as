package ui.gauge
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
		
		/**
		 * Gauge로 나타내고자 하는 항목의 최대값입니다. 
		 * @return 
		 * 
		 */
		public function get total():Number
		{
			return _total;
		}
		
		/**
		 * Gauge로 나타내고자 하는 항목의 최대값입니다.
		 * @param value
		 * 
		 */
		public function set total(value:Number):void
		{
			_total = value;
		}
		
		/**
		 * Gauge로 나타내고자 하는 항목의 현재값입니다. 
		 * @return 
		 * 
		 */
		public function get current():Number
		{
			return _current;
		}
		
		/**
		 * Gauge로 나타내고자 하는 항목의 현재값입니다. 
		 * @param value
		 * 
		 */
		public function set current(value:Number):void
		{
			_current = value;
		}
	}
}