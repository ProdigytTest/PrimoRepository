package comp
{

import mx.collections.*;
import mx.controls.treeClasses.*;

    public class DSPFitemRenderer extends TreeItemRenderer
    {
        public function DSPFitemRenderer() 
		{
            super();
            mouseEnabled = false;			
        }
		
        override public function set data(value:Object):void
        {
            if(value != null)
            { 
                super.data = value;
                //if(TreeListData(super.listData)=="true")
                if(XML(data).@active=="true")
                {
                     setStyle("color", 0x64e6e7);
				}
				else
				{
				     setStyle("color", 0xc4d6d7);
				}
        	}
        }	 

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var tmp:XMLList;
			var val:String;
			if(super.data)
			{
				if(XMLList(TreeListData(super.listData).item)[0].localName()=="k")
				{
					tmp = new XMLList(TreeListData(super.listData).item);
					val = tmp[0].attribute("v");
					super.label.text =  TreeListData(super.listData).label + " (" + val + ")";
				}
				if(XMLList(TreeListData(super.listData).item)[0].localName()=="f")
				{
					tmp = new XMLList(TreeListData(super.listData).item);
					val = tmp[0].attribute("u");
					super.label.text =  TreeListData(super.listData).label + " (" + val + ")";
				}
			}
        }
	}
} 