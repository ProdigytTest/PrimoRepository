package comp
{
	import flash.events.Event;
	import flash.text.FontStyle;
	
	import mx.controls.Label;
	import mx.controls.treeClasses.TreeItemRenderer;
	
	/**
	 * 
	 * 
	 * 
	 * ATTENZIONE: barbatrucco per far funzionare l'aggiornamento dell'item renderer: si chiama il refresh
	 * ad ogni enter frame... in futuro dovrà essere cambiato il funzionamento.
	 * 
	 * 
	 * 
	 */
	public class OutlineTreeItemRenderer extends TreeItemRenderer
	{
		private var valueParameter:Object;
		
		private var myLabel:Label;
		private var myNormalLabel:Label;
		
		public function OutlineTreeItemRenderer():void
		{
			super();
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			invalidateDisplayList();
			// this.valueParameter = value;
		}
				
		override protected function createChildren():void
		{
			super.createChildren();
			myLabel = new Label();
			myLabel.setStyle("fontWeight", FontStyle.BOLD);
			myLabel.text = (data as String).split(":")[0];
			myLabel.text = myLabel.text.concat(":");
			myLabel.setStyle("fontWeight", FontStyle.REGULAR);
			myLabel.text = myLabel.text.concat((data as String).split(":")[1]);
			addChild(myLabel);			
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if ( super.data )
			{
				//setStyle("fontWeight", FontStyle.BOLD);
				// super.label.x = super.icon.x + super.icon.width + 3;
			}
		}
	}
}