package scene.testScene
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.object.Scene;
	import trolling.rendering.Texture;
	import trolling.utils.Color;
	
	import ui.gauge.BarGauge;
	import ui.button.Button;
	import ui.gauge.CursorGauge;
	import ui.Title;

	public class TestScene extends Scene
	{
		[Embed(source="stage_black.png")]
		public static const STAGE:Class;
		
		[Embed(source="01_black.png")]
		public static const ONE:Class;
		
		[Embed(source="setting_orange.png")]
		public static const SETTING:Class;
		
		private var _background:GameObject;
		
		private var _title:Title;
		private var _barGauge:BarGauge;
		private var _cursorGauge:CursorGauge;
		private var _button:Button;
		
		private const HP_MAX:Number = 100;
		private var _currHp:Number;
		
		public function TestScene()
		{
			addEventListener(TrollingEvent.START_SCENE, onInit);
		}
		
		private function onInit(event:Event):void
		{
			var _textures:Dictionary = new Dictionary();
			_textures["3"] = new Texture(new STAGE() as Bitmap);
			var numbers:Vector.<Texture> = new Vector.<Texture>(10);
			for (var name:String in _textures)
			{
				var num:int = int(name);
				numbers.insertAt(int(name), _textures[name]); 
				delete _textures[name];
			}
			
			_background = new GameObject();
			_background.addComponent(new Image(new Texture(new Bitmap(new BitmapData(64, 64, false, Color.GREEN)))));
			_background.width = this.width;
			_background.height = this.height;
			
			var titleRes:Vector.<Texture> = new Vector.<Texture>();
			titleRes.push(new Texture(new STAGE() as Bitmap));
			
			_title = new Title(this.width, this.height, titleRes);
			
			titleRes.pop();
			titleRes.push(new Texture(new ONE() as Bitmap));
			
			_title.addSubTitle(this.width, this.height, titleRes);
						
			//_title.scaleX = 1.5;
			//_title.scaleY = 1.5;
			//_title.isFade = true;
			_title.fadeInterval = 70;
			addChild(_title);
			
			_currHp = HP_MAX;
			_barGauge = new BarGauge(Screen.mainScreen.bounds.width / 4, Screen.mainScreen.bounds.width / 4 * 0.12, 0.95);
			_barGauge.total = HP_MAX;
			addChild(_barGauge);
			
			_cursorGauge = new CursorGauge(Screen.mainScreen.bounds.width / 4, Screen.mainScreen.bounds.width / 4 * 0.12, 0.02);
			_cursorGauge.y = 500;
			_cursorGauge.total = HP_MAX;
			addChild(_cursorGauge);
			
			_button = new Button(new Texture(new SETTING() as Bitmap));
			_button.scaleX = 3;
			_button.scaleY = 3;
			_button.x = this.width - _button.width * 2;
			_button.y += _button.height * 2;
			addChild(_button);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{
			_currHp--;
			_barGauge.update(_currHp);
			_cursorGauge.update(_currHp);
		}
	}
}