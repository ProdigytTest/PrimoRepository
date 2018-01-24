package comp
{
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	import flash.display.Screen;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import spark.components.WindowedApplication;
	import spark.primitives.Rect;

	/**
	 * 
	 * Manager per la gestione delle viste nel panel composer.
	 * 
	 */
	public class ViewsManager extends EventDispatcher
	{
		private static const WIN_CONVERTED_BASE_WIDTH:int	= 1280;
		private static const REFERENCE_WIDTH:int 			= 1280 - 140;
		private static const REFERENCE_HEIGHT:int			= 768 - 40;
		
		// l'unica istanza del manager nel sistema
		private static var _instance:ViewsManager;
		
		// il dizionario delle viste
		private var _views:Dictionary;
		
		// il dizionario delle finestre del componente principale
		private var _windows:Dictionary;
		
		// Riferimento al WindowedApplication principale (quello che tiene le misure della finestra nativa -windows o iOS-)
		private var _nativeWindowArea:Rectangle;		

		// Riferimento al WindowedApplication principale (quello che tiene le misure giuste dello spazio dentro la finestra meno menù e homeArea)
		private var _windowedApplicationAvailableArea:Rectangle;
		
		
		
		/**
		 * 
		 * Costruttore.
		 * 
		 */
		public function ViewsManager(enforcer:SingletonEnforcer)
		{
			_views = new Dictionary();
		}
		
		/**
		 * 
		 * Recupero dell'unica istanza del manager all'interno del sistema.
		 * 
		 */
		public static function getInstance():ViewsManager
		{
			if (_instance == null)
			{
				_instance = new ViewsManager(new SingletonEnforcer());
			}
			return _instance;
		}
		
		/**
		 * 
		 * Predisposizione delle configurazioni ad inizio progetto.
		 * 
		 */
		public function prepareViews():void
		{		
			// Spazio disponibile nell'interiore della finestra
			var bounds:Rectangle = new Rectangle(0,0,windowedApplicationAvailableArea.width,windowedApplicationAvailableArea.height);
			// Misura della finestra nativa (Win/iOS/Linux)
			var nativeBounds:Rectangle = new Rectangle(0,0,nativeWindowArea.width,nativeWindowArea.height);
			
			var winConverted:PCWindow 			= _windows['winConverted'];
			var winDesktopElements:PCWindow		= _windows['winDesktopElements'];
			var winDesktops:PCWindow			= _windows['winDesktops'];
			var winGlobals:PCWindow 			= _windows['winGlobals'];
			var winInpData:PCWindow				= _windows['winInpData'];
			var winInstanceProperties:PCWindow 	= _windows['winInstanceProperties'];
			var winOutData:PCWindow				= _windows['winOutData'];
			var winOutline:PCWindow 			= _windows['winOutline'];
			var winPairing:PCWindow				= _windows['winPairing'];
			var winSpecifics:PCWindow			= _windows['winSpecifics'];
			var winTrace:PCWindow				= _windows['winTrace'];
			var winTree:PCWindow				= _windows['winTree'];
			var winXml:PCWindow					= _windows['winXml'];
			var winStyle:PCWindow				= _windows['winStyle']
			
			var winConvertedV:Array;
			var winConvertedS:Number;
			var winConvertedS_Modify:Number;
			var winDesktopElementsV:Array;
			var winDesktopElementsS:Number		= 1;
			var winDesktopsV:Array;
			var winDesktopsS:Number				= 1;
			var winGlobalsV:Array;
			var winGlobalsS:Number				= 1;
			var winInpDataV:Array;
			var winInpDataS:Number				= 1;
			var winInstancePropertiesV:Array;
			var winInstancePropertiesS:Number	= 1;
			var winOutDataV:Array;
			var winOutDataS:Number				= 1;
			var winOutlineV:Array;
			var winOutlineS:Number				= 1;
			var winPairingV:Array;
			var winPairingS:Number				= 1;
			var winSpecificsV:Array;
			var winSpecificsS:Number			= 1;
			var winTraceV:Array;
			var winTraceS:Number				= 1;
			var winTreeV:Array;
			var winTreeS:Number					= 1;
			var winXmlV:Array;
			var winXmlS:Number					= 1;

			var pcwMinHeight:int				= 200;
			var scaleWC:Number;

			winInstancePropertiesV 	= [0,windowedApplicationAvailableArea.height/2,450,windowedApplicationAvailableArea.height/2-5];

			if (nativeBounds.height < 768)
			{
				// Like 800x455 (SmartPhones)
				winConvertedS = .5;
				winConvertedS_Modify = .7;
				winConvertedV = [bounds.width-WIN_CONVERTED_BASE_WIDTH*winConvertedS-5,0,WIN_CONVERTED_BASE_WIDTH,768];
			} else if (nativeBounds.height < 900)	{
				if (nativeBounds.width < 1200)
				{
					// Like 1024x768 (Old PCs or small tablets)
					winConvertedS = .5;
					winConvertedS_Modify = .7;
					winConvertedV = [bounds.width-WIN_CONVERTED_BASE_WIDTH*winConvertedS-5,0,WIN_CONVERTED_BASE_WIDTH,768];
				} else {
					// Like 1200x768
					winConvertedS = .6;
					winConvertedS_Modify = .7;
					winConvertedV = [bounds.width-WIN_CONVERTED_BASE_WIDTH*winConvertedS-5,0,WIN_CONVERTED_BASE_WIDTH,768];
				}
			} else if (nativeBounds.height < ((winConverted.stage.nativeWindow.displayState==NativeWindowDisplayState.MAXIMIZED)? 1066 : 1080)) {
				// Like 1600x900
				winConvertedS = .7;
				winConvertedS_Modify = .8;
				winConvertedV = [bounds.width-WIN_CONVERTED_BASE_WIDTH*winConvertedS-5,0,WIN_CONVERTED_BASE_WIDTH,768];
			} else if (nativeBounds.height < 1440) {
				// Like 1920x1080
				winConvertedS = .8;
				winConvertedS_Modify = 1;
				winConvertedV = [bounds.width-WIN_CONVERTED_BASE_WIDTH*winConvertedS-5,0,WIN_CONVERTED_BASE_WIDTH,768];
			} else {
				// Like 2560x1440
				winConvertedS = 1.0;
				winConvertedS_Modify = 1;
				winConvertedV = [bounds.width-WIN_CONVERTED_BASE_WIDTH-5,0,WIN_CONVERTED_BASE_WIDTH,768];
				winInstancePropertiesV = [0,windowedApplicationAvailableArea.height/2,450,windowedApplicationAvailableArea.height/2-5];
			}
			
			// Defaults (Project)
			winGlobalsV				= [0,0,Math.floor((windowedApplicationAvailableArea.width-winConvertedV[2]*winConvertedS)/2)-10,windowedApplicationAvailableArea.height-5];
			winPairingV				= [winConvertedV[0],windowedApplicationAvailableArea.height-Math.max(100,windowedApplicationAvailableArea.height-winConvertedV[3]*winConvertedS-5),winConvertedV[2]*winConvertedS/2-5,Math.max(100,windowedApplicationAvailableArea.height-winConvertedV[3]*winConvertedS-5)-5];
			winSpecificsV			= [Math.floor((windowedApplicationAvailableArea.width-winConvertedV[2]*winConvertedS)/2)-5,0,Math.floor((windowedApplicationAvailableArea.width-winConvertedV[2]*winConvertedS)/2)-5,windowedApplicationAvailableArea.height-5];
			
			// Desktop
			winDesktopsV			= [winConvertedV[0],windowedApplicationAvailableArea.height-Math.max(100,windowedApplicationAvailableArea.height-winConvertedV[3]*winConvertedS-5),winConvertedV[2]*winConvertedS/2-5,Math.max(100,windowedApplicationAvailableArea.height-winConvertedV[3]*winConvertedS-5)-5];
			winDesktopElementsV		= [0,0,Math.floor((windowedApplicationAvailableArea.width-winConvertedV[2]*winConvertedS)/2)-10,windowedApplicationAvailableArea.height-5];
			
			// Debug
			if (nativeBounds.height < ((winConverted.stage.nativeWindow.displayState==NativeWindowDisplayState.MAXIMIZED)? 1066 : 1080))
			{
				// Like 1600x900
				winTreeV				= [0, 0, (windowedApplicationAvailableArea.width-winConvertedV[2]*winConvertedS)/2-5, windowedApplicationAvailableArea.height-5];
				winInpDataV				= [(windowedApplicationAvailableArea.width-winConvertedV[2]*winConvertedS)/2, 0, (windowedApplicationAvailableArea.width-winConvertedV[2]*winConvertedS)/2-10, (winConvertedV[3]*winConvertedS-5)/2];
				winOutDataV				= [(windowedApplicationAvailableArea.width-winConvertedV[2]*winConvertedS)/2, (winConvertedV[3]*winConvertedS+5)/2, (windowedApplicationAvailableArea.width-winConvertedV[2]*winConvertedS)/2-10, (winConvertedV[3]*winConvertedS-5)/2];
				winTraceV				= [(windowedApplicationAvailableArea.width-winConvertedV[2]*winConvertedS)/2, windowedApplicationAvailableArea.height-Math.max(100,windowedApplicationAvailableArea.height-winConvertedV[3]*winConvertedS-5), (windowedApplicationAvailableArea.width-(windowedApplicationAvailableArea.width-winConvertedV[2]*winConvertedS)/2)-5, Math.max(100,windowedApplicationAvailableArea.height-winConvertedV[3]*winConvertedS-5)-5];
			} else {
				// Like 1920x1080 or bigger
				winTreeV				= [0, 0, 295, windowedApplicationAvailableArea.height-5];
				winInpDataV				= [300, 0, (windowedApplicationAvailableArea.width-300-winConvertedV[2]*winConvertedS)-10, (winConvertedV[3]*winConvertedS-5)/2];
				winOutDataV				= [300, (winConvertedV[3]*winConvertedS+5)/2, (windowedApplicationAvailableArea.width-300-winConvertedV[2]*winConvertedS)-10, (winConvertedV[3]*winConvertedS-5)/2];
				winTraceV				= [300, windowedApplicationAvailableArea.height-Math.max(100,windowedApplicationAvailableArea.height-winConvertedV[3]*winConvertedS-5), (windowedApplicationAvailableArea.width-300)-5, Math.max(100,windowedApplicationAvailableArea.height-winConvertedV[3]*winConvertedS-5)-5];
			}
			
			// vista 1: modifiche ragno (versione da testare)
			_views['Modify'] = [
				createWindowView(winOutline, 0, 0, 450,  (bounds.height/2 - 5), 1, 1),
				createWindowView(winConverted, (bounds.width-WIN_CONVERTED_BASE_WIDTH*winConvertedS_Modify-5), winConvertedV[1], winConvertedV[2], winConvertedV[3], winConvertedS_Modify, winConvertedS_Modify),
				createWindowView(winInstanceProperties, winInstancePropertiesV[0], winInstancePropertiesV[1], winInstancePropertiesV[2], winInstancePropertiesV[3], winInstancePropertiesS, winInstancePropertiesS),
				createWindowView(winSpecifics, 455, 621, 450, 190, 1, 1)
				// createWindowView(winStyle, 451, 610, 450, 200, 1, 1)
			];
			
			// vista 2: modifiche ai defaults
			_views['Project'] = [
				createWindowView(winConverted, winConvertedV[0], winConvertedV[1], winConvertedV[2], winConvertedV[3], winConvertedS, winConvertedS),
				createWindowView(winGlobals, winGlobalsV[0], winGlobalsV[1], winGlobalsV[2], winGlobalsV[3], winGlobalsS, winGlobalsS),
				createWindowView(winPairing, winPairingV[0], winPairingV[1], winPairingV[2], winPairingV[3], winPairingS, winPairingS),
				createWindowView(winSpecifics, winSpecificsV[0], winSpecificsV[1], winSpecificsV[2], winSpecificsV[3], winSpecificsS, winSpecificsS)
			];
			
			// vista 3: modifiche al desktop
			_views['Desktops'] = [
				createWindowView(winConverted, winConvertedV[0], winConvertedV[1], winConvertedV[2], winConvertedV[3], winConvertedS, winConvertedS),
				createWindowView(winDesktops, winDesktopsV[0], winDesktopsV[1], winDesktopsV[2], winDesktopsV[3], winDesktopsS, winDesktopsS),
				createWindowView(winDesktopElements, winDesktopElementsV[0], winDesktopElementsV[1], winDesktopElementsV[2], winDesktopElementsV[3], winDesktopElementsS, winDesktopElementsS),
				createWindowView(winSpecifics, winSpecificsV[0], winSpecificsV[1], winSpecificsV[2], winSpecificsV[3], winSpecificsS, winSpecificsS)
			];
			
			// vista 4: debug
			_views['Debug'] = [
				createWindowView(winConverted, winConvertedV[0], winConvertedV[1], winConvertedV[2], winConvertedV[3], winConvertedS, winConvertedS),
				createWindowView(winTree, winTreeV[0], winTreeV[1], winTreeV[2], winTreeV[3], winTreeS, winTreeS),
				createWindowView(winInpData, winInpDataV[0], winInpDataV[1], winInpDataV[2], winInpDataV[3], winInpDataS, winInpDataS),
				createWindowView(winOutData, winOutDataV[0], winOutDataV[1], winOutDataV[2], winOutDataV[3], winOutDataS, winOutDataS),
				createWindowView(winTrace, winTraceV[0], winTraceV[1], winTraceV[2], winTraceV[3], winTraceS, winTraceS),
				];
			
			// vista 5: vista libera
			_views['Free'] = [
				createWindowView(winConverted, winConvertedV[0], winConvertedV[1], winConvertedV[2], winConvertedV[3], winConvertedS, winConvertedS),
			];		
			
			//-------------------------------------------------------------------------------------
			
			// RUGGERO
			
			
			if (nativeBounds.width < 1200)
			{
					// Like 1024x768 (Old PCs or small tablets)
					winConvertedS = .5;
			} else if (nativeBounds.width > 1200 && nativeBounds.width < 1400) {
					// Like 1200x768
					winConvertedS = .7;
			} else if (nativeBounds.width > 1400 && nativeBounds.width < 1650) {
				// Like 1600x900
				winConvertedS = .8;
			} else if (nativeBounds.height < 1440) {
				// Like 1920x1080
				winConvertedS = 1;
			} else {
				// Like 2560x1440
				winConvertedS = 1.0;
			}
			
			
			// vista 1: modifiche ragno (versione da testare)
			_views['Modify'] = [
				createWindowView(winSpecifics, 0, 0, 190,  (bounds.height/2 - 5), 1, 1),
				createWindowView(winInstanceProperties, 0,  (bounds.height/2 - 5), 190, (bounds.height/2 - 5), 1, 1),
				createWindowView(winConverted, winSpecifics.width+1, 0, winConvertedV[2], winConvertedV[3], winConvertedS, winConvertedS),
				createWindowView(winOutline, winSpecifics.width+1, winConverted.height*winConvertedS+1,winConverted.width*winConvertedS,  (bounds.height-winConverted.height*winConvertedS), 1, 1)
			];
			
			// vista 2: modifiche ai defaults
			_views['Project'] = [
				createWindowView(winSpecifics,  0, 0, 190,  (bounds.height - 5), 1, 1),
				//createWindowView(winGlobals, 0,  (bounds.height/2 - 5), 190, (bounds.height/2 - 5), 1, 1),
				createWindowView(winConverted, winSpecifics.width+1, winConvertedV[1], winConvertedV[2], winConvertedV[3], winConvertedS, winConvertedS),
				createWindowView(winPairing, winSpecifics.width+1, winConverted.height*winConvertedS+1, winPairingV[2],  (bounds.height-winConverted.height*winConvertedS), 1, 1)
			];
			
			
		}
		
		/**
		 * 
		 * Verifica se la finestra passata come primo parametro rientra nella configurazione passata
		 * come secondo parametro.
		 * 
		 */
		public function hasWindowInConfiguration(window:PCWindow, view:String):Boolean
		{
			var outcome:Boolean = false;
			
			var windowConf:WindowConfiguration;
			for (var i:int=0; i<_views[view].length; i++)
			{
				windowConf = _views[view][i] as WindowConfiguration;
				if (windowConf.window == window)
				{
					outcome = true;
					break;
				}
			}
			
			return outcome;
		}
		
		/**
		 * 
		 * Crea una vista relativa ad una finestra.
		 * 
		 */
		private function createWindowView(window:PCWindow, xPos:int, yPos:int, width:int, height:int, xScale:Number, yScale:Number):WindowConfiguration
		{
			var elementWindow:WindowConfiguration = new WindowConfiguration();
			elementWindow.window = window;
			elementWindow.x = xPos;
			elementWindow.y = yPos;
			elementWindow.w = width;
			elementWindow.h = height;
			elementWindow.xScale = xScale;
			elementWindow.yScale = yScale;
			return elementWindow;
		}

		/**
		 * 
		 * Getters & setters.
		 * 
		 */
		public function set windows(value:Dictionary):void { _windows = value; }
		public function get windows():Dictionary { return _windows; }
		public function get views():Dictionary { return _views; }
		
		public function get nativeWindowArea():Rectangle
		{
			return _nativeWindowArea;	
		}
		
		public function set nativeWindowArea(value:Rectangle):void
		{
			_nativeWindowArea = value;	
		}
		
		public function get windowedApplicationAvailableArea():Rectangle
		{
			return _windowedApplicationAvailableArea;
		}

		public function set windowedApplicationAvailableArea(value:Rectangle):void
		{
			_windowedApplicationAvailableArea = value;
		}


	}
}

internal class SingletonEnforcer{}