package comp
{
	import mx.containers.Canvas;

	public class Freccia extends Canvas
	{

		private var dir:String = "up"
		private var col:int = 0x333333
		private var bdrt:Number = 1
		private var bdrCol:int 
		private var _gap:int=0
		
		public function Freccia()
		{
			super();
			
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight)
			graphics.clear()
			if (!bdrCol) graphics.lineStyle(bdrt,col)
			else graphics.lineStyle(bdrt,bdrCol)
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
		
		[Bindable] public function set direction(d:String)
		{
			dir = d
			this.invalidateDisplayList()
		}
		[Bindable] public function get direction():String
		{
			return dir
		}
		[Bindable] public function set color(c:int)
		{
			col = c
			this.invalidateDisplayList()
		}
		[Bindable] public function get color():int
		{
			return col
		}
		[Bindable] public function set bdrThick(c:int)
		{
			bdrt = c
			this.invalidateDisplayList()
		}
		[Bindable] public function get bdrThick():int
		{
			return bdrt
		}
		[Bindable] public function set bdrColor(c:int)
		{
			bdrCol = c
			this.invalidateDisplayList()
		}
		[Bindable] public function get bdrColor():int
		{
			return bdrCol
		}
		[Bindable] public function set gap(c:int)
		{
			_gap = c
			this.invalidateDisplayList()
		}
		[Bindable] public function get gap():int
		{
			return _gap
		}
	}
}