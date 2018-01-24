package comp
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;

	public class Orologio extends Canvas
	{
		
		private var t:Timer = new Timer(60000,0)
		private var time:Date = null
		
		public function Orologio()
		{
			super();
			t.addEventListener(TimerEvent.TIMER, onTImer)
		}
		
		private function onTimer(e:TimerEvent)
		{
			this.invalidateDisplayList() 
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight)
			
			
			
			// disegno l'orologio
			
			
			
			graphics.clear()
			graphics.lineStyle(bdrt,bdrCol)
			graphics.beginFill(color)
			if (direction=="right")
			{
				graphics.moveTo(_gap,_gap)
				graphics.lineTo(_gap,unscaledHeight-_gap)
				graphics.lineTo(unscaledWidth-_gap,unscaledHeight/2)
				graphics.lineTo(_gap,_gap)
				graphics.endFill()
			}
			else if (direction=="left")
			{
				graphics.moveTo(unscaledWidth-_gap,_gap)
				graphics.lineTo(unscaledWidth-_gap,unscaledHeight-_gap)
				graphics.lineTo(_gap,unscaledHeight/2)
				graphics.lineTo(unscaledWidth-_gap,_gap)
				graphics.endFill()
			}
			else if (direction=="up")
			{
				graphics.moveTo(_gap,unscaledHeight-_gap)
				graphics.lineTo(unscaledWidth-_gap,unscaledHeight-_gap)
				graphics.lineTo(unscaledWidth/2,_gap)
				graphics.lineTo(_gap,unscaledHeight-_gap)
				graphics.endFill()
			}
			else if (direction=="down")
			{
				graphics.moveTo(_gap,_gap)
				graphics.lineTo(unscaledWidth-_gap,_gap)
				graphics.lineTo(unscaledWidth/2,unscaledHeight-_gap)
				graphics.lineTo(_gap,_gap)
				graphics.endFill()
			}
		}
		
		override protected function set width(value:Number):void
		{
			width = value
			this.invalidateDisplayList() 
		}
		
		[Bindable] public function set time(d:Date=null)
		{
			time = d
			this.invalidateDisplayList()
		}
		[Bindable] public function get time():Date
		{
			return time
		}
		
		
		
		
		
	}
	
}