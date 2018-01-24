package comp
{
	import flash.events.Event;
	
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.ListData;
	import mx.managers.LayoutManager;
	
	import it.prodigyt.engine.projectSheet.DefaultsManager;
	
	
	public class CustomItemRenderer extends DataGridItemRenderer
	{
		private var valueParameter:Object;
		
		public function CustomItemRenderer():void
		{
			super();
		}
		
		override public function set data(value:Object):void
		{
			this.valueParameter = value;
			invalidateProperties();
			super.data = value;

			
//			if (data.group == "style" ) 	setStyle("backgroundColor", data.heritage? 0xffffee :  0xffffdd);  
//			else if (data.group == "layout" ) 	setStyle("backgroundColor",  data.heritage? 0xeeffff : 0xddffff);  
//			else if (data.group == "text" ) 	setStyle("backgroundColor",  data.heritage? 0xffeeee : 0xffdddd);  
//			else if (data.group == "other" ) 	setStyle("backgroundColor",  data.heritage? 0xeeffee : 0xddffdd);
//			else setStyle("backgroundColor",  0xffffff);
//			if (data.renderer == "PYBoxColorChooser" && listData.columnIndex == 1  ) 
//			{
//				setStyle("backgroundColor", uint(data.value));
//				
//			}
		}
		
		
		
		override public function validateProperties():void
		{
			
			
//			if (data.group== "style") this.setStyle("backgroundColor", 0xffffdd);
//			else if (data.group== "layout") this.setStyle("backgroundColor", 0xddffff);
//			else if (data.group== "text") this.setStyle("backgroundColor", 0xffddff);
//			else this.setStyle("backgroundColor", 0xffffff);
			
			
			
//			if (data.group == "style" ) 	setStyle("backgroundColor", data.heritage? 0xffffee :  0xffffdd);  
//			else if (data.group == "layout" ) 	setStyle("backgroundColor",  data.heritage? 0xeeffff : 0xddffff);  
//			else if (data.group == "text" ) 	setStyle("backgroundColor",  data.heritage? 0xffeeee : 0xffdddd);  
//			else if (data.group == "other" ) 	setStyle("backgroundColor",  data.heritage? 0xeeffee : 0xddffdd);
//			else setStyle("backgroundColor",  0xffffff);
//			if (data.renderer == "PYBoxColorChooser" && listData.columnIndex == 1  ) 
//			{
//				setStyle("backgroundColor", uint(data.value));
//				
//			}
			
			
//			if (listData.columnIndex == 1 && data.value.indexOf("0x")> -1) 
//			{
//				setStyle("backgroundColor", uint(data.value));
//			}
//			if (listData.columnIndex == 2 ) 
//			{
//				var a=a
//			}
//			if (data.value.indexOf("0x")> -1) 
//			{
//				var a=a
//			}
			
			this.setStyle("color",data.rowColor);
			
			super.validateProperties();
			
			if (data.property=="_DESCRIPTION")
			{
				multiline=true
				wordWrap=true
				this.setStyle("height","100%");
			}
			if (data.renderer == "PYBoxColorChooser" && data.value >"" ) 
			{
				this.background = true
				if (int(data.value) <64)
					this.backgroundColor= uint(DefaultsManager.getInstance().colorsArray[int(data.value) ])
				else
					this.backgroundColor= uint(data.value)
			}
			else
				this.background=false
		}

	}
}