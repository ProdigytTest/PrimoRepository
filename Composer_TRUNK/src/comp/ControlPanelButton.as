package comp
{
	import it.prodigyt.components.core.PYComponent;
	import it.prodigyt.components.core.PYLabel;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeMenu;
	
	import mx.messaging.channels.StreamingAMFChannel;
	
	public class ControlPanelButton extends PYComponent
	{
		[Embed(source="assets/moff.png")] private var mo:Class;
		private var mOff:Bitmap = new mo();
		
		[Embed(source="assets/mon.png")] private var mn:Class;
		private var mOn:Bitmap = new mn();
		
		[Embed(source="assets/doff.png")] private var d:Class;
		private var dOff:Bitmap = new d();
		
		[Embed(source="assets/don.png")] private var dn:Class;
		private var dOn:Bitmap = new dn();
		
		
		
		private var _lab:PYLabel
		private var _set:PYComponent
		private var _nam:PYLabel
		
		private var _font:String
		private var _label:String
		private var _name:String
		
		private var _active:Boolean = false
		
		public var menu:NativeMenu
		public function ControlPanelButton()
		{
			super();
		}
		
		override protected function init():void
		{
			super.init()
			clip=true
			
			
		}
		
		override protected function addChildren():void
		{
			super.addChildren()

			
			_set = addChild( new PYComponent ) as PYComponent
			_set.x = 3
			_set.y = 3
			_set.backgroundImage = mOff
			_set.width = 30
			_set.height = 30
			width = 36
			height = 36

		}
		
		public function get font():String
		{
			return _font;
		}
		
		public function set font(value:String):void
		{
			_font = value;
		}
		
		public function get cLabel():String
		{
			return _label;
		}
		
		public function set cLabel(value:String):void
		{
			_label = value;
		}
		
		public function get cName():String
		{
			return _name;
		}
		
		public function set cName(value:String):void
		{
			_name = value;
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(value:Boolean):void
		{
			_active = value;
			if (_active && letter == "M") _set.backgroundImage = mOn
			if (_active && letter == "D") _set.backgroundImage = dOn
			if (!_active && letter == "M") _set.backgroundImage = mOff
			if (!_active && letter == "D") _set.backgroundImage = dOff
		}
		
		public function get letter():String
		{
			if (_set.backgroundImage == mOn || _set.backgroundImage == mOff ) return "M";
			else return "D";
		}
		
		public function set letter(value:String):void
		{
			if (_active && value == "M") _set.backgroundImage = mOn
			if (_active && value == "D") _set.backgroundImage = dOn
			if (!_active && value == "M") _set.backgroundImage = mOff
			if (!_active && value == "D") _set.backgroundImage = dOff
			
		}
		
	}
}