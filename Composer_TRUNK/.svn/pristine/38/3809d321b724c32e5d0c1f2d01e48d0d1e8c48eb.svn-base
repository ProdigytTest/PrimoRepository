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
	import mx.core.UIComponent;
	import flash.display.Stage;
	import flash.display.Sprite;
	
	import com.greensock.TweenLite
	import org.papervision3d.core.io.BasicExporter;
			import org.papervision3d.view.BasicView;
			import org.papervision3d.core.proto.CameraObject3D;
			import org.papervision3d.cameras.Camera3D;

			import mx.events.MoveEvent;
			import mx.events.CloseEvent;
		
			import mx.graphics.ImageSnapshot;
			import mx.containers.TitleWindow;
			import mx.managers.PopUpManager;
			import mx.core.UIComponent;
			
			import org.papervision3d.objects.primitives.Plane;
			import org.papervision3d.materials.BitmapMaterial;
			import org.papervision3d.render.BasicRenderEngine;
			import org.papervision3d.view.Viewport3D;

			import org.papervision3d.scenes.Scene3D;
			
			
			
	public class FloatWindowAS3
	{
		// ----------------------------------------------------
		// Zone Manager
		// ----------------------------------------------------	
		
		static private var mapInstances:Dictionary = new Dictionary(true);
		
		static public function addFloat (float:Sprite,  f:Function=null):void
		{
			mapInstances[float] = new FloatWindowAS3(float,f);
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
				private var container:Container;
				private var float:Sprite;
				private var floatImg:Image

        		private var stage:Stage

        		private const ANIMATION_TIME:Number = 0.5;
				private const ANIMATION_TRANSITION:String = "easeOutQuad";
				
	
	
				private var _plane:Plane;
				
				private var bv:BasicView
				
				
				private var _mouseIsDown:Boolean = false;
				private var _mousePosition:Point;
	
        	        
        	// Constructor
				public function FloatWindowAS3(float:Sprite, f:Function=null)
				{
					this.float = float;
					//tickFunction = f
					float.addEventListener(Event.ADDED_TO_STAGE, avvia)
				}
				
				private function avvia(e:Event):void
				{	
					
					float.removeEventListener(Event.ADDED_TO_STAGE, avvia)
					stage = float.stage
					setup3D();	
					
					float.addEventListener(MouseEvent.MOUSE_DOWN, window_MOUSE_DOWN);
					stage.addEventListener(MouseEvent.MOUSE_UP, stage_MOUSE_UP);
					
				}
				
			// Destructor
				public function dispose():void
				{
					float.removeEventListener(MouseEvent.MOUSE_DOWN, window_MOUSE_DOWN);
					
					stage.removeEventListener(MouseEvent.MOUSE_UP, stage_MOUSE_UP);
					
					//float.removeEventListener(MoveEvent.MOVE, window_MOVE);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, window_MOVE);

				}	
				
				private function setup3D():void{
					
					bv = new BasicView(stage.width, stage.height,true,true)
					bv.x = float.parent.x
					bv.y = float.parent.y	
					stage.addChild(bv);
					bv.camera.focus = 500
					bv.camera.z = -1000
					bv.camera.zoom = 2
					
					_plane = new Plane(null, float.width, float.height, 10, 10);
					_plane.scale = float.scaleX
					_plane.visible = false;
					_plane.useOwnContainer = true
					_plane.filters = float.filters
					
					bv.scene.addChild(_plane);
				}
				
				
				private function loop(evt:Event):void{
					bv.singleRender()
				}
				private function spegniRender():void{
					stage.removeEventListener(Event.ENTER_FRAME, loop);
				}
				
				private function captureMouse():void{
				_mousePosition = new Point(stage.mouseX, stage.mouseY);
				}
			
			
			
			private function window_MOUSE_DOWN(evt:MouseEvent):void{
				//if(evt.currentTarget.mouseX > float.width - 30 || (evt.currentTarget ).mouseY > 30){
				//	return;
				//}
				float.addEventListener(MoveEvent.MOVE, window_MOVE);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, window_MOVE);
				
				stage.addEventListener(Event.ENTER_FRAME, loop);
				
				
				_mouseIsDown = true;
				
				captureMouse();
				
				var bitmap:BitmapData = getBitmapData(float);
				//var bitmap:BitmapData = ImageSnapshot.captureBitmapData(float)
				float.visible = false;
				
				var material:BitmapMaterial = new BitmapMaterial(bitmap);
				
				_plane.material = material;
				_plane.x = float.localToGlobal(new Point(0,0)).x - stage.stageWidth / 2 + float.width/float.scaleX / 2 - bv.x;
				_plane.y = -(float.localToGlobal(new Point(0,0)).y - stage.stageHeight / 2 + float.height/float.scaleY / 2) + bv.y;
				_plane.visible = true;
			}
			
			private function stage_MOUSE_UP(evt:MouseEvent):void{
				if(!_mouseIsDown){
					return;
				}
				
				_mouseIsDown = false;
				
				float.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, false));
				float.removeEventListener(MoveEvent.MOVE, window_MOVE);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, window_MOVE);
				float.visible = true;
				_plane.visible = false;
				bv.singleRender()
				
			}
			
			private function window_MOVE(evt:*):void{
				if(!_mouseIsDown){
					return;
				}
				
				var diffX:int = stage.mouseX - _mousePosition.x;
				var diffY:int = stage.mouseY - _mousePosition.y;
				
				captureMouse();
				
				float.x += diffX;
				float.y += diffY;
				
				_plane.x += diffX;
				_plane.y -= diffY;
				
				_plane.rotationX -= diffY / 10;
				_plane.rotationY -= diffX / 20;
				
				TweenLite.to(_plane, ANIMATION_TIME, {rotationX: 0, rotationY: 0, onComplete:spegniRender } )
				//Tweener.addTween(_plane, {
				//		rotationX: 0,
				//		rotationY: 0,
				//		time: ANIMATION_TIME,
				//		transition: ANIMATION_TRANSITION
				//	}
				//);
			}
			
			
			private function getBitmapData( target :Sprite ) : BitmapData
			   {
			    var bd : BitmapData = new BitmapData( target.width/target.scaleX, target.height/target.scaleY,true ,0x0055ff);
			    var m : Matrix = new Matrix();
			    m.scale(target.scaleX, target.scaleY)
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
			
	        
	}
}