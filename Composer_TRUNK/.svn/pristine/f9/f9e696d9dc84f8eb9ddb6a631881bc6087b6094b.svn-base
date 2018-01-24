package comp
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	import mx.controls.dataGridClasses.DataGridListData;
	
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
	public class GlobalItemRenderer extends DataGridItemRenderer
	{
		private var valueParameter:Object;
		
		public function GlobalItemRenderer():void
		{
			super();
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			this.valueParameter = value;
			invalidateProperties();
		}
		
		override public function validateProperties():void
		{
			setStyle("color", data.rowColor);
			super.validateProperties();
		}
	}
}