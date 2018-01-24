package org.effects{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	
	public class DockItem extends Sprite{
		
		private var _initPosition:Number;
		public var maxXDistance:Number;
		public var maxYDistance:Number;
		public var maxScale:Number;
		
		public function DockItem($maxXDistance:Number=60,$maxYDistance:Number=30,$maxScale:Number=2):void{
			maxXDistance=$maxXDistance;
			maxYDistance=$maxYDistance;
			maxScale=$maxScale;
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE,init);
			addEventListener(Event.REMOVED_FROM_STAGE,end);
		}
	
		private function init(e:Event=null):void{
			_initPosition=x;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			stage.addEventListener(Event.MOUSE_LEAVE,mouseLeave);
		}
		
		private function mouseLeave(e:Event):void{
			TweenLite.to(this,.3,{x:_initPosition,scaleX:1,scaleY:1});
		}
		
		private function mouseMove(e:MouseEvent):void{
			var yDistance:Number=Math.abs(parent.mouseY-y);
			if(yDistance>maxYDistance){
				if(_initPosition==x) return;
				else{
					TweenLite.to(this,.3,{x:_initPosition,scaleX:1,scaleY:1});
					return;
				}
			}
			var xDistance:Number=parent.mouseX-_initPosition;
			xDistance=xDistance>maxXDistance?maxXDistance:xDistance;
			xDistance=xDistance<-maxXDistance?-maxXDistance:xDistance;
			var posX=_initPosition-xDistance;
			var scale:Number=(maxXDistance-Math.abs(xDistance))/maxXDistance;
			scale=1+(maxScale*scale);
			TweenLite.to(this,.3,{x:posX,scaleX:scale,scaleY:scale});
		}
		
		private function end(e:Event=null):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			stage.removeEventListener(Event.MOUSE_LEAVE,mouseLeave);
		}
	}	
}