package loading
{
	import trolling.event.TrollingEvent;

	public class LoadingEvent extends TrollingEvent
	{
		public static const COMPLETE:String = "completeLoading";
		public static const FAILED:String = "failedLoading";
		public static const PROGRESS:String = "progressLoading";
		
		public function LoadingEvent(type:String, data:Object = null)
		{
			super(type, data);
		}
	}
}