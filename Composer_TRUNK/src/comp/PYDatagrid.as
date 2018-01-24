package comp
{
	import flash.display.Sprite;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.ListBaseContentHolder;
	
	import it.prodigyt.engine.projectSheet.DefaultsManager;
	
	public class PYDatagrid extends DataGrid
	{
		public function PYDatagrid()
		{
			super();
			variableRowHeight = true;
		}
		
		override protected function calculateRowHeight(data:Object, hh:Number, skipVisible:Boolean=false):Number
		{
			if (data !=null && data.property != null && data.property=="_DESCRIPTION")
			{
				return 60;
				data.rowColor=0xff0000
				
			}
			else
				return super.calculateRowHeight(data,hh, skipVisible)
				
		}
		
		
		override protected function drawRowBackground(s:Sprite, rowIndex:int,
													  y:Number, height:Number,
													  color:uint, dataIndex:int):void
		{
			try
			{
				var item:Object = (dataProvider as ArrayCollection).getItemAt(dataIndex);
				if( item.hasOwnProperty("group"))
				{

					var check = String(item.group).substr(1)
					var heritage = item.heritage
					if (check == "style" ) 	color = heritage? 0xffffee :  0xffffdd;  
					else if (check == "layout" ) 	color = heritage? 0xeeffff : 0xddffff;  
					else if (check == "text" ) 	color = heritage? 0xffeeee : 0xffdddd;  
					else if (check == "other" ) 	color = heritage? 0xeeffee : 0xddffdd;
					else color = 0xffffff;
					
					// colora tutta la riga non solo il box del colore
					if (item.renderer == "PYBoxColorChooser"  && 1==0) 
					{
						color =  uint(DefaultsManager.getInstance().colorsArray[item.value ]);
						
					}
				} 
			} 
			catch(error:Error) 
			{
				//Alert.show('Errori nel parsing dell XML: abbandonare', 'Conferma', mx.controls.Alert.YES| mx.controls.Alert.NO, null, salvaProjectSioNo);
			}

			super.drawRowBackground(s,rowIndex,y,height,color,dataIndex);
		}
		
		override protected function drawColumnBackground(s:Sprite, columnIndex:int, color:uint, column:DataGridColumn):void
		{
			super.drawColumnBackground(s, columnIndex,color,column)
		}
	}
}