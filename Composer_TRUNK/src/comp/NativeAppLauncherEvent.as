package comp
{
	import flash.events.Event;
	
	public class NativeAppLauncherEvent extends Event
	{
		public static const EXECUTED:String = "executed";
		
		public var exitCode:Number
		
		public function NativeAppLauncherEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}