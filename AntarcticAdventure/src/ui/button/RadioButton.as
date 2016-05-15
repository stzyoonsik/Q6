package ui.button
{
	import trolling.event.TrollingEvent;
	import trolling.rendering.Texture;

	public class RadioButton extends SelectButton
	{
		private var _id:int;
		private var _onSelected:Function;
		
		public function RadioButton(defaultTexture:Texture, selectedTexture:Texture)
		{
			super(defaultTexture, selectedTexture);
			
			_id = -1;
			_onSelected = null;
		}
		
		public override function dispose():void
		{
			_id = -1;
			_onSelected = null;
			
			super.dispose();
		}
		
		protected override function onEnded(event:TrollingEvent):void
		{
			var isSelectedBefore:Boolean = _isSelected;
			
			super.onEnded(event);
			
			if (_isSelected || isSelectedBefore)
			{
				_onSelected(_id);
			}
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function set onSelected(value:Function):void
		{
			_onSelected = value;
		}
	}
}