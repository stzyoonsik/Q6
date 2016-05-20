package ui.button
{
	public class RadioButtonManager
	{
		private const TAG:String = "[RadioButtonManager]";
		private const NONE:int = -1;
		
		private var _buttons:Vector.<RadioButton>;
		private var _selectedId:int;
		
		public function RadioButtonManager()
		{
			_buttons = null;
			_selectedId = NONE;
		}
		
		public function dispose():void
		{
			_buttons = null;
			_selectedId = NONE;
		}
		
		/**
		 * RadioButton을 추가합니다. 최초로 추가된 버튼은 자동 선택 처리됩니다. 
		 * @param button 추가하고자 하는 RadioButton입니다.
		 * 
		 */
		public function addButton(button:RadioButton):void
		{
			if (!button)
			{
				trace(TAG + " addButton : No button.");
				return;
			}
			
			if (!_buttons)
			{
				_buttons = new Vector.<RadioButton>();
			}
			button.id = _buttons.length;
			button.onSelected = onSelected;
			_buttons.push(button);
			
			if (_buttons.length == 1)
			{
				_buttons[0].isSelected = true;
				_selectedId = 0;
			}
		}
		
		/**
		 * 등록된 RadioButton을 제거합니다. 현재 선택 상태인 버튼을 제거할 경우 첫 번째 인덱스의 버튼이 자동 선택됩니다. 
		 * @param button 제거하고자 하는 RadioButton입니다.
		 * 
		 */
		public function removeButton(button:RadioButton):void
		{
			if (!button || !_buttons)
			{
				if (!button) trace(TAG + " removeButton : No button.");
				if (!_buttons) trace(TAG + " removeButton : No added button.");
				return;
			}
			
			var index:int = _buttons.indexOf(button);
			if (index != NONE)
			{
				_buttons.removeAt(index);
				
				if (button.id < _selectedId)
				{
					_selectedId--;
				}
				else if (button.id == _selectedId)
				{
					if (_buttons[0])
					{
						_selectedId = 0;
						_buttons[_selectedId].isSelected = true;
					}
					else
					{
						_selectedId = NONE;
					}
				}
			}
			else
			{
				trace(TAG + " removeButton : Not added button.");
			}
		}
		
		public function selectButton(id:int):void
		{
			onSelected(id);
		}

		/**
		 * 기존에 선택 상태였던 버튼을 선택 해제 처리합니다. 
		 * @param id 선택된 RadioButton의 ID입니다.
		 * 선택된 RadioButton이 호출하는 함수입니다.
		 */
		private function onSelected(id:int):void
		{
			if (id < 0)
			{
				return;
			}
			
			if (_buttons)
			{
				if (id == _selectedId)
				{
					_buttons[_selectedId].isSelected = true;
					return;
				}
				
				if (_selectedId != NONE)
				{
					_buttons[_selectedId].isSelected = false;	
				}
				
				_selectedId = id;
				_buttons[_selectedId].isSelected = true;
			}
		}
	}
}