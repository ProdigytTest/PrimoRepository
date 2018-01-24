package comp
{
	import it.prodigyt.components.core.PYComponent;
	import it.prodigyt.components.core.PYLabel;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeMenu;
	
	import mx.messaging.channels.StreamingAMFChannel;
	
	public class ControlPanelItem extends PYComponent
	{
		[Embed(source="assets/ledOff.png")] private var lo:Class;
		private var ledOff:Bitmap = new lo();
		
		[Embed(source="assets/ledOn.png")] private var ln:Class;
		private var ledOn:Bitmap = new ln();
		[Embed(source="assets/ctrlPanName.png")] private var cn:Class;
		private var imgName:Bitmap = new cn();
		
		private var _lab:PYLabel
		private var _set:PYComponent
		private var _nam:PYLabel
		
		private var _font:String
		private var _label:String
		private var _name:String
		private var _nameColor:uint
		
		private var _active:Boolean
		
		public var menu:NativeMenu
		public function ControlPanelItem()
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
			_lab = addChild( new PYLabel) as PYLabel
			_lab.fontSize = 12
			_lab.foregroundColor = 0xbbbbbb
			_lab.x = 2
			_lab.y = 0
			_lab.autoSize = false
			_lab.width = 118
			_lab.height = 12
			_lab.align = "right"
			
			_set = addChild( new PYComponent ) as PYComponent
			_set.x = 2
			_set.y = 18
			_set.backgroundImage = ledOff
			_set.width = 15
			_set.height = 15
			_nam = addChild( new PYLabel ) as PYLabel
			_nam.fontSize = 14
			_nam.fontWeight = "bold"
			_nam.foregroundColor = 0x66ddff
			_nam.textField.alpha = 1
			_nam.textField.y -= 2;
			_nam.x = 20
			_nam.y = 16
			_nam.align = "center"
			_nam.autoSize = false
			_nam.width = 100
			_nam.height = 18
			_nam.backgroundImage = imgName
		}

		public function get font():String
		{
			return _font;
		}

		public function set font(value:String):void
		{
			_font = value;
			_lab.fontFamily = _font
			_nam.fontFamily = _font
		}

		public function get cLabel():String
		{
			return _label;
		}

		public function set cLabel(value:String):void
		{
			_label = value;
			_lab.text = _label
		}

		public function get cName():String
		{
			return _name;
		}

		public function set cName(value:String):void
		{
			_name = value;
			_nam.text = _name
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
			if (_active) _set.backgroundImage = ledOn
			else _set.backgroundImage = ledOff
		}

		public function get cNameColor():uint
		{
			return _nameColor;
		}

		public function set cNameColor(value:uint):void
		{
			_nameColor = value;
			_nam.foregroundColor = _nameColor
		}


	}
}