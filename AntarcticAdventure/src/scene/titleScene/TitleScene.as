package scene.titleScene
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import loading.Loading;
	import loading.LoadingEvent;
	import loading.Resources;
	
	import trolling.component.animation.Animator;
	import trolling.component.animation.State;
	import trolling.component.graphic.Image;
	import trolling.core.SceneManager;
	import trolling.event.TrollingEvent;
	import trolling.media.Sound;
	import trolling.media.SoundManager;
	import trolling.object.GameObject;
	import trolling.object.Scene;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	public class TitleScene extends Scene
	{	
		private var _resource:Resources;
		private var _backGround:GameObject;
		private var _backGroundAnimator:Animator;
		private var _imageDir:File = File.applicationDirectory.resolvePath("scene/titleScene");
		private var _soundDir:File = File.applicationDirectory.resolvePath("scene/titleScene");
		private var _eventDispatcher:IEventDispatcher;
		
		public function TitleScene()
		{
			this.addEventListener(TrollingEvent.START_SCENE, onInit);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		private function onTouchKeyBoard(event:KeyboardEvent):void
		{
			trace(event.keyCode);
			//			if(event.keyCode == 8)
			if(event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				var dialog:DialogExtension = new DialogExtension(_eventDispatcher);
				//dialog.showInputDialog("input ID" , onInput);
				dialog.showAlertDialog("종료하시겠습니까?");
			}
		}
		
		
		private function onInit(event:Event):void
		{
			_resource = new Resources(null, _soundDir, _imageDir);
			
			_resource.addImageName("title.png");
			_resource.addImageName("touchToStart.png");
			_resource.addImageName("LoadImage.png");
			_resource.addSoundName("Opening.mp3");
			
			_resource.addEventListener(LoadingEvent.COMPLETE, onCompleteLoad);
			_resource.addEventListener(LoadingEvent.FAILED, onFailedLoad);
			_resource.loadResource();
		}
		
		private function onFailedLoad(event:LoadingEvent):void
		{
			trace(event.data as String);
			Resources(event.currentTarget).removeEventListener(LoadingEvent.COMPLETE, onCompleteLoad);
			Resources(event.currentTarget).removeEventListener(LoadingEvent.FAILED, onFailedLoad);
		}
		
		private function onCompleteLoad(event:LoadingEvent):void
		{
			Resources(event.currentTarget).removeEventListener(LoadingEvent.COMPLETE, onCompleteLoad);
			Resources(event.currentTarget).removeEventListener(LoadingEvent.FAILED, onFailedLoad);
			
			Loading.createLoadImage(_resource.getImageFile("LoadImage.png"));
			
			_backGround = new GameObject();
			_backGround.addEventListener(TrollingEvent.TOUCH_ENDED, onTouch);

			_backGround.pivot = PivotType.CENTER;
			_backGround.x = this.width / 2;
			_backGround.y = this.height / 2;
			_backGround.addComponent(new Image(_resource.getImageFile("title.png")));
			
			// add
			var bitmapData:BitmapData = new BitmapData(10, 10);
			var ct:ColorTransform = new ColorTransform();
			ct.alphaMultiplier = 0; 
			bitmapData.colorTransform(new Rectangle(0, 0, bitmapData.width, bitmapData.height), ct);
			
			var message:GameObject = new GameObject();
			message.pivot = PivotType.CENTER;
			message.y = this.height / 4;
			
			var state:State = new State("title");
			state.addFrame(_resource.getImageFile("touchToStart.png"));
			state.addFrame(new Texture(new Bitmap(bitmapData)));
			state.isLoop = true;
			state.interval = 20;
			
			var animator:Animator = new Animator();
			animator.addState(state);
			
			message.addComponent(animator);
			message.width *= 0.7;
			message.height *= 0.7;
			message.addEventListener(TrollingEvent.TOUCH_ENDED, onBubble);
			_backGround.addChild(message);
			
			_backGround.width = this.width;
			_backGround.height = this.height;
			
			addChild(_backGround);
			
			var sound:Sound = _resource.getSoundFile("Opening.mp3");
			if (sound)
			{
				sound.volume = 0.5;
				sound.loops = Sound.INFINITE;
				SoundManager.addSound("Opening.mp3", sound);
				SoundManager.play("Opening.mp3");
			}
			_resource.dispose();
		}
		
		private function onBubble(event:TrollingEvent):void
		{
			if(GameObject(event.currentTarget).parent != null)
				GameObject(event.currentTarget).parent.dispatchEvent(new TrollingEvent(event.type, event.data));
		}
		
		private function onTouch(event:TrollingEvent):void
		{
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
			SceneManager.switchScene("stageSelect");
		}
	}
}