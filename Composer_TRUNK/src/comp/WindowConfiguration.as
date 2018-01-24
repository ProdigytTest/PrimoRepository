package comp
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	public class WindowConfiguration
	{
		private var _window:PCWindow;
		private var _x:int;
		private var _y:int;
		private var _w:int;
		private var _h:int;
		private var _xScale:Number;
		private var _yScale:Number;
		
		public function WindowConfiguration()
		{
			_window = new PCWindow();
		}

		public function get window():PCWindow
		{
			return _window;
		}
		
		public function set window(value:PCWindow):void
		{
			_window = value;
			_x = _window.x;
			_y = _window.y;
			_w = _window.contenuto.width;
			_h = _window.contenuto.height;
			_xScale = _window.scaleX;
			_yScale = _window.scaleY;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

		public function set y(value:int):void
		{
			_y = value;
		}

		public function set w(value:int):void
		{
			_w = value;
		}

		public function set h(value:int):void
		{
			_h = value;
		}

		public function set xScale(value:Number):void
		{
			_xScale = value;
		}

		public function set yScale(value:Number):void
		{
			_yScale = value;
		}
		
		public function applyModifications():void
		{
			_window.standardPos = this
			_window.inStandard = true
			//_window.snapshot = true
			//TweenLite.to(_window, 1.2, {x:_x, y:_y, width:_w, height:_h, scaleX:_xScale, scaleY:_yScale, ease:Expo.easeOut, onComplete:end} );
			_window.x = _x;
			_window.y = _y;
			_window.contenuto.width = _w;
			_window.contenuto.height = _h;
			_window.width = _w;
			_window.height = _h;
			_window.scaleX = _xScale;
			_window.scaleY = _yScale;
			_window.minimized = false
			_window.standardPos = this
			_window.inStandard = true

		}
		private function end():void{
			//_window.snapshot = false
		}

	}
}