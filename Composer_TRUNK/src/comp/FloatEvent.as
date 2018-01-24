package comp
{
	import flash.events.Event;
	
	public class FloatEvent extends Event
	{
		public static const FLOAT_END = "float_end";
		public static const FLOAT_START = "float_start";
		public var object:Object
		
		public function FloatEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return this
		}
	}
}