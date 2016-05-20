package ui.button
{
	import trolling.event.TrollingEvent;
	import trolling.rendering.Texture;

	/**
	 * 복수의 버튼이 하나의 선택값을 가지는 라디오 버튼 클래스입니다. RadioButtonManager에 등록하여 사용합니다. 
	 * @author user
	 * 
	 */
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

		/**
		 * 선택되었을 경우 호출하는 RadioButtonManager의 함수입니다.
		 * @param value
		 *
		 */
		public function set onSelected(value:Function):void
		{
			_onSelected = value;
		}
	}
}