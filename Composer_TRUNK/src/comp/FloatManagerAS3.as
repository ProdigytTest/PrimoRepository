package comp
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.controls.Image;
	import mx.core.Container;
	import flash.display.Sprite;
	import mx.controls.scrollClasses.ScrollThumb;
	
	public class FloatManagerAS3
	{
		// ----------------------------------------------------
		// Zone Manager
		// ----------------------------------------------------	
		
		static private var mapInstances:Dictionary = new Dictionary(true);
		
		static public function addFloat (float:Sprite, anchor:Point=null, color=null, f:Function=null):void
		{
			mapInstances[float] = new FloatManagerAS3(float,anchor,color,f);
		}
		
		static public function removeFloat (float:Sprite):void
		{
			mapInstances[float].dispose()
			mapInstances[float]  = null
		}			
		
		// ----------------------------------------------------
		// Zone instance
		// ----------------------------------------------------
		
			// Container target

				private var float:Sprite;
				private var floatImg:Image
		
			// Settings for the effects
				private var last_X:Number = 0;
				private var last_Y:Number = 0;
				private var velocity_X:Number = new Number(0);
				private var velocity_Y:Number = new Number(0);
				private var prev_Y_Point:Number = 0;
				private var new_Y_Point:Number = 0;
				private var distance_Y:Number;
				private var prev_X_Point:Number = 0;
				private var new_X_Point:Number = 0;
				private var distance_X:Number = 0;
				private var easing:Boolean = false;
        		private var speed:Point;
        		private var friction:Number = 0.87
        		private var gap:int = 2
        		
        		private var siRiga:Boolean = false
        		private var anchorPoint:Point
        		private var rigaStart:Point
        		private var tickFunction
        		private var anchorColor=0x000000
        
	        	public var factorDesacceleration:uint = 20;
        		public var factorAcceleration:uint = 50;
        
        		private var timerRefresh:Timer;
        
        	// Flag meaning if the mouse is pressed
        		private var isMouseDown:Boolean = false;
        	        
        	// Constructor
				public function FloatManagerAS3(float:Sprite,anchor:Point=null, color=null, f:Function=null)
				{
					this.float = float;
					if (anchor!=null) {
						rigaStart= anchor
						siRiga=true
					} 
					if (color!=null) {
						anchorColor =color
						siRiga=true
					} 
					tickFunction = f
					
					//floatImg = new Image()
					//floatImg.visible = false
					//floatImg.width = float.width

					float.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
					float.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);	
					float.addEventListener(MouseEvent.ROLL_OUT, onMouseUp, false, 0, true);	
					float.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);		
				}
				
			// Destructor
				public function dispose():void
				{
					float.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					float.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);	
					float.removeEventListener(MouseEvent.ROLL_OUT, onMouseUp);	
					float.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);	
									
					speed = null;

				}	
			
				private function onMouseDown(event:MouseEvent):void
				{
						if (event.target is ScrollThumb) return
						
						isMouseDown = true;
						
			            //move vertically
					 	prev_Y_Point = event.stageY;
						new_Y_Point = event.stageY;
						velocity_Y = 0
						
						//move horizontally
						prev_X_Point = event.stageX;
						new_X_Point = event.stageX;
						velocity_X = 0
						
						float.addEventListener(Event.ENTER_FRAME,onTick)
						
						if (siRiga && 1==0) {
							rigaStart=null
							rigaStart = float.localToGlobal( new Point(0, 0) )
						}
			           

		        }
        
        	// Mouse up event
	        private function onMouseUp (event:MouseEvent):void 
	        {
	        	if (isMouseDown)
	        	{
		        	isMouseDown = false;

	         	}
	        }
        	
        	private function onMouseMove (event:MouseEvent):void 
	        {
	        	if (isMouseDown)
				{
					
					last_X = new_X_Point;
					new_X_Point = event.stageX;
					velocity_X = (new_X_Point - last_X);
					
					last_Y = new_Y_Point;
					new_Y_Point = event.stageY;
					velocity_Y = (new_Y_Point - last_Y);
					
					float.x += velocity_X
					float.y+= velocity_Y;
					
					setConstraintsDispo();	 	
					
					if (velocity_Y != 0 && velocity_X != 0) {
						easing = true; 
					}
					if (siRiga) drawRiga()
 				}
	        }        
        	// Calcul
	 		private function onTick (event:Event):void 
	 		{		
	 			
				if (!isMouseDown && easing) {
					
					float.y+= velocity_Y;
		 			float.x+= velocity_X;
		 			
					velocity_X *= friction;
					velocity_Y *= friction;
					
					if (siRiga) drawRiga()
				
					if(Math.abs(velocity_X) < 0.5) velocity_X = 0;
					
					if(Math.abs(velocity_Y) < 0.5) velocity_Y = 0;
					
					if (velocity_X == 0 && velocity_Y == 0) {

						easing = false;
						
			 			float.removeEventListener(Event.ENTER_FRAME,onTick)
					}
				}
				//  constraint
				if (!isMouseDown || easing) setConstraintsDispo();	 			
	        }
	        
	        private function setConstraintsDispo():void
		   {	
		   		if (float.parent==null) return	      
				 //se giorni o corpo controllo la X
				if (float.y<gap) {
					float.y=gap
					velocity_Y= -velocity_Y
				}
				if (float.x<gap) {
					float.x=gap
					velocity_X= -velocity_X
				}
				if (float!=null && float.y>(float.parent.height-gap)-float.height) {
					float.y=(float.parent.height-gap)-float.height
					velocity_Y= -velocity_Y
				}
				if (float!=null && float.x>(float.parent.width-gap)-float.width) {
					float.x=(float.parent.width-gap)-float.width
					velocity_X= -velocity_X
				}
		   }
		   
		   
		   // COPIA BITMAP DA OGGETTO
					 	
		 	private function getBitmapData( target :Sprite ) : BitmapData
			   {
			    var bd : BitmapData = new BitmapData( target.width/target.scaleX, target.height/target.scaleY,true ,0x0055ff);
			    var m : Matrix = new Matrix();
			    bd.draw( target, m );
			    return bd;
			   }
	
		 	public function copia(da:Object,a:Object):void {
		 		var bd2 : BitmapData = getBitmapData( Sprite(da) );
			 	a.source =  new  Bitmap( bd2,'auto', true) 
			 	a.x = da.x 
			 	a.y = da.y 
			 	a.width = da.width 
			 	a.height = da.height
			 	a.scaleX = da.scaleX 
			 	a.scaleY = da.scaleY 
		 	}
	        public function drawRiga():void {
	        	var piano = float.parent
	        	var p:Point = float.globalToLocal( rigaStart)
	        	
	        float.graphics.clear()	
			float.graphics.moveTo(p.x,p.y);
			float.graphics.lineStyle(1,anchorColor,.7)
	        float.graphics.lineTo(0,p.y); 
	        float.graphics.lineTo(0,float.height); 
	        float.graphics.lineTo(float.width,float.height); 
	        	
	        	return
	        	
				float.graphics.clear();
				float.graphics.moveTo(p.x,p.y);
				float.graphics.lineStyle(0.5,anchorColor,1)
	            float.graphics.lineTo(0,float.height/2);  
		}      
	}
}