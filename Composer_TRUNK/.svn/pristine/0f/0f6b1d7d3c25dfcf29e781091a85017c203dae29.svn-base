package comp
{
	import com.greensock.TweenLite;
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.controls.List;
	import mx.events.FlexEvent;
	import mx.managers.FocusManager;
	import mx.managers.WindowedSystemManager;
	
	import it.prodigyt.components.core.PYComponent;
		
	[Event(name="creationComplete", type="mx.events.FlexEvent")] 
	
	public class PCWindowNew extends NativeWindow
	{
		private var systemManager:WindowedSystemManager;
		
		private var windowFlexContainer:Canvas;
		
		private var _dynamicList:List
		private var childrenCreated:Boolean = false;
		
		private var fm:FocusManager 
		
		private var _innerComp:*
			
		private var _enabled:Boolean = true;
		
		private var _originalPosition:Point;
			
		public function PCWindowNew(initOptions:NativeWindowInitOptions = null)
		{
			var options:NativeWindowInitOptions;
			initOptions == null ? options = new NativeWindowInitOptions() : options = initOptions;
			
			super(options);
			
			addEventListener(Event.ACTIVATE, windowActivateHandler);
			addEventListener(NativeWindowBoundsEvent.MOVING, nativeWindowBoundsEventHandler);
			addEventListener(NativeWindowBoundsEvent.RESIZING, nativeWindowBoundsEventHandler);
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.stage.stageFocusRect = null; 
		}
		
		protected function nativeWindowBoundsEventHandler(event:NativeWindowBoundsEvent):void
		{
			var newY:int;
			
			if (event.afterBounds.y + event.afterBounds.height > Screen.mainScreen.visibleBounds.height)
			{
				// Prima sistemiamo la posizione y se è troppo bassa
				newY = Screen.mainScreen.visibleBounds.height - height;
			} else {
				newY = event.afterBounds.y;
			}
			
			_originalPosition = new Point(event.afterBounds.x, newY);
		}
		
		private function windowActivateHandler(event:Event):void 
		{
			event.preventDefault();
			event.stopImmediatePropagation();
			removeEventListener(Event.ACTIVATE, windowActivateHandler);
			if(stage) {
				createChildren();
				stage.addEventListener(Event.RESIZE, windowResizeHandler);
			}
			if (_innerComp)
			{
				if (_innerComp is PYComponent) windowFlexContainer.rawChildren.addChild(_innerComp)
				else windowFlexContainer.addChild(_innerComp)
				_innerComp = null
			}
		}
		
		private function createChildren():void 
		{
			if(!windowFlexContainer) {
				windowFlexContainer = new Canvas();
			}
			
			windowFlexContainer.mouseChildren = enabled;
			windowFlexContainer.mouseEnabled = enabled;

			if(!systemManager) {
				systemManager = new WindowedSystemManager(windowFlexContainer);
			}
			
			stage.addChild(systemManager);
			
			windowFlexContainer.width = stage.stageWidth;
			windowFlexContainer.height = stage.stageHeight;
			
			stage.addChild(windowFlexContainer);
			
			_dynamicList = new List();
			_dynamicList.name = "dynamicList"
			_dynamicList.width = 250
			_dynamicList.percentHeight = 100
			
			if(!fm) {
				fm = new FocusManager(windowFlexContainer)
			}
			
			childrenCreated = true;
			
			windowResizeHandler()
			
			dispatchEvent(new FlexEvent(FlexEvent.CREATION_COMPLETE));
		}
		
		private function windowResizeHandler(event:Event=null):void 
		{
			windowFlexContainer.width = stage.stageWidth;
			windowFlexContainer.height = stage.stageHeight;
			
			// solo quando la window contiene singola grid, o canvas (quando è aperta la dynamiclist non adatta niente)
			if (windowFlexContainer.numChildren==1 && windowFlexContainer.rawChildren.numChildren==1)
			{
				if (title=="Help")
					var cont = windowFlexContainer.rawChildren.getChildAt(0)
				else
					var cont = windowFlexContainer.getChildAt(0)
				
				cont.width = stage.stageWidth;
				cont.height = stage.stageHeight;
			}
			else if (windowFlexContainer.numChildren==2)
			{
				var cont = windowFlexContainer.getChildAt(0)
				var cont1 = windowFlexContainer.getChildAt(1)
				cont1.width = stage.stageWidth - cont.width;
				cont.height = stage.stageHeight;
				cont1.height = stage.stageHeight;
			}
//			// solo quando la window contiene singola grid, o canvas (quando è aperta la dynamiclist non adatta niente)
//			else if (windowFlexContainer.rawChildren.numChildren>0)
//			{
//				var cont = windowFlexContainer.rawChildren.getChildAt(0)
//				cont.width = stage.stageWidth;
//				cont.height = stage.stageHeight;
//			}
			else if (windowFlexContainer.rawChildren.numChildren==2)
			{
				var cont = windowFlexContainer.rawChildren.getChildAt(0)
				var cont1 = windowFlexContainer.rawChildren.getChildAt(1)
				cont1.width = stage.stageWidth - cont.width;
//				cont.height = stage.stageHeight;
//				cont1.height = stage.stageHeight;
			}
			
		}
		
		public function get container():Canvas 
		{
			return windowFlexContainer;
		}
		
		public function get innerComp():* 
		{
			return _innerComp;
		}
		
		public function destroy():void 
		{
			removeEventListener(Event.RESIZE, windowResizeHandler);
			removeEventListener(NativeWindowBoundsEvent.MOVING, nativeWindowBoundsEventHandler);
			removeEventListener(NativeWindowBoundsEvent.RESIZING, nativeWindowBoundsEventHandler);
			windowFlexContainer.removeAllChildren();
			stage.removeChild(windowFlexContainer);
			stage.removeChild(systemManager);
			windowFlexContainer = null;
			systemManager = null;
			fm = null
		}

		public function get dynamicList():List
		{
			return _dynamicList;
		}

		public function showDynamicList():void
		{
			// TODO: Sostituire il numero magico 16 dei bordi nativeWindow 
			//	per il valore ottenuto come utilityChromeWidth
			
			
			// MAD 2015-04-29: Si assicura che la prima volta che parte il showDynamicList 
			//	abbia un ponto di riferimento della posizione originale
			if (x + width + dynamicList.width > Screen.mainScreen.visibleBounds.width) 
			{
				if (y + height > Screen.mainScreen.visibleBounds.height)
				{
					// Prima sistemiamo la posizione y se è troppo bassa
					y = Screen.mainScreen.visibleBounds.height - height;
				}
				_originalPosition = new Point(x,y);
			}

			if (_innerComp) 
			{
				windowFlexContainer.rawChildren.addChild(_innerComp)
				_innerComp.x = windowFlexContainer.getChildAt(0).width
				width = _innerComp.x + _innerComp.width + 16  // bordi nativeWindow
			}
			else if (_dynamicList) 
			{
				windowFlexContainer.addChild(_dynamicList)
				dynamicList.x = windowFlexContainer.getChildAt(0).width
				width = dynamicList.x + dynamicList.width + 16  // bordi nativeWindow
			}

			// MAD 2015-04-29: Sistemazione redimensionamento fuori dell'area visibile dello schermo
			if ((x + width) > Screen.mainScreen.visibleBounds.width)
			{
				x = Screen.mainScreen.visibleBounds.width - width;
			}
			
			windowResizeHandler()
		}
		
		public function hideDynamicList():void
		{
			if (_innerComp)
			{
				windowFlexContainer.rawChildren.removeChild(_innerComp)
				_innerComp=null;
			}
			if (_dynamicList && _dynamicList.stage) windowFlexContainer.removeChild(_dynamicList)
			
			width = windowFlexContainer.getChildAt(0).width+16

			// MAD 2015-04-29: Sistemazione redimensionamento fuori dell'area visibile dello schermo
			if ((x + width) > Screen.mainScreen.visibleBounds.width)
			{
				// Può capitare se hanno spostato la finestra manualmente
				x = Screen.mainScreen.visibleBounds.width - width;
			} else {
				if (_originalPosition)
				{
					// Si era spostata a sinistra nella showDynamicList 
					//	per farla stare entro l'area visible dello schermo,
					//	adesso la rispostiamo dov'era.
					x = _originalPosition.x;
					y = _originalPosition.y;
				}
			}

			windowResizeHandler()
		}
		
		public function addContent(obj:*)
		{
			if (windowFlexContainer && !( obj is PYComponent )) windowFlexContainer.addChild(obj)
			else _innerComp = obj

			
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if (windowFlexContainer)
			{
				windowFlexContainer.mouseChildren = value;
				windowFlexContainer.mouseEnabled = value;
			}
		}

	}
}