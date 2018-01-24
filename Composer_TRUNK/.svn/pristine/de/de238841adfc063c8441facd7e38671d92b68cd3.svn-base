package comp
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import it.prodigyt.components.core.PYComponent;
	
	import mx.containers.Canvas;
	import mx.controls.List;
	import mx.events.FlexEvent;
	import mx.managers.FocusManager;
	import mx.managers.WindowedSystemManager;
	
	[Event(name="creationComplete", type="mx.events.FlexEvent")] 
	
	public class PCWindowAS extends NativeWindow
	{

		
		private var windowFlexContainer:Canvas;
		
		private var _dynamicList:List
		private var childrenCreated:Boolean = false;
		
 
		
		private var _innerComp:*
			
		public function PCWindowAS(initOptions:NativeWindowInitOptions = null)
		{
			var options:NativeWindowInitOptions;
			initOptions == null ? options = new NativeWindowInitOptions() : options = initOptions;
			
			super(options);
			
			addEventListener(Event.ACTIVATE, windowActivateHandler);
			stage.scaleMode = StageScaleMode.NO_SCALE
		}
		
		private function windowActivateHandler(event:Event):void {
			event.preventDefault();
			event.stopImmediatePropagation();
			removeEventListener(Event.ACTIVATE, windowActivateHandler);

			if (_innerComp)
			{
				if (_innerComp is PYComponent) stage.addChild(_innerComp)
				else stage.addChild(_innerComp)
				_innerComp = null
			}
		}
		

	
		
		public function get container():Canvas {
			return windowFlexContainer;
		}
		
		public function get innerComp():* {
			return _innerComp;
		}
		
		public function destroy():void {
			stage.removeChild(_innerComp)
			_innerComp = null
		}

		public function get dynamicList():List
		{
			return _dynamicList;
		}


		
		public function addContent(obj:*)
		{
			stage.addChild(obj)
			_innerComp = obj
		}

	}
}