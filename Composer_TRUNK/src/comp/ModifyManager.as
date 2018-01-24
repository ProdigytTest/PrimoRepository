package comp
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ModifyManager extends EventDispatcher
	{
		private var winConverted:PCWindow
		public function ModifyManager(wc:PCWindow)
		{
			super();
			winConverted =wc
		}
	}
}