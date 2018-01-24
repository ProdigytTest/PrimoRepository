package comp
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;

	/**
	 * 
	 * Il manager dei componenti visuali da istanziare. Legge components.xml che, lo si
	 * ricorda, non può essere modificato. Eventuali modifiche degli utenti agli attributi
	 * globali vanno conservate in configDataSkin1.xml.
	 * 
	 */
	public class ComponentManager extends EventDispatcher
	{
		// il loader usato per il caricamento iniziale dell'xml richiesto
		private var xmlLoader:URLLoader;
		
		// l'xml caricato dal costruttore
		private var xmlLoaded:XMLList;
		
		// gestione del singleton
		private static var _access:Boolean = false;
		private static var _instance:ComponentManager;
		
		/**
		 * 
		 * Costruttore del singleton. 
		 * 
		 */
		public function ComponentManager()
		{
			if (!_access) throw new Error('Singleton');
		}
		
		/**
		 * 
		 * Recupero dell'unica istanza del manager all'interno del sistema.
		 * 
		 */
		public static function get instance():ComponentManager
		{
			if (_instance == null)
			{
				_access = true;
				_instance = new ComponentManager();
				_access = false;
			}
			return _instance;
		}
		
		/**
		 * 
		 *  Si occupa di caricare l'xml passato come argomento, e sistema tutte le variabili interne come al solito.
		 * 
		 */
		public function loadInstanceDefaults(xmlToLoad:String):void
		{			
			var xmlUrlRequest:URLRequest = new URLRequest();
			xmlUrlRequest.url = xmlToLoad;
			
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener( Event.COMPLETE, xmlArrivedHandler );
			xmlLoader.load(xmlUrlRequest);
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		private function xmlArrivedHandler(event:Event):void
		{
			xmlLoaded = new XMLList(xmlLoader.data);
			// trace(this.xmlLoaded.toString());
			
			// trace( getComponentNames() );
			// trace( getGlobalAttributes() );
			// trace( getGlobalInstanceDefaults() );
			// getGlobalInstanceDefaults();
			// trace( getComponentAttributes('FieldO') );
			// getComponentInstanceDefaults('FieldO');
			// trace( getComponentSpecificAttributes('FieldO') );
			// trace( getComponentSpecificInstanceDefaults('FieldO') );
			// trace( getComponentClassName('FieldIO') );
			
			dispatchEvent( new Event("xml loaded") );
		}
		
		/**
		 * 
		 * Restituisce l'elenco (array semplice) dei nomi dei componenti disponibili,
		 * come un elenco di stringhe.
		 * 
		 */
		public function getComponentNames():Array
		{
			// il vettore dei nomi dei componenti da resituire
			var componentNames:Array = [];
			
			// l'xml dei componenti deve essere stato caricato
			if (xmlLoaded == null)
				return null;
			
			// ciclo sui componenti per trovarne i nomi
			for each (var component:XML in xmlLoaded.components.*.children())
			{
				componentNames.push( String(component.localName()) );
			}
			
			return componentNames.sort();
		}
		
		/**
		 * 
		 * Restituisce l'elenco (di stringhe) dei nomi degli attributi globali.
		 * 
		 */
		public function getGlobalAttributes():Array
		{
			// il vettore dei nomi dei componenti da resituire
			var globalAttributesNames:Array = [];
			
			// l'xml dei componenti deve essere stato caricato
			if (xmlLoaded == null)
				return null;
			
			// ciclo sui componenti per trovarne i nomi
			for each (var component:XML in xmlLoaded.commonAttr.children())
			{
				globalAttributesNames.push( String(component.@name) );
			}
			
			return globalAttributesNames.sort();
		}
		
		/**
		 * 
		 * Restituisce l'elenco di object {attributo:valoreDiDefault} che rappresentano
		 * tutti i valori di default dei componenti visuali.
		 * 
		 */
		public function getGlobalInstanceDefaults():Array
		{
			// il vettore dei nomi dei componenti da resituire
			var globalAttributesDefaults:Array = [];
			
			// l'xml dei componenti deve essere stato caricato
			if (xmlLoaded == null)
				return null;
			
			// ciclo sui componenti per trovarne i nomi e i valori di default
			for each (var component:XML in xmlLoaded.commonAttr.children())
			{
				var tempObj:Object = {};
				tempObj[String(component.@name)] = String(component.@defaultValue);
				globalAttributesDefaults.push( tempObj );
				// trace(tempObj[String(component.@name)]);
			}
			
			return globalAttributesDefaults;
		}
		
		/**
		 * 
		 * Restituisce l'elenco di tutti gli attributi (globali e non) del componente passato
		 * per nome come parametro.
		 * 
		 */
		public function getComponentAttributes(componentName:String):Array
		{
			// il vettore dei nomi degli attributi da resituire
			var componentAttributes:Array = [];
			
			// l'xml dei componenti deve essere stato caricato
			if (xmlLoaded == null)
				return null;
			
			// ciclo sui commonAttr per trovarne i nomi e i valori di default globali
			for each (var component:XML in xmlLoaded.commonAttr.children())
			{
				componentAttributes.push( String(component.@name) );
			}
			
			// ciclo sui componenti per trovarne valori di default specializzati per il componente passato
			var tempComponent:XML = xmlLoaded.components.*.*.(localName() == componentName)[0];
			for each (var attribute:XML in tempComponent.children())
			{
				if (componentAttributes.indexOf(String(attribute.@name)) == -1)
				{
					componentAttributes.push( String(attribute.@name) );
				}
			}
			
			return componentAttributes.sort();
		}
		
		/**
		 * 
		 * Restituisce l'array di tutti i valori degli attributi della classe passata come parametro,
		 * nella forma di oggetti del tipo: {attributo:valore}.
		 * 
		 */
		public function getComponentInstanceDefaults(componentName:String):Array
		{
			// il vettore dei nomi degli attributi da resituire
			var componentDefaultValues:Array = [];
			
			// l'xml dei componenti deve essere stato caricato
			if (xmlLoaded == null)
				return null;
			
			// oggetto di supporto per la scansione degli attributi
			var tempObj:Object = {};
			
			// ciclo sui commonAttr per trovarne i nomi e i valori di default globali
			for each (var globalAttribute:XML in xmlLoaded.commonAttr.children())
			{
				tempObj.name = String(globalAttribute.@name);
				tempObj.value = String(globalAttribute.@defaultValue);
				// trace(String(globalAttribute.@name) + ": " + String(globalAttribute.@defaultValue));
				componentDefaultValues.push( tempObj );
			}
			
			// ciclo sui componenti per trovarne valori di default specializzati per il componente passato
			var tempComponent:XML = xmlLoaded.components.*.*.(localName() == componentName)[0];
			for each (var attribute:XML in tempComponent.children())
			{
				if (componentDefaultValues.indexOf(String(tempComponent.@name)) == -1)
				{
					tempObj.name = String(attribute.@name);
					tempObj.value = String(attribute.@defaultValue);
					// trace(String(attribute.@name) + ": " + String(attribute.@defaultValue));
					componentDefaultValues.push( tempObj );
				}
			}
			
			return componentDefaultValues.sortOn('name');
		}
		
		/**
		 * 
		 * Restituisce l'elenco di tutti gli attributi specifici del componente il cui nome è stato
		 * passato come parametro. Vengono restituiti solo i nomi e non i valori di default.
		 * 
		 */
		public function getComponentSpecificAttributes(componentName:String):Array
		{
			// il vettore dei nomi degli attributi da resituire
			var componentSpecificAttributes:Array = [];
			
			// l'xml dei componenti deve essere stato caricato
			if (xmlLoaded == null)
				return null;
			
			// ciclo sui componenti per trovarne valori di default specializzati per il componente passato
			var tempComponent:XML = xmlLoaded.components.*.*.(localName() == componentName)[0];
			for each (var attribute:XML in tempComponent.children())
			{
				componentSpecificAttributes.push( String(attribute.@name) );
			}
			
			return componentSpecificAttributes.sort();
		}
		
		/**
		 * 
		 * Restituisce l'elenco degli attributi di default del componente passato nella forma {nome:valore}.
		 * 
		 */
		public function getComponentSpecificInstanceDefaults(componentName:String):Array
		{
			// il vettore dei nomi degli attributi da resituire
			var componentDefaultValues:Array = [];
			
			// l'xml dei componenti deve essere stato caricato
			if (xmlLoaded == null)
				return null;
			
			// oggetto di supporto per la scansione degli attributi
			var tempObj:Object = {};
			
			// ciclo sui componenti per trovarne valori di default specializzati per il componente passato
			var tempComponent:XML = xmlLoaded.components.*.*.(localName() == componentName)[0];
			for each (var attribute:XML in tempComponent.children())
			{
				tempObj.name = String(attribute.@name);
				tempObj.value = String(attribute.@defaultValue);
				componentDefaultValues.push( tempObj );
				// trace(tempObj.name + ": " + tempObj.value);
			}
			
			return componentDefaultValues.sortOn('name');
		}
		
		/**
		 * 
		 * Restituisce il nome della classe del componente passato come parametro.
		 * 
		 */
		public function getComponentClassName(componentName:String):String
		{
			// l'xml dei componenti deve essere stato caricato
			if (xmlLoaded == null)
				return null;
			
			// cerco la classe nella lista dei componenti visuali
			for each (var component:XML in xmlLoaded.components.*.children())
			{
				if (String(component.localName()) == componentName)
				{
					// uscita forzata: classe trovata
					return component.@className;
				}
			}
			
			// uscita naturale: classe non trovata
			return null;

		}
		
		/**
		 * 
		 * Controlla ed eventualmente restituisce il valore di un particolare attributo di un
		 * componente passato come parametro. Se non viene trovato si restutuisce null.
		 * 
		 */
		public function getAttributeInstanceDefault(componentName:String, attributeName:String):*
		{
			// l'xml dei componenti deve essere stato caricato
			if (xmlLoaded == null)
				return null;
			
			// cerco l'attributo nella lista specializzata del componente in questione
			var tempComponent:XML = xmlLoaded.components.*.*.(localName() == componentName)[0];
			for each (var attribute:XML in tempComponent.children())
			{
				if (String(attribute.@name) == attributeName)
				{
					// uscita forzata: attributo trovato
					return attribute.@defaultValue;
				}
			}
			
			// uscita naturale: attributo non trovato
			return null;
		}

	}
}