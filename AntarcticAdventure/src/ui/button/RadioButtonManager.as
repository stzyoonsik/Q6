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
				else if (button.id == _selectedId) // 제거하려는 버튼이 선택된 버튼이었을 경우 선택 버튼 자동 조정
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