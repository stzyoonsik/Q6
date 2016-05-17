package scene.gameScene.ui
{
	import flash.filesystem.File;

	public final class UIResource
	{
		public static const DIRECTORY:String = File.applicationDirectory.resolvePath("scene/gameScene/sprite").url;
		public static const SPRITE:String = "gameSceneUiSprite0.png";
		
		public static const FIELD:String = "field";
		public static const HEART:String = "heart";
		public static const SLASH:String = "slash";
		public static const SETTING_ICON:String = "setting_icon";
		public static const STAGE:String = "stage";
		public static const BACKGROUND:String = "background";
		public static const SETTING_POPUP:String = "setting_popup";
		public static const CHECK:String = "check";
		public static const SCREEN_WHITE:String = "screen_white";
		public static const SCREEN_ORANGE:String = "screen_orange";
		public static const BUTTON_WHITE:String = "button_white";
		public static const BUTTON_ORANGE:String = "button_orange";
		public static const CLEARED_POPUP:String = "cleared";
		public static const FAILED_POPUP:String = "failed";
		public static const REPLAY:String = "replay";
		public static const MENU:String = "menu";
		public static const NEXT_WHITE:String = "next_white";
		public static const NEXT_GRAY:String = "next_gray";
		public static const STAR:String = "star";
		public static const FILLED_STAR:String = "star_filled";
	}
}