package comp
{
	import mx.controls.treeClasses.TreeItemRenderer;
	
	public class CustomTreeItemRenderer extends TreeItemRenderer
	{
		protected static var COLOR_ME_RED:int	= 0xE32219;
		protected static var COLOR_ME_BLACK:int	= 0x000000;
		
		public function CustomTreeItemRenderer()
		{
			super();
		}

		override public function validateProperties():void
		{
			if (data && data.@manuals=="true") 
			{
				this.setStyle("color", COLOR_ME_RED);
			} else {
				this.setStyle("color", COLOR_ME_BLACK);
			}
			super.validateProperties();
		}
	}
}