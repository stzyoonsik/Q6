package ui.button
{
	import trolling.component.ComponentType;
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.rendering.Texture;

	public class SelectButton extends Button
	{
		private const TAG:String = "[SelectButton]";
		private const DEFAULT:int = 0;
		private const SELECTED:int = 1;
		
		protected var _isSelected:Boolean;
		private var _textures:Vector.<Texture>;
		
		public function SelectButton(defaultTexture:Texture, selectedTexture:Texture)
		{
			super(defaultTexture);
			
			if (!selectedTexture)
			{
				trace(TAG + " ctor : No texture.");
				return;
			}
			
			_textures = new Vector.<Texture>();
			_textures.push(defaultTexture);
			_textures.push(selectedTexture);
			
			_isSelected = false;
		}
		
		public override function dispose():void
		{			
			_isSelected = false;
			
			if (_textures)
			{
				for (var i:int = 0; i < _textures.length; i++)
				{
					_textures[i] = null;
				}
			}
			_textures = null;
			
			super.dispose();
		}
		
		protected override function onEnded(event:TrollingEvent):void
		{
			super.onEnded(event);

			if (_isSelected)
			{
				deselect();
			}
			else
			{
				select();
			}
		}

		public function get isSelected():Boolean
		{
			return _isSelected;
		}

		public function set isSelected(value:Boolean):void
		{
			if (value)
			{
				select();
			}
			else
			{
				deselect();
			}
		}
		
		protected function select():void
		{
			_isSelected = true;
			
			var image:Image = this.components[ComponentType.IMAGE];
			if (!image)
			{
				return;
			}
			image.texture = _textures[SELECTED];
		}
		
		protected function deselect():void
		{
			_isSelected = false;
			
			var image:Image = this.components[ComponentType.IMAGE];
			if (!image)
			{
				return;
			}
			image.texture = _textures[DEFAULT];
		}
	}
}