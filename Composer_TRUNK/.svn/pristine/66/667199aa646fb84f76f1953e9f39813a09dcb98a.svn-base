package comp
{
	import flash.display.NativeWindowInitOptions;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import it.prodigyt.engine.projectSheet.ComponentsManager;
	import it.prodigyt.engine.projectSheet.DefaultsManager;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.DataGrid;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.events.DataGridEvent;
	import it.prodigyt.panelcomposer.PCWindowNew;

	
	public class WinStyles extends PCWindowNew
	{
		
		protected var _styleName:String = "default"
		protected var _compName:String = "global"
		protected var styleGrid:DataGrid
		private var componentTextInput:TextInput;
		private var styleTextInput:TextInput;
		
		public function WinStyles(initOptions:NativeWindowInitOptions=null)
		{
			super(initOptions);
		}

		public function get styleName():String
		{
			return _styleName;
		}

		public function set styleName(value:String):void
		{
			_styleName = value;
		}

		public function get compName():String
		{
			return _compName;
		}

		public function set compName(value:String):void
		{
			_compName = value;
		}

		
		
		
		
		/**
		 * 
		 * 
		 * 
		 */
		private function setupStyleCanvas():void
		{
			var styleCanvas = new Canvas()
			styleCanvas.setStyle("backgroundColor", 0xffffff )
			styleCanvas.percentHeight =60
			styleCanvas.percentWidth =60
			var innerFormComponent = new  mx.controls.Label()
			
			innerFormComponent.text = "componente";
			innerFormComponent.x = 10
			innerFormComponent.y = 0
			
			
			componentTextInput = new TextInput();
			componentTextInput.buttonMode = true
			componentTextInput.useHandCursor = true
			componentTextInput.width = 160
			//componentTextInput.text = "global";
			componentTextInput.text = _compName;
			componentTextInput.editable = false
			componentTextInput.addEventListener(MouseEvent.CLICK, onCompClick)
			componentTextInput.addEventListener(Event.CHANGE, changeComp)
			componentTextInput.x = 10
			componentTextInput.y = 18
			styleCanvas.addChild( componentTextInput );
			styleCanvas.addChild( innerFormComponent );
			
			var innerFormStyle = new  mx.controls.Label()
			innerFormStyle.text = "style";
			innerFormStyle.x = 10
			innerFormStyle.y = 40
			styleTextInput = new TextInput();
			styleTextInput.addEventListener(MouseEvent.CLICK, onStyleClick) 
			styleTextInput.addEventListener(Event.CHANGE, changeStyle)
			styleTextInput.addEventListener(KeyboardEvent.KEY_DOWN, onStyleNameEnter) 
			styleTextInput.width = 160
			styleTextInput.text = _styleName;
			styleTextInput.x = 10
			styleTextInput.y = 58
			styleTextInput.editable = true
			styleCanvas.addChild( styleTextInput );
			styleCanvas.addChild( innerFormStyle );
			
			styleGrid = createGrid( 'style' );
			
			
			styleGrid.addEventListener(MouseEvent.RIGHT_CLICK, undoStyle);
			styleGrid.percentWidth = 100
			styleGrid.y = 90
			styleGrid.percentHeight =90
			styleCanvas.addChild(  styleGrid );
			reloadSpecificWindowDataGrid(  _compName, _styleName  );

		}
		
		private function changeComp(e:Event)
		{
			_compName = componentTextInput.text
		}
		private function changeStyle(e:Event)
		{
			_styleName = styleTextInput.text
		}
		
		private function onCompClick(e:Event)
		{
			showDynComponentList(windowsDictionary['winSpecifics'],componentTextInput, "text", onRetFromCompDynList )
			
			function onRetFromCompDynList()
			{
				styleTextInput.text = "default";
				_styleName = "default";
				reloadSpecificWindowDataGrid(  _compName, _styleName   );
			}
		}
		
		
		
		private function onStyleClick(e:Event)
		{
			showDynStyleList(_compName, windowsDictionary['winSpecifics'],styleTextInput, "text", onRetFromStyleDynList )
			
			function onRetFromStyleDynList()
			{
				if (styleTextInput.text=="<nuovo stile>")
				{
					styleTextInput.selectionBeginIndex = 0
					styleTextInput.selectionEndIndex = styleTextInput.text.length - 1
				}
				else
				{
					if (styleTextInput.text.indexOf(":")>-1)
					{
						// var newValue = String(componentsChooser.selectedItem).split(":");
						var newValue = String(styleDynamicList.selectedItem).split(":");
						_compName = newValue[1];
						componentTextInput = newValue[1];
						_styleName	= newValue[0];
						styleTextInput.text	= newValue[0];
					}
					reloadSpecificWindowDataGrid( _compName, _styleName );
				}
				
			}
		}
		
		
		private function onStyleNameEnter(e:KeyboardEvent)
		{
			
			_styleName = styleTextInput.text
				
			if (e.keyCode == Keyboard.ENTER )
			{
				if (_styleName =="<nuovo stile>" )
				{
					e.preventDefault()
					e.stopImmediatePropagation()
				}
				else if (_styleName =="<cancella stile>" )
				{
					e.preventDefault()
					e.stopImmediatePropagation()
					
					// da implementare: ricerca in tutto il project se usato questo stile; se on usato lo cancella	
				}
				else
				{
					// controllo di presenza dello stile inserito: se non c'è aggiungo lo stile e modifico la GUI
					if (DefaultsManager.getInstance().getStylesList( _compName ).indexOf( _styleName ) == -1)
					{
						
						// aggiorno il file di progetto con il nuovo stile
						if (! DefaultsManager.getInstance().addStyle(
							_compName,
							_styleName
						) )
						{
							for (var i:int=0; i<styleGrid.dataProvider.length-1; i++)
							{				
								DefaultsManager.getInstance().setSpecificDefault(
									_compName,
									styleGrid.dataProvider.getItemAt(i).attribute,
									styleGrid.dataProvider.getItemAt(i).value,
									_styleName
								)
							}
							
						}
						// ricarico lista stili aggiornata con ultimo aggiuntp
						var newDataProvider = new ArrayCollection(DefaultsManager.getInstance().getStylesList( _compName ));
						newDataProvider.addItemAt("<cancella stile>", 0);
						newDataProvider.addItemAt("<nuovo stile>", 0);
						styleDynamicList.dataProvider = newDataProvider
						
						
					}
					reloadSpecificWindowDataGrid(_compName,_styleName);
					
					//						// TEMP SOSPESO	
					//						// predisposizione dei vettori da passare alla updateGui
					//						var styleAttributesArray:Array = [];
					//						var styleValuesArray:Array = [];
					//						for (var s:int=0; s<pairingGrid.dataProvider.length; s++)
					//						{
					//							styleAttributesArray.push(String(pairingGrid.dataProvider.getItemAt(s).attribute));
					//							styleValuesArray.push(String(pairingGrid.dataProvider.getItemAt(s).value));
					//						}
					//						
					//						// aggiorno tutti i componenti visuali del tipo del pairing col nuovo stile
					//						updateGui(
					//							pairingGrid.dataProvider[cellRowIndex]['value'],
					//							styleAttributesArray,
					//							styleValuesArray,
					//							newValue
					//						);								
					
				}
			}
			
		}
		
		
		
		
		/**
		 * 
		 * 
		 * 
		 */
		private function createGrid(name:String):DataGrid
		{
			var grid:DataGrid = new DataGrid();

			grid.editable = true;

			grid.addEventListener(DataGridEvent.ITEM_EDIT_END, editEnd, false, 10); 
			grid.addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING, editBeginning);

			grid.name = name

			var columnOne:DataGridColumn = new DataGridColumn("attributo");
			
			columnOne.dataField = "attribute";
			columnOne.editable = false;
			
			var columnTwo:DataGridColumn = new DataGridColumn("valore");
			
			columnTwo.dataField = "value";
			columnTwo.itemRenderer = new ClassFactory( CustomItemRenderer );


			columnOne.width = 80;
			columnTwo.width = 60;
			grid.columns = [columnOne, columnTwo];

			// stili
			columnOne.setStyle("fontSize", 11)
			columnTwo.setStyle("fontSize", 11)
			grid.setStyle("paddingTop", 0)
			grid.setStyle("paddingBottom", 0)
			
			return grid;
		}
		
		
		
		/**
		 * 
		 * Modifica di una proprietà di data grid.
		 * 
		 */
		protected function editEnd(event:DataGridEvent):void
		{
			
			var dg:DataGrid = event.target as DataGrid;
			
			var oldval:String = (event.target as DataGrid).dataProvider[event.rowIndex]['value'];
			var newval:String = (dg.itemEditorInstance as TextInput).text;
			var attribute:String = String(event.itemRenderer.data.property);
			
			switch (event.reason)
			{
				case DataGridEventReason.CANCELLED:
				case DataGridEventReason.OTHER:
					break;
				case DataGridEventReason.NEW_COLUMN:
				case DataGridEventReason.NEW_ROW:
				{
					
					if (oldval == null && newval >" "
						||	oldval!= null && oldval != newval)
					{											
						
						// undo!! 
						var um:UndoManager = UndoManager.getInstance("style")
						if (um) um.execute(event.target, _compName, attribute, newval, _styleName, styleUndoId++, oldval)
						
						switch (attribute)
						{
							
							case "style":
								// non deve fare assolutamente niente !!!!
								break;
							
							case "borderColor":
							case "backgroundColor":
							case "foregroundColor":
								
								newval = cvtToHex(newval)
								
								// niente break: esegue le successive
								
								
							default:
								DefaultsManager.getInstance().setSpecificDefault(
									_compName,
									attribute,
									newval,
									_styleName
								);
								
								
								
								// riscrivo il valore del colore riformattato nel datagrid
								event.itemRenderer.data.value = newval;
								dg.invalidateProperties();
								dg.invalidateDisplayList();
								break;
						}
						
						
						// in caso di defaults aggiorno la gui e riaggiorno il projectdata corrente
						projectData = rebldProjectData()
						// applico stile modificato a tutti i componenti coinvolti
						applyStyleToGui( _compName, _styleName )
						
						break;
					}
				}
			}				
			
		}
		
		/**
		 * 
		 * Gestione di attributi speciali come backgroundImage, style e fontFamily.
		 * 
		 */
		private function editBeginning(event:DataGridEvent):void
		{
			if (event.localX < event.target.columns[0].width)
				return;
			
			// togliamo il componentChooser se presente
			if (contains(componentsChooser))
			{
				removeElement( componentsChooser );
				stage.removeEventListener(MouseEvent.CLICK, handleFocusOut, true);
			}
			
			var dg:DataGrid = event.target as DataGrid;
			var attribute:String = event.itemRenderer ? String(event.itemRenderer.data.property) : "";
			
			if (attribute == "backgroundImage")
			{
				event.preventDefault();
				var newValue:String = (dg.itemEditorInstance as TextInput) ? (dg.itemEditorInstance as TextInput).text : "";
				
				imgFileReference = new FileReference();
				    imgFileReference.addEventListener(Event.SELECT, onImageSelected);
				    var imgTypeFilter:FileFilter = new FileFilter("Image Files","*.png; *.jpg;*.gif");
				    imgFileReference.browse([imgTypeFilter]);
				
				// salvo i riferimenti ai parametri per il successivo eventuale aggiornamento della GUI
				imageDatagrid = dg;
			}
			else if ( attribute.indexOf('style')>-1 || attribute.indexOf('Style')>-1 || attribute == 'fontFamily')
			{
				// salvo l'indice per modificare la cella in seguito
				cellColumnIndex = event.columnIndex;
				cellRowIndex = event.rowIndex;
				originGrid = event.target as DataGrid;
				
				event.preventDefault();
				
				// aggiorno il componentChooser
				var compName:String;
				
				if (originGrid.name == 'style')
				{
					compName = String(originGrid.selectedItem.value);
				}
				else if (originGrid.name == 'instance')
				{
					compName = getQualifiedClassName( modifyItemsSelected[0] as PYComponent ).split('::')[1];
				}
				componentsChooser.dataProvider = setComponentsChooserDataProvider(originGrid.name, null, compName, attribute);
				
				if (originGrid.name == 'style') showComponentChooser(windowsDictionary['winSpecifics']);
				if (originGrid.name == 'instance') showComponentChooser(windowsDictionary['winInstanceProperties']);
			}
		}
		
		
		
		
		/**
		 * 
		 * Ricarica tutte le proprietà della griglia degli specifici.
		 * 
		 */
		private function reloadSpecificWindowDataGrid(componentName:String, style:String):void
		{
			// l'indice di scroll viene salvato per essere ripreso dopo il refresh
			var reloadIndex:int = styleGrid ? styleGrid.selectedIndex : -1;
			
			var element:String = componentName;
			var customAttributes:Array = [];
			var commonAttributes:XMLList = ComponentsManager.getInstance().components.commonAttr;
			var commonSubAttributes:XMLList = ComponentsManager.getInstance().components.subCommonAttr;
			var defaultAttributes:XML = DefaultsManager.getInstance().defaults;
			
			for each (var attribute:XML in commonAttributes.children())
			{
				customAttributes.push({attribute:attribute.@name, value:null, rowColor:'0x009900'});
			}
			for each (var subAttribute:XML in commonSubAttributes.children())
			{
				customAttributes.push({attribute:subAttribute.@name, value:null, rowColor:'0x009900'});
			}
			
			// rimouvo i duplicati fra i due vettori cui sopra per ottenere la lista completa delle proprietà dell'oggetto visuale
			var specificProperties:XML = ComponentsManager.getInstance().components.components.*.*.(localName()==element)[0];
			var found:Boolean;
			if (specificProperties != null)
			{
				for each (var child:XML in specificProperties.children())
				{
					found = false;
					for (var j:int=0; j<customAttributes.length; j++)
					{
						if (String(child.@name) == String(customAttributes[j].attribute))
						{
							found = true;
							break;
						}
					}
					if (!found)
						customAttributes.push({attribute:String(child.@name), value:null, rowColor:'0x009900'});
				}
			}
			
			// loop sui componenti presenti nella sezione stili
			for each (var customS:XML in defaultAttributes.skinProperties.styles.children())
			{
				if (customS.localName() == element )
				{
					// loop tra gli stili inclusi nella sezione componente
					for each (var custom:XML in customS.children())
					{
						if (custom.localName() ==  style)
						{
							// loop sugli attributi , finalmente!
							for each (var attr:XML in custom.attributes())
							{
								var alreadyPresent:Boolean = false;
								for (var i:int=0; i<customAttributes.length; i++)
								{
									if (customAttributes[i].attribute == attr.localName())
									{
										customAttributes[i].value = attr;
										alreadyPresent = true;
									}
								}
								if (!alreadyPresent)
								{
									customAttributes.push({attribute:attr.localName(), value:attr, rowColor:'0x009900'});
								}
							}
						}
					}
				}
			}
			
			styleGrid.dataProvider = new ArrayCollection( customAttributes.sortOn('attribute') );
			
			if (reloadIndex != -1)
			{
				styleGrid.scrollToIndex(reloadIndex);
				styleGrid.selectedIndex = reloadIndex;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}