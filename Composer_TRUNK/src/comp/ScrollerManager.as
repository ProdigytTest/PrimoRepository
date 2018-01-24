package comp
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.controls.scrollClasses.ScrollThumb;
	import mx.core.Container;
	import mx.core.UIComponent;
	import flash.events.EventDispatcher;
	
	public class ScrollerManager extends EventDispatcher
	{
		// ----------------------------------------------------
		// Zone Manager
		// ----------------------------------------------------	
		
		static private var mapInstances:Dictionary = new Dictionary(true);
		static private var callBack:Function
		
		static public function addContainer (container:Container, callback:Function):void
		{
			mapInstances[container] = new ScrollerManager(container);
			callBack =callback
		}
		
		static public function getInstance (container:Container):Container
		{
			return mapInstances[container] 
		}
		
		static public function removeContainer (container:Container):void
		{
			(mapInstances[container] as ScrollerManager).dispose()

		}			
		
		// ----------------------------------------------------
		// Zone instance
		// ----------------------------------------------------
		
			// Container target
				private var container:Container;
		
			// Settings for the effects
				private var d0:int;
        		private var mouseOffset:Point;
        		private var scrollOffset:Point;
	        	private var deltaPosition:Point;
        		
        		private var speed = 1
        		private var calcSpeed = 1
        		private var friction = 3
        		
        		
	        	public var factorDesacceleration:uint = 20;
        		public var factorAcceleration:uint = 200;
        
        		private var timerRefresh:Timer;
        		
        		private var flagEF:Boolean = false
        
        	// Flag meaning if the mouse is pressed
        		private var isMouseDown:Boolean = false;
        	        
        	// Constructor
				public function ScrollerManager(container:Container)
				{
					this.container = container;
					
					container.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
					//container.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);	
					container.addEventListener(MouseEvent.MOUSE_WHEEL, whee)
					
				}
			
			private function whee(e:MouseEvent):void
			{	
				container.removeEventListener(Event.ENTER_FRAME, onTick, false);
				flagEF = false	
			}
				
			// Destructor
				public function dispose():void
				{
					container.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					container.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);	
					container.removeEventListener(MouseEvent.ROLL_OUT, onMouseUp);					
					
					deltaPosition = null;
				}	
			
			// Mouse Down event: Check if the target is not the scrollbar
				private var listenerAdded:Boolean = false
				private var lastMouseType
				private var dispatch:Boolean = false
				
				private function onMouseDown(event:MouseEvent):void
				{
					if (!listenerAdded)
					{
						listenerAdded = true
						container.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);	
						container.addEventListener(MouseEvent.ROLL_OUT, onMouseUp, false, 0, true);		
					}
					if (!flagEF)
					{
						flagEF = true
						container.addEventListener(Event.ENTER_FRAME, onTick, false, 0, true);	
					}
					
					if (!(event.target is ScrollThumb))
					{
						isMouseDown = true;	
						calcSpeed = 0
						d0 = (new Date()).getTime();
						friction = 2	
						deltaPosition = new Point(0,0);		
			            mouseOffset = new Point(container.stage.mouseX,container.stage.mouseY);	
			            scrollOffset = new	Point(container.horizontalScrollPosition,container.verticalScrollPosition);	            
		   				lastMouseType = event.type
		   				dispatch = true
		   			}
		        }
        
        	// Mouse up event
	        private function onMouseUp (event:MouseEvent):void 
	        {
			if	(  lastMouseType == MouseEvent.MOUSE_UP
				|| lastMouseType == MouseEvent.ROLL_OUT )
				{
					return
				}
					
				isMouseDown = false;
				
				
				
				
				var dt:int = (new Date()).getTime() - d0;
				if (deltaPosition && ( Math.abs(deltaPosition.x)>0 || Math.abs(deltaPosition.y)> 0 ) )
					var velocita  = new Point(factorAcceleration*deltaPosition.x/dt,factorAcceleration*deltaPosition.y/dt);
	         	else
	         		var velocita  = new Point(0,0);
	         	var aa = velocita.x
	         	calcSpeed  = velocita.y
	         	friction = 15
	         	lastMouseType = event.type
	        }
        	        
        	// Calcul
	 		private function onTick (e:Event):void 
	 		{		
	 			
	 			if (isMouseDown)
	 				deltaPosition = 
	 				new Point(mouseOffset.x - container.stage.mouseX  ,mouseOffset.y - container.stage.mouseY );

		     	container.verticalScrollPosition   += ( (scrollOffset.y + deltaPosition.y+calcSpeed ) - container.verticalScrollPosition ) / friction
	            container.horizontalScrollPosition += ( (scrollOffset.x + deltaPosition.x+calcSpeed ) - container.horizontalScrollPosition ) / friction
	            
	            //costraints
	            if (container.verticalScrollPosition<100) 
	            {
	            	friction = 3
	            	//container.verticalScrollPosition = 0  
	            }
	            if (container.verticalScrollPosition>container.maxVerticalScrollPosition-100) 
	            {
	            	friction = 3
	            	//container.verticalScrollPosition = container.maxVerticalScrollPosition  
	            }
	            	
	            
	            if (container.verticalScrollPosition<0) container.verticalScrollPosition = 0  
	            if (container.verticalScrollPosition>container.maxVerticalScrollPosition) 
	            	container.verticalScrollPosition = container.maxVerticalScrollPosition  
		     	
		     	if (dispatch && container.verticalScrollPosition==container.maxVerticalScrollPosition)
		     	{
		     		dispatch=false
		     		if (callBack!=null) callBack.call(this)
		     	}
	 			if (!isMouseDown)
	 			{
					if ( Math.abs( container.verticalScrollPosition - ( scrollOffset.y + deltaPosition.y ) ) <.3 )
					//&&   Math.abs( container.horizontalScrollPosition - ( scrollOffset.x + deltaPosition.x ) ) <.1 )
					{
						container.removeEventListener(Event.ENTER_FRAME, onTick, false);
						flagEF = false	
					}	 
		     	}
	 			
	           // for each (var item:UIComponent in container.getChildren())
	           //{
	           // 	item.invalidateSize();
	           // }
	        }
	}
}