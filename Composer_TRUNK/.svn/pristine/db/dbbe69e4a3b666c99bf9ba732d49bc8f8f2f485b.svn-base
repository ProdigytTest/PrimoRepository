package comp
{
	public class SlumGenerator
	{
		public static function generate(componentsToTranslate:XML):XML
		{
			var componentsTranslated:XML = <node label="Components"></node>;
			
			for each (var categoryToProcess:XML in componentsToTranslate.components.children())
			{
				var category:XML = <node/>;
				category.@label = categoryToProcess.name();
				componentsTranslated.appendChild(category);
				
				for each (var componentToProcess:XML in categoryToProcess.children())
				{
					var component:XML = <node/>;
					component.@label = String(componentToProcess.name());
					component.@className = String(componentToProcess.@className);
					component.@highlight = String(componentToProcess.@highlight);
					component.@icon = String(componentToProcess.@icon);
					component.@layoutMargins = String(componentToProcess.@layoutMargins);
					component.@acceptChildren = String(componentToProcess.@acceptChildren);				
					category.appendChild(component);
					
					/*var stringCommonTag:String = "<common />";
					var stringStyleTag:String = "<style />";
					var stringLayoutTag:String = "<layout />";
					var stringPropertiesTag:String = "<properties />";
					var stringEventsTag:String = "<events />";
					var stringChildrenTag:String = "<children />";
					
					// inserisco i parametri generali di tutti i componenti
					for each (var commonAttr:XML in componentsToTranslate.commonAttr.children())
					{
						if (String(commonAttr.@subset) == "common")
						{
							stringCommonTag = stringCommonTag.replace("/>", String(commonAttr.@name) + '="' + (commonAttr.@defaultValue != "" ? String(commonAttr.@defaultValue) : "") + '" />');
							stringPropertiesTag = stringPropertiesTag.replace("/>", String(commonAttr.@name) + '="' + (commonAttr.@defaultValue != "" ? String(commonAttr.@defaultValue) : "") + '" />');
						}
						if (String(commonAttr.@subset) == "style")
						{
							stringStyleTag = stringStyleTag.replace("/>", String(commonAttr.@name) + '="' + (commonAttr.@defaultValue != "" ? String(commonAttr.@defaultValue) : "") + '" />');
							stringPropertiesTag = stringPropertiesTag.replace("/>", String(commonAttr.@name) + '="' + (commonAttr.@defaultValue != "" ? String(commonAttr.@defaultValue) : "") + '" />');
						}
						if (String(commonAttr.@subset) == "layout")
						{
							stringLayoutTag = stringLayoutTag.replace("/>", String(commonAttr.@name) + '="' + (commonAttr.@defaultValue != "" ? String(commonAttr.@defaultValue) : "") + '" />');
							stringPropertiesTag = stringPropertiesTag.replace("/>", String(commonAttr.@name) + '="' + (commonAttr.@defaultValue != "" ? String(commonAttr.@defaultValue) : "") + '" />');
						}
						if (String(commonAttr.@subset) == "properties")
						{
							// poniamo il valore dell'attributo dentro properties comunque
							if (stringPropertiesTag.indexOf(String(commonAttr.@name)) != -1)
							{
								stringPropertiesTag = clearAttributeDuplicate(stringPropertiesTag, String(commonAttr.@name));
							}
							stringPropertiesTag = stringPropertiesTag.replace("/>", String(commonAttr.@name) + '="' + (commonAttr.@defaultValue != "" ? String(commonAttr.@defaultValue) : "") + '" />');
						}
						if (String(commonAttr.@subset) == "events")
						{
							stringEventsTag = stringEventsTag.replace("/>", String(commonAttr.@name) + '="' + (commonAttr.@defaultValue != "" ? String(commonAttr.@defaultValue) : "") + '" />');
							stringPropertiesTag = stringPropertiesTag.replace("/>", String(commonAttr.@name) + '="' + (commonAttr.@defaultValue != "" ? String(commonAttr.@defaultValue) : "") + '" />');
						}
						if (String(commonAttr.@subset) == "children")
						{
							stringChildrenTag = stringChildrenTag.replace("/>", String(commonAttr.@name) + '="' + (commonAttr.@defaultValue != "" ? String(commonAttr.@defaultValue) : "") + '" />');
							stringPropertiesTag = stringPropertiesTag.replace("/>", String(commonAttr.@name) + '="' + (commonAttr.@defaultValue != "" ? String(commonAttr.@defaultValue) : "") + '" />');
						}
					}
					
					// inserisco i parametri particolari del componente in questione
					for each (var attr:XML in componentToProcess.children())
					{						
						// attributo common
						if (String(attr.@subset) == "common")
						{
							if (stringCommonTag.indexOf(" " + String(attr.@name) + "=\"") != -1)
							{
								stringCommonTag = clearAttributeDuplicate(stringCommonTag, String(attr.@name));
							}
							stringCommonTag = stringCommonTag.replace("/>", String(attr.@name) + '="' + (attr.@defaultValue != "" ? String(attr.@defaultValue) : "") + '" />');
							
							// poniamo il valore dell'attributo dentro properties comunque
							if (stringPropertiesTag.indexOf(" " + String(attr.@name) + "=\"") != -1)
							{
								stringPropertiesTag = clearAttributeDuplicate(stringPropertiesTag, String(attr.@name));
							}
							stringPropertiesTag = stringPropertiesTag.replace("/>", String(attr.@name) + '="' + (attr.@defaultValue != "" ? String(attr.@defaultValue) : "") + '" />');
						}

						// atributo style
						if (String(attr.@subset) == "style")
						{
							stringStyleTag = stringStyleTag.replace("/>", String(attr.@name) + '="' + (attr.@defaultValue != "" ? String(attr.@defaultValue) : "") + '" />');
							
							// poniamo il valore dell'attributo dentro properties comunque
							if (stringPropertiesTag.indexOf(" " + String(attr.@name) + "=\"") != -1)
							{
								stringPropertiesTag = clearAttributeDuplicate(stringPropertiesTag, String(attr.@name));
							}
							stringPropertiesTag = stringPropertiesTag.replace("/>", String(attr.@name) + '="' + (attr.@defaultValue != "" ? String(attr.@defaultValue) : "") + '" />');
						}

						// attributo layout
						if (String(attr.@subset) == "layout")
						{
							stringLayoutTag = stringLayoutTag.replace("/>", String(attr.@name) + '="' + (attr.@defaultValue != "" ? String(attr.@defaultValue) : "") + '" />');
							
							// poniamo il valore dell'attributo dentro properties comunque
							if (stringPropertiesTag.indexOf(" " + String(attr.@name) + "=\"") != -1)
							{
								stringPropertiesTag = clearAttributeDuplicate(stringPropertiesTag, String(attr.@name));
							}
							stringPropertiesTag = stringPropertiesTag.replace("/>", String(attr.@name) + '="' + (attr.@defaultValue != "" ? String(attr.@defaultValue) : "") + '" />');
						}
						
						// attributo properties
						if (String(attr.@subset) == "properties")
						{
							if (stringPropertiesTag.indexOf(" " + String(attr.@name) + "=\"") != -1)
							{
								stringPropertiesTag = clearAttributeDuplicate(stringPropertiesTag, String(attr.@name));
							}
							stringPropertiesTag = stringPropertiesTag.replace("/>", String(attr.@name) + '="' + (attr.@defaultValue != "" ? String(attr.@defaultValue) : "") + '" />');
						}
						
						// attributo events
						if (String(attr.@subset) == "events")
						{
							stringEventsTag = stringEventsTag.replace("/>", String(attr.@name) + '="' + (attr.@defaultValue != "" ? String(attr.@defaultValue) : "") + '" />');
							
							// poniamo il valore dell'attributo dentro properties comunque
							if (stringPropertiesTag.indexOf(" " + String(attr.@name) + "=\"") != -1)
							{
								stringPropertiesTag = clearAttributeDuplicate(stringPropertiesTag, String(attr.@name));
							}
							stringPropertiesTag = stringPropertiesTag.replace("/>", String(attr.@name) + '="' + (attr.@defaultValue != "" ? String(attr.@defaultValue) : "") + '" />');
						}
						
						// attributo children
						if (String(attr.@subset) == "children")
						{
							stringChildrenTag = stringChildrenTag.replace("/>", String(attr.@name) + '="' + (attr.@defaultValue != "" ? String(attr.@defaultValue) : "") + '" />');
							
							// poniamo il valore dell'attributo dentro properties comunque
							if (stringPropertiesTag.indexOf(" " + String(attr.@name) + "=\"") != -1)
							{
								stringPropertiesTag = clearAttributeDuplicate(stringPropertiesTag, String(attr.@name));
							}
							stringPropertiesTag = stringPropertiesTag.replace("/>", String(attr.@name) + '="' + (attr.@defaultValue != "" ? String(attr.@defaultValue) : "") + '" />');
						}
					}
					component.appendChild(XML(stringCommonTag));
					component.appendChild(XML(stringStyleTag));
					component.appendChild(XML(stringLayoutTag));
					component.appendChild(XML(stringPropertiesTag));
					component.appendChild(XML(stringEventsTag));
					component.appendChild(XML(stringChildrenTag));*/
				}
			}
			
			// trace(componentsTranslated);
			return componentsTranslated;
		}
		
		/*private static function clearAttributeDuplicate(xmlString:String, attribute:String):String
		{
			var startIndex:int = xmlString.indexOf(" " + attribute + "=\"");
			var endIndex:int = xmlString.indexOf('"', startIndex + attribute.length + 3);
			var subs:String = xmlString.substring(startIndex, endIndex+1);
			xmlString = xmlString.replace(subs, "");
			return xmlString;
		}*/
	}
}