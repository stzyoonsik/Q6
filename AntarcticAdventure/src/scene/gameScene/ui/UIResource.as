package scene.gameScene.ui
{
	import flash.filesystem.File;

	public final class UIResource
	{
		public static const DIRECTORY:String = File.applicationDirectory.resolvePath("resources/ui/ingameUi").url;
		public static const INGAME_TEXT:String = "ingameText";
		public static const HEART:String = "heart";
		public static const SLASH:String = "slash";
		public static const SETTING_ICON:String = "settingIcon";
		public static const BACKGROUND:String = "background";
		public static const STAGE:String = "stage";
		public static const SETTING_POPUP:String = "settingPopup";
		public static const STAGE_CLEARED_POPUP:String = "stageClearedPopup";
		public static const STAGE_FAILED_POPUP:String = "stageFailedPopup";
	}
}