package comp
{
	import it.prodigyt.coreObsolete.ibm5250Obsolete.PanelMediatorV2;
	import it.prodigyt.coreObsolete.ibm5250Obsolete.SkinXML;
	import it.prodigyt.components.base.text.Constant;
	import it.prodigyt.components.core.PYComponent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import it.prodigyt.transformation.proxies.TransformToolAS3Proxy;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.events.CollectionEvent;
	import mx.events.DataGridEvent;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.BorderContainer;
	import it.prodigyt.panelcomposer.RagnoEvent;

	public class TransformationsManager
	{
		private static var _instance:TransformationsManager;
		
		private var _active:Boolean = false;
		private var _constantsCursor:IViewCursor;
		private var _panelComposer:PanelComposer;
		private var _panelMediator:PanelMediatorV2;
		private var _skinXML:SkinXML;
		private var _target:PYComponent;
		private var _transformableComponents:Dictionary;
		private var _transformableConstantsAC:ArrayCollection;
		private var _winConverted:PCWindow;
		private var _gridSprite:Sprite;
		
		/**
		 * @param enforcer Avoids accidental direct instantiation from another class.
		 */		
		public function TransformationsManager(enforcer:SingletonEnforcer)
		{
			_skinXML = new SkinXML();
			_skinXML.init();
		}
		
		/**
		 * @return singleton instance of KeywordsManager
		 */
		public static function getInstance():TransformationsManager
		{
			if( _instance == null )
				_instance =	new TransformationsManager(new SingletonEnforcer());
			
			return _instance;			
		}

		/**
		 * Tells whether the targetted component is undergoing transformations or not 
		 */
		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
			if (value)
			{
				resetTransformables();
				activateTransformableComponents();
			} else {
				deactivateTransformToolCapabilities();
			}
		}
		
		public function get panelComposer():PanelComposer
		{
			return _panelComposer;
		}
		
		public function set panelComposer(value:PanelComposer):void
		{
			_panelComposer = value;
		}
		
		public function get panelMediator():PanelMediatorV2
		{
			return _panelMediator;
		}
		
		public function set panelMediator(value:PanelMediatorV2):void
		{
			_panelMediator = value;
		}
		
		public function get target():PYComponent
		{
			return _target;
		}
		
		public function set target(value:PYComponent):void
		{
			_target = value;
		}
		
		public function get winConverted():PCWindow
		{
			return _winConverted;
		}
		
		public function set winConverted(value:PCWindow):void
		{
			_winConverted = value;
		}
		
		protected function destroyedHandler(event:Event):void
		{
			// Remove the reference to a TransformToolAS3Proxy that is not being used anymore
			_transformableComponents[(event.target as TransformToolAS3Proxy).target] = null;
		}
		
		protected function itemEditEndHandler(event:DataGridEvent):void
		{
			//			for each (var ttap:TransformToolAS3Proxy in _transformableComponents)
			//			{
			//				ttap.updateTool();
			//trace("[" + ttap + "] is updating its TransformTool and stuff");
			//			}			
		}
		
		protected function transformToolProxyEventHandler(event:RagnoEvent):void
		{
			if (event.component is Constant)
			{
				_transformableConstantsAC.refresh();
				_constantsCursor = _transformableConstantsAC.createCursor();
				_constantsCursor.findFirst(event.component);
				if (event.type==RagnoEvent.MOVE_NEXT) _constantsCursor.moveNext();
				if (event.type==RagnoEvent.MOVE_PREVIOUS) _constantsCursor.movePrevious();
				var component:PYComponent = _constantsCursor.current as PYComponent;				
				if (component)
				{
					clearTransformableComponents();
					panelComposer.activateInstancePropertiesWindow(component);
					var ttap:TransformToolAS3Proxy = instantiateTransformTool(component);
					ttap.activateEditableTextField();
				}
			}
		}
		
		protected function transformableComponents_clickHandler(event:MouseEvent):void
		{
			var pyc:PYComponent = event.currentTarget as PYComponent;
			if (pyc && pyc.visible)
			{
				event.stopPropagation();
				if (!event.shiftKey) clearTransformableComponents();
				panelComposer.activateInstancePropertiesWindow(pyc);
				instantiateTransformTool(pyc);
			}
		}
		
		
		protected function transformedHandler(event:RagnoEvent):void
		{
			// Update info on InstanceProperties window
			var ac:ArrayCollection = panelComposer.instancePropertiesDataProvider;
			var restoreHandlerAfterDispatch:Boolean = false;
			// 
			for (var key:String in event.modifiedProperties)
			{
				for (var i:int=0; i<panelComposer.instancePropertiesDataProvider.length; i++)
				{
					if (panelComposer.instancePropertiesDataProvider.getItemAt(i)["property"]==key && 
						panelComposer.instancePropertiesDataProvider.getItemAt(i)["value"] != event.modifiedProperties[key])
					{
						// Deactivate listener temporarily so as to avoid an infinite loop instanceProperties->TransformTool->Component->instanceProperties...
						if (panelComposer.instancePropertiesDataProvider.hasEventListener(CollectionEvent.COLLECTION_CHANGE))
						{
							panelComposer.instancePropertiesDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
							restoreHandlerAfterDispatch = true;
						}
						// Update XML (via Dictionary)
						panelComposer.modifyProperty(event.component, key, event.modifiedProperties[key]);
						// Update instanceProperties dataProvider data
						panelComposer.instancePropertiesDataProvider.getItemAt(i)["value"] = event.modifiedProperties[key];
						panelComposer.instancePropertiesDataProvider.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
						if (restoreHandlerAfterDispatch)
						{
							panelComposer.instancePropertiesDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
						}
						continue;
					}
				}				
			}			
		}
		
		protected function collectionChangeHandler(event:CollectionEvent):void
		{
			for each (var ttap:TransformToolAS3Proxy in _transformableComponents)
			{
				ttap.updateTool();
				trace("[" + ttap + "] is updating its TransformTool and stuff");
			}			
		}
		
		/**
		 * @private
		 */
		private function instantiateTransformTool(pyc:PYComponent):TransformToolAS3Proxy
		{
			var doc:DisplayObjectContainer;
			var ttap:TransformToolAS3Proxy;
			
			if (pyc && pyc.visible)
			{					
				if (_transformableComponents[pyc] == null)
				{
					doc = pyc.parent;
					
					ttap 			= new TransformToolAS3Proxy();
					ttap.area		= doc;
					ttap.container	= winConverted as BorderContainer;
					ttap.stepWidth 	= _skinXML.charX;
					ttap.stepHeight = _skinXML.charY;
					ttap.target 	= pyc;
					
					//pyc.addEventListener(YComponent.DRAW,drawHandler);

					//ttap.useScale = true;
					
					panelComposer.instancePropertiesDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
					//panelComposer.instancePropertiesDataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END,itemEditEndHandler);

					ttap.addEventListener(RagnoEvent.TRANSFORMED, transformedHandler);
					ttap.addEventListener(RagnoEvent.MOVE_NEXT, transformToolProxyEventHandler);
					ttap.addEventListener(RagnoEvent.MOVE_PREVIOUS, transformToolProxyEventHandler);
					ttap.addEventListener(RagnoEvent.DESTROYED, destroyedHandler);
					
					_transformableComponents[pyc] = ttap;
					

				}
			}
			
			return ttap;			
		}
		
		private function activateTransformableComponents():void
		{			
			var area:PYComponent = target;
			
			applyRecursively(area, addActivationListener);
			
			applyRecursively(area, addConstantsToCollection);
			
			panelMediator.toggleCursorActivity(false);
			
		}
		
		private function addActivationListener(component:PYComponent):void
		{
			component.addEventListener(MouseEvent.CLICK,transformableComponents_clickHandler);				
		}
		
		private function addConstantsToCollection(component:PYComponent):void
		{
			if ((component is Constant) && (component.visible))
			{
				_transformableConstantsAC.addItem(component);
				_transformableConstantsAC.refresh();
				if (!_constantsCursor) _constantsCursor = _transformableConstantsAC.createCursor();
				_constantsCursor.findFirst(component);
			}
		}
		
		private function applyRecursively(component:DisplayObjectContainer, method:Function):void
		{
			if (component is PYComponent)
			{
				//trace(component.name);
				method(component);
			}
			if (component.numChildren!=0)
			{
				for (var i:int=0; i<component.numChildren; i++)
				{
					var child:DisplayObjectContainer = component.getChildAt(i) as DisplayObjectContainer;
					if (child) applyRecursively(child, method);
				}
			}
		}
		
		private function clearTransformableComponents():void
		{
			var doc:DisplayObjectContainer;
			var ttap:TransformToolAS3Proxy;
			
			for (var key:Object in _transformableComponents)
			{
				if (_transformableComponents[key] != null)
				{
					doc = key.parent;
					_gridSprite = null;
					ttap = _transformableComponents[key];
					ttap.removeEventListener(RagnoEvent.TRANSFORMED, transformedHandler);
					ttap.removeEventListener(RagnoEvent.MOVE_NEXT, transformToolProxyEventHandler);
					ttap.removeEventListener(RagnoEvent.MOVE_PREVIOUS, transformToolProxyEventHandler);
					ttap.removeEventListener(RagnoEvent.DESTROYED, destroyedHandler);
					ttap.destroy();
				}
			}
			_transformableComponents = new Dictionary(true);
//			resetTransformables();
		}
		
		private function deactivateTransformToolCapabilities():void
		{
			clearTransformableComponents();

			var area:PYComponent = target;
			
			applyRecursively(area, removeActivationListener);
			
			panelMediator.toggleCursorActivity(true);
		}

		private function removeActivationListener(component:PYComponent):void
		{
			component.removeEventListener(MouseEvent.CLICK,transformableComponents_clickHandler);				
		}
		
		private function resetTransformables():void
		{
			_transformableComponents = new Dictionary(true);
			_transformableConstantsAC = new ArrayCollection();
			var _sort:Sort = new Sort();
			_sort.fields = [new SortField("y",false,true),new SortField("x",false,true)];
			_transformableConstantsAC.sort = _sort;
//			_constantsCursor = _transformableConstantsAC.createCursor();
		}
		
		
		
		/*
			
		
		_transformableComponents = new Dictionary(true);
		activateTransformToolCapabilities();
		_fixWinConvertedWhileTransformationInactive = winConverted.fixed;
		winConverted.fixed = true;

		else
		
		clearTransformableComponents();
		_transformableComponents = null;
		deactivateTransformToolCapabilities();
		dv_link.label = "ENABLE TRANSFORMATIONS";
		winConverted.fixed = _fixWinConvertedWhileTransformationInactive;

		*/
	}
}

internal class SingletonEnforcer{}