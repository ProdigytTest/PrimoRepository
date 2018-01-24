package
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.html.HTMLLoader;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.containers.Canvas;
	import mx.containers.Form;
	import mx.controls.Alert;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.controls.Tree;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.events.CollectionEvent;
	import mx.events.DataGridEvent;
	import mx.events.DataGridEventReason;
	import mx.events.ListEvent;
	
	import comp.ControlPanel;
	import comp.ControlPanelItem;
	import comp.CustomItemRenderer;
	import comp.CustomTreeItemRenderer;
	import comp.NativeAppLauncherDirect;
	import comp.NativeAppLauncherEvent;
	import comp.PCDefaultColors;
	import comp.PCWindowNew;
	import comp.PYDatagrid;
	import comp.PrjLoader;
	
	import it.prodigyt.client.Client;
	import it.prodigyt.client.ClientEvent;
	import it.prodigyt.components.base.containers.BaseLayout;
	import it.prodigyt.components.base.containers.DisplayFile;
	import it.prodigyt.components.base.containers.SflRow;
	import it.prodigyt.components.base.controls.PYButton;
	import it.prodigyt.components.base.controls.PYColorHolder;
	import it.prodigyt.components.base.inputs.FieldIO;
	import it.prodigyt.components.base.tables.BaseColumnV2;
	import it.prodigyt.components.base.tables.BaseHeaderV2;
	import it.prodigyt.components.base.tables.BaseTableV2;
	import it.prodigyt.components.base.tables.HeaderV2Event;
	import it.prodigyt.components.base.text.Constant;
	import it.prodigyt.components.base.text.FieldO;
	import it.prodigyt.components.core.PYComponent;
	import it.prodigyt.components.core.PYContainer;
	import it.prodigyt.components.core.PYInputText;
	import it.prodigyt.components.core.PYLabel;
	import it.prodigyt.components.gui.as3.PYAlert;
	import it.prodigyt.components.gui.as3.PYBoxColorChooser;
	import it.prodigyt.components.gui.as3.PYNBoxSelectable;
	import it.prodigyt.components.gui.as3.PYNbox;
	import it.prodigyt.components.gui.as3.events.PYColorChooserEvent;
	import it.prodigyt.components.gui.as3.events.PYEvent;
	import it.prodigyt.components.gui.as3.events.PYNBoxEvent;
	import it.prodigyt.components.interfaces.IMeasurable;
	import it.prodigyt.engine.converter.Converter;
	import it.prodigyt.engine.converter.UIGenerator;
	import it.prodigyt.engine.elements5250.Dspf;
	import it.prodigyt.engine.managers.ControlSessionManager;
	import it.prodigyt.engine.managers.OVManager;
	import it.prodigyt.engine.managers.PanelMediator;
	import it.prodigyt.engine.managers.SessionManager;
	import it.prodigyt.engine.managers.events.SessionEvent;
	import it.prodigyt.engine.projectSheet.ComponentsManager;
	import it.prodigyt.engine.projectSheet.DefaultsManager;
	import it.prodigyt.engine.projectSheet.DesktopsManager;
	import it.prodigyt.engine.projectSheet.KeywordsManager;
	import it.prodigyt.engine.projectSheet.ManagerEvent;
	import it.prodigyt.engine.projectSheet.PYFontsManager;
	import it.prodigyt.engine.projectSheet.PairingsManager;
	import it.prodigyt.engine.projectSheet.RulesManager;
	import it.prodigyt.panelcomposer.InstanceManager;
	import it.prodigyt.panelcomposer.InstanceManager4Panels;
	import it.prodigyt.panelcomposer.ProjectBox;
	import it.prodigyt.panelcomposer.RagnoEvent;
	import it.prodigyt.panelcomposer.RagnoManager;
	import it.prodigyt.panelcomposer.UndoManager;
	import it.prodigyt.plugins.dds.KeywordsAnalyzer;
	import it.prodigyt.utils.CacheBitmapManager;
	import it.prodigyt.utils.ConnectionsPack;
	import it.prodigyt.utils.PyDirectoryManager;
	import it.prodigyt.utils.StringUtils;
	import it.prodigyt.utils.tree.TreeParser;
	
	public class PanelComposer
	{
		// Immagini dei pulsanti del menu del pannello di controllo
		
		[Embed(source="resources/abbinamento.png")]
		private const EMBEDDED_ABBINAMENTO:Class;
		private var bmpABBINAMENTO:Bitmap = new EMBEDDED_ABBINAMENTO();
		
		[Embed(source="resources/abilitare_modifiche_del_desktop.png")]
		private const EMBEDDED_ABILITARE_MODIFICHE_DEL_DESKTOP:Class;
		private var bmpABILITARE_MODIFICHE_DEL_DESKTOP:Bitmap = new EMBEDDED_ABILITARE_MODIFICHE_DEL_DESKTOP();
		
		[Embed(source="resources/abilitare_modifiche_del_pannello.png")]
		private const EMBEDDED_ABILITARE_MODIFICHE_DEL_PANNELLO:Class;
		private var bmpABILITARE_MODIFICHE_DEL_PANNELLO:Bitmap = new EMBEDDED_ABILITARE_MODIFICHE_DEL_PANNELLO();
		
		[Embed(source="resources/abilitare_modifiche_di_tabella.png")]
		private const EMBEDDED_ABILITARE_MODIFICHE_DI_TABELLA:Class;
		private var bmpABILITARE_MODIFICHE_DI_TABELLA:Bitmap = new EMBEDDED_ABILITARE_MODIFICHE_DI_TABELLA();
		
		[Embed(source="resources/abilitare_tracking_componenti.png")]
		private const EMBEDDED_ABILITARE_TRACKING_COMPONENTI:Class;
		private var bmpABILITARE_TRACKING_COMPONENTI:Bitmap = new EMBEDDED_ABILITARE_TRACKING_COMPONENTI();
		
		[Embed(source="resources/about_prodigyt_versions.png")]
		private const EMBEDDED_ABOUT_PRODIGYT_VERSIONS:Class;
		private var bmpABOUT_PRODIGYT_VERSIONS:Bitmap = new EMBEDDED_ABOUT_PRODIGYT_VERSIONS();
		
		[Embed(source="resources/albero_del_progetto.png")]
		private const EMBEDDED_ALBERO_DEL_PROGETTO:Class;
		private var bmpALBERO_DEL_PROGETTO:Bitmap = new EMBEDDED_ALBERO_DEL_PROGETTO();
		
		[Embed(source="resources/albero_di_modifiche_manuali.png")]
		private const EMBEDDED_ALBERO_DI_MODIFICHE_MANUALI:Class;
		private var bmpALBERO_DI_MODIFICHE_MANUALI:Bitmap = new EMBEDDED_ALBERO_DI_MODIFICHE_MANUALI();
		
		[Embed(source="resources/annulla.png")]
		private const EMBEDDED_ANNULLA:Class;
		private var bmpANNULLA:Bitmap = new EMBEDDED_ANNULLA();
		
		[Embed(source="resources/apri_project.png")]
		private const EMBEDDED_APRI_PROJECT:Class;
		private var bmpAPRI_PROJECT:Bitmap = new EMBEDDED_APRI_PROJECT();
		
		[Embed(source="resources/componenti.png")]
		private const EMBEDDED_COMPONENTI:Class;
		private var bmpCOMPONENTI:Bitmap = new EMBEDDED_COMPONENTI();
				
		[Embed(source="resources/copia.png")]
		private const EMBEDDED_COPIA:Class;
		private var bmpCOPIA:Bitmap = new EMBEDDED_COPIA();
				
		[Embed(source="resources/attivare_cache.png")]
		private const EMBEDDED_ATTIVARE_CACHE:Class;
		private var bmpATTIVARE_CACHE:Bitmap = new EMBEDDED_ATTIVARE_CACHE();
		
		[Embed(source="resources/disattivare_modifiche_manuali.png")]
		private const EMBEDDED_DISATTIVARE_MODIFICHE_MANUALI:Class;
		private var bmpDISATTIVARE_MODIFICHE_MANUALI:Bitmap = new EMBEDDED_DISATTIVARE_MODIFICHE_MANUALI();
		
		[Embed(source="resources/disattivare_modifiche_utente.png")]
		private const EMBEDDED_DISATTIVARE_MODIFICHE_UTENTE:Class;
		private var bmpDISATTIVARE_MODIFICHE_UTENTE:Bitmap = new EMBEDDED_DISATTIVARE_MODIFICHE_UTENTE();

		[Embed(source="resources/disattivare_regole_di_trasformazione.png")]
		private const EMBEDDED_DISATTIVARE_REGOLE_DI_TRASFORMAZIONE:Class;
		private var bmpDISATTIVARE_REGOLE_DI_TRASFORMAZIONE:Bitmap = new EMBEDDED_DISATTIVARE_REGOLE_DI_TRASFORMAZIONE();
		
		[Embed(source="resources/edit_with_notepad.png")]
		private const EMBEDDED_EDIT_WITH_NOTEPAD:Class;
		private var bmpEDIT_WITH_NOTEPAD:Bitmap = new EMBEDDED_EDIT_WITH_NOTEPAD();
		
		[Embed(source="resources/enable_components_tracking.png")]
		private const EMBEDDED_ENABLE_COMPONENTS_TRACKING:Class;
		private var bmpENABLE_COMPONENTS_TRACKING:Bitmap = new EMBEDDED_ENABLE_COMPONENTS_TRACKING();
		
		[Embed(source="resources/enable_modify_desktop.png")]
		private const EMBEDDED_ENABLE_MODIFY_DESKTOP:Class;
		private var bmpENABLE_MODIFY_DESKTOP:Bitmap = new EMBEDDED_ENABLE_MODIFY_DESKTOP();
		
		[Embed(source="resources/enable_modify_panel.png")]
		private const EMBEDDED_ENABLE_MODIFY_PANEL:Class;
		private var bmpENABLE_MODIFY_PANEL:Bitmap = new EMBEDDED_ENABLE_MODIFY_PANEL();
		
		[Embed(source="resources/enable_modify_tables.png")]
		private const EMBEDDED_ENABLE_MODIFY_TABLES:Class;
		private var bmpENABLE_MODIFY_TABLES:Bitmap = new EMBEDDED_ENABLE_MODIFY_TABLES();
		
		[Embed(source="resources/esporta.png")]
		private const EMBEDDED_ESPORTA:Class;
		private var bmpESPORTA:Bitmap = new EMBEDDED_ESPORTA();
				
		[Embed(source="resources/importa.png")]
		private const EMBEDDED_IMPORTA:Class;
		private var bmpIMPORTA:Bitmap = new EMBEDDED_IMPORTA();
		
		[Embed(source="resources/incolla.png")]
		private const EMBEDDED_INCOLLA:Class;
		private var bmpINCOLLA:Bitmap = new EMBEDDED_INCOLLA();
		
		[Embed(source="resources/istanza.png")]
		private const EMBEDDED_ISTANZA:Class;
		private var bmpISTANZA:Bitmap = new EMBEDDED_ISTANZA();
		
		[Embed(source="resources/keywords.png")]
		private const EMBEDDED_KEYWORDS:Class;
		private var bmpKEYWORDS:Bitmap = new EMBEDDED_KEYWORDS();
		
		[Embed(source="resources/log.png")]
		private const EMBEDDED_LOG:Class;
		private var bmpLOG:Bitmap = new EMBEDDED_LOG();
		
		[Embed(source="resources/modifica_con_editore_esterno.png")]
		private const EMBEDDED_MODIFICA_CON_EDITORE_ESTERNO:Class;
		private var bmpMODIFICA_CON_EDITORE_ESTERNO:Bitmap = new EMBEDDED_MODIFICA_CON_EDITORE_ESTERNO();
		
		[Embed(source="resources/outline.png")]
		private const EMBEDDED_OUTLINE:Class;
		private var bmpOUTLINE:Bitmap = new EMBEDDED_OUTLINE();
		
		[Embed(source="resources/pairing.png")]
		private const EMBEDDED_PAIRING:Class;
		private var bmpPAIRING:Bitmap = new EMBEDDED_PAIRING();
		
		[Embed(source="resources/pannello_di_controllo.png")]
		private const EMBEDDED_PANNELLO_DI_CONTROLLO:Class;
		private var bmpPANNELLO_DI_CONTROLLO:Bitmap = new EMBEDDED_PANNELLO_DI_CONTROLLO();
		
		[Embed(source="resources/redo.png")]
		private const EMBEDDED_REDO:Class;
		private var bmpREDO:Bitmap = new EMBEDDED_REDO();
		
		[Embed(source="resources/panels.png")]
		private const EMBEDDED_PANELS:Class;
		private var bmpPANELS:Bitmap = new EMBEDDED_PANELS();

		[Embed(source="resources/regole_di_trasformazione.png")]
		private const EMBEDDED_REGOLE_DI_TRASFORMAZIONE:Class;
		private var bmpREGOLE_DI_TRASFORMAZIONE:Bitmap = new EMBEDDED_REGOLE_DI_TRASFORMAZIONE();
		
		[Embed(source="resources/reorganize_windows.png")]
		private const EMBEDDED_REORGANIZE_WINDOWS:Class;
		private var bmpREORGANIZE_WINDOWS:Bitmap = new EMBEDDED_REORGANIZE_WINDOWS();
		
		[Embed(source="resources/riordinare_finestre.png")]
		private const EMBEDDED_RIORDINARE_FINESTRE:Class;
		private var bmpRIORDINARE_FINESTRE:Bitmap = new EMBEDDED_RIORDINARE_FINESTRE();
		
		[Embed(source="resources/ripristina.png")]
		private const EMBEDDED_RIPRISTINA:Class;
		private var bmpRIPRISTINA:Bitmap = new EMBEDDED_RIPRISTINA();
		
		[Embed(source="resources/salva_project_con_nome.png")]
		private const EMBEDDED_SALVA_PROJECT_CON_NOME:Class;
		private var bmpSALVA_PROJECT_CON_NOME:Bitmap = new EMBEDDED_SALVA_PROJECT_CON_NOME();
		
		[Embed(source="resources/salva_project.png")]
		private const EMBEDDED_SALVA_PROJECT:Class;
		private var bmpSALVA_PROJECT:Bitmap = new EMBEDDED_SALVA_PROJECT();
		
		[Embed(source="resources/save_project_as.png")]
		private const EMBEDDED_SAVE_PROJECT_AS:Class;
		private var bmpSAVE_PROJECT_AS:Bitmap = new EMBEDDED_SAVE_PROJECT_AS();
		
		[Embed(source="resources/save_project.png")]
		private const EMBEDDED_SAVE_PROJECT:Class;
		private var bmpSAVE_PROJECT:Bitmap = new EMBEDDED_SAVE_PROJECT();
		
		[Embed(source="resources/riavvia_desktop.png")]
		private const EMBEDDED_RIAVVIA_DESKTOP:Class;
		private var bmpRIAVVIA_DESKTOP:Bitmap = new EMBEDDED_RIAVVIA_DESKTOP();
		
		[Embed(source="resources/reboot_desktop.png")]
		private const EMBEDDED_REBOOT_DESKTOP:Class;
		private var bmpREBOOT_DESKTOP:Bitmap = new EMBEDDED_REBOOT_DESKTOP();
		
		[Embed(source="resources/schema.png")]
		private const EMBEDDED_SCHEMA:Class;
		private var bmpSCHEMA:Bitmap = new EMBEDDED_SCHEMA();
		
		[Embed(source="resources/selezionare_griglia.png")]
		private const EMBEDDED_SELEZIONARE_GRIGLIA:Class;
		private var bmpSELEZIONARE_GRIGLIA:Bitmap = new EMBEDDED_SELEZIONARE_GRIGLIA();
		
		[Embed(source="resources/selezionare_risoluzione.png")]
		private const EMBEDDED_SELEZIONARE_RISOLUZIONE:Class;
		private var bmpSELEZIONARE_RISOLUZIONE:Bitmap = new EMBEDDED_SELEZIONARE_RISOLUZIONE();
		
		[Embed(source="resources/split.png")]
		private const EMBEDDED_SPLIT:Class;
		private var bmpSPLIT:Bitmap = new EMBEDDED_SPLIT();
		
		[Embed(source="resources/stile.png")]
		private const EMBEDDED_STILE:Class;
		private var bmpSTILE:Bitmap = new EMBEDDED_STILE();
		
		[Embed(source="resources/struttura_del_dspf.png")]
		private const EMBEDDED_STRUTTURA_DEL_DSPF:Class;
		private var bmpSTRUTTURA_DEL_DSPF:Bitmap = new EMBEDDED_STRUTTURA_DEL_DSPF();
		
		[Embed(source="resources/taglia.png")]
		private const EMBEDDED_TAGLIA:Class;
		private var bmpTAGLIA:Bitmap = new EMBEDDED_TAGLIA();
		
		[Embed(source="resources/ultimo_input_verso_as400.png")]
		private const EMBEDDED_ULTIMO_INPUT_VERSO_AS400:Class;
		private var bmpULTIMO_INPUT_VERSO_AS400:Bitmap = new EMBEDDED_ULTIMO_INPUT_VERSO_AS400();
		
		[Embed(source="resources/ultimo_output_da_as400.png")]
		private const EMBEDDED_ULTIMO_OUTPUT_DA_AS400:Class;
		private var bmpULTIMO_OUTPUT_DA_AS400:Bitmap = new EMBEDDED_ULTIMO_OUTPUT_DA_AS400();
		
		[Embed(source="resources/undo.png")]
		private const EMBEDDED_UNDO:Class;
		private var bmpUNDO:Bitmap = new EMBEDDED_UNDO();
		
		[Embed(source="resources/vista_dettaglio_del_dspf.png")]
		private const EMBEDDED_VISTA_DETTAGLIO_DEL_DSPF:Class;
		private var bmpVISTA_DETTAGLIO_DEL_DSPF:Bitmap = new EMBEDDED_VISTA_DETTAGLIO_DEL_DSPF();		
		
		
		private var timeMachineMilestones:Array = [];
		private var timeMachinePosition:int = -1;
		private var timeMachineLastSave:int = 0;
		private var undoMenuItem:NativeMenuItem;
		private var redoMenuItem:NativeMenuItem;

		
		public function PanelComposer()
		{
			CacheBitmapManager.getInstance().StoreImage(bmpABBINAMENTO, "embed:abbinamento.png");
			CacheBitmapManager.getInstance().StoreImage(bmpABILITARE_MODIFICHE_DEL_DESKTOP, "embed:abilitare_modifiche_del_desktop.png");
			CacheBitmapManager.getInstance().StoreImage(bmpABILITARE_MODIFICHE_DEL_PANNELLO, "embed:abilitare_modifiche_del_pannello.png");
			CacheBitmapManager.getInstance().StoreImage(bmpABILITARE_MODIFICHE_DI_TABELLA, "embed:abilitare_modifiche_di_tabella.png");
			CacheBitmapManager.getInstance().StoreImage(bmpABILITARE_TRACKING_COMPONENTI, "embed:abilitare_tracking_componenti.png");
			CacheBitmapManager.getInstance().StoreImage(bmpABOUT_PRODIGYT_VERSIONS, "embed:about_prodigyt_versions.png");
			CacheBitmapManager.getInstance().StoreImage(bmpALBERO_DEL_PROGETTO, "embed:albero_del_progetto.png");
			CacheBitmapManager.getInstance().StoreImage(bmpALBERO_DI_MODIFICHE_MANUALI, "embed:albero_di_modifiche_manuali.png");
			CacheBitmapManager.getInstance().StoreImage(bmpANNULLA, "embed:annulla.png");
			CacheBitmapManager.getInstance().StoreImage(bmpAPRI_PROJECT, "embed:apri_project.png");
			CacheBitmapManager.getInstance().StoreImage(bmpCOMPONENTI, "embed:componenti.png");
			CacheBitmapManager.getInstance().StoreImage(bmpCOPIA, "embed:copia.png");
			CacheBitmapManager.getInstance().StoreImage(bmpATTIVARE_CACHE, "embed:attivare_cache.png");
			CacheBitmapManager.getInstance().StoreImage(bmpDISATTIVARE_MODIFICHE_MANUALI, "embed:disattivare_modifiche_manuali.png");
			CacheBitmapManager.getInstance().StoreImage(bmpDISATTIVARE_MODIFICHE_UTENTE, "embed:disattivare_modifiche_utente.png");
			CacheBitmapManager.getInstance().StoreImage(bmpDISATTIVARE_REGOLE_DI_TRASFORMAZIONE, "embed:disattivare_regole_di_trasformazione.png");
			CacheBitmapManager.getInstance().StoreImage(bmpEDIT_WITH_NOTEPAD, "embed:edit_with_notepad.png");
			CacheBitmapManager.getInstance().StoreImage(bmpENABLE_COMPONENTS_TRACKING, "embed:enable_components_tracking.png");
			CacheBitmapManager.getInstance().StoreImage(bmpENABLE_MODIFY_DESKTOP, "embed:enable_modify_desktop.png");
			CacheBitmapManager.getInstance().StoreImage(bmpENABLE_MODIFY_PANEL, "embed:enable_modify_panel.png");
			CacheBitmapManager.getInstance().StoreImage(bmpENABLE_MODIFY_TABLES, "embed:enable_modify_tables.png");
			CacheBitmapManager.getInstance().StoreImage(bmpESPORTA, "embed:esporta.png");
			CacheBitmapManager.getInstance().StoreImage(bmpIMPORTA, "embed:importa.png");
			CacheBitmapManager.getInstance().StoreImage(bmpINCOLLA, "embed:incolla.png");
			CacheBitmapManager.getInstance().StoreImage(bmpISTANZA, "embed:istanza.png");
			CacheBitmapManager.getInstance().StoreImage(bmpKEYWORDS, "embed:keywords.png");
			CacheBitmapManager.getInstance().StoreImage(bmpLOG, "embed:log.png");
			CacheBitmapManager.getInstance().StoreImage(bmpMODIFICA_CON_EDITORE_ESTERNO, "embed:modifica_con_editore_esterno.png");
			CacheBitmapManager.getInstance().StoreImage(bmpOUTLINE, "embed:outline.png");
			CacheBitmapManager.getInstance().StoreImage(bmpPAIRING, "embed:pairing.png");
			CacheBitmapManager.getInstance().StoreImage(bmpPANNELLO_DI_CONTROLLO, "embed:pannello_di_controllo.png");
			CacheBitmapManager.getInstance().StoreImage(bmpREDO, "embed:redo.png");
			CacheBitmapManager.getInstance().StoreImage(bmpPANELS, "embed:panels.png");
			CacheBitmapManager.getInstance().StoreImage(bmpREGOLE_DI_TRASFORMAZIONE, "embed:regole_di_trasformazione.png");
			CacheBitmapManager.getInstance().StoreImage(bmpREORGANIZE_WINDOWS, "embed:reorganize_windows.png");
			CacheBitmapManager.getInstance().StoreImage(bmpRIORDINARE_FINESTRE, "embed:riordinare_finestre.png");
			CacheBitmapManager.getInstance().StoreImage(bmpRIPRISTINA, "embed:ripristina.png");
			CacheBitmapManager.getInstance().StoreImage(bmpSALVA_PROJECT_CON_NOME, "embed:salva_project_con_nome.png");
			CacheBitmapManager.getInstance().StoreImage(bmpSALVA_PROJECT, "embed:salva_project.png");
			CacheBitmapManager.getInstance().StoreImage(bmpSAVE_PROJECT_AS, "embed:save_project_as.png");
			CacheBitmapManager.getInstance().StoreImage(bmpSAVE_PROJECT, "embed:save_project.png");
			CacheBitmapManager.getInstance().StoreImage(bmpRIAVVIA_DESKTOP, "embed:riavvia_desktop.png");
			CacheBitmapManager.getInstance().StoreImage(bmpSCHEMA, "embed:schema.png");
			CacheBitmapManager.getInstance().StoreImage(bmpSELEZIONARE_GRIGLIA, "embed:selezionare_griglia.png");
			CacheBitmapManager.getInstance().StoreImage(bmpSELEZIONARE_RISOLUZIONE, "embed:selezionare_risoluzione.png");
			CacheBitmapManager.getInstance().StoreImage(bmpSPLIT, "embed:split.png");
			CacheBitmapManager.getInstance().StoreImage(bmpSTILE, "embed:stile.png");
			CacheBitmapManager.getInstance().StoreImage(bmpSTRUTTURA_DEL_DSPF, "embed:struttura_del_dspf.png");
			CacheBitmapManager.getInstance().StoreImage(bmpTAGLIA, "embed:taglia.png");
			CacheBitmapManager.getInstance().StoreImage(bmpULTIMO_INPUT_VERSO_AS400, "embed:ultimo_input_verso_as400.png");
			CacheBitmapManager.getInstance().StoreImage(bmpULTIMO_OUTPUT_DA_AS400, "embed:ultimo_output_da_as400.png");
			CacheBitmapManager.getInstance().StoreImage(bmpUNDO, "embed:undo.png");
			CacheBitmapManager.getInstance().StoreImage(bmpVISTA_DETTAGLIO_DEL_DSPF, "embed:vista_dettaglio_del_dspf.png");
			
			//			Singleton.registerClass("mx.styles::IStyleManager2",
			//				Class(getDefinitionByName("mx.styles::StyleManagerImpl")));
		}
		
		// NON USATO		
		//var sssss:IStyleManager2    
		
		[Embed(source="assets/zigri.png")] private var zi:Class;
		private var zig:Bitmap = new zi();
		
		[Embed(source="resources/ComposerStyle.xml",mimeType="application/octet-stream")] 
		private static const CSClass:Class;
		private var csba:ByteArray = new CSClass();
		private var css:String = csba.readUTFBytes( csba.length );
		private var csXML:XML = new XML( css );
		
		// NON USATO		
		// la finestra per la visualizzazione delle proprietà interessanti del componente visuale cliccato
		// private var winInstanceProperties;
		
		// la lista delle finestre attive e non
		private var windows:Array = [];
		
		// le finestre messe in un dizionario per il ViewsManager
		private var _windowsDictionary:Dictionary = new Dictionary();
		
		private var _localConfig:XML;
		private var _projectData:XML;
		private var ctrlSession:ControlSessionManager;
		private var baseSession:SessionManager;
		private var panelMediator:PanelMediator;
		private var controlPanelMediator:PanelMediator;
		private var converter:Converter;
		private var uiGen:UIGenerator;
		private var defaultDesktop:XML;
		private var kwa:KeywordsAnalyzer;
		private var _menuObject:Object;
		
		private var _objectsVector:Dictionary = new Dictionary();
		
		public var myAlert:Alert;
		
		private var componentsGrid:PYDatagrid;
		private var globalGrid:PYDatagrid;  // <=== HEY!!! LOOK HERE
		private var styleGrid:PYDatagrid;
		private var pairingGrid:PYDatagrid;
		private var keywordsGrid:PYDatagrid;
		private var desktopGrid:PYDatagrid;
		private var desktopElementsGrid:PYDatagrid;
		// private var keywordsDefaultDatagrid:PYDatagrid;
		private var _instanceGrid:PYDatagrid;
		private var _instancePropertiesDataProvider:ArrayCollection;
		private var _styleWindowDataProvider:ArrayCollection;
		private var componentsTree:Tree;
		
		
		// private var panelDesignComposer:PanelDesignComposer;
		
		private var modificationTaken:int = 1;
		
		// l'elemento selezionato dall'utente per la modifica
		public var selectedVisualElement:PYComponent;					// BAD DOG!!!
		
		// (CONFIGURAZIONI) Dictionary delle configurazioni possibili
		private var _configurations:Dictionary;
		
		private var _fixWinConvertedWhileTransformationInactive:Boolean;
		private var _transformableComponents:Dictionary;
		
		// (XML DI PANNELLO) Dictionary degli xml di pannello
		private var _xmlModificationsPanels:Dictionary;
		
		private var _client:Client
		
		// .............
		private var flowing:Boolean;
		
		
		// menu contestuale
		private var nativeMenu:NativeMenu;
		
		// l'array delle keywords da visualizzare nel renderer della griglia delle keywords
		private var keywordsToShow:Array = [];
		
		// l'array dei valori delle keywords da visualizzare nel renderer della griglia delle keywords
		private var keywordValuesToShow:Array = [];
		
		// gui del pannello in modifica e flag
		private var xmlGuiModified:Boolean = false
        private var xmlGuiFastModified:Boolean = false;
		private var xmlGui:XML
		private var xmlGuiIndex:int
		
		
		private var controlPanel:ControlPanel
		
		
		// l'indice della riga e della colonna selezionata nel pairings nel datataprovider
		private var cellRowIndex:int;
		private var cellColumnIndex:int;
		
		// griglia origine evento modifica valore pairing
		private var originGrid:PYDatagrid;
		
		
		// il file reference per il caricamento delle immagini via grid di default
		private var imgFileReference:FileReference;
		private var imgFileFile:File;
		
		// salvataggi per l'aggiornamento della GUI sulla modifica delle property backgroundImage, iconImage...
		private var imageDatagrid:PYDatagrid;
		private var imagePropertyValue:String;
		
		// semafori di sblocco delle funzionalità della navigazione per menuItem
		private var serverConnectionAvailable:Boolean = true;
		private var developerLoginDone:Boolean = false;
		private var developerAuthDone:Boolean = false;
		private var clientLoginDone:Boolean = false;
		private var projectLoaded:Boolean = false;
		private var projectSaved:Boolean = true;
		
		// il menu correntemente cliccato
		private var currentControlPanelItem:ControlPanelItem;
		
		// il vettore degli elementi selezionati (per ora uno solo)
		private var modifyItemsSelected:Array = [];
		
		// la vista corrente
		private var actualView:String = "";
		
		// stile della classe dei componenti selezionati in pairingGrid
		private var previousStyle:String;
		
		// il nome del progetto aperto e gestito nel momento
		private var projectName:String
		
		private var projectTextArea:TextArea
		private var inpArea:TextArea
		private var outArea:TextArea
		private var structureArea:TextArea
		private var logArea:TextArea
		private var dspfTree:Tree
		private var outlineTree:Tree
		
		
		private var _gui:UIComponent = new UIComponent();
		
		private var undoId:int = 0
		
		private var projectBox:ProjectBox = new ProjectBox();
		private var controlPanelBox:PYNbox = new PYNbox();
		private var manualsBox:ProjectBox = new ProjectBox();
		
		
		private var projectBoxCont:PYComponent = new PYComponent();
		// RIMOSSO IN V3
		//private var controlPanelBoxCont:PYComponent = new PYComponent();
		private var manualsBoxCont:PYComponent = new PYComponent();
		
		private var uico:UIComponent
		private var Manualsuico:UIComponent
		
		private var _rootMenu:NativeMenu
		private var resolutionMenu:NativeMenu;
		private var gridMenu:NativeMenu;
		
		private var importMenu:NativeMenu;
		private var exportMenu:NativeMenu;
		
		private var homePoint:Point = new Point(0, 0)
		
		
		
		private var dontCloseDynamicList:Boolean = false
		
		
		private var styleCanvas:Canvas;
		private var innerForm:Form;
		private var innerFormComponent:mx.controls.Label;
		private var innerFormStyle:mx.controls.Label;
		private var componentTextInput:TextInput;
		private var styleTextInput:TextInput;
		
		
		private var originalWindow:*
		
		private var prjLoader:PrjLoader
		
		private var alert:PYAlert
		
		// MAD 120215: Adesso convivono due menu, e entrambi devono communicarsi
		//	Rinomino per lasciare chiaro cosa contiene e a cosa serve. 
		//	Inoltre, il commento nella closingWindow era sbagliato: 
		//		Non faceva uncheck globali, ma univoco 
		private var menuItemsDictionary:Dictionary = new Dictionary();
		
		private var modifyTableFlag:Boolean
		private var modifyPanelFlag:Boolean
		private var modifyDesktopFlag:Boolean
		
		protected var xmlColors:XML=<colors>			
				</colors>;
		protected var oldColor:String;
		
		private var _trackingFlag:Boolean = false
		
		private var salvaManualsNelProject:Boolean = true
		
		private var projectModified:Boolean = false
		
		// MAD 311014: Aggiunta a livello di classe per non crearne una sopra l'altra
		private var styleAlert:PYAlert;
		// MAD 311014: Aggiunti per controllare "CRUD" su stili
		private var isCreatingNewStyle:Boolean;
		private var isDeletingExistingStyle:Boolean;
		
		// MAD 221214: Variabile per poter deselezionare la rule cuando è già selezionata
		private var selectedTransformRuleItem:Object;
		
		// MAD 2016-10-27: Variabile per poter deselezionare il panel quando è già selezionato
		protected var selectedPanelItem:Object;
		
		// MAD 100215: Variabili per tracciare le dimensioni del chrome delle utility NativeWindow
		private var utilityChromeWidth:Number;
		private var utilityChromeHeight:Number;
		
		// MAD 100215: Variabili per tracciare le dimensioni del chrome delle normal NativeWindow
		private var normalChromeWidth:Number;
		private var normalChromeHeight:Number;
		
		// MAD 120215: Contenitore del menu della Control Panel
		private var utilityMenu:PYNbox;
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////// getters setters///////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		/**
		 * Begin class retrievers and modifiers (getters and setters)
		 */
		
		public function get objectsVector():Dictionary
		{
			return _objectsVector;
		}
		
		public function set objectsVector(value:Dictionary):void
		{
			_objectsVector = value;
		}
		
		public function get projectData():XML
		{
			return _projectData;
		}
		
		public function set projectData(value:XML):void
		{
			_projectData = value;
		}
		
		public function get windowsDictionary():Dictionary
		{
			return _windowsDictionary;
		}
		
		public function set windowsDictionary(value:Dictionary):void
		{
			_windowsDictionary = value;
		}
		
		
		
		
		public function get instanceGrid():PYDatagrid
		{
			return _instanceGrid;
		}
		
		public function set instanceGrid(value:PYDatagrid):void
		{
			_instanceGrid = value;
		}
		
		[Bindable]
		public function get instancePropertiesDataProvider():ArrayCollection
		{
			return _instancePropertiesDataProvider;
		}
		
		public function set instancePropertiesDataProvider(value:ArrayCollection):void
		{
			_instancePropertiesDataProvider = value;
		}
		
		
		
		
		/**
		 * End class retrievers and modifiers (getters and setters)
		 */
		
		
		
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////    startup functions    //////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		public function startup(client:Client, root:NativeMenu, originalWindow:*):void
		{
			initComposerStyle();
			
			this.originalWindow = originalWindow
			_client  = client
			_rootMenu = root	
			_localConfig = _client.getLocalConfig()
			_objectsVector = _client.objectsVector
			panelMediator = _client.panelMediator;
			initLog();
			
			// Prima di usare l'elenco di componenti, preparare il messaggio di alerta caso non trovi alcuno di loro
			ComponentsManager.getInstance().addEventListener(ManagerEvent.MANAGER_ERROR, alertMissingComponent);
			
			// Serve a misurare le dimensioni della finestra col chroma normale dell'OS 
			if (NativeApplication.nativeApplication.activeWindow)
			{
				measureNormalChrome();
			} else {
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, activateHandler);	
				NativeApplication.nativeApplication.addEventListener(Event.EXITING, close);		
			}
			
			// ascolta gli I/O del client
			_client.session.addEventListener(SessionEvent.READY, clientSessionReady);
			_client.session.addEventListener(SessionEvent.SYSTEM_READY, clientSessionReady);
			
			//this.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, true)
			
			//loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);	
			
			UndoManager.addInstance("")
			
			//stage.stageFocusRect = false;
			
			if (_client.clientShell is UIComponent ) _client.clientShell.focusManager.deactivate();
			
			// creatione of control panel
			initAppMenu()
			
			initOtherManagers()
			
			// ragno
			
			RagnoManager.getInstance().addEventListener(RagnoEvent.READY, ragnoHandler)
			RagnoManager.getInstance().addEventListener(RagnoEvent.TRANSFORMED, ragnoTransformed)
			RagnoManager.getInstance().addEventListener(RagnoEvent.FAST_TRANSFORM, ragnoFastTransformed);
			RagnoManager.getInstance().addEventListener(RagnoEvent.ADD_COMPONENT, ragnoAdded)
			
			// Project data has been lfoaded successfully. The whole XML is in the event.data property
			_projectData = DefaultsManager.getInstance().root;
			
			//
			buildPCWindows()	
			
			// Avvia sessione del panel composer
			initControlSession();
			
			// Pulire lo storico di modifiche temporali della sessione precedente
			resetChronos();
			// NEW - TUTTI - 201117 - SCHEMA DEL DESKTOP
			populateDesktopSchema()
		}
		
		protected function alertMissingComponent(event:ManagerEvent):void
		{
			var msg:String		= "Il componente " + event.data.cName + " non è codificato.\nSegnalarlo a suporto tecnico."; 
			alert			 	= new PYAlert(_client.clientShell.stage, msg, "Errore interno", ["OK"]);				
			alert.boxStyle		= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // Oppure _stage.getChildAt(0).client.cleanSplashStyle
			alert.buttonStyle	= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // Oppure _stage.getChildAt(0).client.cleanSplashStyle
		}
		
		protected function activateHandler(event:Event):void
		{
			measureNormalChrome();		
		}
		
		public function restart( ):void
		{
			// creatione of control panel
			initAppMenu()
			initOtherManagers()
		}
		
		public function closeFromClient():void
		{
			if (ctrlSession &&  ctrlSession.connected) ctrlSession.logout() // athesia : no joblog
		}
		
		public function close():void
		{
			
			for each (var win:NativeWindow in windowsDictionary)
			{
				win.visible=false
			}
			if (ctrlSession && ctrlSession.connected) ctrlSession.logout() // athesia : no joblog
			
		}
		
		public function canClose():Boolean
		{
			if (projectModified)
			{
				alert=new PYAlert(_client.clientShell.stage,"Il Project è stato modificato: salvare? ", "Conferma",["Salva","Con nome","NO"],salvaProjectSioNo);
				alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
				alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
				return false
			}
			else
				return true
		}
		
		private function measureNormalChrome():void
		{
			// MAD 20150425: Se l'utente avvia l'applicazione ma sposta il foco su
			// 	un'altra cose, e poi torna, la finestra attiva può non essere quella
			//	principale. Particolarmente se prova a usare il "panic button".
			var nw:NativeWindow = NativeApplication.nativeApplication.activeWindow;
			if (nw !=null && nw.type!=NativeWindowType.NORMAL)
			{
				var ow:Array = NativeApplication.nativeApplication.openedWindows;
				for (var i:int=0; i<ow.length; i++)
				{
					if ((ow[i] as NativeWindow).type == NativeWindowType.NORMAL)
					{
						nw = ow[i];
						break;
					}
				}
			}
			
			if (nw !=null &&  (isNaN(normalChromeWidth) || isNaN(normalChromeHeight)))
			{
				normalChromeWidth 	= nw.width - nw.stage.stageWidth;
				normalChromeHeight 	= nw.height - nw.stage.stageHeight;
			}			
		}
		
		/**
		 * risposta a Alert di salvataggio gui su AS400
		 */
		private function salvaProjectSioNo(event:int):void
		{
			if (event == 0)  // save
			{
				if (!windowsDictionary["prjLoader"].active) windowsDictionary["prjLoader"].activate()	
				windowsDictionary["prjLoader"].visible = true	
				prjLoader.isSaveAs = false
				prjLoader.prjTitle.text = "Salva project"
				prjLoader.visible = false
				// BUG - TUTTI - 201117 - salvataggio su AS400 con nuova sessione	
				prjLoader.localConfig = _localConfig
				if (!prjLoader.ctrlSession)  prjLoader.ctrlSession = ctrlSession
				prjLoader.saveProject()
			}
			else if (event ==  1) // save as
			{
				if (!windowsDictionary["prjLoader"].active) windowsDictionary["prjLoader"].activate()	
				windowsDictionary["prjLoader"].visible = true
				prjLoader.visible = true
				prjLoader.isSaveAs = true
				// BUG - TUTTI - 201117 - salvataggio su AS400 con nuova sessione
				prjLoader.localConfig = _localConfig
				prjLoader.prjTitle.text = "Salva project con nome"
				prjLoader.setPath()
				if (!prjLoader.ctrlSession)  prjLoader.ctrlSession = ctrlSession
				prjLoader.stage.addEventListener(KeyboardEvent.KEY_DOWN,prjLoader.prjNameCont_keyDownHandler);
			}
			else if (event ==  2) // throw modified flag
			{
				projectModified = false
			}
		}
		
		
		public function updateScale():void
		{
			RagnoManager.getInstance().setScale(originalWindow.scaleX)
			
		}
		
		/**
		 *  
		 * @param option
		 * 
		 */
		public function saveBackup(option:String="CHRONOS"):void
		{
			if (option=="PRE" || option=="POST")
			{
				DefaultsManager.getInstance().saveBackup(option);
				// Il salvataggio di partenza del composer viene fatto una volta come backup
				//	e una seconda volta per la time machine (sottocartella chronos).
				if (option=="PRE") saveBackup("RESET");
				return;
			}
			
			if (timeMachinePosition+1 < timeMachineMilestones.length)
			{
				// Si arriva qua se hanno fatto undo (annulla) e poi modificato il project senza redo (ripristina)
				// La catena di modifiche dopo la posizione attuale viene persa (è così in qualsiasi programma) ma
				//	per evitare perdite accidentali spostiamo tutti i file in una sottocartella timelines.
				
				// path: PYDEMO\PRJ_PYDEMO_20161114145408_PRE.xml -> PYDEMO\PRJ_PYDEMO
				var path:String = timeMachineMilestones[timeMachinePosition+1].substr(0,-19);
				// start: PYDEMO\PRJ_PYDEMO_20161114145408_PRE.xml -> 20161114145408
				var start:String = timeMachineMilestones[timeMachinePosition+1].substr(-18).split(".xml").join("");
				// end: PYDEMO\PRJ_PYDEMO_20161114150420_POST.xml -> 20161114150420
				var end:String = timeMachineMilestones[timeMachineMilestones.length-1].substr(-18).split(".xml").join("");
				
				var file:File;
				var i:int = timeMachineMilestones.length-1;
				while (i>timeMachinePosition)
				{
					file = PyDirectoryManager.resolveCompletePath("undo",timeMachineMilestones[i]);
					file.moveTo(PyDirectoryManager.resolveCompletePath("undo\\discarded\\" + start + "-" + end,timeMachineMilestones[i]));
					timeMachineMilestones.pop();
					i--;
				}
			}
			
			// BUG - TUTTI - Composer: Salvataggio POST appena dopo il PRE - 20170202
			//	Aggiunto "option" (RESET) in modo di salvare il primo undo senza POST
			timeMachineMilestones.push(DefaultsManager.getInstance().saveBackup(option));
			timeMachinePosition++;
			undoMenuItem.enabled = (timeMachinePosition>0);
			redoMenuItem.enabled = false;
		}
		
		
		
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////    init functions    //////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		private function initComposerStyle():void
		{
			DefaultsManager.getInstance("ComposerStyle").root = csXML;
		}
		
		
		
		private function initLog():void
		{
			// log  
			//			if (!logArea) logArea = new TextArea()
			//			var tt:TextTarget = new TextTarget( logArea );
			//			tt.includeCategory = true;
			//			tt.includeTime = true;
			//			tt.includeLevel = true;
			//			Log.addTarget(tt);  
			//			
			//			var trt:TraceTarget = new TraceTarget();
			//			trt.includeCategory = true;
			//			trt.includeTime = true;
			//			trt.includeLevel = true;				
		}
		
		
		
		/**
		 * 
		 * Inizializzazione dei managers dei dati visuali.
		 * 
		 */
		private function initOtherManagers():void
		{
			
			PairingsManager.getInstance().pairings = DefaultsManager.getInstance().pairingsSection 	
			DesktopsManager.getInstance().desktops = DefaultsManager.getInstance().desktopsSection
			RulesManager.getInstance().fastRules = DefaultsManager.getInstance().fastRulesSection;
			RulesManager.getInstance().rules = DefaultsManager.getInstance().rulesSection;
			KeywordsManager.getInstance().keywords = DefaultsManager.getInstance().keywordsSection;
			
			PairingsManager.getInstance().pairingsRich = DefaultsManager.getInstance().pairingsSectionRich 	
			DesktopsManager.getInstance().desktopsRich = DefaultsManager.getInstance().desktopsSectionRich
			RulesManager.getInstance().fastRulesRich = DefaultsManager.getInstance().fastRulesSectionRich;
			RulesManager.getInstance().rulesRich = DefaultsManager.getInstance().rulesSectionRich;
			KeywordsManager.getInstance().keywordsRich = DefaultsManager.getInstance().keywordsSectionRich
			
		}
		
		
		
		
		
		/**
		 * 
		 * 
		 * 
		 */
		private function buildPCWindows():void
		{
			// MAD 100215: Nota:
			//	La prima finestra creata (Pairing) verrà usata per calcolare le dimensioni del chrome delle utility window
			//	in modo di poter dimensionare e posizionare il resto di finestre con precisione.
			
			var pcWindow:PCWindowNew;
			var winName:String;
			var winWidth:Number;
			var winHeight:Number;
			
			winName = "Pairing"
			if (!windowsDictionary[winName])
			{
				createWindow(winName, winName, homePoint, 400, 420, 1, null);
				pairingGrid = createGrid(winName, new ArrayCollection( PairingsManager.getInstance().getPairings() ) );
				(pairingGrid.columns[0] as DataGridColumn).editable = true;
				pairingGrid.percentHeight = 100
				pairingGrid.width = 400 - 16  // gap per window ativa
				windowsDictionary[winName].addContent(pairingGrid);	
			}
			
			winName = "Pannello di controllo"
			if (!windowsDictionary[winName])
			{
				winWidth 	= Screen.mainScreen.visibleBounds.width; // Tutto il largo dello schermo
				winHeight 	= 4 + 12 + 24 + 4 + utilityChromeHeight; 	 // Per titoli di 11px + icone di 16x16 in bottoni da 24x24
				
				createWindow(winName, winName, homePoint, winWidth, winHeight, 1, null);
				
				pcWindow	= windowsDictionary[winName];
				pcWindow.x	= 0;
				pcWindow.y	= 0;
				pcWindow.addContent(setControlPanelBox());
				pcWindow.addEventListener(Event.CLOSING, onClosing);
				updateControlPanel();
				pcWindow.activate();
				// MAD 20150421: Porcatina: Scatto un evento resize della finestra del pannello di controllo, se no non va la scrollbar
				pcWindow.dispatchEvent(new NativeWindowBoundsEvent(Event.RESIZE));
			}
			
			winName = "Stile"
			if (!windowsDictionary[winName])
			{
				winWidth	= (windowsDictionary["Pannello di controllo"].width<1920)? 300 : 380;
				winHeight	= Screen.mainScreen.visibleBounds.height - windowsDictionary["Pannello di controllo"].height;
				
				createWindow(winName, winName, homePoint, winWidth, winHeight, 1, null);
				var styleCanvas:Canvas = setupStyleCanvas(winName);
				
				pcWindow	= windowsDictionary[winName];
				pcWindow.x	= 0;
				pcWindow.y	= windowsDictionary["Pannello di controllo"].height;
				pcWindow.addContent(styleCanvas);
				pcWindow.activate();
			}
			
			winName = "Schema"
			if (!windowsDictionary[winName])
			{
				winWidth	= (windowsDictionary["Pannello di controllo"].width<1920)? 300 : 380;
				winHeight	= (Screen.mainScreen.visibleBounds.height - windowsDictionary["Pannello di controllo"].height)*1/3;
				
				createWindow(winName, winName, homePoint, winWidth, winHeight, 1, null);
				
				outlineTree 				= new Tree();
				outlineTree.itemRenderer 	= new ClassFactory( CustomTreeItemRenderer );
				outlineTree.labelFunction 	= outlineTreeLabels;
				outlineTree.percentHeight 	= 100;
				outlineTree.percentWidth 	= 100;
				outlineTree.setStyle("backgroundColor", 0xeeeeee);
				outlineTree.setStyle("backgroundAlpha", 1);
				outlineTree.setStyle("color", 0x000033);
				outlineTree.setStyle("fontSize", 12);
				outlineTree.addEventListener(MouseEvent.CLICK, outlineTree_mouseClick);
				
				pcWindow	= windowsDictionary[winName];
				pcWindow.x	= Screen.mainScreen.visibleBounds.width - winWidth;
				pcWindow.y	= windowsDictionary["Pannello di controllo"].height;
				pcWindow.addContent(outlineTree);
				pcWindow.activate();
			}
			
			winName = "Regole di trasformazione"
			if (!windowsDictionary[winName])
			{
				// winWidth coincide con la largezza disponibile per il client
				// la usiamo per calcolare l'altezza disponibile per il client e per le Transform Rules
				winWidth	= Screen.mainScreen.visibleBounds.width - windowsDictionary["Stile"].width - windowsDictionary["Schema"].width;
				var clientHeight:Number = (_client.clientShell.calcHeight / _client.clientShell.calcWidth) * (winWidth - normalChromeWidth) + normalChromeHeight;
				// Se si desidera farlo alto quanto lo spazio libero dopo client e control panel
				// winHeight	= Screen.mainScreen.visibleBounds.height - windowsDictionary["Pannello di controllo"].height - (clientHeight);
				// Per adesso, altezza fissa 360px;
				winHeight	= _client.clientShell.stage.stageHeight * .25;
				
				createWindow(winName, winName, homePoint, winWidth, winHeight, 1, null);
				
				var pyc:PYComponent					= new PYComponent();
				pyc.name							= "pyc";
				pyc.alpha							= 1;
				pyc.backgroundColor					= 0xF0F0F6;
				pyc.backgroundAlpha					= 1;
				pyc.x								= 0;
				pyc.y								= 0;
				pyc.width							= 800;
				pyc.percentHeight					= 100;
				pyc.percentWidth					= 100;
				pyc.visible							= true;
				pyc.drawComponent();
				
				var pynbs:PYNBoxSelectable 			= new PYNBoxSelectable();
				pynbs.scrollMethod 					= PYContainer.SCROLLMETHOD_NORMAL;
				pynbs.autoSize						= false;
				pynbs.layout						= PYContainer.VERTICAL;
				pynbs.name							= "sceltaTransformRule";
				pynbs.y								= 0;
				pynbs.x								= 0;
				pynbs.width							= 800;
				pynbs.percentWidth					= 100;
				pynbs.percentHeight					= 100;	
				pynbs.paddingRight					= 16;	
				pynbs.verticalScrollBar 			= PYContainer.INTERNAL;
				pynbs.verticalScrollBarAppearance 	= PYContainer.VISIBLE;
				pynbs.verticalScrolling				= true;
				pynbs.backgroundAlpha				= 1;
				pynbs.backgroundColor				= 0xFFFFFF;
				pynbs.style							= "ComposerStyle:TransformBox";
				pynbs.itemStyle						= "ComposerStyle:TransformItem";
				pynbs.overStyle						= "ComposerStyle:TransformOver";
				pynbs.selectedStyle					= "ComposerStyle:TransformSelected";
				pynbs.scrollBarStyle				= "ComposerStyle:TransformScrollBar";
				pynbs.forceAlign					= true;
				pynbs.addEventListener(PYNBoxEvent.SELECT,selectTransformRule);
				pynbs.drawContainer();
				pyc.addChild(pynbs);
				
				pcWindow	= windowsDictionary[winName];
				pcWindow.x	= windowsDictionary["Stile"].width;
				pcWindow.y	= Screen.mainScreen.visibleBounds.height - pcWindow.height;
				pcWindow.addContent(pyc);	
				pcWindow.activate();
				updateTransformRulesList();
			}
			
			winName = "Panels";
			if (!windowsDictionary[winName])
			{
				// winWidth coincide con la largezza disponibile per il client
				// la usiamo per calcolare l'altezza disponibile per il client e per le Transform Rules
				winWidth	= Screen.mainScreen.visibleBounds.width - windowsDictionary["Stile"].width - windowsDictionary["Schema"].width;
				// Se si desidera farlo alto quanto lo spazio libero dopo client e control panel
				// var clientHeight:Number = (_client.clientShell.calcHeight / _client.clientShell.calcWidth) * (winWidth - normalChromeWidth) + normalChromeHeight;
				// winHeight	= Screen.mainScreen.visibleBounds.height - windowsDictionary["Pannello di controllo"].height - (clientHeight);
				// Per adesso, altezza fissa 360px;
				winHeight	= _client.clientShell.stage.stageHeight * .25;
				
				createWindow(winName, winName, homePoint, winWidth, winHeight, 1, null);
				
				var pyc:PYComponent					= new PYComponent();
				pyc.name							= "pyc";
				pyc.alpha							= 1;
				pyc.backgroundColor					= 0xF0F0F6;
				pyc.backgroundAlpha					= 1;
				pyc.x								= 0;
				pyc.y								= 0;
				pyc.width							= 800;
				pyc.percentHeight					= 100;
				pyc.percentWidth					= 100;
				pyc.visible							= true;
				pyc.drawComponent();
				
				var pynbs:PYNBoxSelectable 			= new PYNBoxSelectable();
				pynbs.scrollMethod 					= PYContainer.SCROLLMETHOD_NORMAL;
				pynbs.autoSize						= false;
				pynbs.layout						= PYContainer.VERTICAL;
				pynbs.name							= "sceltaPanels";
				pynbs.y								= 0;
				pynbs.x								= 0;
				pynbs.width							= 800;
				pynbs.percentWidth					= 100;
				pynbs.percentHeight					= 100;	
				pynbs.paddingRight					= 16;	
				pynbs.verticalScrollBar 			= PYContainer.INTERNAL;
				pynbs.verticalScrollBarAppearance 	= PYContainer.VISIBLE;
				pynbs.verticalScrolling				= true;
				pynbs.backgroundAlpha				= 1;
				pynbs.backgroundColor				= 0xFFFFFF;
				pynbs.style							= "ComposerStyle:TransformBox";
				pynbs.itemStyle						= "ComposerStyle:TransformItem";
				pynbs.overStyle						= "ComposerStyle:TransformOver";
				pynbs.selectedStyle					= "ComposerStyle:TransformSelected";
				pynbs.scrollBarStyle				= "ComposerStyle:TransformScrollBar";
				pynbs.forceAlign					= true;
				pynbs.addEventListener(PYNBoxEvent.SELECT,selectPanel);
				pynbs.drawContainer();
				pyc.addChild(pynbs);
				
				pcWindow	= windowsDictionary[winName];
				pcWindow.x	= windowsDictionary["Stile"].width;
				pcWindow.y	= windowsDictionary["Pannello di controllo"].height;
				pcWindow.addContent(pyc);	
			}
			
			winName = "Istanza"
			if (!windowsDictionary[winName])
			{
				winWidth	= windowsDictionary["Schema"].width;
				winHeight	= (Screen.mainScreen.visibleBounds.height - windowsDictionary["Pannello di controllo"].height)*2/3;
				
				createWindow(winName, winName, homePoint, winWidth, winHeight, 1, null);
				
				instanceGrid 				= createGrid("Istanza", new ArrayCollection());
				instanceGrid.enabled 		= false;	
				instanceGrid.percentHeight 	= 100;
				//				instanceGrid.percentWidth	= 100;  // gap per window ativa
				instanceGrid.width			= windowsDictionary["Schema"].width - utilityChromeWidth;
				
				pcWindow	= windowsDictionary[winName];
				pcWindow.x	= Screen.mainScreen.visibleBounds.width - winWidth;
				pcWindow.y	= windowsDictionary["Pannello di controllo"].height + windowsDictionary["Schema"].height;
				pcWindow.addContent(instanceGrid);
				pcWindow.activate();
			}
			
			winName = "Project_xml"
			if (!windowsDictionary[winName])
			{
				//createWindow(winName, winName, homePoint, 1024, 420, 1, null);
				//modifyProjectXml();
				//windowsDictionary[winName].addContent(projectTextArea);
			}
			
			winName = "Albero del progetto"
			if (!windowsDictionary[winName])
			{
				createWindow(winName, winName, homePoint, 800, 600, 1, null);
				setProjectBox();
				projectBox.rootXml = DefaultsManager.getInstance().root 
				windowsDictionary[winName].addContent(projectBoxCont);
			}
			
			// MAD 021214
			winName = "Componenti";
			if (!windowsDictionary[winName])
			{
				createWindow(winName, winName, homePoint, 280, 600, 1, null);
				var componentsArray:Array = ComponentsManager.getInstance().getComponentNames();
				componentsArray.splice(0, 0, "global" );
				componentsGrid = createGrid("Componenti", new ArrayCollection(componentsArray));
				componentsGrid.enabled = true; // false;	
				componentsGrid.percentHeight = 100;
				componentsGrid.width = 280 - 16;  // gap per window ativa
				windowsDictionary[winName].addContent(componentsGrid);
			}
			
			//------------------marco
			winName = "Components tree"
			if (!windowsDictionary[winName])
			{
				createWindow(winName, winName, homePoint, 800, 600, 1, null);
				setProjectBox();
				//projectBox.rootXml = DefaultsManager.getInstance().root 
				windowsDictionary[winName].addContent(projectBoxCont);
			}
			//------------------marco
			
			
			winName = "Albero di modifiche manuali"
			if (!windowsDictionary[winName])
			{
				createWindow(winName, winName, homePoint, 800, 600, 1, null);
				setManualsBox();
				manualsBox.rootXml =  InstanceManager.getInstance().manualXML
				windowsDictionary[winName].addContent(manualsBoxCont);
			}
			
			winName = "Ultimo input verso AS400"
			if (!windowsDictionary[winName])
			{
				createWindow(winName, winName, homePoint, 800, 600, 1, null);
				inpArea = new TextArea()
				inpArea.percentHeight = 100
				inpArea.percentWidth = 100
				inpArea.setStyle("backgroundColor", 0xeeeeee)
				inpArea.setStyle("backgroundAlpha", 1)
				inpArea.setStyle("color", 0x000033)	
				windowsDictionary[winName].addContent(inpArea);
			}
			
			winName = "Ultimo output da AS400"
			if (!windowsDictionary[winName])
			{
				createWindow(winName, winName, homePoint, 800, 600, 1, null);
				outArea = new TextArea()
				outArea.percentHeight = 100
				outArea.percentWidth = 100
				outArea.setStyle("backgroundColor", 0xeeeeee)
				outArea.setStyle("backgroundAlpha", 1)
				outArea.setStyle("color", 0x000033)	
				windowsDictionary[winName].addContent(outArea);
			}
			
			winName = "Vista dettaglio del DSPF"
			if (!windowsDictionary[winName])
			{
				createWindow(winName, winName, homePoint, 800, 600, 1, null);
				structureArea = new TextArea()
				structureArea.percentHeight = 100
				structureArea.percentWidth = 100
				structureArea.setStyle("backgroundColor", 0xeeeeee)
				structureArea.setStyle("backgroundAlpha", 1)
				structureArea.setStyle("color", 0x000033)	
				windowsDictionary[winName].addContent(structureArea);
			}
			
			winName = "Log"
			if (!windowsDictionary[winName])
			{
				createWindow(winName, winName, homePoint, 800, 600, 1, null);
				if (!logArea) logArea = new TextArea()
				logArea.percentHeight = 100
				logArea.percentWidth = 100
				logArea.setStyle("backgroundColor", 0xeeeeee)
				logArea.setStyle("backgroundAlpha", 1)
				logArea.setStyle("color", 0x000033)	
				windowsDictionary[winName].addContent(logArea);
			}
			
			winName = "Struttura del DSPF"
			if (!windowsDictionary[winName])
			{
				// Commentato causa refactor HaXe
//				createWindow(winName, winName, homePoint, 400, 300, 1, null);
//				dspfTree = new Tree();
//				///////dspfTree.addEventListener(MouseEvent.CLICK, dspfTree_mouseClick);  // da implementare
//				dspfTree.labelFunction = outlineTreeLabels;
//				dspfTree.setStyle("fontSize", 12)
//				dspfTree.percentHeight = 100
//				dspfTree.percentWidth = 100
//				dspfTree.setStyle("backgroundColor", 0xeeeeee)
//				dspfTree.setStyle("backgroundAlpha", 1)
//				dspfTree.setStyle("color", 0x000033)	
//				dspfTree.itemRenderer = new ClassFactory(comp.DSPFitemRenderer) 
//				dspfTree.addEventListener(ListEvent.ITEM_CLICK, treeClick)
//				windowsDictionary[winName].addContent(dspfTree);
			}
			
			
			winName = "prjLoader"
			if (!windowsDictionary[winName])
			{
				createWindow(winName, winName, homePoint, 520, 200, 1, null);
				prjLoader = new PrjLoader()
				prjLoader.percentHeight = 100
				prjLoader.percentWidth = 100
				prjLoader.setStyle("contentBackgroundColor", 0xeeeeee)
				prjLoader.setStyle("contentBackgroundAlpha", 1)
				prjLoader.setStyle("color", 0x000033)	
				prjLoader.ctrlSession = ctrlSession
				// BUG - TUTTI - 201117 - salvataggio su AS400 con nuova sessione
				prjLoader.projectLocation = _localConfig.@projectLocation;
				prjLoader.localConfig = _localConfig;
				prjLoader.addEventListener("loadFromServer", setProjectToLoad )
				prjLoader.addEventListener("loadFromLocal", setProjectToLoad )
				prjLoader.addEventListener("savedOnLocal", ProjectSaved )
				prjLoader.addEventListener("savedOnAS400", ProjectSaved )
				prjLoader.addEventListener("saveError", ProjectSaved )
				windowsDictionary[winName].addContent(prjLoader);
			}
			
			winName = "Keywords"
			if (!windowsDictionary[winName])
			{
				createWindow(winName, winName, homePoint, 460, 560, 1, null);
				keywordsGrid = createGrid(winName, new ArrayCollection( KeywordsManager.getInstance().getKeywords() ) );
				(keywordsGrid.columns[0] as DataGridColumn).editable = true;
				keywordsGrid.percentHeight = 100;
				keywordsGrid.width = 460 - 16  // gap per window ativa
				windowsDictionary[winName].addContent(keywordsGrid);	
			}
		}
		
		protected function onClosing(event:Event):void
		{
			var window:PCWindowNew = event.target as PCWindowNew;
			window.removeEventListener(Event.CLOSING,onClosing);
			switch(window.title)
			{
				case "Pannello di controllo":
					event.preventDefault();
					event.stopImmediatePropagation();
					// BUG - TUTTI - Composer: Chiusura con la x della finestra pannello di controllo fa andare il Composer in crash - 20170206
//					(_client.clientShell as ClientPc).stage.nativeWindow.dispatchEvent(new Event(Event.CLOSING));
					break;
				default:
					if (window.container.getChildByName("pyc"))
					{
						var pyc:PYComponent = window.container.getChildByName("pyc") as PYComponent;
						if (pyc.getChildByName("fio")) pyc.getChildByName("fio").removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
					}
					delete windowsDictionary[window.title];
					window.destroy();
					//window.close();
					break;
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var fio:PYInputText = (event.target.parent as PYComponent).getChildByName("fio") as PYInputText;
			var fo:FieldO = (event.target.parent as PYComponent).getChildByName("fo") as FieldO;
			var ruleLabel:String = (event.target as PYButton).stage.nativeWindow.title.split("  =>  ")[1];
			var ruleXML:XML;
			
			function alertOK():void
			{
				// trace("Yeah... close me");
			}
			
			switch(event.target.text)
			{
				case "Aggiungi":
					try {
						var newRuleXML:XML	= DefaultsManager.getInstance().validatedRule(new XML(fio.text));
						if (newRuleXML.localName()!="error")
						{
							var rule:Object = DefaultsManager.getInstance().getRuleObjectFromXML(newRuleXML);
							if (rule && DefaultsManager.getInstance().getRuleLabel(rule).indexOf("<REGOLA NON VALIDA>")<0)
							{
								ruleXML = DefaultsManager.getInstance().getRule(rule);
								if (ruleXML==null)
								{
									// La rule non esisteva prima
									DefaultsManager.getInstance().addRule(fio.text);
									updateTransformRulesList();
									initOtherManagers();
									projectModified = true;
									saveBackup();
									(event.target as PYButton).stage.nativeWindow.dispatchEvent(new Event(Event.CLOSING));
								} else {
									// Già esisteva!!!
									createWindowedAlert("", "Transform Rules Alert", homePoint, 800, 600, 'Questa regola esisteva già!', 'Avviso', ["OK"], alertOK);
								}
							} else {
								// Non è valida
								trace("La rule non è valida: " + newRuleXML.toXMLString());
								createWindowedAlert("", "Transform Rules Alert", homePoint, 800, 600, 'La regola non è valida!', 'Avviso', ["OK"], alertOK);
							}
						} else {
							// Alert invalid rule
							trace("La rule non ha un XML valido");
							createWindowedAlert("", "Transform Rules Alert", homePoint, 800, 600, 'La regola non ha un XML valido!', 'Avviso', ["OK"], alertOK);
						}
					} catch (e:Error) {
						createWindowedAlert("", "Transform Rules Alert", homePoint, 800, 600, "La rule non ha un XML valido!\n"+e.message, 'Avviso', ["OK"], alertOK);
					}
					break;
				case "Annulla":
					(event.target as PYButton).stage.nativeWindow.dispatchEvent(new Event(Event.CLOSING));
					break;
				case "Conferma":
					ruleXML = DefaultsManager.getInstance().getRuleFromLabel(ruleLabel);
					if (ruleXML!=null)
					{
						DefaultsManager.getInstance().deleteRule(int(fo.text));						
						updateTransformRulesList();
						initOtherManagers();
						projectModified = true;
						saveBackup();
						(event.target as PYButton).stage.nativeWindow.dispatchEvent(new Event(Event.CLOSING));
					}					
					break;
				case "Salva":
					ruleXML = DefaultsManager.getInstance().getRuleFromLabel(ruleLabel);
					if (ruleXML!=null && ruleXML.@name == DefaultsManager.getInstance().validatedRule(fio.text).@name)
					{
						var result:String = DefaultsManager.getInstance().modifyRule(int(fo.text),fio.text);
						if (result=="OK")
						{
							updateTransformRulesList();
							initOtherManagers();
							projectModified = true;
							saveBackup();
							(event.target as PYButton).stage.nativeWindow.dispatchEvent(new Event(Event.CLOSING));							
						} else {
							createWindowedAlert("", "Transform Rules Alert", homePoint, 800, 600, result, 'Avviso', ["OK"], alertOK);
						}
                    } else if (ruleXML!=null && ruleXML.@name != DefaultsManager.getInstance().validatedRule(fio.text).@name) {
                        result = "Non è previsto modificare il nome della regola.\nCopiare il contenuto in una nuova regola e modificarlo lì.";
                        createWindowedAlert("", "Transform Rules Alert", homePoint, 800, 600, result, 'Avviso', ["OK"], alertOK);
					} else {
						if (!ruleXML)
						{
							createWindowedAlert("", "Transform Rules Alert", homePoint, 800, 600, 'Questa rule non esiste!', 'Avviso', ["OK"], alertOK);
						} else {
							var errorXML:XML = DefaultsManager.getInstance().validatedRule(fio.text);
							
							createWindowedAlert("", "Transform Rules Alert", homePoint, 800, 600, "Questa rule non è valida:\n" + errorXML.toString(), 'Avviso', ["OK"], alertOK);
						}
					}
					break;
			}
		}
		
		protected function buildTransformRuleWindow(winTitle:String, winName:String, point:Point, xml:XML, id:int):PCWindowNew
		{
			var bl:BaseLayout;
			var pyb1:PYButton;
			var pyb2:PYButton;
			var pyc:PYComponent;
			// MAD 20150618 Sostituito FieldIO con PYInputText 
			//	per evitare lo scroll alla fine del campo quando riceve il focus.
			var fio:PYInputText;
			var fo:FieldO;
			var window:PCWindowNew;
			
			createWindow(winTitle, winName, point, 1280, 400, 1, null);
			pyc					= new PYComponent();
			pyc.name			= "pyc";
			pyc.alpha			= 1;
			pyc.backgroundAlpha	= 1;
			pyc.x				= 0;
			pyc.y				= 0;
			pyc.width			= 1280;
			pyc.percentHeight	= 100;
			pyc.percentWidth	= 100;
			pyc.visible			= true;
			
			if(winTitle.indexOf("Modifica")!=-1)
			{
				pyc.backgroundColor	= 0xE6E0E0;
				pyb1				= new PYButton("Salva");
				pyb1.addEventListener(MouseEvent.CLICK, onMouseClick);
				pyb1.text			= "Salva";
				pyb1.style			= "ComposerStyle:SaveRule";
				pyb1.normalStyle	= "ComposerStyle:SaveRule";
				pyb1.overStyle		= "ComposerStyle:SaveRuleOver";
				pyb2				= new PYButton("Annulla");
				pyb2.addEventListener(MouseEvent.CLICK, onMouseClick);
				pyb2.text			= "Annulla";
				pyb2.style			= "ComposerStyle:CancelRule";
				pyb2.normalStyle	= "ComposerStyle:CancelRule";
				pyb2.overStyle		= "ComposerStyle:CancelRuleOver";
			}
			if(winTitle.indexOf("Copia")!=-1)
			{
				pyc.backgroundColor	= 0xE0E0E6;
				pyb1				= new PYButton("Aggiungi");
				pyb1.addEventListener(MouseEvent.CLICK, onMouseClick);
				pyb1.text			= "Aggiungi";
				pyb1.style			= "ComposerStyle:SaveRule";
				pyb1.normalStyle	= "ComposerStyle:SaveRule";
				pyb1.overStyle		= "ComposerStyle:SaveRuleOver";
				pyb2				= new PYButton("Annulla");
				pyb2.addEventListener(MouseEvent.CLICK, onMouseClick);
				pyb2.text			= "Annulla";
				pyb2.style			= "ComposerStyle:CancelRule";
				pyb2.normalStyle	= "ComposerStyle:CancelRule";
				pyb2.overStyle		= "ComposerStyle:CancelRuleOver";
			}
			if(winTitle.indexOf("Cancellazione")!=-1)
			{
				pyc.backgroundColor	= 0xE0E0E6;
				pyb1				= new PYButton("Conferma");
				pyb1.addEventListener(MouseEvent.CLICK, onMouseClick);
				pyb1.text			= "Conferma";
				pyb1.style			= "ComposerStyle:DeleteRule";
				pyb1.normalStyle	= "ComposerStyle:DeleteRule";
				pyb1.overStyle		= "ComposerStyle:DeleteRuleOver";
				pyb2				= new PYButton("Annulla");
				pyb2.addEventListener(MouseEvent.CLICK, onMouseClick);
				pyb2.text			= "Annulla";
				pyb2.style			= "ComposerStyle:CancelRule";
				pyb2.normalStyle	= "ComposerStyle:CancelRule";
				pyb2.overStyle		= "ComposerStyle:CancelRuleOver";
			}
			pyb1.height	 		= 30;
			pyb2.height 		= 30;
			pyb1.width 			= 60;
			pyb2.width 			= 60;
			pyb1.x				= 20;
			pyb2.x				= 100;
			pyb1.y				= 20;
			pyb2.y				= 20;
			pyb1.selected		= false;
			pyb2.selected		= false;
			pyb1.toggle			= false;
			pyb2.toggle			= false;
			
			fio					= new PYInputText();
			fio.name			= "fio";
			fio.marginTop		= 20; // In realtà sono i padding del FieldIO, come margin del TextField che ha dentro
			fio.marginLeft		= 20;
			fio.marginRight		= 20;
			fio.marginBottom	= 20;
			//			fio.percentWidth	= 100;
			//			fio.percentHeight	= 100;
			fio.width			= 1230;
			fio.height			= 280;
			fio.x				= fio.marginLeft;
			fio.y				= 60;
			fio.wordWrap		= true;
			fio.style			= "ComposerStyle:TransformRuleEditWindow";
			
			// BRANCH: IMPORTANT!!!
			var originalIgnoreComments:Boolean = XML.ignoreComments;
			XML.ignoreComments	= false;
			fio.text			= xml.copy().toXMLString();
			XML.ignoreComments	= originalIgnoreComments;
			
			fo					= new FieldO();
			fo.name				= "fo";
			fo.text				= id.toString();
			fo.visible			= false;
			
			pyc.addChild(pyb1);
			pyc.addChild(pyb2);
			pyc.addChild(fio);
			pyc.addChild(fo);
			pyc.drawComponent(true);
			fio.drawComponent();
			
			fio.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			window 				= windowsDictionary[winName] as PCWindowNew
			window.addContent(pyc);
			window.addEventListener(Event.CLOSING, onClosing);
			window.addEventListener(Event.RESIZE, resizeWindow);
			
			return window;
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			var tf:TextField = event.target as TextField;
			switch(event.keyCode)
			{
				case Keyboard.ENTER:
					event.preventDefault();
					event.stopImmediatePropagation();
					tf.text = tf.text.substr(0,tf.caretIndex) + "\n" + tf.text.substr(tf.caretIndex,tf.text.length);
					tf.setSelection(tf.caretIndex+1,tf.caretIndex+1);
					break;
				case Keyboard.TAB:
					event.preventDefault();
					event.stopImmediatePropagation();
					var caretIndex:int			= tf.caretIndex;
					if (event.shiftKey)
					{
						var preCaret:String 	= tf.text.substr(0,caretIndex);
						var postCaret:String 	= tf.text.substr(caretIndex,tf.text.length);
						var lastTabId:int = preCaret.lastIndexOf("\t");
						if (lastTabId>-1)
						{
							var preTab:String = preCaret.substr(0,lastTabId);
							var postTab:String = preCaret.substr(lastTabId+1);
							(tf.parent as PYInputText).text = preTab + postTab + postCaret;
							(tf.parent as PYInputText).drawComponent();
							tf.stage.focus = tf;
							tf.setSelection(caretIndex-1,caretIndex-1);
						}
					} else {
						(tf.parent as PYInputText).text = tf.text.substr(0,caretIndex) + "\t" + tf.text.substr(caretIndex,tf.text.length);
						(tf.parent as PYInputText).drawComponent();
						tf.stage.focus = tf;
						tf.setSelection(caretIndex+1,caretIndex+1);
					}
					break;
				default:
					break;
			}
		}
		
		protected function selectPanel(event:PYNBoxEvent):void
		{
			// NOTA: Diversamente da le trasform rules, fa apparire il menu contestuale anche con 
			//	singolo click quando è già selezionato (visto che c'è un "chiudi pannello")
			if (event.doubleClicked || selectedPanelItem == event.item) 
			{
				if (selectedPanelItem == event.item && event.doubleClicked)
				{
					// Fare sparire il menu contestuale
					var pynbe:PYNBoxEvent = new PYNBoxEvent(PYNBoxEvent.DESELECT,true);
					pynbe.item = event.item;
					pynbe.index = event.index;
					event.currentTarget.selectedIndex = -1;
					selectedPanelItem = null;
				}
				else
				{
					var pynbs:PYNBoxSelectable = event.currentTarget as PYNBoxSelectable;
					selectedPanelItem = event.item;
					
					var panelClassName:String = event.item.text.split(" | ")[0];
					var panelStyle:String = event.item.text.split(" | ")[1]; 
					var panelName:String = event.item.text.split(" | ")[2];
					
					var xml:XML = DefaultsManager.getInstance().getPanelByName(panelName);
					
					function addNamesToPanel(xml:XML):void
					{
						if (xml.@name == null || xml.@name.toString()=="")
							xml.@name = "field" + panelNamesProgress++
						for each(var child:XML in xml.children() )
						{
							addNamesToPanel(child)
						}
					}
					function onPanelActionSelect(event:Event):void
					{
						if (event.target.label=="Apri Pannello")
						{
							addNamesToPanel(xml)
							
							
							InstanceManager4Panels.getInstance().panelXML =xml;
							InstanceManager4Panels.getInstance().projectName = DefaultsManager.getInstance().cleanedProjectName
							
							manualsBox.rootXml =  InstanceManager.getInstance().manualXML
							// man - tutti - 201117 - gestione pannelli con displayfile
							if (uiGen == null)
								uiGen = new UIGenerator( XML(DefaultsManager.getInstance().defaults.skinProperties), OVManager.getInstance(_client.clientShell.stage).vector, null, null, true);
							var panel:* = uiGen.generate( xml, null );
							if (panel!=null)
							{
								isPanelManagement = true
								// prendeo il canvas e aggiungo formato
								// man - tutti - 201117 - gestione pannelli con displayfile
							
								//var canvas:DisplayFile = (objectsVector["AREA"] as PYComponent).getChildByName("CANVAS") as DisplayFile;
								var canvas:PYComponent = (objectsVector["AREA"] as PYComponent);
								canvas.addChild(panel);
								objectsVector["AREA"].drawContainer(true)
								_client.session.activeDSPF = new Dspf()
								panelMediator.activeDspfName = canvas.name
								//baseSession.activeDSPF = canvas;
								// man - tutti - 201117 - gestito schema per nuovi pannelli
								outlineTree.dataProvider = xml;
								outlineTree.validateNow();
								for each(var item:XML in outlineTree.dataProvider)
								{
									outlineTree.expandChildrenOf(item,true);
								}
							}
						}
						else if (event.target.label=="Chiudi Pannello")
						{
							// TODO: Se ci sono modifiche  chiedere se salvare si o no
							// 	Se sì, prendere pannello da InstanceManager e metterlo nel DefaultsManager
							// Pulire InstanceManager
							// Togliere e fare dispose del pannello attivo nel canvas/displayfile.
							pynbs.selectedIndex = -1;
							selectedPanelItem = null;
							//var canvas:DisplayFile = (objectsVector["AREA"] as PYComponent).getChildByName("CANVAS") as DisplayFile;
							var canvas:PYComponent = (objectsVector["AREA"] as PYComponent);
							canvas.removeChild(canvas.getChildByName(panelName))
							objectsVector["AREA"].drawContainer(true)
							_client.session.activeDSPF = null
							panelMediator.activeDspfName = ""
								
							outlineTree.dataProvider = null;
							outlineTree.validateNow();
							populateDesktopSchema()
						}
						else
						{
							// Editori dei pannelli.
//						var winName:String;
//						var winTitle:String;
//						var pyc:PYComponent;
//						var window:PCWindowNew;
//						var copyWindowsTotal:int = 0;
//						var deleteWindowsTotal:int = 0;
//						var modifyWindowsTotal:int = 0;
//						var rulesWindowsTotal:int;
//						var regExp:RegExp = /(\d+)/;
//						
//						for each (var key:* in windowsDictionary)
//						{
//							if (key.title && key.title.indexOf("Modifica in corso (")==0)
//							{
//								modifyWindowsTotal = Math.max(modifyWindowsTotal, int(key.title.match(regExp)[0]));
//							}
//							if (key.title && key.title.indexOf("Copia in corso (")==0)
//							{
//								copyWindowsTotal = Math.max(copyWindowsTotal, int(key.title.match(regExp)[0]));
//							}
//							if (key.title && key.title.indexOf("Cancellazione in corso (")==0)
//							{
//								deleteWindowsTotal = Math.max(deleteWindowsTotal, int(key.title.match(regExp)[0]));
//							}
//						}
//						
//						var ww:int = 500;
//						var wh:int = 400;
//						var wx:Number = stage.nativeWindow.x + stage.mouseX + 130 + 200;
//						var wy:Number = stage.nativeWindow.y + stage.mouseY;
//						if (wx+ww > _client.clientShell.stage.stageWidth) 	wx = (_client.clientShell.stage.stageWidth/_client.clientShell.scaleX - ww)/2;
//						if (wy+wh > _client.clientShell.stage.stageHeight) 	wy = (_client.clientShell.stage.stageHeight/_client.clientShell.scaleY - wh)/2;
//						
//						switch(event.target.label)
//						{
//							case "Modifica":
//								modifyWindowsTotal++;
//								rulesWindowsTotal 	= modifyWindowsTotal + copyWindowsTotal + deleteWindowsTotal;
//								winName = winTitle 	= "Modifica in corso (" + modifyWindowsTotal + ")  =>  " + ruleLabel;		
//								window 				= buildTransformRuleWindow(winTitle, winName, new Point(homePoint.x+rulesWindowsTotal*20,homePoint.y+rulesWindowsTotal*20),xml,id);
//								window.activate();
//								break;
//							case "Copia":
//								copyWindowsTotal++;
//								rulesWindowsTotal 	= modifyWindowsTotal + copyWindowsTotal + deleteWindowsTotal;
//								winName = winTitle 	= "Copia in corso (" + copyWindowsTotal + ")  =>  " + ruleLabel;						
//								window 				= buildTransformRuleWindow(winTitle, winName, new Point(homePoint.x+rulesWindowsTotal*20,homePoint.y+rulesWindowsTotal*20),xml,id);
//								window.activate();
//								break;
//							case "Cancella":
//								copyWindowsTotal++;
//								rulesWindowsTotal 	= modifyWindowsTotal + copyWindowsTotal + deleteWindowsTotal;
//								winName = winTitle 	= "Cancellazione in corso (" + deleteWindowsTotal + ")  =>  " + ruleLabel;						
//								window 				= buildTransformRuleWindow(winTitle, winName, new Point(homePoint.x+rulesWindowsTotal*20,homePoint.y+rulesWindowsTotal*20),xml,id);
//								window.activate();
//								break;
//							case "Rules Help":
//								openHelpWindowHTML(	"Regole di trasformazione", wx, wy, ww, wh, "Regole di trasformazione.htm" );
//								break;
//							case "Transform Help":
//								openHelpWindowHTML(	ruleLabel.split(" | ")[0], wx, wy, ww, wh, "Regole di trasformazione.htm");
//								break;
//						}
						}
					}
					
					var panelMenu:NativeMenu = new NativeMenu();
					var openMenuItem:NativeMenuItem = panelMenu.addItem(new NativeMenuItem("Apri Pannello"));
					openMenuItem.data = xml;
					var closeMenuItem:NativeMenuItem = panelMenu.addItem(new NativeMenuItem("Chiudi Pannello"));
					closeMenuItem.data = xml;
					var copyMenuItem:NativeMenuItem = panelMenu.addItem(new NativeMenuItem("Copia Pannello"));
					copyMenuItem.data = xml;
					var modifyMenuItem:NativeMenuItem = panelMenu.addItem(new NativeMenuItem("Modifica Pannello"));
					modifyMenuItem.data = xml;
					var deleteMenuItem:NativeMenuItem = panelMenu.addItem(new NativeMenuItem("Cancella Pannello"));
					deleteMenuItem.data = xml;
					
//					panelMenu.addItem(new NativeMenuItem("",true));
//					panelMenu.addItem(new NativeMenuItem("Rules Help"));
//					panelMenu.addItem(new NativeMenuItem("Transform Help"));
					
					panelMenu.addEventListener(Event.SELECT, onPanelActionSelect);	
					
					// Position of the item in the Stage
					panelMenu.display(event.target.stage, event.item.mouseX, event.item.parent.y + event.item.y + event.item.mouseY);
				}
			}
		}
		
		protected function selectTransformRule(event:PYNBoxEvent):void
		{
			if (event.doubleClicked)
			{
				if (selectedTransformRuleItem == event.item)
				{
					// Fare sparire il menu contestuale
					var pynbe:PYNBoxEvent = new PYNBoxEvent(PYNBoxEvent.DESELECT,true);
					pynbe.item = event.item;
					pynbe.index = event.index;
					event.currentTarget.selectedIndex = -1;
					selectedTransformRuleItem = null;
				} else {
					selectedTransformRuleItem = event.item;
					
					var xml:XML = DefaultsManager.getInstance().getRuleFromLabel(event.item.text);
					var id:int	= ((DefaultsManager.getInstance().getRulesList() as Array)[event.index] as Object).id; // È l'oggetto rule
					var ruleLabel:String = event.item.text;
					var stage:Stage = event.item.stage;
					
					function onRuleActionSelect(event:Event):void
					{
						var winName:String;
						var winTitle:String;
						var pyc:PYComponent;
						var window:PCWindowNew;
						var copyWindowsTotal:int = 0;
						var deleteWindowsTotal:int = 0;
						var modifyWindowsTotal:int = 0;
						var rulesWindowsTotal:int;
						var regExp:RegExp = /(\d+)/;
						
						for each (var key:* in windowsDictionary)
						{
							if (key.title && key.title.indexOf("Modifica in corso (")==0)
							{
								modifyWindowsTotal = Math.max(modifyWindowsTotal, int(key.title.match(regExp)[0]));
							}
							if (key.title && key.title.indexOf("Copia in corso (")==0)
							{
								copyWindowsTotal = Math.max(copyWindowsTotal, int(key.title.match(regExp)[0]));
							}
							if (key.title && key.title.indexOf("Cancellazione in corso (")==0)
							{
								deleteWindowsTotal = Math.max(deleteWindowsTotal, int(key.title.match(regExp)[0]));
							}
						}
						
						var ww:int = 500;
						var wh:int = 400;
						var wx:Number = stage.nativeWindow.x + stage.mouseX;
						var wy:Number = stage.nativeWindow.y - wh;
						if (wx+ww > _client.clientShell.stage.fullScreenWidth) 	wx = (_client.clientShell.stage.fullScreenWidth - ww);
						if (wy+wh > _client.clientShell.stage.fullScreenHeight) wy = (_client.clientShell.stage.fullScreenHeight - wh);
						
						switch(event.target.label)
						{
							case "Modifica":
								modifyWindowsTotal++;
								rulesWindowsTotal 	= modifyWindowsTotal + copyWindowsTotal + deleteWindowsTotal;
								winName = winTitle 	= "Modifica in corso (" + modifyWindowsTotal + ")  =>  " + ruleLabel;		
								window 				= buildTransformRuleWindow(winTitle, winName, new Point(homePoint.x+rulesWindowsTotal*20,homePoint.y+rulesWindowsTotal*20),xml,id);
								window.activate();
								break;
							case "Copia":
								copyWindowsTotal++;
								rulesWindowsTotal 	= modifyWindowsTotal + copyWindowsTotal + deleteWindowsTotal;
								winName = winTitle 	= "Copia in corso (" + copyWindowsTotal + ")  =>  " + ruleLabel;						
								window 				= buildTransformRuleWindow(winTitle, winName, new Point(homePoint.x+rulesWindowsTotal*20,homePoint.y+rulesWindowsTotal*20),xml,id);
								window.activate();
								break;
							case "Cancella":
								copyWindowsTotal++;
								rulesWindowsTotal 	= modifyWindowsTotal + copyWindowsTotal + deleteWindowsTotal;
								winName = winTitle 	= "Cancellazione in corso (" + deleteWindowsTotal + ")  =>  " + ruleLabel;						
								window 				= buildTransformRuleWindow(winTitle, winName, new Point(homePoint.x+rulesWindowsTotal*20,homePoint.y+rulesWindowsTotal*20),xml,id);
								window.activate();
								break;
							case "Rules Help":
								openHelpWindowHTML(	"Regole di trasformazione", wx, wy, ww, wh, "Regole di trasformazione.htm" );
								break;
							case "Transform Help":
								openHelpWindowHTML(	ruleLabel.split(" | ")[0], wx, wy, ww, wh, "Regole di trasformazione.htm");
								break;
						}
					}
					
					var ruleMenu:NativeMenu = new NativeMenu();
					var modifyMenuItem:NativeMenuItem = ruleMenu.addItem(new NativeMenuItem("Modifica"));
					modifyMenuItem.data = xml;
					var copyMenuItem:NativeMenuItem = ruleMenu.addItem(new NativeMenuItem("Copia"));
					copyMenuItem.data = xml;
					var deleteMenuItem:NativeMenuItem = ruleMenu.addItem(new NativeMenuItem("Cancella"));
					deleteMenuItem.data = xml;
					
					ruleMenu.addItem(new NativeMenuItem("",true));
					ruleMenu.addItem(new NativeMenuItem("Rules Help"));
					ruleMenu.addItem(new NativeMenuItem("Transform Help"));
					
					ruleMenu.addEventListener(Event.SELECT, onRuleActionSelect);	
					
					// Position of the item in the Stage
					ruleMenu.display(event.target.stage, event.item.mouseX, event.item.parent.y + event.item.y + event.item.mouseY);
				}
			}
		}
		
		// NON IMPLEMENTATA ANCORA, MA PUÒ ESSERE UTILE NEL FUTURO
		//		private function prettyPrintify(xml:XML):XML
		//		{
		//			var oriIgnoreComments:Boolean 	= XML.ignoreComments;
		//			var oriIgnoreWhitespace:Boolean = XML.ignoreWhitespace;
		//			var oriPrettyPrinting:Boolean 	= XML.prettyPrinting;
		//			
		//			// PrettyPrintify la rule
		//			XML.ignoreComments		= false;
		//			XML.ignoreWhitespace	= false;
		//			XML.prettyPrinting		= true;
		//			xml						= xml.copy();
		//			XML.ignoreComments		= oriIgnoreComments;
		//			XML.ignoreWhitespace	= oriIgnoreWhitespace;
		//			XML.prettyPrinting		= oriPrettyPrinting;
		//			
		//			return xml;
		//		}
		//		
		private function updateControlPanel():void
		{
			if (modifyItemsSelected[0])
			{
				var className:String = getQualifiedClassName(modifyItemsSelected[0]).split("::")[1];
				var styleName:String = modifyItemsSelected[0].style
				var compName:String = modifyItemsSelected[0].name
				var transformRule:String = modifyItemsSelected[0].transformRule
			}
			
			
			for each (var pyc:PYComponent in utilityControls.getChildren())
			{
				for each (var o:* in pyc.getChildren())
				{
					if(o is FieldIO)
					{
						switch((o as FieldIO).name)
						{
							case "fieldIOUser":
								(o as FieldIO).text = (_client.getUid())? _client.getUid() : "";
								break;
							
							case "fieldIOProject":
								(o as FieldIO).text = (DefaultsManager.getInstance().cleanedProjectName)? DefaultsManager.getInstance().cleanedProjectName : "";
								break;
							
							case "fieldIODisplay_File":
								(o as FieldIO).text = (_client.session && _client.session.activeDSPF && _client.session.activeDSPF.name)? _client.session.activeDSPF.name : "";
								break;
							
							case "fieldIOAS400_Call":
								(o as FieldIO).text = (_client.desktop && _client.desktop.menuCallCommand && _client.session && _client.session.activeDSPF)? _client.desktop.menuCallCommand : "";
								break;
							
							case "fieldIOField_Name":
								(o as FieldIO).text = (compName)? compName : "";
								break;
							
							case "fieldIOComponent":
								(o as FieldIO).text = (className)? className : "";
								break;
							
							case "fieldIOStyle":
								(o as FieldIO).text = (styleName)? styleName : "";
								break;
							
							case "fieldIOTransformation_Rule":
								(o as FieldIO).text = (transformRule)? transformRule : "";
								break;
							
						}
						
					}
				
				}				
			}
			
			utilityControls.drawContainer(true);			
		}		
		
		
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////    menu functions    //////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		protected function initAppMenu():void
		{
			var splitMenuItem:NativeMenuItem;
			
			var projectMenu:NativeMenu;
			var projectMenuItem:NativeMenuItem;
			var editMenu:NativeMenu;
			var editMenuItem:NativeMenuItem;
			var panelMenu:NativeMenu;
			var panelMenuItem:NativeMenuItem;
			var debugMenu:NativeMenu;
			var debugMenuItem:NativeMenuItem;
			var windowsMenu:NativeMenu;
			var windowsMenuItem:NativeMenuItem;
			
			// IMPORTANTE: Lo style deve essere impostato prima di settare altri attributi (ad es. horizontalSpacing non lo prende)
			utilityMenu 						= new PYNbox();
			utilityMenu.layout					= PYContainer.HORIZONTAL;
			utilityMenu.alignOnScroll			= false;
			utilityMenu.autoSize				= true;
			utilityMenu.clip					= true;
			utilityMenu.doubleClickEnabled		= false;
			utilityMenu.forceAlign				= true;
			utilityMenu.height					= 24;
			utilityMenu.horizontalScrollBar		= PYContainer.ARROW;
			utilityMenu.horizontalScrolling		= false; // true; se dovesse attivare la ScrollBar
			utilityMenu.horizontalSpacing		= 4;
			utilityMenu.paddingBottom			= 0;
			utilityMenu.paddingLeft				= 2; // 16; se dovesse attivare la ScrollBar
			utilityMenu.paddingRight			= 2; // 16; se dovesse attivare la ScrollBar
			utilityMenu.paddingTop				= 0;
			utilityMenu.scrollBarAlwaysShown	= false;
			utilityMenu.scrollBarDimension		= 16;
			utilityMenu.scrollBarStyle			= "ComposerStyle:ScrollContenitoriPannelloDiControllo";
			
			projectMenu = new NativeMenu();
			
			createMenuElements(projectMenu,"Apri project",onViewCommand,false);
//			projectMenu.addItem(createMenuItem("Apri project",onViewCommand,false,false)); // Qui lo inseriamo solo nel nativeMenu	
			createMenuElements(projectMenu,"Salva project",onViewCommand,false);
			createMenuElements(projectMenu,"Salva project con nome",onViewCommand,false);
			createMenuElements(projectMenu,"Riavvia Desktop",onViewCommand,false);
			createMenuElements(projectMenu,"Importa",onViewCommand,false,false);
			createMenuElements(projectMenu,"Esporta",onViewCommand,false,false);
			createMenuElements(projectMenu,"");
			createMenuElements(projectMenu,"Attivare cache",onWindowCommand);
			createMenuElements(projectMenu,"Disattivare regole di trasformazione",onWindowCommand);
			createMenuElements(projectMenu,"Disattivare modifiche manuali",onWindowCommand);
			createMenuElements(projectMenu,"Disattivare modifiche utente",onWindowCommand);
			createMenuElements(projectMenu,"");
			createMenuElements(projectMenu,"Modifica con EDITORE ESTERNO",onWindowCommand,false,false,(ConnectionsPack.getInstance(_client.clientShell.stage).notepadDirectory!="")); 	// Non fa toggle (RIVEDERE?)
			
			//			//-----------------------------marco
			//			createMenuElements(projectMenu,"Components tree",onWindowCommand);
			//			//-----------------------------marco
			
			_rootMenu.addSubmenuAt(projectMenu, 1, "Project");
			utilityMenu.addChild(createMenuButton("",null,false,false,true));
			
			
			editMenu = new NativeMenu();
			undoMenuItem = createMenuItem("Annulla",onViewCommand,false,false);
			editMenu.addItem(undoMenuItem);
			redoMenuItem = createMenuItem("Ripristina",onViewCommand,false,false);
			editMenu.addItem(redoMenuItem);
			createMenuElements(editMenu,"");
			editMenu.addItem(createMenuItem("Copia",onViewCommand,false,false));
			editMenu.addItem(createMenuItem("Taglia",onViewCommand,false,false));
			editMenu.addItem(createMenuItem("Incolla",onViewCommand,false,false));
			//			editMenu.addItem(createMenuItem("Delete",onViewCommand,false,false));
			createMenuElements(editMenu,"");
			editMenu.addItem(createMenuItem("Copia nome icone negli appunti", onViewCommand,false,true));
			editMenu.addItem(createMenuItem("Esporta icone della imgDir", onViewCommand,false,true));
			
			_rootMenu.addSubmenuAt(editMenu, 2, "Edit");
			//			utilityMenu.addChild(createMenuButton("",null,false,false,false));
			
			
			panelMenu = new NativeMenu();
			createMenuElements(panelMenu,"Abilitare tracking componenti",onViewCommand);
			createMenuElements(panelMenu,"Abilitare modifiche del pannello",onViewCommand);
			createMenuElements(panelMenu,"Abilitare modifiche di tabella",onViewCommand);
			createMenuElements(panelMenu,"Abilitare modifiche del Desktop",onViewCommand,true,false,false); // Per ora, non abilitato
			createMenuElements(panelMenu,"");
			createMenuElements(panelMenu,"Selezionare griglia",onViewCommand,false,false);
			createMenuElements(panelMenu,"Selezionare risoluzione",onViewCommand,false,false);
			
			
			
			_rootMenu.addSubmenuAt(panelMenu, 3, "Panel");
			utilityMenu.addChild(createMenuButton("",null,false,false,true));
			
			
			// apertura finestre varie
			debugMenu = new NativeMenu()
			//createMenuElements(debugMenu,"Pannello di controllo",onWindowCommand,true,true); // Parte già aperto
			createMenuElements(debugMenu,"Struttura del DSPF",onWindowCommand,true,false,false);
			createMenuElements(debugMenu,"Vista dettaglio del DSPF",onWindowCommand,true,false,false);
			createMenuElements(debugMenu,"Ultimo input verso AS400",onWindowCommand);
			createMenuElements(debugMenu,"Ultimo output da AS400",onWindowCommand);
			createMenuElements(debugMenu,"Log",onWindowCommand);
			
			_rootMenu.addSubmenuAt(debugMenu, 4, "Debug");
			utilityMenu.addChild(createMenuButton("",null,false,false,false));
			
			
			// apertura finestre varie
			windowsMenu = new NativeMenu()
			createMenuElements(windowsMenu, "Pannello di controllo",onWindowCommand,true,true); // Parte già aperto
			createMenuElements(windowsMenu, "Stile", onWindowCommand,true,true); // Parte già aperto
			createMenuElements(windowsMenu, "Schema",onWindowCommand,true,true); // Parte già aperto
			createMenuElements(windowsMenu, "Istanza",onWindowCommand,true,true); // Parte già aperto
			createMenuElements(windowsMenu, "Regole di trasformazione", onWindowCommand, true, true); // Parte già aperto
			createMenuElements(windowsMenu, "");
			createMenuElements(windowsMenu, "Keywords", onWindowCommand);
			createMenuElements(windowsMenu, "Pairing", onWindowCommand);
			createMenuElements(windowsMenu, "Albero di modifiche manuali",onWindowCommand,true,false,false);
			createMenuElements(windowsMenu, "Albero del progetto", onWindowCommand, true, false, false);
			createMenuElements(windowsMenu, "Componenti", onWindowCommand, true, false, false);
			createMenuElements(windowsMenu, "Panels", onWindowCommand, true, false, false);
			createMenuElements(windowsMenu, "");
			createMenuElements(windowsMenu, "Riordinare finestre",onViewCommand,false);
			
			_rootMenu.addSubmenuAt(windowsMenu, 5, "Windows");
			//utilityMenu.addChild(createMenuButton("",null,false,false,false));
			
			
			//			var editMenuItem2:NativeMenuItem = _rootMenu.addSubmenuAt(viewMenu, 3, "Debug");
			//			editMenuItem2.name = editMenuItem2.label
			//				var editMenuItem3:NativeMenuItem = _rootMenu.addSubmenu(new NativeMenu(), "Help"); 
			
			//				var connMenu:NativeMenu = new NativeMenu()
			//				
			//				var menuFs:NativeMenuItem = new NativeMenuItem("Server Connect", false); 
			//				menuFs.addEventListener(Event.SELECT, onViewCommand); 
			//				connMenu.addItem(menuFs)
			//				var menuFs:NativeMenuItem = new NativeMenuItem("Server Disconnect", false); 
			//				menuFs.addEventListener(Event.SELECT, onViewCommand); 
			//				connMenu.addItem(menuFs)
			//				var menuFs:NativeMenuItem = new NativeMenuItem("Options", false); 
			//				menuFs.addEventListener(Event.SELECT, onViewCommand); 
			//				connMenu.addItem(menuFs)
			//				
			//				uidMenu = new NativeMenu()
			//				
			//				var menuFs:NativeMenuItem = new NativeMenuItem("Login", false); 
			//				menuFs.addEventListener(Event.SELECT, onViewCommand); 
			//				uidMenu.addItem(menuFs)
			//				var menuFs:NativeMenuItem = new NativeMenuItem("Logout", false); 
			//				menuFs.addEventListener(Event.SELECT, onViewCommand); 
			//				uidMenu.addItem(menuFs)
			
			utilityMenu.drawContainer();
		}
		
		
		protected function createMenuButton(name:String,listener:Function,toggle:Boolean=true,selected:Boolean=false,enabled:Boolean=true):PYButton
		{
			var preventClickDefault:Function = function(event:MouseEvent):void
			{
				event.preventDefault();
				event.stopImmediatePropagation();
			}
				
			var iconCode:String			= "embed:" + ((name=="")? "split" : name).toLowerCase().split(" ").join("_") + ".png";
				
			var abButton:PYButton		= new PYButton();
			abButton.enabled			= enabled;
			abButton.iconImage 			= iconCode; //File.applicationDirectory.resolvePath("assets/composer/" + ((name=="")? "split" : name).toLowerCase().split(" ").join("_") + ".png").nativePath;
			abButton.name				= name;
			abButton.style				= "ComposerStyle" + ((name=="")? ":Spazio" : ":") + "PulsantiMenuSuperiore"; // Style needs to be set before toggle and selected
			abButton.toggle				= toggle; // Toggle needs to be set before selected
			abButton.selected			= selected;
			if (name!="")
			{
				abButton.toolTip		= name;
				abButton.toolTipTime	= 250;
			}
			abButton.clip				= false;
			abButton.mouseChildren		= false;
			abButton.doubleClickEnabled	= false;
			abButton.addEventListener(MouseEvent.CLICK, ((name!="")? listener : preventClickDefault));
			return abButton;
		}
		
		protected function createMenuElements(menu:NativeMenu,name:String,listener:Function=null,toggle:Boolean=true,isOn:Boolean=false,enabled:Boolean=true):void
		{
			if (name=="")
			{
				// We're just creating a separator
				menu.addItem(new NativeMenuItem("",true));
			} else {
				// We're creating both a NativeMenuItem for the ApplicationMenu and a PYButton for the Utility Menu
				menu.addItem(createMenuItem(name,listener,isOn,enabled));
				utilityMenu.addChild(createMenuButton(name,listener,toggle,isOn,enabled));
			}
		}
		
		protected function createMenuItem(name:String,listener:Function,checked:Boolean=false,enabled:Boolean=true):NativeMenuItem
		{
			var menuItem:NativeMenuItem	= new NativeMenuItem(name);
			menuItem.checked			= checked;
			menuItem.enabled			= enabled;
			menuItem.name				= name;
			menuItem.addEventListener(Event.SELECT, listener);	
			menuItemsDictionary[name]		= menuItem;
			if (menuItem.name=="Esporta") menuItem.submenu = createExportMenu();
			if (menuItem.name=="Importa") menuItem.submenu = createImportMenu();
			if (menuItem.name=="Selezionare griglia") menuItem.submenu = createGridMenu();
			if (menuItem.name=="Selezionare risoluzione") menuItem.submenu = createResolutionMenu();
			return menuItem;
		}
		
		protected function createExportMenu():NativeMenu
		{
			// Creare menu nativo
			exportMenu	= new NativeMenu();
			
			var skin:NativeMenuItem			= new NativeMenuItem("Skin");
			skin.data						= {name:"Esporta Skin"};
			var pairings:NativeMenuItem		= new NativeMenuItem("Pairings");
			pairings.data					= {name:"Esporta Pairings"};
			var desktop:NativeMenuItem		= new NativeMenuItem("Desktop");
			desktop.data					= {name:"Esporta Desktop"};
			var keywords:NativeMenuItem		= new NativeMenuItem("Keywords");
			keywords.data					= {name:"Esporta Keywords"};
			var fastRules:NativeMenuItem	= new NativeMenuItem("Fast Rules");
			fastRules.data					= {name:"Esporta Fast Rules"};
			var rules:NativeMenuItem		= new NativeMenuItem("Rules");
			rules.data						= {name:"Esporta Rules"};
			var fonts:NativeMenuItem		= new NativeMenuItem("Fonts");
			fonts.data						= {name:"Esporta Fonts"};
			var gui:NativeMenuItem			= new NativeMenuItem("GUI");
			gui.data						= {name:"Esporta GUI"};
			
			exportMenu.addItem(desktop);
			exportMenu.addItem(fastRules);
			exportMenu.addItem(fonts);
			exportMenu.addItem(gui);
			exportMenu.addItem(pairings);
			exportMenu.addItem(rules);
			exportMenu.addItem(skin);
			
			exportMenu.addEventListener(Event.SELECT, selectExport);
			
			return exportMenu;
		}
		
		protected function createGridMenu():NativeMenu
		{
			// Creare menu nativo
			gridMenu	= new NativeMenu();
			
			var grid0x0:NativeMenuItem 		= new NativeMenuItem("(libero)");
			grid0x0.data 					= {gridX:0,gridY:0};
			grid0x0.checked					= true;
			var grid1x1:NativeMenuItem 		= new NativeMenuItem("1x1");
			grid1x1.data 					= {gridX:1,gridY:1};
			var grid2x2:NativeMenuItem 		= new NativeMenuItem("2x2");
			grid2x2.data 					= {gridX:2,gridY:2};
			var grid5x5:NativeMenuItem 		= new NativeMenuItem("5x5");
			grid5x5.data 					= {gridX:5,gridY:5};
			var grid10x10:NativeMenuItem 	= new NativeMenuItem("10x10");
			grid10x10.data 					= {gridX:10,gridY:10};
			var grid20x20:NativeMenuItem 	= new NativeMenuItem("20x20");
			grid20x20.data 					= {gridX:20,gridY:20};
			var grid50x50:NativeMenuItem 	= new NativeMenuItem("50x50");
			grid50x50.data 					= {gridX:50,gridY:50};
			
			gridMenu.addItem(grid0x0);
			gridMenu.addItem(grid1x1);
			gridMenu.addItem(grid2x2);
			gridMenu.addItem(grid5x5);
			gridMenu.addItem(grid10x10);
			gridMenu.addItem(grid20x20);
			gridMenu.addItem(grid50x50);
			
			gridMenu.addEventListener(Event.SELECT, selectGrid);
			
			return gridMenu;
		}
		
		protected function createImportMenu():NativeMenu
		{
			// Creare menu nativo
			importMenu	= new NativeMenu();
			
			var skin:NativeMenuItem			= new NativeMenuItem("Skin");
			skin.data						= {name:"Importa Skin"};
			var pairings:NativeMenuItem		= new NativeMenuItem("Pairings");
			pairings.data					= {name:"Importa Pairings"};
			var desktop:NativeMenuItem		= new NativeMenuItem("Desktop");
			desktop.data					= {name:"Importa Desktop"};
			var keywords:NativeMenuItem		= new NativeMenuItem("Keywords");
			keywords.data					= {name:"Importa Keywords"};
			var fastRules:NativeMenuItem	= new NativeMenuItem("Fast Rules");
			fastRules.data					= {name:"Importa Fast Rules"};
			var rules:NativeMenuItem		= new NativeMenuItem("Rules");
			rules.data						= {name:"Importa Rules"};
			var fonts:NativeMenuItem		= new NativeMenuItem("Fonts");
			fonts.data						= {name:"Importa Fonts"};
			var gui:NativeMenuItem			= new NativeMenuItem("GUI");
			gui.data						= {name:"Importa GUI"};
			
			importMenu.addItem(desktop);
			importMenu.addItem(fastRules);
			importMenu.addItem(fonts);
			importMenu.addItem(gui);
			importMenu.addItem(pairings);
			importMenu.addItem(rules);
			importMenu.addItem(skin);
			
			importMenu.addEventListener(Event.SELECT, selectImport);
			
			return importMenu;
		}
		
		protected function createResolutionMenu():NativeMenu
		{
			// Creare menu nativo
			resolutionMenu	= new NativeMenu();
			
			var iPadHor:NativeMenuItem 	= new NativeMenuItem("1024x768 4:3 (iPad Landscape)");
			iPadHor.data 					= {width:1024,height:768,ratio:"4:3"};
			var iPadVer:NativeMenuItem 	= new NativeMenuItem("768x1024 3:4 (iPad Portrait)");
			iPadVer.data 					= {width:768,height:1024,ratio:"3:4"};
			var andrHor:NativeMenuItem 	= new NativeMenuItem("1280x720 16:9 (Android Landscape)");
			andrHor.data 					= {width:1280,height:720,ratio:"16:9"};
			var andrVer:NativeMenuItem 	= new NativeMenuItem("720x1280 9:16 (Android Portrait)");
			andrVer.data 					= {width:720,height:1280,ratio:"9:16"};
			
			resolutionMenu.addItem(iPadHor);
			resolutionMenu.addItem(iPadVer);
			resolutionMenu.addItem(andrHor);
			resolutionMenu.addItem(andrVer);
			
			resolutionMenu.addEventListener(Event.SELECT, selectResolution);
			
			return resolutionMenu;
		}
		
		protected function onViewCommand(event:Event):void
		{
			var lib:String;
			var name:String;
			var params:String;
			
			var menuButton:PYButton;
			var menuItem:NativeMenuItem;
			
			if (event is MouseEvent)
			{
				menuButton 	= ((event.target is PYButton)? (event.target) : (event.target.parent)) as PYButton;
				menuItem	= menuItemsDictionary[menuButton.name];
			} else {
				menuItem	= (event.target as NativeMenuItem);
				menuButton	= utilityMenu.getChildByName(menuItem.label) as PYButton;
			}
			
			var i:int;
			var array:Array;
			var text:String;
			
			switch (menuItem.label)
			{
				case "Riordinare finestre":
				{
					reorganizeWindows();
					break;
				}
					
				case "Apri project":
				{
//					// bug - tessport 300917 - il caricamento fuziona in debug e non nel release, dove crash!!!!!!!!!
//					var filterName:String		= "Selezionare" + " XML File";
//					var onFileLoaded:Function 	= function(event:Event):void
//					{
//						alert=new PYAlert(_client.clientShell.stage,'Non è stato possibile localizzare la cartella dei backup.', 'Avviso',['OK']);
//						alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
//						alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
//						return;
//						var ba:ByteArray = event.target.data as ByteArray
//						var strXml:String 				= ba.readUTFBytes(ba.bytesAvailable)
//						//loadProjectFromString(strXml);
//						projectModified = true;
//
//					}
//					var onFileSelected:Function	= function(event:Event):void
//					{
//						trace(ifr.name);
//						alert=new PYAlert(_client.clientShell.stage,ifr.name, 'Avviso',['OK']);
//						alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
//						alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
//						return;
//						ifr.addEventListener(Event.COMPLETE, onFileLoaded);
//						ifr.load();						
//					}
//					var ifr:FileReference = new FileReference();
//					ifr.addEventListener(Event.SELECT, onFileSelected);
//					try {
//					ifr.browse([new FileFilter(filterName, "*.xml")]);
//					} catch ( error:Error ) {
//						trace(error.message);
//						alert=new PYAlert(_client.clientShell.stage,error.message, 'Avviso',['OK']);
//						alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
//						alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
//					}	
//					return;
					
					
					
					
					///////////// OPSOLETO  ///////////////////////
					var file:File = PyDirectoryManager.resolveCompletePath("backup","");
					
					if (!file.exists)
					{
						alert=new PYAlert(_client.clientShell.stage,'Non è stato possibile localizzare la cartella dei backup.', 'Avviso',['OK']);
						alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
						return;
					} else {
						file.addEventListener(Event.SELECT,onProjectFileSelected);
						file.browseForOpen("Seleziona il file di project");
					}
//					if (!windowsDictionary["prjLoader"].active) windowsDictionary["prjLoader"].activate()	
//					windowsDictionary["prjLoader"].visible = true		
//					prjLoader.prjTitle.text = menuItem.name;
//					prjLoader.setPath()
//					prjLoader.stage.addEventListener(KeyboardEvent.KEY_DOWN,prjLoader.prjNameCont_keyDownHandler);
//					prjLoader.ctrlSession = ctrlSession
					break;
				}
					
				case "Salva project":
				{
					if (!commandIsExecutable("Salva project"))
					{
						alert=new PYAlert(_client.clientShell.stage,'Impossibile effettuare il salvataggio del progetto.', 'Avviso',['OK']);
						alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
						return;
					}
					if (!windowsDictionary["prjLoader"].active) windowsDictionary["prjLoader"].activate()	
					windowsDictionary["prjLoader"].visible = true	
					prjLoader.isSaveAs = false
					prjLoader.prjTitle.text = menuItem.name;
					prjLoader.visible = false	
					prjLoader.ctrlSession = ctrlSession
					prjLoader.localConfig = _localConfig;
					prjLoader.saveProject()
					break;
				}
					
				case "Salva project con nome":
				{
					if (!commandIsExecutable("Salva project"))
					{
						alert=new PYAlert(_client.clientShell.stage,'Impossibile effettuare il salvataggio del progetto.', 'Avviso',['OK']);
						alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
						return;
					}
					if (!windowsDictionary["prjLoader"].active) windowsDictionary["prjLoader"].activate()	
					windowsDictionary["prjLoader"].visible = true
					prjLoader.visible = true
					prjLoader.isSaveAs = true
					prjLoader.prjTitle.text = menuItem.name;
					prjLoader.ctrlSession = ctrlSession
					prjLoader.localConfig = _localConfig;
					prjLoader.setPath()
					prjLoader.stage.addEventListener(KeyboardEvent.KEY_DOWN,prjLoader.prjNameCont_keyDownHandler);
					break;
				}
					
				case "Riavvia Desktop":
				{
					// RUG - non funziona -  da testare
//					_client.restartDesktop()
//					_objectsVector = _client.objectsVector
//					panelMediator = _client.panelMediator;
				}
					
				case "Importa":
				{
					if(event.target is NativeMenuItem)
					{
						(event.target as NativeMenuItem).submenu = importMenu;
					} else {
						importMenu.display(event.target.stage, event.target.x,event.target.y);
					}
					break;
				}
										
				case "Esporta":
				{
					if(event.target is NativeMenuItem)
					{
						(event.target as NativeMenuItem).submenu = exportMenu;
					} else {
						exportMenu.display(event.target.stage, event.target.x,event.target.y);
					}
					break;
				}
			
				case "Esporta Skin":
				{
					var skin:XML = DefaultsManager.getInstance().richRoot.projectSection.skinProperties[0];
					var efr:FileReference = new FileReference();
					efr.save(skin,"ProjectSkin.xml");
					break;
				}
					
				case "Selezionare griglia":
				{										
					if(event.target is NativeMenuItem)
					{
						(event.target as NativeMenuItem).submenu = gridMenu;
					} else {
						gridMenu.display(event.target.stage, event.target.x,event.target.y);
					}
					break;
				}
					
				case "Selezionare risoluzione":
				{										
					if(event.target is NativeMenuItem)
					{
						(event.target as NativeMenuItem).submenu = resolutionMenu;
					} else {
						resolutionMenu.display(event.target.stage, event.target.x,event.target.y);
					}
					break;
				}
					
				case "Copia nome icone negli appunti":
				{
					// NEW - TUTTI - 20170328 - Composer: Nuova voce di menu Copia nome icone negli appunti - 
					//	Esegue la funzione che rileva il path delle immagini usate nel project e le copia nella clipboard di sistema
					array = DefaultsManager.getInstance().getProjectImages();
					array = array.sort();
					text = "";
					for (i=0; i<array.length; i++)
					{
						text += array[i] + "\n";
					}
					
					try
					{
						Clipboard.generalClipboard.clear();
						Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, text);
						alert				= new PYAlert(_client.clientShell.stage,"I nomi delle immagini del project\nsono stati copiati negli appunti.", 'Clipboard',['OK']);
						alert.boxStyle		= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						alert.buttonStyle	= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
					} catch (e:Error) {
						alert				= new PYAlert(_client.clientShell.stage,"Non è stato possibile copiare i nomi\ndelle immagini del project.", 'Avvertenza',['OK']);
						alert.boxStyle		= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						alert.buttonStyle	= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
					}
					
					break;
				}
					
				case "Esporta icone della imgDir":
				{
					// NEW - TUTTI - 20170424 - Composer: Nuova voce di menu Copia icone (genera pacchetto assets?) - 
					// Esegue la funzione che rileva il path delle immagini usate nel project e ne genera il pacchetto 
					// 	di asset con sottodirrettori icone, etc
					array = DefaultsManager.getInstance().getProjectImages();
					array = array.sort();
					text = "";
					
					var oriFile:File;
					var expFile:File;
					
					// Questa parte è riportata dal PYComponente, per la gestione dei diversi path possibili per l'immagine
					var appDir:String 	= ConnectionsPack.getInstance().appDirectory;
					var baseDir:String 	= ConnectionsPack.getInstance().baseDirectory;
					var imgDir:String 	= ConnectionsPack.getInstance().imageDirectory;
					
					for (i=0; i<array.length; i++)
					{
						var value:String = StringUtils.trim(array[i]);
						
						if (value > "")
						{
							if ( ( appDir == "" || value.indexOf(appDir)<0 ) && value.indexOf("embed:")<0) // Se ha già la applicationDirectory come inizio del path, non modifica nulla
							{
								// BUG CAPGEMINI/ALL 2015-12-02: Inviava http: come HTTP:. Questa parte di una URL è case insensitive (anche in linux).
								//	Quindi la comparazione di questa parte del value va fatta indipendentemente di se è minuscola o meno.
								if (imgDir!=null && 
									value.substr(0,7).toLowerCase()!="file://" &&
									value.substr(0,7).toLowerCase()!="http://" && 
									value.substr(0,8).toLowerCase()!="https://")
								{ 
									// Se non esiste ancora imgDir, o se il valore originale è un indirizzo di OS (e.g. C:\...), un path di rete, o è una URL completa, 
									//	la caricherà così come'è. Altrimenti Sistema il path per localizzarla correttamente.
									if (imgDir.substr(-1)=="/")	imgDir = imgDir.substr(0,imgDir.length-1);	// Normalizza imgDir "/blabla" -> "blabla"
									
									if (value.substr(0,3) == "../") value = value.split("../").join("");	// Normalizza value "../../xxx/yyy/pippo.png" -> "xxx/yyy/pippo.png"		
									if (value.substr(0,2) == "..") 	value = value.split("..").join("");		// Normalizza value "..xxx/yyy/pippo.png" -> "xxx/yyy/pippo.png"
									
									// MAD 2016-10-13 Normalizzare il value, caso qualcuno l'abbia scritto con "/" iniziale (la caricarebbe lo stesso, ma...)
									if (value.substr(0,1)=="/") value = value.substr(1,value.length-1);
									
									// MAD 2016-01-22 Permettere di usare directory URL o file come imgDir
									if (imgDir.substr(0,7).toLowerCase()=="file://" ||
										imgDir.substr(0,7).toLowerCase()=="http://" || 
										imgDir.substr(0,8).toLowerCase()=="https://")
									{
										// Aggiungere solo la imgDir
										value	= imgDir + "/" + value;
									} else {
										// Aggiungere baseDir se c'è, e la imgDir
										value	= ((baseDir)? baseDir + "/" : "") + ((value.substr(0,7)=="assets/")? "" : imgDir + "/") + value;
									}
								}
								
								if (value.substr(0,7).toLowerCase()!="http://" && 
									value.substr(0,8).toLowerCase()!="https://") 
								{
									oriFile = new File(value);
									if (oriFile.exists)
									{
										if (baseDir && value.indexOf(baseDir)>-1) value = value.substr(baseDir.length);
										expFile = PyDirectoryManager.resolveCompletePath("temp/",value);
										oriFile.copyTo(expFile,true);
									}
									else
									{
										// Immagine inesistente/non disponibile. Copiamo il path negli appunti
										text += value + "\n";
									}
								}
								else
								{
									// Immagine fuori della ProdigytClient/assets. Copiamo il path negli appunti
									text += array[i] + "\n";
								}
							}
						}
					}
					
					try
					{
						var dirFile:File 	= PyDirectoryManager.resolveCompletePath("temp/","");
						var msg:String 		= "Le immagini usate nel project sono state copiate in:\n" + dirFile.nativePath +  
												((text.length>0)? "\n\nInoltre, i nomi delle immagini esterne, o non localizzate localmente,\nsono stati copiati negli appunti." : ""); 
						Clipboard.generalClipboard.clear();
						Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, text);
						alert				= new PYAlert(_client.clientShell.stage, msg, 'Avviso',['OK']);
						alert.boxStyle		= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						alert.buttonStyle	= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
					} catch (e:Error) {
						alert				= new PYAlert(_client.clientShell.stage,"Non è stato possibile copiare i nomi\ndelle immagini del project.", 'Avvertenza',['OK']);
						alert.boxStyle		= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						alert.buttonStyle	= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
					}
					
					break;
				}
					
				case "Abilitare tracking componenti" :
				{
					// se è già attivo il modify non permette tracking
					if (RagnoManager.getInstance().ragnoActive)
					{
						alert=new PYAlert(_client.clientShell.stage,"È già attiva la funzione di modifica pannello.", 'Avviso',['OK']);
						alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
						// BUG TUTTI 20160222 Tentativo di attivare dal pannello di controllo il tracking con modifiche pannello già attive
						//	lasciava il bottone attivo quando il tracking era spento
						menuButton.selected	= menuItem.checked; // Se viene cliccato dal pannello di controllo serve rimettere lo stile giusto 
						return;
					}

					if (!menuItem.checked)
					{
						// MAN - TUTTI - 011216 - tracking attivato anche per elementi del desktop.
						// non riesce pero ad individuare elementi del menu, o i contenitori es navigation, se grandi tanto quanto i bottoni
						// da implementare: schema del desktop!!! E modifiche manuali, ocorre però usare il merge fatto per i pannelli !!!!!
						// separare instanceManager da InstancePanelManager per pannelli 
						
						// si attiva solo se c'è un dspf attivo
//						if (_client.session.activeDSPF == null)
//						{
//							alert=new PYAlert(_client.clientShell.stage,'Nessun display File attivo.', 'Avviso',['OK']);
//							alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
//							alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
//							// Il select del PYArrowBox è già partito, selezionando il bottone quando non può. Lo deseleziono qua:
//							menuButton.selected = false;
//							return;
//						}
						
						// ragno manager update
						// MAN - TUTTI - 011216 - tracking attivato anche per elementi del desktop.
						//RagnoManager.getInstance().target 			= objectsVector["AREA"] as PYComponent;
						RagnoManager.getInstance().target 			= objectsVector["DESKTOP"] as PYComponent;
						RagnoManager.getInstance().panelComposer 	= this;
						RagnoManager.getInstance().panelMediator 	= panelMediator;
					}
					
					menuItem.checked						= !menuItem.checked;
					menuButton.selected						= menuItem.checked;
					_trackingFlag							= menuItem.checked;
					RagnoManager.getInstance().trackActive	= menuItem.checked;
					break;
				}
					
					//				case "Disable components tracking":
					//				{	
					//					break;
					//				}
					// menuItem dell'abilitazione delle modifiche al pannello
				case "Abilitare modifiche del pannello":
				{
					if (!menuItem.checked)
					{
						// si attiva solo se c'è un dspf attivo
						if (_client.session.activeDSPF == null)
						{
							alert				= new PYAlert(_client.clientShell.stage,'Nessun display File attivo.', 'Avviso',['OK']);
							alert.boxStyle		= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
							alert.buttonStyle	= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
							menuButton.selected	= false; // Se siamo arrivati qua da click nel Control Panel, bisogna deselezionarlo
							return
						}
						
						if (modifyTableFlag || modifyDesktopFlag)
						{
							alert				= new PYAlert(_client.clientShell.stage,'Modifica attiva: impossibile modificare pannello.', 'Avviso',['OK']);
							alert.boxStyle		= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
							alert.buttonStyle	= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
							menuButton.selected	= false; // Se siamo arrivati qua da click nel Control Panel, bisogna deselezionarlo
							return
						}
						
						modifyPanelFlag = true;
						
						if (instanceGrid) instanceGrid.enabled = true;
						
						// ragno manager update
						RagnoManager.getInstance().target = objectsVector["AREA"] as PYComponent;
						RagnoManager.getInstance().panelComposer = this;
						RagnoManager.getInstance().panelMediator = panelMediator;
						
						if (salvaManualsNelProject)
						{
							if (!modifyTableFlag) 
								RagnoManager.getInstance().ragnoActive = true;
							// creazione dizionario dall'xml della gui convertita
							// new - tutti - 101016 - gestione pannelli dal project !!!!
							//if (!isPanelManagement)
								//createXmlGuiDictionary();
						}
						else
						{
							ctrlSession.zipFlag = true
							ctrlSession.sendFromMenu("CALL WSE_MODUSP","CALL", false)
						}
						
						//  BLOCCO NAVIGAZIONE DELLA GUI !!
						panelMediator.lockGui(true, true);
						
						// se chiuse, apro le windows di instance e outline	
						if (!windowsDictionary["Schema"].active && !windowsDictionary["Schema"].visible )
						{
							// Facciamo scattare un evento select nel corrispondente nativeMenuItem
							menuItemsDictionary["Schema"].dispatchEvent(new Event(Event.SELECT));
						}
						if (!windowsDictionary["Istanza"].active  && !windowsDictionary["Istanza"].visible )
						{
							// Facciamo scattare un evento select nel corrispondente nativeMenuItem
							menuItemsDictionary["Istanza"].dispatchEvent(new Event(Event.SELECT));
						}
					} else {
						if (xmlGuiModified ||xmlGuiFastModified)
						{
							if (salvaManualsNelProject)
							{
								// MAD 2016-01-11: Spostato qua e commentato nel salvaSioNoNelProject
								// Veniva eseguito in qualsiasi caso, e se eseguito solo dopo dell'alert,
								//	copriva la finestra, per volte impedendo fare click nei bottoni.
								if (!modifyTableFlag) 
									RagnoManager.getInstance().ragnoActive = false; 
								if (_client.clientShell.hasOwnProperty("focusManager")) _client.clientShell.focusManager.deactivate();
								// Adesso che il ragno è disattivato, lanciare l'alert.
								alert=new PYAlert(_client.clientShell.stage,"Il Pannello è stato modificato: salvare nel Project?", "Conferma",["SI","NO"],salvaSioNoNelProject);
								alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
								alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
							}
							else
							{
								alert=new PYAlert(_client.clientShell.stage,"Il Pannello è stato modificato: salvare? per quale Project?", "Conferma",["Questo","Tutti","NO"],salvaSioNo);
								alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
								alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
							}
						}
						else
						{
							if (salvaManualsNelProject)
							{
								
							}
							else
							{
								lib = addBlank( panelMediator.getUSRSPCLib(), 10 );
								name = addBlank( panelMediator.getUSRSPCName(), 10 );
								params = "CLOSE     " + "MOD_PANEL "  + lib + name;
								ctrlSession.sendFreeData(params, "")
							}
							if (!modifyTableFlag) 
								RagnoManager.getInstance().ragnoActive = false;
							if (_client.clientShell.hasOwnProperty("focusManager") ) _client.clientShell.focusManager.deactivate();
							modifyPanelFlag = false
							
						}
						
						if (instanceGrid) instanceGrid.enabled = false;	
						
						// SBLOCCO NAVIGAZIONE DELLA GUI !!
						panelMediator.lockGui(false);
						
						RagnoManager.getInstance().trackActive = _trackingFlag;
					}
					menuItem.checked		= !menuItem.checked;
					menuButton.selected		= menuItem.checked;
					break;
				}
					
					//				case "Disable modify Panel":
					//				{
					//					break;
					//				}
					
				case "Abilitare modifiche di tabella" :
				{
					if (!menuItem.checked)
					{
						// si attiva solo se c'è un dspf attivo
						if (_client.session.activeDSPF == null)
						{
							alert=new PYAlert(_client.clientShell.stage,'Nessun display File attivo.', 'Avviso',['OK']);
							alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
							alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
							menuButton.selected	= false; // Se siamo arrivati qua da click nel Control Panel, bisogna deselezionarlo
							return
						}
						else if (modifyPanelFlag || modifyDesktopFlag)
						{
							alert=new PYAlert(_client.clientShell.stage,'Modifica attiva: impossibile modificare tabelle.', 'Avviso',['OK']);
							alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
							alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
							menuButton.selected	= false; // Se siamo arrivati qua da click nel Control Panel, bisogna deselezionarlo
							return
						}
						
						if (salvaManualsNelProject)
						{
							// creazione dizionario dall'xml della gui convertita
							//createXmlGuiDictionary();
						}
						else
						{
							ctrlSession.zipFlag = true
							ctrlSession.sendFromMenu("CALL WSE_MODUSP","CALL", false)
						}
						
						modifyTableFlag = true
						setTableListeners(objectsVector["AREA"] as PYComponent)
						
						panelMediator.lockGui(true, true);
						
						// se chiuse, apro le windows di instance e outline	
						if (!windowsDictionary["Schema"].active && !windowsDictionary["Schema"].visible )
						{
							// Facciamo scattare un evento select nel corrispondente nativeMenuItem
							menuItemsDictionary["Schema"].dispatchEvent(new Event(Event.SELECT));
						}
						if (!windowsDictionary["Istanza"].active  && !windowsDictionary["Istanza"].visible )
						{
							// Facciamo scattare un evento select nel corrispondente nativeMenuItem
							menuItemsDictionary["Istanza"].dispatchEvent(new Event(Event.SELECT));
						}
						//					menuItem.label 	= "Disable modify Tables";
						//					menuItem.name 	= menuItem.label;
						//					menuButton.name	= menuItem.label;
					} else {
						if (xmlGuiModified || xmlGuiFastModified)
						{
							if (salvaManualsNelProject)
							{
								alert=new PYAlert(_client.clientShell.stage,"Il Pannello è stato modificato: salvare nel Project?", "Conferma",["SI","NO"],salvaSioNoNelProject);
								alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
								alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
							}
							else
							{
								alert=new PYAlert(_client.clientShell.stage,"Il Pannello è stato modificato: salvare? per quale Project?", "Conferma",["Questo","Tutti","NO"],salvaSioNo);
								alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
								alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
							}
							
						}
						else
						{
							if (salvaManualsNelProject)
							{
								
							}
							else
							{
								lib = addBlank( panelMediator.getUSRSPCLib(), 10 )
								name = addBlank( panelMediator.getUSRSPCName(), 10 )
								params = "CLOSE     " + "MOD_PANEL "  + lib + name
								ctrlSession.sendFreeData(params, "")
							}
							if (_client.clientShell.hasOwnProperty("focusManager") ) _client.clientShell.focusManager.deactivate();
							
							modifyTableFlag = false
							
							
						}
						//if (instanceGrid) instanceGrid.enabled = false;	
						
						
						removeTableListeners(objectsVector["AREA"] as PYComponent)
						
						panelMediator.lockGui(false);
						RagnoManager.getInstance().trackActive = _trackingFlag;
						
						//						menuItem.label 	= "Abilitare modifiche di tabella";
						//						menuItem.name 	= menuItem.label;
						//						menuButton.name	= menuItem.label;
					}
					menuItem.checked		= !menuItem.checked;
					menuButton.selected		= menuItem.checked;
					break;	
				}
					
					//				case "Disable modify Tables":
					//				{
					//					break;
					//				}
					
					
				case "Abilitare modifiche del Desktop" :
				{
					if (!menuItem.checked)
					{
						alert=new PYAlert(_client.clientShell.stage,'Funzione non attiva.', 'Avviso',['OK']);
						alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
						menuButton.selected	= false; // Se siamo arrivati qua da click nel Control Panel, bisogna deselezionarlo
						return
						
						if (_client.session.activeDSPF != null)
						{
							alert=new PYAlert(_client.clientShell.stage,'Display File attivoç: modifiche Desktop non permesse.', 'Avviso',['OK']);
							alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
							alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
							menuButton.selected	= false; // Se siamo arrivati qua da click nel Control Panel, bisogna deselezionarlo
							return
						}
						
						if (modifyTableFlag || modifyPanelFlag)
						{
							alert=new PYAlert(_client.clientShell.stage,'Modifica attiva: impossibile modificare Desktop.', 'Avviso',['OK']);
							alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
							alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
							menuButton.selected	= false; // Se siamo arrivati qua da click nel Control Panel, bisogna deselezionarlo
							return
						}
						
						modifyDesktopFlag = true
						
						
						// ragno manager update
						RagnoManager.getInstance().target = objectsVector["DESKTOP"] as PYComponent;
						RagnoManager.getInstance().panelComposer = this;
						RagnoManager.getInstance().panelMediator = panelMediator;
						
						//  BLOCCO NAVIGAZIONE DELLA GUI !!
						panelMediator.lockGui(true, true);
						
						//					menuItem.label 	= "Disable modify Desktop";
						//					menuItem.name 	= menuItem.label;
						//					menuButton.name	= menuItem.label;
						
						// se chiuse, apro le windows di instance e outline	
						//					if (!windowsDictionary["Schema"].active  || !windowsDictionary["Schema"].visible )
						//					{
						//						if (!windowsDictionary["Schema"].active) windowsDictionary["Schema"].activate()	
						//						windowsDictionary["Schema"].visible=true
						//						homePoint.x +=50
						//						homePoint.y += 50		
						//					}
						//					if (!windowsDictionary["Istanza"].active  || !windowsDictionary["Istanza"].visible )
						//					{
						//						if (!windowsDictionary["Istanza"].active) windowsDictionary["Istanza"].activate()	
						//						windowsDictionary["Istanza"].visible=true
						//						homePoint.x +=50
						//						homePoint.y += 50	
						//						break;
						//					}
					} else {
						if (xmlGuiModified || xmlGuiFastModified)
						{
							alert=new PYAlert(_client.clientShell.stage,"Il Desktop è stato modificato: salvare? per quale Project?", "Conferma",["Questo","Tutti","NO"],salvaSioNo);
							alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
							alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
						}
						else
						{
							if (!modifyTableFlag) 
								RagnoManager.getInstance().ragnoActive = false;
							if (_client.clientShell.hasOwnProperty("focusManager") ) _client.clientShell.focusManager.deactivate();
							modifyDesktopFlag = false
						}
						
						// qui deve modificare il desktop 
//						InstanceManager.getInstance().mergeManuals(1) // forProject: 0=per progetto, 1= per tutti
//						DefaultsManager.getInstance().setGuiManuals( InstanceManager.getInstance().manualXML ,  panelMediator.getUSRSPCName() )
						
						if (instanceGrid) instanceGrid.enabled = false;	
						
						// SBLOCCO NAVIGAZIONE DELLA GUI !!
						panelMediator.lockGui(false)
						
						RagnoManager.getInstance().trackActive = _trackingFlag;
						
					}
					menuItem.checked		= !menuItem.checked;
					menuButton.selected		= menuItem.checked;
					break;
				}
					
					//				case "Disable modify Desktop":
					//				{
					//					break;
					//				}
					//					
					
				case "Save Panel":
				{
					// bug - v4.2 - 210117 - flag per far comparire finestra manuali anche su fat transform
					if (xmlGuiModified || xmlGuiFastModified)
					{
						alert=new PYAlert(_client.clientShell.stage,"Il Pannello è stato modificato: salvare? per quale Project?", "Conferma",["Questo","Tutti","NO"],salvaSioNo);
						alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
					}
					else
					{
						lib = addBlank( panelMediator.getUSRSPCLib(), 10 )
						name = addBlank( panelMediator.getUSRSPCName(), 10 )
						params = "CLOSE     " + "MOD_PANEL "  + lib + name
						ctrlSession.sendFreeData(params, "")
						
						if (!modifyTableFlag) 
							RagnoManager.getInstance().ragnoActive = false;
						if (_client.clientShell.hasOwnProperty("focusManager")) _client.clientShell.focusManager.deactivate();
					}
					break;
				}
				case "Modify":
				case "Defaults":
				case "Desktops":
				case "Debug":
				{
					setViews(menuItem.name);
					break;
				}
				case "Annulla":
				{
					undo();
					break;
				}
				case "Ripristina":
				{
					redo();
					break;
				}
			}			
		}
		// bug - tessport 300917 - il caricamento fuziona in debug e non nel release, dove crash!!!!!!!!!
		protected function importProjectSection(xmlInput:String, section:String):void
		{			
			XML.ignoreComments		= false;
			XML.ignoreWhitespace	= false;
			XML.prettyIndent		= 4;
			XML.prettyPrinting		= true;	
			
			var xmlRich:XML			= XML(xmlInput);
			//var xmlRich:XML			= XML(ba.readUTFBytes(ba.bytesAvailable));
			
			XML.ignoreComments		= true;
			XML.ignoreWhitespace	= true;
			XML.prettyPrinting		= false;
			
			//ba.position = 0
			var xml:XML			= XML(xmlInput);
			//var xml:XML				= XML(ba.readUTFBytes(ba.bytesAvailable));
						
			var error:String		= "";
			
			if (xml)
			{
				switch (section)
				{
					case "Importa Desktop":
						if (xml.localName()=="desktops")
						{
							DefaultsManager.getInstance().root.desktopsSection.desktops[0]		= xml.copy();
							DefaultsManager.getInstance().richRoot.desktopsSection.desktops[0]	= xmlRich.copy();
							DesktopsManager.getInstance().desktops 								= DefaultsManager.getInstance().desktopsSection;
							DesktopsManager.getInstance().desktopsRich 							= DefaultsManager.getInstance().desktopsSectionRich;
							// MAD 2016-06-11 Mancarebbe buttare giù l'attuale desktop e inizializzarlo di nuovo?
							// _client.startDesktop() <- reso pubblico?
						} else {
							error = "Il file XML selezionato non corrisponde con la sezione 'Desktops'";
						}
						break;
					case "Importa Fast Rules":
						if (xml.localName()=="fastRulesSection")
						{
							DefaultsManager.getInstance().root.fastRulesSection[0] 		= xml.copy();
							DefaultsManager.getInstance().richRoot.fastRulesSection[0]	= xmlRich.copy();
							RulesManager.getInstance().fastRules 						= DefaultsManager.getInstance().fastRulesSection;
							RulesManager.getInstance().fastRulesRich 					= DefaultsManager.getInstance().fastRulesSectionRich;
						} else {
							error = "Il file XML selezionato non corrisponde con la sezione 'Fast Rules'";
						}
						break;
					case "Importa Fonts":
						if (xml.localName()=="fontsSection")
						{
							DefaultsManager.getInstance().root.fontsSection[0] 		= xml.copy();
							DefaultsManager.getInstance().richRoot.fontsSection[0]	= xmlRich.copy();
							PYFontsManager.getInstance().fonts 						= DefaultsManager.getInstance().fontsSection;
							PYFontsManager.getInstance().fontsRich 					= DefaultsManager.getInstance().fontsSectionRich;
							PYFontsManager.getInstance().loadAvailableFontsList();
						} else {
							error = "Il file XML selezionato non corrisponde con la sezione 'Fonts'";							
						}
						break;
					case "Importa GUI":
						if (xml.localName()=="guiSection")
						{
							DefaultsManager.getInstance().root.guiSection[0] 		= xml.copy();
							DefaultsManager.getInstance().richRoot.guiSection[0]	= xmlRich.copy();
						} else {
							error = "Il file XML selezionato non corrisponde con la sezione 'GUI'";
						}
						break;
					case "Importa Keywords":
						if (xml.localName()=="keywordsSection")
						{
							DefaultsManager.getInstance().root.keywordsSection[0] 					= xml.copy();
							DefaultsManager.getInstance().richRoot.keywordsSection[0]				= xmlRich.copy();
						} else {
							error = "Il file XML selezionato non corrisponde con la sezione 'Keywords'";
						}
						break;
					case "Importa Pairings":
						if (xml.localName()=="pairingsSection")
						{
							DefaultsManager.getInstance().root.pairingsSection[0] 		= xml.copy();
							DefaultsManager.getInstance().richRoot.pairingsSection[0]	= xmlRich.copy();
							PairingsManager.getInstance().pairings 						= DefaultsManager.getInstance().pairingsSection; 	
							PairingsManager.getInstance().pairingsRich 					= DefaultsManager.getInstance().pairingsSectionRich;
						} else {
							error = "Il file XML selezionato non corrisponde con la sezione 'Pairings'";
						}
						break;
					case "Importa Rules":
						if (xml.localName()=="rulesSection")
						{
							DefaultsManager.getInstance().root.rulesSection[0] 		= xml.copy();
							DefaultsManager.getInstance().richRoot.rulesSection[0]	= xmlRich.copy();
							RulesManager.getInstance().rules 						= DefaultsManager.getInstance().rulesSection;
							RulesManager.getInstance().rulesRich 					= DefaultsManager.getInstance().rulesSectionRich;
						} else {
							error = "Il file XML selezionato non corrisponde con la sezione 'Rules'";
						}
						break;
					case "Importa Skin":
						if (xml.localName()=="skinProperties")
						{
							DefaultsManager.getInstance().root.projectSection.skinProperties[0] 	= xml.copy();
							DefaultsManager.getInstance().richRoot.projectSection.skinProperties[0]	= xmlRich.copy();
						} else {
							error = "Il file XML selezionato non corrisponde con la sezione 'Skin'";
						}
						break;
				}
				if (error!="")
				{
					alert				= new PYAlert(_client.clientShell.stage, error, 'Avvertenza', ['OK']);
					alert.boxStyle		= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
					alert.buttonStyle	= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
				} else {
					// Ricostruire i dictionaries
					DefaultsManager.getInstance().root = DefaultsManager.getInstance().root;
					initOtherManagers();
					projectModified = true;
					saveBackup();
				}
			} else {
				alert				= new PYAlert(_client.clientShell.stage,"XML non valido! Selezionare un altro file.", 'Avvertenza', ['OK']);
				alert.boxStyle		= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
				alert.buttonStyle	= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
			}

			redrawAll(objectsVector["DESKTOP"] as PYComponent);
			
			if (objectsVector["AREA"].suspended)
			{
				objectsVector["AREA"].suspended = false;
				objectsVector["AREA"].drawContainer(true);
				objectsVector["AREA"].suspended = true;
			}
		}
		
		private function redrawAll(obj:PYComponent):void
		{
//			obj.backgroundColor = obj.backgroundColor;
//			obj.toColor = obj.toColor;
//			obj.borderColor = obj.borderColor;
//			obj.foregroundColor = obj.foregroundColor;
//			obj.shadowColor = obj.shadowColor;
			
			
			obj.style = obj.style;
			// bug - svib - 310517 - mancava il draw del componente: il cambio skin non mostrava il nuovo skin: NON E' STATO PROVATO
			if (obj is IMeasurable)
				IMeasurable(obj).drawContainer()
			else
				obj.drawComponent()
					
			for each (var child:Object in obj.getChildren())
			{
				if (child is PYComponent) redrawAll(child as PYComponent);
			}
		}
			
			
			
		private function reorganizeWindows():void
		{
			// Per permettere debug
			var mainScreen:Screen = Screen.mainScreen;
			
			// Se l'utente apre l'applicazione ma sposta il foco su qualcos'altra non riesce a misurarla bene
			//	Qui riprova a ottenerne le dimensioni.
			if (isNaN(normalChromeWidth) || isNaN(normalChromeHeight)) measureNormalChrome();
			
			// 300 o 380 è la larghezza delle finestre ausiliari, a seconda dello spazio disponibile è più larga o meno
			var clientWidth:Number	= Screen.mainScreen.visibleBounds.width - ((Screen.mainScreen.visibleBounds.width<1920)? 300 : 380) * 2; 
			var clientHeight:Number = (_client.clientShell.calcHeight / _client.clientShell.calcWidth) * (clientWidth - normalChromeWidth) + normalChromeHeight;

			for each (var nw:NativeWindow in NativeApplication.nativeApplication.openedWindows)
			{
				switch(nw.title)
				{
					// TODO: Reposition windows
					case "Pannello di controllo":
						nw.width 	= Screen.mainScreen.visibleBounds.width; // Tutto il largo dello schermo
						nw.height 	= (4 + 12 + 24 + 4 + utilityChromeHeight); 	 // Per icone di 16x16 in bottoni da 24x24, 6px di margine
						nw.x		= 0;
						nw.y		= 0;
						adjustControlPanelInternals();
						break;
					case "Stile":
						nw.width 	= (Screen.mainScreen.visibleBounds.width<1920)? 300 : 380;
						nw.height	= Screen.mainScreen.visibleBounds.height - (4 + 12 + 24 + 4 + utilityChromeHeight);
						nw.x		= 0;
						nw.y		= (4 + 12 + 24 + 4 + utilityChromeHeight);
						break;
					case "Schema":
						nw.width 	= (Screen.mainScreen.visibleBounds.width<1920)? 300 : 380;
						nw.height	= (Screen.mainScreen.visibleBounds.height - (4 + 12 + 24 + 4 + utilityChromeHeight))*1/3;
						nw.x		= Screen.mainScreen.visibleBounds.width - nw.width;
						nw.y		= (4 + 12 + 24 + 4 + utilityChromeHeight);
						break;
					case "Istanza":
						nw.width 	= (Screen.mainScreen.visibleBounds.width<1920)? 300 : 380;
						nw.height	= (Screen.mainScreen.visibleBounds.height - (4 + 12 + 24 + 4 + utilityChromeHeight))*2/3;
						nw.x		= Screen.mainScreen.visibleBounds.width - nw.width;
						nw.y		= (4 + 12 + 24 + 4 + utilityChromeHeight) + (Screen.mainScreen.visibleBounds.height - (4 + 12 + 24 + 4 + utilityChromeHeight))*1/3;
						break;
					case "Regole di trasformazione":
						nw.width 	= Screen.mainScreen.visibleBounds.width - ((Screen.mainScreen.visibleBounds.width<1920)? 300 : 380) * 2;
						nw.height	= Screen.mainScreen.visibleBounds.height - (4 + 12 + 24 + 4 + utilityChromeHeight) - (clientHeight);
						nw.x		= (Screen.mainScreen.visibleBounds.width<1920)? 300 : 380;
						nw.y		= Screen.mainScreen.visibleBounds.height - nw.height;
						break;
					default:
						if (nw==this.originalWindow.stage.nativeWindow)
						{
							// È il Client. Aspettiamo a uscire dal ciclo
						} else {
							if (nw.title.indexOf("Modifica in corso (")==0 ||
								nw.title.indexOf("Copia in corso (")==0  ||
								nw.title.indexOf("Cancellazione in corso (")==0)
							{
								// TODO: Chiudere la finestra
								nw.x = nw.x;
							} else {
								nw.visible = false;
							}
						}
						break;
				}
			}
			// Last but not least: Il proprio Client davanti a tutti
//			(_client.clientShell).normalizeClient();
			this.originalWindow.stage.nativeWindow.orderToFront();
		}		
		
		protected function selectExport(event:Event):void
		{
			var nmi:NativeMenuItem	= event.target as NativeMenuItem;
			var nm:NativeMenu		= nmi.menu;
			var efr:FileReference 	= new FileReference();
			var prjName:String		= DefaultsManager.getInstance().cleanedProjectName;
			var xml:XML;
			
			switch (nmi.data.name)
			{
				case "Esporta Desktop":
					xml = DefaultsManager.getInstance().richRoot.desktopsSection.desktops[0];
					efr.save(xml,prjName + "_Desktop.xml");
					break;
				case "Esporta Fast Rules":
					xml = DefaultsManager.getInstance().richRoot.fastRulesSection[0];
					efr.save(xml,prjName + "_FastRules.xml");
					break;
				case "Esporta Fonts":
					xml = DefaultsManager.getInstance().richRoot.fontsSection[0];
					efr.save(xml,prjName + "_Fonts.xml");
					break;
				case "Esporta GUI":
					xml = DefaultsManager.getInstance().richRoot.guiSection[0];
					efr.save(xml,prjName + "_GUI.xml");
					break;
				case "Esporta Keywords":
					xml = DefaultsManager.getInstance().richRoot.keywordsSection[0];
					efr.save(xml,prjName + "_Keywords.xml");
					break;
				case "Esporta Pairings":
					xml = DefaultsManager.getInstance().richRoot.pairingsSection[0];
					efr.save(xml,prjName + "_Pairings.xml");
					break;
				case "Esporta Rules":
					xml = DefaultsManager.getInstance().richRoot.rulesSection[0];
					efr.save(xml,prjName + "_Rules.xml");
					break;
				case "Esporta Skin":
					xml = DefaultsManager.getInstance().richRoot.projectSection.skinProperties[0];
					efr.save(xml,prjName + "_Skin.xml");
					break;
			}
		}
		
		protected function selectGrid(event:Event):void
		{
			// Nascondere selezioni precedenti e mostrare selezione attuale
			var nm:NativeMenu	= (event.target as NativeMenuItem).menu;
			var nmi:NativeMenuItem;
			for (var i:int=0; i<nm.items.length; i++)
			{
				nmi 		= nm.items[i];
				nmi.checked = false;
			}
			nmi				= event.target as NativeMenuItem;
			nmi.checked		= true;
			// Aggiornare valori griglia nel ragno
			RagnoManager.getInstance().stepWidth 	= event.target.data.gridX;
			RagnoManager.getInstance().stepHeight 	= event.target.data.gridY;
		}	
		
		protected function selectImport(event:Event):void
		{
			var nmi:NativeMenuItem		= event.target as NativeMenuItem;
			// bug - tessport 300917 - il caricamento fuziona in debug e non nel release, dove crash!!!!
			var xmlLoader:URLLoader = new URLLoader();
			var xmlUrlRequest:URLRequest = new URLRequest();
			var file:File = PyDirectoryManager.resolveCompletePath("","");
			var onFileSelected:Function	= function(event:Event):void
			{
				xmlUrlRequest.url = file.nativePath;
				xmlLoader.addEventListener( Event.COMPLETE, xmlArrivedHandler );
				xmlLoader.load(xmlUrlRequest);
			}
			function xmlArrivedHandler(event:Event):void
			{
				importProjectSection(xmlLoader.data, nmi.data.name);
				projectModified = true;
			}
			file.addEventListener(Event.SELECT,onFileSelected);
			file.browseForOpen(nmi.data.name.substr(7) + " XML File");
			
			
			
			
			
			

			
			
			
			
			
			
			
//			var nmi:NativeMenuItem		= event.target as NativeMenuItem;
//			var filterName:String		= nmi.data.name.substr(7) + " XML File";
//			var onFileLoaded:Function 	= function(event:Event):void
//			{
//				importProjectSection(event.target.data as ByteArray, nmi.data.name);
//			}
//			var onFileSelected:Function	= function(event:Event):void
//			{
//				trace(ifr.name);
//				ifr.addEventListener(Event.COMPLETE, onFileLoaded);
//				ifr.load();						
//			}
//			var ifr:FileReference = new FileReference();
//			ifr.addEventListener(Event.SELECT, onFileSelected);
//			ifr.browse([new FileFilter(filterName, "*.xml")]);
		}
		
		protected function selectResolution(event:Event):void
		{
			var elements:Array	= event.target.data.ratio.split(":");
			var x:int 			= elements[0];
			var y:int 			= elements[1];
			var w:int			= event.target.data.width;
			var h:int			= event.target.data.height;
			setResolution(x/y, w, h);
		}	
		
		private function setResolution(newRatio:Number, w:int, h:int):void
		{
			var oldRatio:Number		= objectsVector["DESKTOP"].width/objectsVector["DESKTOP"].height;
			var screenRatio:Number	= Screen.mainScreen.bounds.width / Screen.mainScreen.bounds.height;
			
			if ( newRatio != oldRatio)
			{
				var nw:NativeWindow		= this._client.clientShell.stage.nativeWindow;
				var dtx:XML				= DefaultsManager.getInstance().desktopsSection.desktops.desktop.gui.child(0)[0];
				var dts:String			= dtx.localName();
				var sts:String			= (dtx.@style.toString()!="")? dtx.@style.toString() : "default";
				
				var newWidth:int;
				var newHeight:int;
				
				DefaultsManager.getInstance().setStyleDefault( dts, "width", w, sts );
				DefaultsManager.getInstance().setStyleDefault( dts, "height", h, sts );
				applyStyleToGui( dts, sts );

				// in caso di defaults aggiorno la gui e riaggiorno il projectdata corrente
				projectData = rebldProjectData();
				
				// BUG ALL Selezione risoluzione non viene impostata nel project.
				//	Aggiornare il project e alzare il flag per salvataggio.
				var dt:XML		= DefaultsManager.getInstance().desktopsSection.desktops.desktop[0];
				dt.@resolution 	= w + "x" + h;
				
				projectModified = true;
				saveBackup();

				originalWindow.resetDimensions(w,h);
				
				drawWholeArea();
				
//				objectsVector["DESKTOP"].drawContainer(true);
				
				
//				if (newRatio<1 && oldRatio<1) // Da portrait a portrait
//				{
//					newWidth	= int( objectsVector["DESKTOP"].height * newRatio );
//					newHeight	= int( objectsVector["DESKTOP"].height );
//				}
//				else if (newRatio>1 && oldRatio>1) // Da landscape a landscape
//				{
//					newWidth	= int( objectsVector["DESKTOP"].width );
//					newHeight	= int( objectsVector["DESKTOP"].width / newRatio );
//				}
//				else // Cambio da landscape a portrait o viceversa
//				{
//					newWidth	= int( objectsVector["DESKTOP"].height );
//					newHeight	= int( objectsVector["DESKTOP"].width );
//					
//					if ( newRatio != 1/oldRatio ) // Cambia anche di proporzione
//					{
//						if (newRatio>1) // Da 3:4 a 16:9  o  da 9:16 a 4:3
//						{
//							newHeight 	= newWidth / newRatio;
//						}
//						else if (newRatio<1) // Da 4:3 a 9:16  o  da 16:9 a 3:4
//						{
//							newWidth	= newHeight * newRatio;
//						}
//					}
//				}
//				
//				nw.width 	= newWidth + normalChromeWidth;
//				nw.height 	= newHeight + normalChromeHeight;
				
//				originalWindow.width 	= w; // newWidth;
//				originalWindow.height 	= h; //newHeight;
				
			}
		}
		
		/**
		 * 
		 * Apre gruppi di finestre omogeneew
		 * 
		 */
		private function setViews(viewName:String):void
		{
			var ar:Array = []
			if (viewName=="Modify") ar = ["Istanza", "Stile", "Schema"]
			if (viewName=="Defaults") ar = ["Pairing", "Stile"]
			if (viewName=="Debug") ar = ["Ultimo input verso AS400", "Ultimo output da AS400", "Struttura del DSPF"]
			
			homePoint.x = 50;
			homePoint.y = 50;
			
			for each (var w:PCWindowNew in windowsDictionary)
			{
				if (ar.indexOf( w.title ) >-1 ) 
				{
					if (!w.active) w.activate()	
					w.visible=true
					w.x = homePoint.x
					w.y =homePoint.y
					homePoint.x +=50
					homePoint.y += 50
				}
				else w.visible=false
			}
			
		}
		
		
		
		
		/**
		 * 
		 * Controlla se è possibile eseguire un determinato comando proveniente dai nativeMenu.
		 * 
		 */
		private function commandIsExecutable(command:String, controlPanelName:String=null):Boolean
		{
			var executability:Boolean = true;
			
			switch (command)
			{					
//				case "Apri project":
//					if (_client.isConnected() ) executability = false;				
//					break;
			}
			
			return executability;
		}
		
		
		
		//		/**
		//		 * 
		//		 * 
		//		 * 
		//		 */
		//		private function onPrjSelected(event:Event):void
		//		{
		//			var fr:File = event.target   as File
		//			fr.removeEventListener(Event.SELECT, onPrjSelected);
		//			_client.externalProjectLocation = "local"
		//		    _client.externalProjectName =  fr.nativePath;			
		//		}
		//		
		/**
		 * 
		 * 
		 * imposta il project da caricare da parte del client
		 * 
		 * 
		 */
		protected function setProjectToLoad(e:Event):void
		{
			if (e.type=="loadFromServer") _client.externalProjectLocation = "server"
			else if (e.type=="loadFromLocal") _client.externalProjectLocation = "local"
			
			_client.externalProjectName = prjLoader.prjName.text
		}
		
		
		protected function ProjectSaved(e:Event):void
		{
			windowsDictionary["prjLoader"].visible = false
			var prjName:String = (e.currentTarget.prjName.text.split("\\")).pop().split(".xml").join("");
			if (e.type == "savedOnLocal" || e.type == "savedOnAS400")
			{
				// Aggiornare l'indice del project salvato nell'elenco dei milestones della time machine
				//	(permette sapere che il project non è diverso di quello salvato se si torna in quella 
				//	posizione a base di successivi undo/redo).
				timeMachineLastSave = timeMachinePosition;
				
				projectModified = false;
				
				alert=new PYAlert(_client.clientShell.stage,"Project " + prjName + " salvato " + (e.type=="savedOnAS400"? "su AS400" : "in locale") + " con successo.", 'Info',['OK']);
				// MAD 2015-06-22
				// TODO: Una volta sistemato il DefaultsManager per aggiornare
				//	sia il completePath sia il projectName e cleanedProjectName
				//	bastarebbe chiamare updateControlPanel(); in vece che 
				//	tutta la carrelata qui sotto
				(((utilityControls as PYComponent).getChildByName("ProjectWrapper") as PYComponent).getChildByName("fieldIOProject") as FieldIO).text = prjName;
			}
			else 
			{
				alert=new PYAlert(_client.clientShell.stage,'Errore nel salvataggio del project.', 'Info',['OK']);
			}
			alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
			alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
		}
		
		protected function onProjectFileSelected(event:Event):void
		{
			var file:File = event.target as File;
			
			loadProjectFromBackup(file);

			// SE IN VECE VOGLIAMO FORZARE CHE IL NOME DEL FILE CORRISPONDA AL PROPRIO PROJECT, 
			//	COMMENTARE LA RIGA PRECEDENTE E SCOMMENTARE QUI SOTTO
//			// Ci assicuriamo che corrisponde col proprio project, altrimenti rovina tutto!
//			var inStr:String = "backup" + "\\" + DefaultsManager.getInstance().completePath.split("/").join("_");
//			if (file.nativePath.indexOf(inStr)>-1)
//			{
//				loadProjectFromBackup(file);
//			} else {
//				// Selezionato un file fuori la propria cartella!!!
//				alert = new PYAlert(_client.clientShell.stage,'Il file selezionato non corrisponde al presente project!', 'Avviso',['OK']);
//				alert.boxStyle = _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
//				alert.buttonStyle = _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
//			}

		}
				
		protected function onWindowCommand(event:Event):void
		{
			var menuButton:PYButton;
			var menuItem:NativeMenuItem;
			var nativeWindow:NativeWindow;
			
			if (event is MouseEvent)
			{
				menuButton 	= ((event.target is PYButton)? (event.target) : (event.target.parent)) as PYButton;
				menuItem	= menuItemsDictionary[menuButton.name];
			} else {
				menuItem	= (event.target as NativeMenuItem);
				menuButton	= utilityMenu.getChildByName(menuItem.label) as PYButton;
			}
			
			nativeWindow 	= windowsDictionary[menuItem.label]; // Adesso potrebbe usare anche menuItem.name
			
			menuItem.checked 	= !menuItem.checked;
			menuButton.selected	= menuItem.checked;
			
			switch(menuItem.label)
			{
				case "Modifica con EDITORE ESTERNO":
					menuItem.checked = false;
					menuButton.selected = false;
					modifyProjectXml();
				case "Attivare cache":
					ConnectionsPack.getInstance().useCache = menuItem.checked;
					break;
				case "Disattivare regole di trasformazione":
					RulesManager.getInstance().active = !menuItem.checked;
					break
				case "Disattivare modifiche manuali":
					panelMediator.manualsActive = !menuItem.checked;
					// man v4.2 - se disattivo modifiche manualli deve anche disattivare fasttransform	
					RulesManager.getInstance().fastActive = !menuItem.checked;
					break
				case "Disattivare modifiche utente":
					panelMediator.userManualsActive = !menuItem.checked;
					break
				case "Componenti":
				case "Pannello di controllo":
				case "Vista dettaglio del DSPF":
				case "Struttura del DSPF":
				case "Istanza":
				case "Keywords":
				case "Ultimo input verso AS400":
				case "Ultimo output da AS400":
				case "Log":
				case "Albero di modifiche manuali":
				case "Schema":
				case "Pairing":
				case "Stile":
				case "Panels":
				case "Regole di trasformazione":
				{
					if (!nativeWindow.active && menuItem.checked) nativeWindow.activate();
					nativeWindow.visible = menuItem.checked;
					break;
				}
				case "Albero del progetto":
				{
					if (!nativeWindow.active && menuItem.checked)
					{
						nativeWindow.activate();
						projectBox.rootXml = DefaultsManager.getInstance().root; 
					}
					nativeWindow.visible = menuItem.checked;
					break;
				}
				case "Components tree":
				{
					if (!nativeWindow.active && menuItem.checked)
					{
						nativeWindow.activate();
						projectBox.rootXml = TreeParser.getTree( ComponentsManager.getInstance().components ); 
					}
					nativeWindow.visible = menuItem.checked;
					break;
				}
			}
			
			if (menuItem.label == "Panels")
			{
				updatePanelsList();
			}
		}
		
		protected function redo():void
		{
			timeMachinePosition++;
			
			if (timeMachinePosition>=timeMachineMilestones.length)
			{
				timeMachinePosition = timeMachineMilestones.length-1;
				return;
			}
			
			redoMenuItem.enabled = (timeMachinePosition+1<timeMachineMilestones.length);
			undoMenuItem.enabled = true;
			loadProjectFromTimeMachine();
		}
		
		protected function undo():void
		{
			timeMachinePosition--;
			
			if (timeMachinePosition<0)
			{
				timeMachinePosition = 0;
				return;
			}
			
			undoMenuItem.enabled = (timeMachinePosition>0);
			redoMenuItem.enabled = true;
			loadProjectFromTimeMachine();
		}
		
		private function loadProjectFromBackup(file:File):void
		{
			// bug - tessport 300917 - il caricamento fuziona in debug e non nel release, dove crash!!!!!!!!!
			var xmlUrlRequest:URLRequest = new URLRequest();
				

			function xmlArrivedHandler(event:Event):void
			{

				loadProjectFromString(xmlLoader.data);
				projectModified = true;
			}
			xmlUrlRequest.url = file.nativePath;
			
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener( Event.COMPLETE, xmlArrivedHandler );
			xmlLoader.load(xmlUrlRequest);
			
//			var strXml:String = "";
//			var fs:FileStream = new FileStream();
//			try {
//				fs.open(file, FileMode.READ);
//				fs.position = 0
//				strXml 				= fs.readUTFBytes(fs.bytesAvailable)
//			} catch ( error:Error ) {
//				trace(error.message);
//				
//			}	
//			fs.close();

//			loadProjectFromString(strXml);
//			projectModified = true;
			//saveBackup();
		}
		
		private function loadProjectFromTimeMachine():void
		{
			var strXml:String = PyDirectoryManager.loadString("undo", timeMachineMilestones[timeMachinePosition]);
			loadProjectFromString(strXml);
			projectModified = (timeMachinePosition!=timeMachineLastSave);
		}
		
		private function loadProjectFromString(strXml:String):void
		{
			XML.ignoreComments = false
			XML.ignoreWhitespace = false
			XML.prettyPrinting = true
			XML.prettyIndent = 4
			// serve wrappare la stringa in XML per controllo ed eventuale catch
			DefaultsManager.getInstance().richRoot = XML(strXml);
			XML.ignoreComments = true
			XML.ignoreWhitespace = true
			XML.prettyPrinting = false	
			_projectData = XML(strXml);
			DefaultsManager.getInstance().root = XML(strXml);
			updateTransformRulesList();
			initOtherManagers();
			drawWholeArea();
			reloadStyleWindowDataGrid( componentTextInput.text, styleTextInput.text );
			// bug - tutti - 201117 - non ridisegnava il desktop quando veniva caricato uno skin
			redrawAll(objectsVector["DESKTOP"] as PYComponent);
		}
		
		/**
		 * Cancella tutti i file presenti nella cronologia e la reinizia.
		 * Viene eseguita all'inizio della sessione e/o ogni volta che si apre un file di project.
		 */
		private function resetChronos():void
		{
			// Spostare la cronologia undo/redo della sessione precedente nel cestino
			var file:File = PyDirectoryManager.resolveCompletePath("undo","");
			if (file.exists) file.moveToTrash();
			timeMachineMilestones = [];
			timeMachinePosition = -1;
			timeMachineLastSave = 0;
			// Salvare il backup del project in locale (richiede avere già la ControlSession) e iniziare la nuova cronologia
			saveBackup("PRE");
		}
		
		private function updatePanelsList():void
		{
			var window:PCWindowNew 		= windowsDictionary["Panels"];
			var pynbs:PYNBoxSelectable 	= (window.container.rawChildren.getChildAt(0) as PYComponent).getChildByName("sceltaPanels") as PYNBoxSelectable;
			var i:int;
			
			pynbs.removeAllChildren();
			
			var panels:Array = DefaultsManager.getInstance().getPanelsList();
			for (i=0; i<panels.length; i++)
			{
				var panel:Object 		= panels[i];
				var pyl:PYLabel 		= new PYLabel();
				pyl.autoSize			= false;
				pyl.text				= panel.className + " | " + panel.style + " | " + panel.name;
				pyl.percentWidth		= 100;
				pyl.height				= 20;
				pyl.mouseEnabled		= true;
				pyl.buttonMode			= true;
				pynbs.addChild(pyl);
			}
			var pyc:PYComponent = pynbs.parent as PYComponent;
			pyc.drawComponent(true);
			pynbs.drawContainer(true);
		}
		
		private function updateKeywordsGrid():void
		{
			keywordsGrid.dataProvider = new ArrayCollection( KeywordsManager.getInstance().getKeywords() );
		}	
		
		private function updateTransformRulesList():void
		{
			var window:PCWindowNew 		= windowsDictionary["Regole di trasformazione"];
			var pynbs:PYNBoxSelectable 	= (window.container.rawChildren.getChildAt(0) as PYComponent).getChildByName("sceltaTransformRule") as PYNBoxSelectable;
			var i:int;
			
			pynbs.removeAllChildren();
			
			var rules:Array = DefaultsManager.getInstance().getRulesList();
			for (i=0; i<rules.length; i++)
			{
				var rule:Object 		= rules[i];
				var pyl:PYLabel 		= new PYLabel();
				pyl.autoSize			= false;
				pyl.text				= DefaultsManager.getInstance().getRuleLabel(rules[i]);
				if (pyl.text.indexOf("<REGOLA NON VALIDA>")!=-1)
				{
					pyl.backgroundColor	= 0xE39989;
				}
				if (rule.desc!="") 
				{
					pyl.toolTip 		= rule.desc;
					pyl.toolTipTime		= 300;
					pyl.toolTipWidth	= 200;
				}
				pyl.percentWidth		= 100;
				pyl.height				= 20;
				pyl.mouseEnabled		= true;
				pyl.buttonMode			= true;
				pynbs.addChild(pyl);
			}
			var pyc:PYComponent = pynbs.parent as PYComponent;
			pyc.drawComponent(true);
			pynbs.drawContainer(true);
		}		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////    native windows  functions    //////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
		/**
		 * 
		 * Crea una generica PCWindow con tutti i parametri necessari.
		 * 
		 */
		private function createWindow(
			title:String=null,
			name:String=null,
			homePosition:Point=null,
			width:int=0,
			height:int=0,
			scale:Number=1,
			innerComponent:Canvas=null,
			nativeWindowType:String="utility"
		):void
		{
			var optns:NativeWindowInitOptions = new NativeWindowInitOptions()
			switch (nativeWindowType)
			{
				case NativeWindowType.LIGHTWEIGHT:
					optns.type = nativeWindowType;
					optns.systemChrome = NativeWindowSystemChrome.NONE;
					optns.transparent = true;
					break;
				case NativeWindowType.NORMAL:
					optns.type = nativeWindowType
					optns.transparent = false;
					break;
				default:
					optns.type = NativeWindowType.UTILITY;
					optns.transparent = false;
					break;
			}
			
			var pcWindow:PCWindowNew = new PCWindowNew(optns)
			
			if (innerComponent)
			{
				//pcWindow.add(innerComponent, true, false, false );
			}
			//pcWindow.name = name; 
			
			//areaLavoro.addElement( pcWindow );
			
			pcWindow.visible = false;
			pcWindow.width = width;
			pcWindow.height = height;
			pcWindow.title = title;		
			pcWindow.addEventListener(Event.CLOSING, closingWindow )
			pcWindow.addEventListener(Event.RESIZE, resizeWindow);
			windowsDictionary[name] = pcWindow;
			
			if ((isNaN(utilityChromeWidth) || isNaN(utilityChromeHeight)) && nativeWindowType==NativeWindowType.UTILITY)
			{
				utilityChromeWidth 	= pcWindow.width - pcWindow.stage.stageWidth;
				utilityChromeHeight = pcWindow.height - pcWindow.stage.stageHeight;
				
				(_client.clientShell).utilityChromeWidth = utilityChromeWidth;
				(_client.clientShell).utilityChromeHeight = utilityChromeHeight;
			}
		}
		
		protected function resizeWindow(event:NativeWindowBoundsEvent):void
		{
			var window:PCWindowNew;
			var pyc:PYComponent;
			var pynbs:PYNBoxSelectable;
			
			if(event.target.title=="Albero del progetto") 
			{
				projectBoxCont.percentWidth		= 100;
				projectBoxCont.percentHeight	= 100;
				projectBoxCont.drawImmediate();
				//
				projectBox.percentWidth			= 100;
				projectBox.percentHeight		= 100;
				projectBox.drawImmediate();
			} else if(event.target.title=="Albero di modifiche manuali") {
				manualsBoxCont.percentWidth=100;
				manualsBoxCont.percentHeight=100;
				manualsBoxCont.drawImmediate();
			} else if ( event.target.title=="Pannello di controllo") {
				adjustControlPanelInternals();
			} else if ( event.target.title=="Panels") {
				window 					= windowsDictionary[event.target.title];
				pyc					 	= window.container.rawChildren.getChildByName("pyc") as PYComponent;
				pynbs					= pyc.getChildByName("sceltaPanel") as PYNBoxSelectable;
				pyc.drawComponent(true);
				// BUG - TUTTI - COMPOSER: pynbs null - AM - 20161005 - Esplodeva per un componente null su cui si cercava di fare un drawComponent (l'elenco dei pannelli non era ancora pronto).
				if (pynbs!=null) pynbs.drawContainer(true);
			} else if ( event.target.title=="Regole di trasformazione") {
				window 					= windowsDictionary[event.target.title];
				pyc					 	= window.container.rawChildren.getChildByName("pyc") as PYComponent;
				pynbs					= pyc.getChildByName("sceltaTransformRule") as PYNBoxSelectable;
				pyc.drawComponent(true);
				pynbs.drawContainer(true);
			} else if ( event.target.title.indexOf("Modifica in corso (")==0 ||
						event.target.title.indexOf("Copia in corso (")==0  ||
						event.target.title.indexOf("Cancellazione in corso (")==0 ) {
				window 					= windowsDictionary[event.target.title];
                if (window!=null)
                {
    				pyc						= window.container.rawChildren.getChildByName("pyc") as PYComponent;
    				var fio:PYInputText		= pyc.getChildByName("fio") as PYInputText;
    				pyc.drawComponent();
    				fio.width 				= pyc.width - fio.marginLeft - fio.marginRight;
    				fio.x					= fio.marginLeft;
    				fio.height 				= pyc.height - 60 - fio.marginBottom;
    				fio.y					= 60;
    				fio.drawComponent();
                }
			} else if (event.target.title=="Help") {
				var uic:UIComponent		= (event.target.container as Canvas).getChildAt(0) as UIComponent;
				var htmll:HTMLLoader 	= uic.getChildAt(0) as HTMLLoader;
				htmll.width				= uic.width + event.afterBounds.width - event.beforeBounds.width; // - utilityChromeWidth;
				htmll.height			= uic.height + event.afterBounds.height - event.beforeBounds.height; // - utilityChromeHeight;
			} else if (event.target.title=="Stile") {
				styleGrid.width 		= styleCanvas.width - 6*2;
			}
		}
		
		private function adjustControlPanelInternals():void
		{
			controlPanelBox.width 			= windowsDictionary["Pannello di controllo"].width - utilityChromeWidth;
			controlPanelBox.height 			= windowsDictionary["Pannello di controllo"].height - utilityChromeHeight;
			
			utilityControls.width	= controlPanelBox.width - controlPanelBox.horizontalSpacing - controlPanelBox.paddingLeft - controlPanelBox.paddingRight - utilityMenuVBox.width;
			if (utilityControls.width > utilityControls.calcWidth)
			{
				utilityControls.horizontalScrollPosition 	= 0;
				utilityControls.horizontalScrolling 		= false;
			} else {
				utilityControls.horizontalScrolling 		= true;
			}
		}
		
		private function closingWindow(e:Event):void
		{
			// TODO: Verify closing of Transform Rule window
			e.preventDefault()	
			var pcWindow:PCWindowNew = e.target as PCWindowNew
			var name:String = pcWindow.title		
			var menuItem:NativeMenuItem = menuItemsDictionary[name] as NativeMenuItem;
			if (menuItem)
			{
				var menuButton:PYButton	= utilityMenu.getChildByName(menuItem.name) as PYButton;
				menuItem.dispatchEvent( new Event(Event.SELECT) )  // MAD 120215: NON SONO GLOBALI: "// eseguo funzioni di uncheck globali (vedi onWindowCommand)"
				if (menuButton) menuButton.selected = false;
				return;
			}
			// BUG - TESSPORT - 300917 - se chiudo la finesta salva project  con la x poi ri-salvando va in errore
			if (name != "prjLoader")
				pcWindow.close();
			else
				pcWindow.visible = false;
		}
		
		
		
		
		/**
		 * 
		 * 
		 * 
		 */
		private function createGrid(name:String, dp:ArrayCollection):PYDatagrid
		{
			
			var grid:PYDatagrid = new PYDatagrid();
			grid.dataProvider = dp;
			grid.addEventListener(MouseEvent.RIGHT_CLICK, gridRightClick);
			
			grid.editable = true;
			if (name == "Stile" )
			{
				grid.addEventListener(DataGridEvent.ITEM_EDIT_END, styleGrid_editEnd, false, 10);
				grid.addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING, styleGrid_editBeginning);
			}
			else if (name == "Istanza" )
			{
				grid.addEventListener(DataGridEvent.ITEM_EDIT_END, instanceGrid_editEnd, false, 10);
				grid.addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING, instanceGrid_editBeginning);
			}
			else if (name == "Pairing" )
			{
				grid.addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING, pairingGrid_editBeginning);
			}
			else if (name == "Keywords" )
			{
				grid.addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING, keywordsGrid_editBeginning);
				grid.addEventListener(DataGridEvent.ITEM_EDIT_END, keywordsGrid_editEnd, false, 10);
			}
			
			grid.name = name
			grid.editable = true;
			var columnOne:DataGridColumn = new DataGridColumn("attributo");
			
			columnOne.dataField = "property";
			columnOne.editable = false;
			
			var columnTwo:DataGridColumn = new DataGridColumn("valore");
			
			columnTwo.dataField = "value";
			columnTwo.itemRenderer = new ClassFactory( CustomItemRenderer );
			
			// la colonna degli stili
			var columnThree:DataGridColumn = new DataGridColumn('style');
			
			columnThree.dataField = "style";
			columnThree.editable = true;
			
			// la colonna degi componenti
			var columnFour:DataGridColumn = new DataGridColumn('component');
			
			columnFour.dataField = "component";
			columnFour.editable = false;
			
			// la colonna degi attributi
			var columnFive:DataGridColumn = new DataGridColumn('attributo');
			
			columnFive.dataField = "attributo";
			columnFive.editable = true;
			
			
			var columnSix:DataGridColumn = new DataGridColumn('attrValue');
			
			columnSix.dataField = "attrValue";
			columnSix.editable = true;
			
			
			
			if (grid.name=="Pairing")
			{
				columnOne.width = 130;
				columnOne.headerText = "elemento 5250";
				columnOne.editable = false;
				columnTwo.width = 130;
				columnTwo.headerText = "componente";
				columnThree.width = 140;
				columnThree.headerText = "stile";
				grid.columns = [columnOne, columnTwo, columnThree];
			}
			else if (grid.name == 'Keywords')
			{
				columnOne.width = 130;
				columnOne.dataField = "keyword";
				columnOne.headerText = "keyword";
				columnOne.editable = false;
				columnTwo.width = 130;
				columnTwo.headerText = "kwvalue";
				columnTwo.editable = false;
				
				columnFour.width = 130;
				columnFour.headerText = "component";
				columnFour.editable = false;
				
				columnFive.width = 190;
				columnFive.headerText = "attributo";
				columnFive.editable = true;
				
				columnSix.width = 130;
				columnSix.headerText = "attrValue";
				columnSix.editable = true;
				
				grid.columns = [columnOne, columnTwo, columnFour, columnFive, columnSix];
			}
			else if (grid.name == 'Components')
			{
				//				columnFour.width = 130;
				columnFour.headerText = "component";
				columnFour.editable = false;
				//				grid.setStyle("alternatingItemColors", [])
				//				grid.setStyle("horizontalGridLineColor",null)			
				grid.columns = [columnFour];
			}
			else if (grid.name == "Stile")
			{
				// nativeWindow 300 or 380 | scrollbar 20 | "padding" 12
				columnOne.minWidth = (((windowsDictionary["Pannello di controllo"].width<1920)? 300 : 380)-utilityChromeWidth-20-12)/2 + 20;
				columnTwo.minWidth = (((windowsDictionary["Pannello di controllo"].width<1920)? 300 : 380)-utilityChromeWidth-20-12)/2 - 20;
				grid.columns 	= [columnOne, columnTwo];
			}
			else if (grid.name == "Istanza")
			{
				// nativeWindow 300 or 380 | scrollbar 20 | "padding" 12
				columnOne.minWidth = (((windowsDictionary["Pannello di controllo"].width<1920)? 300 : 380)-utilityChromeWidth-20-12)/2 + 20;
				columnTwo.minWidth = (((windowsDictionary["Pannello di controllo"].width<1920)? 300 : 380)-utilityChromeWidth-20-12)/2 - 20;
				grid.columns 	= [columnOne, columnTwo];
			}
			else
			{
				columnOne.width = 80;
				columnTwo.width = 60;
				grid.columns = [columnOne, columnTwo];
			}
			// stili
			columnOne.setStyle("fontSize", 11)
			columnTwo.setStyle("fontSize", 11)
			columnThree.setStyle("fontSize", 11)
			grid.setStyle("paddingTop", 0)
			grid.setStyle("paddingBottom", 0)
			//			grid.setStyle("alternatingItemColors", [])
			//			grid.setStyle("horizontalGridLineColor",null)
			
			return grid;
		}
		
		
		private function gridRightClick(e:MouseEvent)
		{
			rClickGrid = e.currentTarget
			rClickItem = e.target
			//cellRowIndex = event.rowIndex;
			
			var undoMenu:NativeMenu = new NativeMenu()
			
			var menuUndo:NativeMenuItem = new NativeMenuItem("Window Help", false); 
			menuUndo.addEventListener(Event.SELECT, rClickCommand); 
			undoMenu.addItem(menuUndo)
			
			var menuUndo:NativeMenuItem = new NativeMenuItem("Component Help", false); 
			menuUndo.addEventListener(Event.SELECT, rClickCommand); 
			// MAD 20150617 Saltare item menu quando non ha niente in lista. Evita ERROR #1069
			if (rClickGrid.dataProvider.length > 0) undoMenu.addItem(menuUndo)
			
			var menuUndo:NativeMenuItem = new NativeMenuItem("Attribute Help", false); 
			menuUndo.addEventListener(Event.SELECT, rClickCommand); 
			// MAD 20150617 Saltare item menu quando non ha niente in lista. Evita ERROR #1069
			if (rClickGrid.dataProvider.length > 0) undoMenu.addItem(menuUndo)
			
			
			undoMenu.display(rClickGrid.stage, rClickGrid.stage.mouseX + 30, rClickGrid.stage.mouseY)
		}
		
		private function rClickCommand(event:Event):void
		{
			var op:String = NativeMenuItem(event.target).label;
			var attr:String;
			var comp:String;
			
			if (rClickGrid.name=="Stile" || rClickGrid.name=="Istanza")
			{
				// MAD 20150615 BUG CapGemini 2015-06-16 Composer Istanza Finestra Help appare fuori dello schermo
				// 	Calcolati i parametri qua, se è fuori viene centrato sullo schermo
				var ww:int = 500;
				var wh:int = 400;
				var wx:Number = rClickGrid.stage.nativeWindow.x + ((rClickGrid.name=="Stile")? rClickGrid.stage.nativeWindow.width : -ww);
				var wy:Number =	rClickGrid.stage.nativeWindow.y + rClickGrid.stage.mouseY;
				if (wx+ww > _client.clientShell.stage.fullScreenWidth) wx = (_client.clientShell.stage.fullScreenWidth - ww);
				if (wy+wh > _client.clientShell.stage.fullScreenHeight) wy = (_client.clientShell.stage.fullScreenHeight - wh);
				
				if (op == "Attribute Help" ) 
				{
					comp = componentTextInput.text;
					if (comp=="global") comp = "PYComponent"
					// MAD 2015-07-07  rClickItem.listData.rowIndex è l'indice della riga tra quelle visibili, 
					//	ci voleva aggiungere la posizione dello scroll per ottenere la riga giusta.
					attr = rClickItem.listData.owner.dataProvider[rClickItem.listData.owner.verticalScrollPosition + rClickItem.listData.rowIndex].property;
					rClickGrid.addEventListener(MouseEvent.CLICK, chiudiHelp)
					openHelpWindowHTML(	attr, wx, wy, ww, wh);
				}
				else if (op == "Component Help" ) 
				{
					comp = componentTextInput.text
					if (comp=="global") comp = "PYComponent" 
//						// MAD 2015-07-07  rClickItem.listData.rowIndex è l'indice della riga tra quelle visibili, 
//						//	ci voleva aggiungere la posizione dello scroll per ottenere la riga giusta.
//					attr = rClickItem.listData.owner.dataProvider[rClickItem.listData.owner.verticalScrollPosition + rClickItem.listData.rowIndex].property;	
					rClickGrid.addEventListener(MouseEvent.CLICK, chiudiHelp)
					openHelpWindowHTML(	comp, wx, wy, ww, wh );
				}
				else if (op == "Window Help") 
				{
					//					
					//					var comp = componentTextInput.text
					//					if (comp=="global") comp = "PYComponent" 
					//					var attr = rClickItem.text	
					rClickGrid.addEventListener(MouseEvent.CLICK, chiudiHelp)
					openHelpWindowHTML(	"Finestra " + rClickGrid.name, wx, wy, ww, wh, "05-Gli elementi di Touch400 - il Composer.htm");
				}
			}
			
		}
		
		private function chiudiHelp(event:MouseEvent):void
		{
			// BUG - TUTTI - 2017-01-20 Mancava togliere il listener
			rClickGrid.removeEventListener(MouseEvent.CLICK, chiudiHelp);
			//helpWindow.visible = false
			helpWindowHTML.visible = false;
		}
		
		
		//////////////////   tasto estro su ragno
		
		
		
		
		
		
		/**
		 * 
		 * Crea una generica PCWindow con tutti i parametri necessari.
		 * 
		 */
		
		var helpWindow:PCWindowNew
		var helpText:mx.controls.Text
		
		private function openHelpWindow(text:String,
										xx:int, 
										yy:int,
										width:int=0,
										height:int=0
		):void
		{
			if (!helpWindow)
			{
				var optns:NativeWindowInitOptions = new NativeWindowInitOptions()
				optns.type = NativeWindowType.LIGHTWEIGHT
				optns.systemChrome = "none"
				helpWindow= new PCWindowNew(optns)
				helpWindow.visible = false;
				helpWindow.width = width;
				helpWindow.height = height;
				helpWindow.activate()
				
				var styleCanvas = new Canvas()
				styleCanvas.setStyle("backgroundColor", 0xffffdd )
				styleCanvas.height = height;
				styleCanvas.percentWidth =100
				styleCanvas.horizontalScrollPolicy="off";
				styleCanvas.verticalScrollPolicy="on";
				
				helpText = new  mx.controls.Text()
				helpText.height = height;
				helpText.width = width-16
				helpText.setStyle("backgroundColor", 0xffffdd )
				helpText.setStyle("backgroundAlpha", 1 )
				helpWindow.addContent( styleCanvas );	
				styleCanvas.addChild( helpText );	
			}
			
			if (text)
			{
				helpText.htmlText = text	
				helpText.validateNow()
				helpText.height=helpText.textHeight + 20;
			}
			
			helpWindow.width = width;
			
			if(helpText.height<200) helpWindow.height=helpText.textHeight+20;
			else helpWindow.height=200;
			
			helpWindow.x = xx;
			helpWindow.y = yy;
			helpWindow.visible = true
		}
		
		
		
		/**
		 * 
		 * Crea una generica PCWindow con tutti i parametri necessari.
		 * 
		 */
		
		private var helpWindowHTML:PCWindowNew
		private var htmlText:HTMLLoader
		
		private function openHelpWindowHTML(text:String,
											xx:int, 
											yy:int,
											width:int=0,
											height:int=0,
											helpFile:String="04-Gli elementi di Touch400 - i Componenti visuali.htm"
		):void
		{
			if (!helpWindowHTML)
			{
				var optns:NativeWindowInitOptions = new NativeWindowInitOptions()
				optns.type = NativeWindowType.UTILITY
				helpWindowHTML= new PCWindowNew(optns)
				helpWindowHTML.visible = false;
				helpWindowHTML.width = width;
				helpWindowHTML.height = height;
				helpWindowHTML.title ="Help"
				helpWindowHTML.activate()
				helpWindowHTML.addEventListener( Event.CLOSING, closingHelp );
				helpWindowHTML.addEventListener( Event.RESIZE, resizeWindow );
				var styleCanvas:UIComponent = new UIComponent();
				htmlText = new HTMLLoader()
				htmlText.addEventListener(Event.COMPLETE, caricata2)
				helpWindowHTML.addContent( styleCanvas );	
				styleCanvas.addChild( htmlText );	
				styleCanvas.percentHeight = 100;
				styleCanvas.percentWidth = 100;
			}
			
			if (text)
			{
				// NEW - TUTTI - 20170302 - Composer: Help online - Nuovo parametro aggiuntivo di configurazione 
				//	(editabile solo con editore esterno). Serve a specificare da dove prendere i file di documentazione.
				var helpLocation:String = ConnectionsPack.getInstance(_client.clientShell.stage).helpLocation;
				if (helpLocation=="")
				{
					var folder:File = PyDirectoryManager.resolveCompletePath("bin/docs","",true);
					if (!folder.exists)
					{
						var setupDocs:File = File.applicationDirectory.resolvePath("docs");
						if (setupDocs.exists) setupDocs.copyTo(folder);
					}
					helpLocation = folder.url;
				}
				var _url:String = helpLocation + ((helpLocation.substr(-1)=="/")? "" : "/") + helpFile + ((text!="Regole di trasformazione")? "#"+text : ""); 
				htmlText.load( new URLRequest(_url) )	
				htmlText.height = height;
				htmlText.width = width
			}
			if (!helpWindowHTML.active) helpWindowHTML.activate()	
			helpWindowHTML.visible=true
			helpWindowHTML.width = width;
			helpWindowHTML.x = xx;
			helpWindowHTML.y = yy;
			helpWindowHTML.visible = true;
			
		}
		
		
		protected function caricata2(e:Event):void
		{
			var a=a
			var anchor  : Object  = htmlText.window.document.getElementsByTagName("a");
			htmlText.width = htmlText.parent.width; // - utilityChromeWidth;
		}
		
		private function closingHelp(e:Event):void
		{
			e.preventDefault()	
			var pcWindow:PCWindowNew = e.target as PCWindowNew
			pcWindow.visible = false
		}
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////    client I/O  functions    //////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		/**
		 * 
		 * Rispone agli eventi della sessione client per sincronizzare le altre finestre.
		 * 
		 */ 
		protected function clientSessionReady(e:SessionEvent):void
		{
			var area:PYComponent = objectsVector["AREA"] as PYComponent;
			var baseSession:SessionManager = _client.session	
			
			if (baseSession.activeDSPF)
			{
				//					ControlPanelItem(controlPanel.getChildByName("running")).cName = baseSession.activeDSPF.name
				//					ControlPanelItem(controlPanel.getChildByName("running")).active = true
				
			}
			else
			{
				//					ControlPanelItem(controlPanel.getChildByName("running")).cName = ""
				//					ControlPanelItem(controlPanel.getChildByName("running")).active = false
				
			}
			
			if (e.type == SessionEvent.READY && e.fKey=="CALL")
			{
				
			}
			
			if (e.type == SessionEvent.READY )
			{
				
				if (!baseSession.activeDSPF ) return;
				
				
				// finestra output
				XML.ignoreComments = false
				XML.ignoreWhitespace = false
				XML.prettyPrinting = true
				XML.prettyIndent = 3
				
				if (outArea)
				{
					outArea.text = "";
					for (var i:int=0;i<baseSession.debugOutput.length;i++)
					{
						var xxx:XML = baseSession.debugOutput[i].copy()
						outArea.text += xxx.toXMLString() + "\n";
					}
				}
				
				
				// finestra input
				if (inpArea && baseSession.debugInput) 
				{
					var xxx:XML = baseSession.debugInput.copy()
					inpArea.text = xxx.toXMLString() + "\n";
				}
				
				XML.ignoreComments = true
				XML.ignoreWhitespace = true
				XML.prettyPrinting = false	
				
				// finestra tree dspf
				// Commentato causa refactor HaXe
//				if (dspfTree) dspfTree.dataProvider = setDspfWindow(baseSession);
				
				// finestra (fondo) debug
				if (logArea) logArea.verticalScrollPosition =  logArea.maxVerticalScrollPosition
				// keyword analyzer
				if (!kwa) kwa = new KeywordsAnalyzer();
				//structureArea.text = String(kwa.analyze(baseSession.activeDSPF))
				
				// informazioni del pannello di controllo
				updateControlPanel()
				
				// ragno manager update
				//				RagnoManager.getInstance().setScale(originalWindow.scaleX)
				//				RagnoManager.getInstance().target = objectsVector["AREA"] as PYComponent;
				//				RagnoManager.getInstance().panelComposer = this;
				//				RagnoManager.getInstance().panelMediator = panelMediator;
				//				RagnoManager.getInstance().active = true;  
				
				// prendo l'xml del pannello (in sostanza gli xml  di instance) e creo un dizionario di comodo
				createXmlGuiDictionary()
				
				if (outlineTree)
				{
					// tolgo i vari CDATA (testi delle costanti) prima di passare il dataprovider al tree
					//var xmlOutlineTree:XML = panelMediator.getFormatsGuiXml().*.(localName()!='links')[0].copy();
					var ixml:XML = InstanceManager.getInstance().guiXml
					var mxml:XML = DefaultsManager.getInstance().getGuiManuals(baseSession.activeDSPF.name);
					
					if (ixml) 
					{
						var xmlOutlineTree:XML = ixml.copy()
						// aggiunta dei figli ricorsivamente
						for each (var child:XML in xmlOutlineTree.children())
						{
							
							if (child.localName() == "links")
							{
								// delete (subChild.parent().children()[subChild.childIndex()].children()[0]);
								delete (child.parent().children()[child.childIndex()]);
							}
							else
							{
								removeConstantHeaders( child );
							}
						}
					}
					else  xmlOutlineTree = null
					
					// bug - svib - 310517 - nel caso di PUMENU e EDPDesktop, l'xml outline tree è null, e andava in crash
					if ( mxml && xmlOutlineTree!=null) checkForManualsAttribute(xmlOutlineTree,mxml);
					
					// outlineTree.dataProvider = panelMediator.getFormatsGuiXml().*.(localName()!='links');
					
					try
					{
						outlineTree.dataProvider = xmlOutlineTree;
						outlineTree.validateNow();
						for each(var item:XML in outlineTree.dataProvider)
						{
							outlineTree.expandChildrenOf(item,true);
						}
					}
					catch (e:Error)
					{
						
					}
					
				}
				
				//  se c'è attivo il tracking
				if (RagnoManager.getInstance().trackActive)
					RagnoManager.getInstance().clearTracking()
				
				
				// Francesco 1: espansione completa del tree degli active formats
				//					tree.validateNow();
				//					for each (var item:XML in tree.dataProvider)
				//					{
				//						if (item.localName() != 'ps' && item.localName() != 'ks')
				//							// tree.expandChildrenOf(item, true);
				//							tree.expandItem(item, true);
				//						
				//						for each (var child:XML in item.children())
				//						{
				//							openSubChild(child);
				//						}
				//					}
				//					
				
				
			}
			// NEW - TUTTI - 201117 - SCHEMA DEL DESKTOP
			if (e.type == SessionEvent.SYSTEM_READY )
			{
				if (_trackingFlag) RagnoManager.getInstance().clearTracking();
				modifyItemsSelected = [];
				updateControlPanel();
				outlineTree.dataProvider = null;
				outlineTree.validateNow();
				populateDesktopSchema()
					var ixml:XML = XML(DesktopsManager.getInstance().getDesktop( DefaultsManager.getInstance().desktopName )  )
					var mxml:XML = null
					
					if (ixml) 
					{
						var xmlOutlineTree:XML = ixml.copy()
						// aggiunta dei figli ricorsivamente
						for each (var child:XML in xmlOutlineTree.children())
						{
							
							if (child.localName() == "links")
							{
								// delete (subChild.parent().children()[subChild.childIndex()].children()[0]);
								delete (child.parent().children()[child.childIndex()]);
							}
							else
							{
								removeConstantHeaders( child );
							}
						}
					}
					else  xmlOutlineTree = null
					
					// bug - svib - 310517 - nel caso di PUMENU e EDPDesktop, l'xml outline tree è null, e andava in crash
					if ( mxml && xmlOutlineTree!=null) checkForManualsAttribute(xmlOutlineTree,mxml);
					
					// outlineTree.dataProvider = panelMediator.getFormatsGuiXml().*.(localName()!='links');
					
					try
					{
						outlineTree.dataProvider = xmlOutlineTree;
						outlineTree.validateNow();
						for each(var item:XML in outlineTree.dataProvider)
						{
							outlineTree.expandChildrenOf(item,true);
						}
					}
					catch (e:Error)
					{
						
					}

			}
			
			if (e.type == SessionEvent.DSPF_OPEN )
			{
				
			}
		}
		
		protected function populateDesktopSchema():void
		{
			var ixml:XML = XML(DesktopsManager.getInstance().getDesktop( DefaultsManager.getInstance().desktopName )  )
			var mxml:XML = null
			
			if (ixml) 
			{
				var xmlOutlineTree:XML = ixml.copy()
				// aggiunta dei figli ricorsivamente
				for each (var child:XML in xmlOutlineTree.children())
				{

					removeConstantHeaders( child );
				}
			}
			else  xmlOutlineTree = null
			
			// bug - svib - 310517 - nel caso di PUMENU e EDPDesktop, l'xml outline tree è null, e andava in crash
			if ( mxml && xmlOutlineTree!=null) checkForManualsAttribute(xmlOutlineTree,mxml);

			try
			{
				outlineTree.dataProvider = xmlOutlineTree;
				outlineTree.validateNow();
				for each(var item:XML in outlineTree.dataProvider)
				{
					outlineTree.expandChildrenOf(item,true);
				}
			}
			catch (e:Error)
			{
				
			}
		}
		
		/**
		 * Aggiunge l'attributo manuals true se presente nella sezione aposita del Project.xml
		 *  
		 * @param nxml	l'xml della instance o un suo subnodo
		 * @param mxml	l'xml della sezione manuals (guis) del Project.xml
		 * 
		 */		
		private function checkForManualsAttribute(nxml:XML, mxml:XML):void
		{
			var child:XML;
			for each (child in nxml.children())
			{
				if (mxml.descendants(child.@name.toString()).length()>0)
				{
					child.@manuals = "true";
				}
				checkForManualsAttribute(child, mxml);
			}
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		private function removeConstantHeaders( child:XML ):void
		{	
			for each (var subChild:XML in child.children())
			{
				if (subChild.localName() == null)
				{
					// delete (subChild.parent().children()[subChild.childIndex()].children()[0]);
					delete (subChild.parent().children()[subChild.childIndex()]);
				}
				else
				{
					removeConstantHeaders( subChild );
				}
			}
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		private function openSubChild(child:XML):void
		{
			if (child.localName() != 'ps' && child.localName() != 'ks')
				dspfTree.expandItem(child, true);
			
			for each (var subChild:XML in child.children())
			{
				openSubChild(subChild);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////    project load/save/manage  functions    //////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		private function setControlPanelBox():PYComponent
		{
			if (controlPanelBox.parent==null)
			{
				utilityControls 						= new PYNbox();
				utilityControls.layout					= PYContainer.HORIZONTAL;
				utilityControls.alignOnScroll			= false;
				utilityControls.clip					= true;
//				utilityControls.forceAlign				= true;
				utilityControls.height					= 44;
				utilityControls.horizontalScrollBar		= PYContainer.ARROW;
				utilityControls.horizontalScrolling		= true;
				utilityControls.horizontalSpacing		= 4;
				utilityControls.name					= "utilityControls";
				utilityControls.paddingBottom			= 0;
				utilityControls.paddingLeft				= 24;
				utilityControls.paddingRight			= 24;
				utilityControls.paddingTop				= 3;
				utilityControls.scrollBarDimension 		= 24;
				utilityControls.scrollBarStyle			= "ComposerStyle:ScrollContenitoriPannelloDiControllo";
				utilityControls.verticalScrolling		= false;
				utilityControls.y						= 0;
				
				utilityMenuVBox							= new PYNbox();
				utilityMenuVBox.name					= "utilityMenuVBox";
				utilityMenuVBox.layout					= PYContainer.VERTICAL;
				utilityMenuVBox.verticalSpacing			= 0;
				utilityMenuVBox.horizontalScrolling		= false;
				utilityMenuVBox.verticalScrolling		= false;
				utilityMenuVBox.autoSize				= true;
				utilityMenuVBox.paddingBottom			= 0;
				utilityMenuVBox.paddingTop				= 0;
				
				var utilityMenuTitles:Constant			= new Constant();
				utilityMenuTitles.text					= "--------------------------------------------------------------- Project --------------------------------------------------------------     ------------------------------ Panel ----------------------------     ------------- Debug -------------";
				utilityMenuTitles.autoSize				= true;
				utilityMenuTitles.height				= 12;
				utilityMenuTitles.fontFamily			= "Arial";
				utilityMenuTitles.fontSize				= 11;
				utilityMenuTitles.fontWeight			= "normal"
				utilityMenuTitles.foregroundColor		= 0x444444;
				utilityMenuTitles.foregroundAlpha		= 1;
				utilityMenuTitles.align					= "left";
				utilityMenuTitles.marginRight			= 2;
				utilityMenuTitles.marginTop				= 0;

												
				controlPanelBox.autoSize	= false;
				controlPanelBox.layout		= PYContainer.HORIZONTAL;
				controlPanelBox.width 		= windowsDictionary["Pannello di controllo"].width - utilityChromeWidth;
				controlPanelBox.height 		= windowsDictionary["Pannello di controllo"].height - utilityChromeHeight;
				controlPanelBox.style		= "ComposerStyle:RiquadroDelPannelloDiControllo";
				
				var arConst:Array = new Array();
				arConst.push("User");
				arConst.push("Project");
				arConst.push("Display File");	
				arConst.push("AS400 Call");
				arConst.push("Field Name");	
				arConst.push("Component");
				arConst.push("Style");
				arConst.push("Transformation Rule");
				
				for (var i:int=0; i<arConst.length; i++)
				{
					var utilityControlsItem:PYComponent = new PYComponent();
					utilityControlsItem.name			= arConst[i].split(" ").join("_") + "Wrapper";
					utilityControlsItem.height			= 36;
					
					//
					var userLabel:Constant 	= new Constant();
					userLabel.name			= "constant" + arConst[i].split(" ").join("_");
					userLabel.autoSize		= true;
					userLabel.text			= arConst[i];
					userLabel.style			= "ComposerStyle:CostanteDelPannelloDiControllo"; // OLD:constantControlPanel
					userLabel.y				= -2;
					//
					var userField:FieldIO 	= new FieldIO();
					switch(arConst[i])
					{
						case "AS400 Call":
						case "Display File":
						case "Field Name":
						case "Transformation Rule":
							// "Display File" -> "Display_File", "Field Name" -> "Field_Name", etc
							userField.name	= "fieldIO" + arConst[i].split(" ").join("_"); 
							break;
						default:
							userField.name	= "fieldIO" + arConst[i];
							break;
					}
					switch(arConst[i])
					{
						case "Display File":
						case "Project":
						case "User":
							userField.width	= utilityControlsItem.width	= 98;
							break;
						case "Field Name":
							userField.width	= utilityControlsItem.width = 140;
							break;
						default:
							userField.width	= utilityControlsItem.width	= 154;
							break;
					}
					userField.style			= "ComposerStyle:CampoDiInputDelPannelloDiControllo"; // OLD:fieldIOControlPanel
					userField.y				= 16;
					
					utilityControlsItem.addChild(userLabel);
					utilityControlsItem.addChild(userField);
					
					utilityControls.addChild(utilityControlsItem);
				}
				
				utilityControls.drawContainer();
				
				utilityMenuVBox.addChildAt(utilityMenuTitles,0);	
				utilityMenuVBox.addChildAt(utilityMenu,1);
				utilityMenu.drawContainer();
				utilityMenuTitles.drawComponent();
				controlPanelBox.addChildAt(utilityMenuVBox,0);
				utilityMenuVBox.drawContainer();
				controlPanelBox.addChildAt(utilityControls,1);
				utilityControls.drawContainer();
				
			}
			
//			// Proviamo a farci stare entrambi
//			utilityMenu.drawContainer();
//			utilityMenuBox.drawContainer();
//			utilityControls.drawContainer();
			
//			if (((utilityMenuBox.calcWidth  + utilityControls.calcWidth) < controlPanelBox.width) || 
//				(utilityMenuBox.calcWidth < controlPanelBox.width - 300))
//			{
//				utilityMenu.horizontalScrolling		= false;
//				utilityMenu.paddingLeft				= 0;
//				utilityMenu.paddingRight			= 0;
//				utilityMenu.width 					= utilityMenu.calcWidth;
//				utilityMenu.scrollBarAlwaysShown	= false;
//				utilityMenuBox.width 				= utilityMenuBox.calcWidth;
//				utilityControls.width 				= controlPanelBox.width - controlPanelBox.horizontalSpacing - controlPanelBox.paddingLeft - controlPanelBox.paddingRight - utilityMenuBox.width;
//				if (utilityControls.width > utilityControls.calcWidth)
//				{
//					utilityControls.horizontalScrolling = false;
//				}
//			} else {
//				utilityMenu.scrollBarAlwaysShown	= true;
//				utilityMenu.horizontalScrolling		= true;
//				utilityMenu.width 					= controlPanelBox.width / 2;
//				utilityMenuBox.width 				= controlPanelBox.width / 2;
//				utilityControls.width 				= controlPanelBox.width / 2;
//			}
//			
//			utilityMenu.drawContainer();
//			utilityControls.drawContainer();
//			controlPanelBox.drawContainer();
			
			
			return controlPanelBox;
		}
		
		private function setProjectBox():void
		{
			
			if (projectBox.parent==null)
			{
				uico = new UIComponent()
				uico.width =  800
				uico.height = 800
				
				projectBoxCont.width = 800
				projectBoxCont.height = 800
				//projectBoxCont.backgroundColor = PCDefaultColors.AREALAVORO 
				projectBoxCont.backgroundColor = 0xffffff;
				projectBoxCont.backgroundAlpha = 1 
				//				projectBox.percentHeight =  100
				//				projectBox.percentWidth = 100	
				projectBox.percentWidth = 100;
				projectBox.percentHeight = 100;
				projectBox.foregroundColor = 0x000000
				projectBox.backgroundColor = 0xee0000   //PCDefaultColors.AREALAVORO
				projectBox.backgroundAlpha = 0.0;	
				
				projectBox.attrStyle			= "ComposerStyle:ProjectBoxattrStyle";
				projectBox.attrLabelStyle		= "ComposerStyle:attrLabelStyle";
				projectBox.attrInputTextStyle	= "ComposerStyle:attrInputTextStyle";
				
				projectBox.popAreaStyle			= "ComposerStyle:ProjectBoxPopStyle";
				projectBox.popAreaItemStyle		= "ComposerStyle:ProjectBoxItemStyle";
				projectBox.popAreaOverStyle		= "ComposerStyle:ProjectBoxOverStyle";
				projectBox.popAreaSelectedStyle	= "ComposerStyle:ProjectBoxSelectedStyle";
				
				projectBoxCont.addChild(projectBox);
				
			}
			
		}
		
		private function setManualsBox():void
		{
			
			if (manualsBox.parent==null)
			{
				Manualsuico = new UIComponent()
				Manualsuico.width =  800
				Manualsuico.height = 800
				
				manualsBoxCont.width = 800
				manualsBoxCont.height = 800
				//manualsBoxCont.backgroundColor = PCDefaultColors.AREALAVORO 
				manualsBoxCont.backgroundColor = 0xffffff;
				manualsBoxCont.backgroundAlpha = 1 
				//				manualsBox.percentHeight =  100
				//				manualsBox.percentWidth = 100	
				manualsBox.percentWidth = 100
				manualsBox.percentHeight = 100
				manualsBox.foregroundColor = 0xeeeeee
				manualsBox.backgroundColor = PCDefaultColors.AREALAVORO
				manualsBox.backgroundAlpha = 0.0	
				manualsBoxCont.addChild(manualsBox)  
				
				manualsBox.attrStyle			= "ComposerStyle:ProjectBoxattrStyle";
				manualsBox.attrLabelStyle		= "ComposerStyle:attrLabelStyle";
				manualsBox.attrInputTextStyle	= "ComposerStyle:attrInputTextStyle";
				
				manualsBox.popAreaStyle			= "ComposerStyle:ProjectBoxPopStyle";
				manualsBox.popAreaItemStyle		= "ComposerStyle:ProjectBoxItemStyle";
				manualsBox.popAreaOverStyle		= "ComposerStyle:ProjectBoxOverStyle";
				manualsBox.popAreaSelectedStyle	= "ComposerStyle:ProjectBoxSelectedStyle";
			}
			
		}
		
		
		var alertBlocco:PYAlert
		
		private function modifyProjectXml():void
		{
			// save prj in temp
			var prn:String = DefaultsManager.getInstance().cleanedProjectName;
			
			// MAD 2015-12-18 Assicurarci che la richRoot è pretty printed
			XML.ignoreComments 		= false;
			XML.ignoreWhitespace 	= false;
			XML.prettyPrinting 		= true;
			XML.prettyIndent 		= 4;
			var xml:XML				= new XML(DefaultsManager.getInstance().richRoot.toString());
			XML.ignoreComments 		= true;
			XML.ignoreWhitespace 	= true;
			XML.prettyPrinting 		= false;
			var xmls:String			= xml.toString();
			
			var path:String = PyDirectoryManager.flushString("temp", prn+".xml", xmls);
			var dirNotePad:String = ConnectionsPack.getInstance(_client.clientShell.stage).notepadDirectory;
			if (dirNotePad && dirNotePad!="")
			{
				// lock gui
				alertBlocco=new PYAlert(_client.clientShell.stage,'EDITORE ESTERNO in esecuzione', 'Avviso');
				alertBlocco.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
				alertBlocco.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
				var l:NativeAppLauncherDirect = new NativeAppLauncherDirect( dirNotePad );
				//var l:NativeAppLauncherDirect = new NativeAppLauncherDirect("C:\\Program Files (x86)\\Notepad++\\notepad++.exe");
				l.addEventListener(NativeAppLauncherEvent.EXECUTED, launcherReturn);
				l.execute(path);
			}
		}
		
		
		private function launcherReturn(event:*):void	
		{	
			if (event.exitCode <= 1 )
			{
				try
				{
					
					var prn:String = DefaultsManager.getInstance().cleanedProjectName
					var strXml:String = PyDirectoryManager.loadString("temp", prn+".xml")
					XML.ignoreComments = false
					XML.ignoreWhitespace = false
					XML.prettyPrinting = true
					XML.prettyIndent = 4
					// serve wrappare la stringa in XML per controllo ed eventuale catch
					DefaultsManager.getInstance().richRoot = XML(strXml);
					XML.ignoreComments = true
					XML.ignoreWhitespace = true
					XML.prettyPrinting = false	
					_projectData = XML(strXml);
					DefaultsManager.getInstance().root = XML(strXml);
					initOtherManagers();
					updateTransformRulesList();
					updateKeywordsGrid();
					projectModified = true;
					saveBackup();
					alertBlocco.disattivaComp();
				}
				catch(error:Error) 
				{
					// Prima di sostituire l'alert del notepad++ aperto con quello del messaggio di errore, chiudiamo quello di notepad++ 
					alertBlocco.disattivaComp();
					alert=new PYAlert(_client.clientShell.stage,'Errore nel controllo del file XML.', 'Avviso',['OK']);
					alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
					alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
				}
			}
			else
			{
				// Prima di sostituire l'alert del notepad++ aperto con quello del messaggio di errore, chiudiamo quello di notepad++ 
				alertBlocco.disattivaComp();
				alert=new PYAlert(_client.clientShell.stage,"Errore nell esecuzione dell'EDITORE ESTERNO", 'Avviso',['OK']);
				alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
				alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
			}		
		}
		
		
		
		/**
		 * 
		 * 
		 * 
		 */
		private function rebldProjectData():XML
		{
			return DefaultsManager.getInstance().root;
		}
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////    AS400 Session I/O  functions    //////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
		
		private function initControlSession():void
		{
			// BUG - TUTTI - 201117 - salvataggio su AS400 con nuova sessi
			return;
			
			// ccreazione sessione da spostare dopo load di config locale
			ctrlSession = new ControlSessionManager()
			ctrlSession.addEventListener("Connected", ctrlSessionConnResult)
			ctrlSession.addEventListener("ConnectionError", ctrlSessionConnResult)
			ctrlSession.addEventListener(SessionEvent.FREEDATA_READY, ctrlSessionReady)
			ctrlSession.addEventListener(SessionEvent.LOGIN_RESPONSE, ctrlSessionReady)
			ctrlSession.addEventListener(SessionEvent.AUTH_RESPONSE, ctrlSessionReady)
			ctrlSession.addEventListener(SessionEvent.SYSTEM_READY, ctrlSessionReady)
			ctrlSession.addEventListener(SessionEvent.MESSAGE, getMessagesFromSession);
			// connetti al sistema
			ctrlSession.connect(XML(_localConfig));
		}
		
		/// sessione di controllo
		protected function ctrlSessionConnResult(e:Event):void
		{
			// adesso siamo connessi: posso accendere il semaforo di sblocco dei nativeMenu
			serverConnectionAvailable = false;
			
			if (e.type=="ConnectErrord") 
			{
				//ledConnection.source = ledrn
				//esito.text = "errore connessione"
				
				return
			}
			
			ctrlSession.sendLogin(_localConfig.@uid.toString(), _localConfig.@pw.toString())
			
		}
		
		protected function ctrlSessionReady(e:SessionEvent):void
		{
			if (e.type==SessionEvent.FREEDATA_READY) 
			{
				if (e.fKey == "login") {}
				else if (e.fKey == "write") {
					
					var params:String = e.option as String
					if (params.substr(0,10) == "READY     "  && params.substr(10,10) == "MOD_PANEL " )
					{
						var lib = addBlank( panelMediator.getUSRSPCLib(), 10 )
						var name = addBlank( panelMediator.getUSRSPCName(), 10 )
						
						params = "RD_FOR_UPD" + params.substr(10, 10) + lib + name
						ctrlSession.sendFreeData(params, "")
					}
					if (params.substr(0,10) == "LOCKED    "  && params.substr(10,10) == "MOD_PANEL " )
					{
						// cerco il dspf target (che può essere scalato rispetto ad AREA)
						for each (var dob in objectsVector["AREA"].getChildren() )
						{
							
						}
						// attivo ragno se non sto modificando tabelle
						if (!modifyTableFlag) 
							RagnoManager.getInstance().ragnoActive = true;
						// creazione dizionario dall'xml della gui convertita
						createXmlGuiDictionary();
					}
					if (params.substr(0,10) == "ERROR     "  && params.substr(10,10) == "MOD_PANEL " )
					{
						params = "RELEASE   " + params.substr(10)
						ctrlSession.sendFreeData(params, "")
						//Alert.show('Errore nel reperimento pannello su server', 'Conferma');
						alert=new PYAlert(_client.clientShell.stage,'Errore nel reperimento pannello su server.', 'Avviso',['OK']);
						alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
						
					}
					if (params.substr(0,5) == "SAVED"  && params.substr(10,9) == "MOD_PANEL" )
					{
						// cicla sul salvatqaggio nel caso ci siano piu formati da salvare
						//saveFormatsOnAS400()
						saveManualsOnAS400(-1)
					}
				}
				
			}
			if (e.type==SessionEvent.SYSTEM_READY) 
			{
				
			}
			
			// risposta positiva al login (la risposta negativa è gestita altrove...) 
			if (e.type == SessionEvent.LOGIN_RESPONSE) 
			{
				// siamo loggati: sblocco la chiamata di successive funzionalità (menuItem)
				developerLoginDone = true;
				var os:String = Capabilities.os
				os.replace(" ","")
				os = os.substr(0,10)
				var dn:String = _localConfig.@deviceName.toString();
				ctrlSession.sendAuth("*COMPOSER","*SUBSESS", os, dn);
			}
			// risposta positiva all'autorizzazione (la risposta negativa è gestita altrove...) 
			if (e.type == SessionEvent.AUTH_RESPONSE) 
			{
				// siamo loggati: sblocco la chiamata di successive funzionalità (menuItem)
				developerAuthDone = true;
			}
		}
		
		private function addBlank(s:String, v:int):String
		{
			var ret:String = ""
			for (var i:int=0;i<10;i++ )
			{
				if (i > s.length- 1 ) ret = ret + " "
				else ret = ret + s.charAt(i)
			}
			return ret	
		}
		
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function getMessagesFromSession(e:SessionEvent):void
		{
			
		}
		
		
		
		
		/**
		 * 
		 * Gestisce il salvataggio progressivo delle gu
		 * preso in input dal convertitore per creare la GUI.
		 * 
		 */
		private function saveManualsOnAS400(forProject:int):void
		{
			xmlGuiIndex++
			
			if (xmlGuiIndex < 1)  // salva una volta sola
			{
				
				var guiForAS400:XML = new XML(<g/>)
				var formatName:String = ""
				var lib = panelMediator.getUSRSPCLib()
				var name = panelMediator.getUSRSPCName()
				
				InstanceManager.getInstance().mergeManuals(forProject) // forProject: 0=per progetto, 1= per tutti
				guiForAS400 = InstanceManager.getInstance().manualXML 
				panelMediator.setFormatsManualXml(guiForAS400)
				// misura emme : duplico modifiche su progetto
				
				//				for each (var chd:XML in 	guiForAS400.gui.(@project=="projectMM_CRM").children() )
				//				{
				//					guiForAS400.gui.(@project=="PRJ_CRM").appendChild(chd)
				//				}
				
				//				var xxmmll:String = String(	guiForAS400 )
				//				
				//				guiForAS400 = XML(xxmmll)
				
				
				// preparo le variabili con blanks per AS400
				lib = addBlank( lib, 10 )
				name = addBlank( name, 10 )
				formatName = addBlank( formatName, 10 )
				// rispetto la struttura dei dati di controllo definiti nel WSE_MODUSP
				var params:String = "SAVE_DATA " + "MOD_PANEL " + lib + name + formatName + "          " + "          " + "          " + "          " 
				ctrlSession.sendFreeData( params + String(guiForAS400),"" )
				if (_client.clientShell.hasOwnProperty("focusManager")) _client.clientShell.focusManager.deactivate();
			}
			else
			{
				var lib = addBlank( panelMediator.getUSRSPCLib(), 10 )
				var name = addBlank( panelMediator.getUSRSPCName(), 10 )
				params = "CLOSE     " + "MOD_PANEL "  + lib + name
				ctrlSession.sendFreeData(params, "")
				if (!modifyTableFlag) 
					RagnoManager.getInstance().ragnoActive = false; 
				if (_client.clientShell.hasOwnProperty("focusManager")) _client.clientShell.focusManager.deactivate();
				xmlGuiModified = false
				modifyTableFlag = false
				modifyPanelFlag = false
				//Alert.show('pannello salvato con successo', 'Conferma');
				alert=new PYAlert(_client.clientShell.stage,'Modifiche manuali salvate nel Project.', 'Avviso',['OK']);
				alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
				alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
			}
		}
		
		
		/**
		 * risposta a Alert di salvataggio gui su AS400
		 */
		private function salvaSioNo(choice:int):void
		{
			if (choice == 2)
			{
				var lib:String 		= addBlank( panelMediator.getUSRSPCLib(), 10 );
				var name:String 	= addBlank( panelMediator.getUSRSPCName(), 10 );
				var params:String	= "CLOSE     " + "MOD_PANEL "  + lib + name;
				ctrlSession.sendFreeData(params, "")
				if (!modifyTableFlag) 
					RagnoManager.getInstance().ragnoActive = false;
				if (_client.clientShell.hasOwnProperty("focusManager")) _client.clientShell.focusManager.deactivate();
				xmlGuiModified = false
				modifyTableFlag = false
				modifyPanelFlag = false
				//////////////////////   UNDO !!!!!!!!!!!!!
			}
			if (choice == 0 || choice == 1)
			{
				xmlGuiIndex = -1
				saveManualsOnAS400(choice)
				//saveFormatsOnAS400()
			}
		}
		
		
		private function salvaSioNoNelProject(choice:int, resp:String=null):void
		{
			
			// new - tutti - 101016 - gestione pannelli nel project
			if (isPanelManagement)
			{
				if (choice == 1)
				{

					xmlGuiModified = false
					modifyTableFlag = false
					modifyPanelFlag = false;
					// man v4.2 - implementato resetManuals quando si risponde no a modifiche pannello, ma non funziona: testare
					// bug - tutti - rug - 101016 - nuovo tentativo di resettare i manuals
					InstanceManager4Panels.getInstance().resetManuals()
					if (xmlGuiFastModified)
					{
						alert               = new PYAlert(_client.clientShell.stage, "Le trasformazioni dei campi devono essere disattivate manualmente.", 'Fast Transform', ["OK"]);
						alert.boxStyle      = _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						xmlGuiFastModified  = false;
					}
					reapplyInstanceToGui( objectsVector["DESKTOP"] );
					drawWholeArea();
					//////////////////////   UNDO !!!!!!!!!!!!!
				}
				if (choice == 0 )
				{
					// SI
					var guiForAS400:XML = new XML(<g/>)
					var formatName:String = ""

					//InstanceManager.getInstance().mergeManualsInPanel(1) // forProject: 0=per progetto, 1= per tutti
					DefaultsManager.getInstance().addPanel( InstanceManager4Panels.getInstance().getPanelWithManuals()  )
					//DefaultsManager.getInstance().addPanel(InstanceManager.getInstance().getPanelWithManuals())
					manualsBox.rootXml =  InstanceManager4Panels.getInstance().manualXML

					xmlGuiModified = false
					xmlGuiFastModified = false;
					modifyTableFlag = false
					modifyPanelFlag = false
					projectModified = true;
					saveBackup();
					alert=new PYAlert(_client.clientShell.stage,'Modifiche manuali salvate nel Project.', 'Avviso',['OK']);
					alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
					alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
				}
			}
			else
			{
				if (choice == 1)
				{
					// NO
					//				if (!modifyTableFlag) 
					//					RagnoManager.getInstance().ragnoActive = false;
					//				if (_client.clientShell.hasOwnProperty("focusManager")) _client.clientShell.focusManager.deactivate();
					xmlGuiModified = false
					modifyTableFlag = false
					modifyPanelFlag = false;
					// BUG - tutti - RUG - 101016 - non resettava la situazione  originale del pannello quando dicevo NO al salvatqaggio modifiche
					// GRAVISSIMO!!!!!!!!  ho risposto no e ha bruciato TUTTE LE MODIFICHE MANUALI!!!!!!!! SOSPENDERE!!!!!!!!!
					//InstanceManager.getInstance().manualXML = null;
					// bug - tutti - rug - 101016 - nuovo tentativo di resettare i manuals
					InstanceManager.getInstance().resetManuals()
					if (xmlGuiFastModified)
					{
						alert               = new PYAlert(_client.clientShell.stage, "Le trasformazioni dei campi devono essere disattivate manualmente.", 'Fast Transform', ["OK"]);
						alert.boxStyle      = _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						xmlGuiFastModified  = false;
					}
					reapplyInstanceToGui( objectsVector["DESKTOP"] );
					drawWholeArea()
					//////////////////////   UNDO !!!!!!!!!!!!!
				}
				if (choice == 0 )
				{
					// SI
					var guiForAS400:XML = new XML(<g/>)
					var formatName:String = ""
					var lib = panelMediator.getUSRSPCLib()
					var name = panelMediator.getUSRSPCName()
					//var pwmxml:XML =  InstanceManager.getInstance().getPanelWithManuals();				
					InstanceManager.getInstance().mergeManuals(1) // forProject: 0=per progetto, 1= per tutti
					DefaultsManager.getInstance().setGuiManuals( InstanceManager.getInstance().manualXMLForProject,  panelMediator.getUSRSPCName() );
					//guiForAS400 = InstanceManager.getInstance().manualXML 
					manualsBox.rootXml =  InstanceManager.getInstance().manualXML
					//panelMediator.setFormatsManualXml(guiForAS400)
					// misura emme : duplico modifiche su progetto
					
					//				for each (var chd:XML in 	guiForAS400.gui.(@project=="projectMM_CRM").children() )
					//				{
					//					guiForAS400.gui.(@project=="PRJ_CRM").appendChild(chd)
					//				}
					
					//				var xxmmll:String = String(	guiForAS400 )
					//				
					//				guiForAS400 = XML(xxmmll)
					
					//				if (!modifyTableFlag) 
					//					RagnoManager.getInstance().ragnoActive = false; 
					//				if (_client.clientShell.hasOwnProperty("focusManager")) _client.clientShell.focusManager.deactivate();
					xmlGuiModified = false
					xmlGuiFastModified = false;
					modifyTableFlag = false
					modifyPanelFlag = false
					projectModified = true;
					saveBackup();
					//Alert.show('pannello salvato con successo', 'Conferma');
					alert=new PYAlert(_client.clientShell.stage,'Modifiche manuali salvate nel Project.', 'Avviso',['OK']);
					alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
					alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
				}
			}
			
			// MAD 2015-11-02: Dopo modifiche del pannello (salvate o meno) non rispondeva più il tracking
			RagnoManager.getInstance().trackActive = _trackingFlag;
			if (_trackingFlag) RagnoManager.getInstance().updateTrackingFromTarget();
		}
		
		// Commentata causa refactor HaXe (Field -> Field5250)
//		private function setDspfWindow(baseSession:SessionManager):XML
//		{
//			// se non genera gui , nessun dato ritorna
//			if (!baseSession.activeDSPF.generateGui) return null
//			
//			if (!baseSession.activeDSPF.DSPFData[0]) return null
//			
//			var aa:XML = baseSession.activeDSPF.DSPFData[0].copy();
//			
//			// prendo i nomi dei formati attivi
//			for each (var f1:Format in 	baseSession.formatStack )
//			{
//				aa.appendChild( f1.fmtData )
//				structureArea.text = structureArea.text+ String(f1.fmtData)
//				structureArea.visible = true
//			}
//			
//			//				for (var f:String in baseSession.activeDSPF.formats )
//			//				{
//			//					aa.addItem( baseSession.activeDSPF.formats[f].fmtData.source )
//			//					structureArea.text = structureArea.text+ String(baseSession.activeDSPF.formats[f].fmtData.source)
//			//				}
//			
//			for each (var datoRoot:XML in aa.children() )
//			{		
//				var fmt:String = datoRoot.parent().@n.toString()
//				
//				for each (var dato:XML in datoRoot.children() )
//				{
//					if (dato.localName()=="p")
//					{
//						if (baseSession.activeDSPF.formats[fmt])
//							dato.@active = baseSession.activeDSPF.formats[fmt].pfkeys[dato.@n.toString()].active
//					}
//					if (dato.localName()=="k")
//					{
//						if (baseSession.activeDSPF.formats[fmt])
//							dato.@active = baseSession.activeDSPF.formats[fmt].keywords[dato.@n.toString()][0].active
//					}
//					if (dato.localName()=="f")
//					{
//						var fld:String = dato.@n.toString(); // <=== HEY CHECK THIS (StrongTyping)
//						var ffff:Field5250 = baseSession.activeDSPF.formats[fmt].fields[dato.@n.toString()];
//						if (ffff.type =="I")
//						{
//							var i = int(ffff.name.substr(2,2))
//							dato.@active = baseSession.activeDSPF.indicators[i] 
//						}
//						else dato.@active = baseSession.activeDSPF.formats[fmt].fields[dato.@n.toString()].active
//						for each (var dato2:XML in dato.children() ) // <=== HEY CHECK THIS (var dato -> dato2)
//						{
//							if (dato2.localName()=="ks")
//							{
//								for each (var dato3:XML in dato2.children() )
//								{
//									if (dato3.localName()=="k")
//									{
//										if (baseSession.activeDSPF.formats[fmt])
//											if ( baseSession.activeDSPF.formats[fmt].fields[fld].keywords[dato3.@n.toString()] )
//												dato3.@active = baseSession.activeDSPF.formats[fmt].fields[fld].keywords[dato3.@n.toString()][0].active
//									}
//								}
//							}
//						}
//					}
//				}	
//			}
//			
//			return aa;
//		}
		
		
		
		public function sendKeepAlive():void
		{
			if (ctrlSession && ctrlSession.connected)
				ctrlSession.sendKeepAlive()
		}
		
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////   manual panel modify  functions    //////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 
		 * Crea il dizionario degli elementi visuali a partire dall'xml convertito del DSPF e
		 * preso in input dal convertitore per creare la GUI.
		 * 
		 */
		private function createXmlGuiDictionary():void
		{
			var xx:XML = panelMediator.getFormatsGuiXml();
			if (!xx) return;
			InstanceManager.getInstance().projectName = DefaultsManager.getInstance().cleanedProjectName
			InstanceManager.getInstance().guiXml = xx
			//InstanceManager.getInstance().manualXMLList = panelMediator.getFormatsManualXmlList();
			
			// NEW 1.5 !! RUG 231113 - SE RILEVA VECCHI MANUALS LI CONVERTE	- sospeso
			
			if (ConnectionsPack.getInstance().useProjectManuals)
			{
				if (!DefaultsManager.getInstance().getGuiManuals(panelMediator.activeDspfName) )
				{
					var manXml:XML = panelMediator.getFormatsManualXml()
					if (manXml)
					{
						alert=new PYAlert(_client.clientShell.stage,"Individuate modifiche manuali versione 1.4: si desidera convertirle a versione 2.0?", "Avviso",["Convert","Discard"],convertOldManuals);
						
						//alert=new PYAlert(_client.clientShell.stage,"Trovate modifiche manuali versione 1.4: sono state convertite a versione 2.0; è necessario salvare il project.", 'Avviso',['OK']);
						alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
						alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
						
					}
					else
					{
						InstanceManager.getInstance().manualXML = DefaultsManager.getInstance().getGuiManuals(panelMediator.activeDspfName)
						manualsBox.rootXml =  InstanceManager.getInstance().manualXML
					}
				}
				else
				{
					//					InstanceManager.getInstance().manualXML = panelMediator.getFormatsManualXml();
					//					manualsBox.rootXml =  InstanceManager.getInstance().manualXML
					InstanceManager.getInstance().manualXML = DefaultsManager.getInstance().getGuiManuals(panelMediator.activeDspfName)
					manualsBox.rootXml =  InstanceManager.getInstance().manualXML
				}
			}
			
			
		}
		
		/**
		 * 
		 * Ascolta le modifiche impostate dal ragno (spostamenti etc). Fa le veci di edit_end per le griglie.
		 * 
		 */
		private function convertOldManuals(event:int)
		{
			if (event == 1)
			{
				// da ripensare
				DefaultsManager.getInstance().setGuiManuals( new XML('<gui name="'+panelMediator.activeDspfName+'" project="*ALL" ></gui>'), panelMediator.getUSRSPCName() )
				
				alert=new PYAlert(_client.clientShell.stage,"Modifiche manuali versione 1.4 NON convertite a versione 2.0.", 'Avviso',['OK']);
				alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
				alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
				
			}
			if (event == 0 )
			{
				var manXml:XML = panelMediator.getFormatsManualXml()
				DefaultsManager.getInstance().convertOldManuals(manXml, panelMediator.getUSRSPCName())
				InstanceManager.getInstance().manualXML = DefaultsManager.getInstance().getGuiManuals(panelMediator.activeDspfName)
				manualsBox.rootXml =  InstanceManager.getInstance().manualXML
				alert=new PYAlert(_client.clientShell.stage,"Modifiche manuali convertite a versione 2.0.", 'Avviso',['OK']);
				alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
				alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
				
			}
		}
		
		
		/**
		 * 
		 * Ascolta le modifiche impostate dal ragno per quanto riguarda le fastTransform.
		 * 
		 */
		protected function ragnoFastTransformed(event:RagnoEvent):void
		{
            xmlGuiFastModified = true;
			initOtherManagers();
			projectModified = true;
			saveBackup();
		}
		
		
		
		/**
		 * 
		 * Ascolta le modifiche impostate dal ragno per quanto riguarda le add di componenti.
		 * 
		 */
		protected function ragnoAdded(event:RagnoEvent):void
		{
			xmlGuiFastModified = true;
			// RUG: deve aggiungere nell'instance4panel, generare il componente, ricaricare schema, selezionare nuovo comp. e ricaricare instance
			//InstanceManager4Panels.getInstance().addNewComponentToPanel(container, classna,compnam,"default")  //todo - style non previsto qui
			initOtherManagers();
			projectModified = true;
			saveBackup();
		}
		
		/**
		 * 
		 * Ascolta le modifiche impostate dal ragno (spostamenti etc). Fa le veci di edit_end per le griglie.
		 * 
		 */
		protected function ragnoTransformed(event:RagnoEvent):void
		{	
			// Update info on InstanceProperties window
			instancePropertiesDataProvider = instanceGrid.dataProvider as ArrayCollection;
			
			undoId++;
			
			var cname:String;
			var cstyle:String;
			var cclass:String;
			var ragnoUpdateFlag:Boolean = false;
			
			for (var key:String in event.modifiedProperties)
			{
				cname = event.component.name
				cstyle = event.component.style
				cclass =  getQualifiedClassName(event.component).split("::")[1];
				
				// BUG - TUTTI - Composer: calcSize da ragno non viene applicato subito - 20170207 - 
				//	Attivando calcSize col ragno non modifica le dimensioni. Selezionando un altro componente 
				//	e tornando sul primo, la dimensione si ricalcola. Dovrebbe ricalcolarsi subito dopo che 
				//	ha selezionato calcSize true col ragno, così come fa già la instance grid.
				// IDEM includeInLayout
				if ((key=="calcSize" && event.modifiedProperties[key]==true) ||
					(key=="includeInLayout" && event.modifiedProperties[key]==true))
				{
					ragnoUpdateFlag = true;
				}
				
				for (var i:int=0; i<instancePropertiesDataProvider.length; i++)
				{
					// BUG ALL 2015-11-04: Se originalmente aveva calcSize e modificava solo width, 
					//	la height veniva persa (perche uguale a quella che trovava nella grid). 
					//	Modificare l'xml del project sempre per entrambi.
					if ((instancePropertiesDataProvider.getItemAt(i)["property"]==key) && 
						(key=="width" || 
						 key=="height" ||
						 key=="x" || 
						 key=="y" || 
						 instancePropertiesDataProvider.getItemAt(i)["value"] != event.modifiedProperties[key]))
					{
						var um:UndoManager = UndoManager.getInstance("")
						if (um) um.execute(instanceGrid, cclass, cname, key, event.modifiedProperties[key], cstyle, undoId, instancePropertiesDataProvider.getItemAt(i)["value"])
						// Update XML (via Dictionary)
						modifyXmlGuiAttribute(event.component, key, event.modifiedProperties[key]);
						
						// Update instanceProperties dataProvider data
						instancePropertiesDataProvider.getItemAt(i)["value"] = event.modifiedProperties[key];
						instancePropertiesDataProvider.getItemAt(i)["rowColor"] = '0x990000';
						instancePropertiesDataProvider.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
						
						instanceGrid.dataProvider = instancePropertiesDataProvider;
						
						break;
					}
				}				
			}
			
			// BUG - TUTTI - Composer: calcSize da ragno non viene applicato subito - 20170207 
			drawWholeArea();
			if (ragnoUpdateFlag) 
			{
				// AGGIORNO IL RAGNO SE ATTIVO
				if (RagnoManager.getInstance().ragnoActive) RagnoManager.getInstance().updateFromTarget();
				// AGGIORNO IL PHANTOM SE ATTIVO
				if (RagnoManager.getInstance().trackActive) RagnoManager.getInstance().updateTrackingFromTarget();								
			}
		}
		
		
		/**
		 * 
		 * eseguita quando viene selezionato un elemento col ragno. Fa le veci di edit_beginning per le griglie.
		 * 
		 */
		
		private function ragnoHandler(event:RagnoEvent):void
		{
			
			if(originWin) originWin.hideDynamicList()
			
			
			var pyc:PYComponent = event.component as PYComponent;
			var className:String = getQualifiedClassName(pyc).split("::")[1];
			var styleName:String = pyc.style;
			
			// sistemo il componente selezionato nel vettore globale (per ora con un solo elemento...)
			modifyItemsSelected = [];
			modifyItemsSelected[0] = pyc;
			
			// control panel
			updateControlPanel();

			// style
			if (styleGrid)
			{
				reloadStyleWindowDataGrid( className, styleName  );
				componentTextInput.text = className;
				styleTextInput.text = styleName;
			}
			
			// instance
			if (instanceGrid) activateInstancePropertiesWindow( pyc );
			
			// outline tree
			if (outlineTree && outlineTree.dataProvider) positionOutlineTree(pyc);	
			// dspf tree - SOSPESO: VA DEFINITO BENE SENNO SI CHIUDE
			//positionTree(pyc);			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////    Pairing  functions    //////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 
		 * 
		 * 
		 */
		private function pairingGrid_editBeginning(event:DataGridEvent):void
		{
			if (event.itemRenderer)
			{
				// salvo l'indice per modificare la cella in seguito
				cellColumnIndex = event.columnIndex;
				cellRowIndex = event.rowIndex;
				originGrid = event.target as PYDatagrid;
				
				event.preventDefault();	
				if (event.columnIndex >0 )
				{
					// serve a inibire con questo clic la chiusura automatica della lista; qui siamo dentro ad un editbegin, ma la grid 
					// scatena anche un mouse click, che il nostro listener sullo stage sente...
					dontCloseDynamicList = true
					// salvo l'indice per modificare la cella in seguito
					cellColumnIndex = event.columnIndex;
					cellRowIndex = event.rowIndex;
					originGrid = event.target as PYDatagrid;
					event.preventDefault();
					event.stopImmediatePropagation();
					if ( event.columnIndex == 2) var type:String = "components"
					else var type:String =  "styles"
					
					if ( event.columnIndex == 1) 
						showDynamicList("components", windowsDictionary["Pairing"], event.itemRenderer.data.value, onRetFromDynList )
					if ( event.columnIndex == 2) 
						showDynamicList("styles", windowsDictionary["Pairing"],event.itemRenderer.data.style, onRetFromDynList, event.itemRenderer.data.value )
					
					function onRetFromDynList(selectedItem:String)
					{
						hideDynamicList(windowsDictionary["Pairing"])
						if ( event.columnIndex == 1)
						{
							var ar:Array = selectedItem.split(" : ")
							selectedItem = ar[ar.length-1]
							originGrid.dataProvider[cellRowIndex]['value']= selectedItem
							originGrid.dataProvider[cellRowIndex]['style'] = "default";
							
							// se non c'è style default lo creo
							if ( DefaultsManager.getInstance().getStyleObject(selectedItem, "default").componentName=="global" )
								DefaultsManager.getInstance().addStyle(selectedItem, "default")		
						}
						else if ( event.columnIndex == 2)
						{
							if (selectedItem.indexOf(" : ")> -1) selectedItem = selectedItem.split(" : ")[1] 
							if (selectedItem=="<nessuno>") originGrid.dataProvider[cellRowIndex]['style'] = ""
							else if (selectedItem.substr(0,1) !="<" ) originGrid.dataProvider[cellRowIndex]['style'] = selectedItem 
						}
						
						(originGrid.dataProvider as ArrayCollection).refresh();
						
						PairingsManager.getInstance().setPairingComponentName(
							originGrid.dataProvider[cellRowIndex]['property'],
							originGrid.dataProvider[cellRowIndex]['value']
						);
						// aggiorno il file di progetto con il nuovo Pairing
						PairingsManager.getInstance().setPairingComponentStyle(
							originGrid.dataProvider[cellRowIndex]['property'],
							originGrid.dataProvider[cellRowIndex]['value'],
							originGrid.dataProvider[cellRowIndex]['style']
						);
						// se è aperta finestra stili, allineo
						if (componentTextInput) 
						{
							componentTextInput.text = originGrid.dataProvider[cellRowIndex]['value']
							styleTextInput.text = originGrid.dataProvider[cellRowIndex]['style']
							reloadStyleWindowDataGrid(componentTextInput.text , styleTextInput.text);
						}
						
						projectModified = true;
						saveBackup();
					}
				}
				// se è aperta finestra stili, allineo
				if (componentTextInput) 
				{
					componentTextInput.text = originGrid.dataProvider[cellRowIndex]['value']
					styleTextInput.text = originGrid.dataProvider[cellRowIndex]['style']
					reloadStyleWindowDataGrid(componentTextInput.text , styleTextInput.text);
				}
				
			}
			
		}
		
		
		/**
		 * 
		 * 
		 * 
		 */
		private function keywordsGrid_editBeginning(event:DataGridEvent):void
		{
			if (event.itemRenderer)
			{
				
				if(originWin) originWin.hideDynamicList()
				
				// salvo l'indice per modificare la cella in seguito
				cellColumnIndex = event.columnIndex;
				cellRowIndex = event.rowIndex;
				originGrid = event.target as PYDatagrid;
				
				if(event.columnIndex==0) event.preventDefault();	
				
				if (event.columnIndex >0 )
				{
					// serve a inibire con questo clic la chiusura automatica della lista; qui siamo dentro ad un editbegin, ma la grid 
					// scatena anche un mouse click, che il nostro listener sullo stage sente...
					
					
					dontCloseDynamicList = true
					// salvo l'indice per modificare la cella in seguito
					if(event.columnIndex!=4)
					{
						event.preventDefault();
						event.stopImmediatePropagation();
					}
					
					
					
					if (event.columnIndex == 3)
					{
						showDynamicList("attribute",windowsDictionary["Keywords"],event.itemRenderer.data.attributo,onRetFromDynList);	
						
					}
					
					
					///////////////////////////////////////////////////////////////////////////////
					if (event.columnIndex == 4)
					{
						
						var att:String=originGrid.dataProvider[cellRowIndex]['attributo'].toString();
						var commonAttribute:XML = ComponentsManager.getInstance().components.commonAttr.attr.(@name==att)[0];
						
						var a:Array=ComponentsManager.getInstance().getComponentAttributesV2('global');
						var enumerate:Array=new Array();
						
						var enumerateExist:Boolean=false;
						for (var i:int=0; i<a.length; i++)
						{
							if(a[i].property==att && a[i].enumerate.length>0)
							{
								for (var j:int=0; j<a[i].enumerate.length; j++)
								{
									enumerate.push(a[i].enumerate[j]);
									if(a[i].enumerate[0]!="")enumerateExist=true;
								}
								
							}
						}
						
						var colorChooserExist:Boolean=false;
						for (var i:int=0; i<a.length; i++)
						{
							if(a[i].property==att && a[i].renderer=="PYBoxColorChooser")
							{
								colorChooserExist=true;
								var dg:PYDatagrid = event.target as PYDatagrid;
								var value:String = (event.target as PYDatagrid).dataProvider[event.rowIndex]['attrValue']
								var enumerate:Array = event.itemRenderer ? event.itemRenderer.data.enumerate : [];
								var renderer:String = "PYBoxColorChooser";
								var newValue:String = (dg.itemEditorInstance as TextInput) ? (dg.itemEditorInstance as TextInput).text : "";
							}
						}
						
						
						/// Mi serve per vedere se l'attributo è backgroundImage
						var property:String = (event.target as PYDatagrid).dataProvider[event.rowIndex]['attributo'];
						
						if (colorChooserExist==true)
						{
							// serve a inibire con questo clic la chiusura automatica della lista; qui siamo dentro ad un editbegin, ma la grid 
							// scatena anche un mouse click, che il nostro listener sullo stage sente...
							dontCloseDynamicList = true
							// salvo l'indice per modificare la cella in seguito
							cellColumnIndex = event.columnIndex;
							cellRowIndex = event.rowIndex;
							originGrid = event.target as PYDatagrid;
							
							showDynamicList("", windowsDictionary["Keywords"], originGrid.dataProvider[cellRowIndex]['attrValue'], onRetFromKeywordsDynList,null, value )
							
							event.preventDefault();
							event.stopImmediatePropagation();
						}
						
						if (enumerateExist==true && enumerate.length>0)	
						{
							
							showDynamicList(enumerate, windowsDictionary["Keywords"], originGrid.dataProvider[cellRowIndex]['attrValue'], onRetFromKeywordsDynList, null )
							event.preventDefault();
							event.stopImmediatePropagation();
						}
						else if (property=="backgroundImage") // Nelle keywords non ci sarano altre Image
						{
							event.preventDefault();
							
							imgFileReference = new FileReference();
							imgFileReference.addEventListener(Event.SELECT, onImageSelected);
							var imgTypeFilter:FileFilter = new FileFilter("Image Files","*.png; *.jpg;*.gif");
							imgFileReference.browse([imgTypeFilter]);
							
							
							
							
							imageDatagrid = keywordsGrid;
						}
						else hideDynamicList(windowsDictionary["Keywords"]);
						
					}
					
					
					///////////////////////////////////////////////////////////////////////////////
					
					
					
					function onRetFromDynList(selectedItem:String)
					{
						// aggiornamento visuale sulla griglia delle keywords
						hideDynamicList(windowsDictionary["Keywords"])
						if (event.columnIndex == 1)
						{
							//originGrid.dataProvider[cellRowIndex]['value'] = selectedItem;
						}
						if (event.columnIndex == 2)
						{
							//originGrid.dataProvider[cellRowIndex]['component'] = selectedItem;
						}
						if (event.columnIndex == 3)
						{
							originGrid.dataProvider[cellRowIndex]['attributo'] = selectedItem;
						}
						(originGrid.dataProvider as ArrayCollection).refresh();
						
						projectModified = true;
						saveBackup();
					}
					
					
				}				
			}
			
		}
		
		protected function onRetFromKeywordsDynList(selectedItem:String)
		{
			hideDynamicList(windowsDictionary["Keywords"])
			if (selectedItem.indexOf(" : ")> -1)  selectedItem = selectedItem.split(" : ")[1]
			if (selectedItem=="<nessuno>") originGrid.dataProvider[cellRowIndex]["attrValue"] = ""
			else if (selectedItem.substr(0,1) !="<" ) originGrid.dataProvider[cellRowIndex]["attrValue"] = selectedItem
			
			originGrid.dataProvider[cellRowIndex]["attrValue"] = selectedItem;
			originGrid.dataProvider.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE))
			
			
			// rug 280613 - NON DEVE ASSOLUTAMENTE AGGIORNARE ALCUN DEFAULT DI RITORNO DALLE KEYWORDS	
			
			//			DefaultsManager.getInstance().setStyleDefault(
			//				componentTextInput.text,
			//				originGrid.dataProvider[cellRowIndex]['attributo'],
			//				originGrid.dataProvider[cellRowIndex]['attrValue'],
			//				styleTextInput.text
			//			);
			
			//			applyStyleToGui( componentTextInput.text, styleTextInput.text )
			//			drawWholeArea()	
			//			// aggiorno il gestore delle fonts
			//			if (  originGrid.dataProvider[cellRowIndex]['attributo'] == 'fontFamily' ) PYFontsManager.getInstance().addProjectFont(selectedItem );
			//									
			//			// AGGIORNO IL RAGNO SE ATTIVO
			//			if (RagnoManager.getInstance().ragnoActive) RagnoManager.getInstance().updateFromTarget()
			
			updateKeiwordsProject(cellRowIndex);
			
		}
		
		
		protected function keywordsGrid_editEnd(event:DataGridEvent):void
		{
			
			var dg:PYDatagrid = event.target as PYDatagrid;
			
			var oldval:String = (event.target as PYDatagrid).dataProvider[event.rowIndex]["attrValue"];
			var newval:String = (dg.itemEditorInstance as TextInput).text;
			var property:String = String(event.itemRenderer.data.attributo);
			var cellRowIndex:int = event.rowIndex;
			
			
			switch (event.reason)
			{
				case DataGridEventReason.CANCELLED:
				case DataGridEventReason.OTHER:
					break;
				case DataGridEventReason.NEW_COLUMN:
				case DataGridEventReason.NEW_ROW:
				{
					
					if (oldval == null && newval >""
						||	oldval!= null && oldval != newval)
					{											
						switch (property)
						{
							case "backgroundColor":
							case "borderColor":
							case "foregroundColor":
							case "highColor":
							case "highLightColor":
							case "iconColor":
							case "itemBackColor":	
							case "itemOverBackColor":
							case "lineColor":
							case "selectedColor":
							case "separatorColor":
							case "textColor":
							case "toColor":							
								newval = cvtToHex(newval)
						}
						
						event.itemRenderer.data.attrValue = newval;
						dg.invalidateProperties();
						dg.invalidateDisplayList();
						
						// aggiorno il file di progetto con il nuovo stile per la keyword
						updateKeiwordsProject(cellRowIndex);
						
						projectModified = true;
						saveBackup();
						
						break;
					}
				}
			}				
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		//////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////   STYLE FUNCTIONS   //////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 
		 * 
		 * 
		 */
		private function setupStyleCanvas(winName:String):Canvas
		{
			styleCanvas 				= new Canvas();
			styleCanvas.percentHeight 	= 100;
			styleCanvas.width 			= ((windowsDictionary["Pannello di controllo"].width<1920)? 300 : 380) - utilityChromeWidth;
			styleCanvas.setStyle("backgroundColor", 0xffffff);
			
			innerFormComponent 			= new mx.controls.Label();
			innerFormComponent.text 	= "componente";
			innerFormComponent.x 		= 6;
			innerFormComponent.y 		= 0;
			
			componentTextInput 			= new TextInput();
			componentTextInput.editable = false;
			componentTextInput.text 	= "global";
			componentTextInput.width 	= styleCanvas.width - 6*2;
			componentTextInput.x 		= 6;
			componentTextInput.y 		= 18;
			componentTextInput.addEventListener(MouseEvent.CLICK,onCompWinClick);
			
			styleCanvas.addChild( componentTextInput );
			styleCanvas.addChild( innerFormComponent );
			
			innerFormStyle 			= new  mx.controls.Label()
			innerFormStyle.text 	= "stile";
			innerFormStyle.x 		= 6;
			innerFormStyle.y 		= 40;
			
			styleTextInput 			= new TextInput();
			styleTextInput.editable = true;
			styleTextInput.text 	= "default";
			styleTextInput.width 	= styleCanvas.width - 6*2;
			styleTextInput.x 		= 6;
			styleTextInput.y 		= 58;
			styleTextInput.addEventListener(MouseEvent.CLICK,onStyleWinClick);
			styleTextInput.addEventListener(KeyboardEvent.KEY_DOWN,onStyleNameEnter);
			
			styleCanvas.addChild( styleTextInput );
			styleCanvas.addChild( innerFormStyle );
			
			styleGrid 				= createGrid( winName, null );			
			styleGrid.percentHeight	= 100;
			styleGrid.width 		= styleCanvas.width - 6*2;
			styleGrid.x 			= 6;
			styleGrid.y 			= 90;
			styleCanvas.addChild(  styleGrid );
			
			reloadStyleWindowDataGrid(componentTextInput.text,styleTextInput.text);	
			
			return styleCanvas;
		}
		
		
		protected function hideDyn(event:MouseEvent):void
		{
			if (!dontCloseDynamicList && DisplayObject(event.target).stage && getQualifiedClassName(event.target)!="mx.controls::Button") 
			{				
				hideDynamicList( DisplayObject(event.target).stage.nativeWindow as PCWindowNew)
			}			
			dontCloseDynamicList = false
		}
		
		private function onCompWinClick(e:Event)
		{
			function alertOK():void
			{
				windowsDictionary["Stile"].enabled = true;
			}
			
			e.stopImmediatePropagation();
			
			if (isCreatingNewStyle)
			{
				// MAD 2015-04-30: Comportamento modificato
				// 	R.B.: "...esegue enter e crea stile; NO!!! Fare esc" https://app.asana.com/0/29215585791430/32695764140347
//				//* Finire la creazione di un nuovo stile, simulando il tasto TAB *//
//				styleTextInput.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,Keyboard.TAB,Keyboard.TAB));
				styleTextInput.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, Keyboard.ESCAPE, Keyboard.ESCAPE));
			}
			
			if (isDeletingExistingStyle) 
			{
				var message:String = "Cancellazione annullata. Lo stile " + componentTextInput.text.toUpperCase() + ":" + styleTextInput.text + " esiste ancora."
				createWindowedAlert("", "Style Alert", homePoint, 800, 600, message, 'Avviso', ["OK"], alertOK);	
				windowsDictionary["Stile"].enabled = false;
				isDeletingExistingStyle = false;
			}
			
			if (!isCreatingNewStyle) showDynamicList("components",windowsDictionary["Stile"],componentTextInput.text, onRetFromCompDynList )
			
			function onRetFromCompDynList(selectedItem:String):void
			{
				var ar:Array = selectedItem.split(" : ")
				selectedItem = ar[ar.length-1]
				hideDynamicList(windowsDictionary["Stile"])
				componentTextInput.text = selectedItem
				styleTextInput.text = "default";
				
				if (DefaultsManager.getInstance().getStylesList( componentTextInput.text ).indexOf( styleTextInput.text ) == -1)
				{
					
					// aggiorno il file di progetto con il nuovo stile
					if (! DefaultsManager.getInstance().addStyle(
						componentTextInput.text,
						styleTextInput.text
					) )
					{
						
					}
					
				}
				
				
				reloadStyleWindowDataGrid(  componentTextInput.text, styleTextInput.text   );
			}
		}
		
		// Funzione ausiliare per i messaggi di alert
		private function createWindowedAlert(wTitle:String, wName:String, wPoint:Point, wW:Number, wH:Number, aMessage:String="", aTitle:String="", aButtons:Array=null, aFunction:Function=null):void
		{
			if (!wName || wName=="") wName = "Alert";
			
			var alertCont:PYComponent 	= new PYComponent();
			alertCont.width = wW;
			alertCont.height = wH;
			
			createWindow(wTitle, wName, wPoint, wW, wH, 1, null, NativeWindowType.LIGHTWEIGHT);
			var pcw:PCWindowNew = windowsDictionary[wName] as PCWindowNew;
			pcw.x = (Capabilities.screenResolutionX - pcw.width) / 2;
			pcw.y = (Capabilities.screenResolutionY - pcw.height) / 2;
			pcw.addContent(alertCont);
			pcw.alwaysInFront = true;
			pcw.activate();
			pcw.visible = true;
			
			if (aFunction)
			{
				styleAlert = new PYAlert(alertCont, aMessage, aTitle, aButtons, aFunction);
			} else if (aButtons) {
				styleAlert = new PYAlert(alertCont, aMessage, aTitle, aButtons);
			} else {
				styleAlert = new PYAlert(alertCont, aMessage, aTitle);
			}
			styleAlert.boxStyle =  _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
			styleAlert.buttonStyle =  _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert	
			pcw.activate();
		}
		
		private function onStyleWinClick(event:Event):void
		{
			event.stopImmediatePropagation();
			
			if (isCreatingNewStyle || isDeletingExistingStyle)
			{
				event.preventDefault();
			} else {
				showDynamicList("styles", windowsDictionary["Stile"],styleTextInput.text, onRetFromStyleDynList, componentTextInput.text )
				
				function alertOK(option:int):void
				{
					windowsDictionary["Stile"].enabled = true;					
				}
				
				function onDeletionAlertFeedback(option:int):void
				{
					var message:String;
					switch(option)
					{
						case 0:
							//	Ha confermato la cancellazione
							DefaultsManager.getInstance().deleteStyle(componentTextInput.text, styleTextInput.text);
							styleTextInput.text = "default";
							reloadStyleWindowDataGrid( componentTextInput.text, "default" );
							projectModified = true;
							saveBackup();
							break;
						case 1:
							//	Ha scelto di non cancellare nulla.
							break;
					}
					// Viene tolto il flag in entrambi i casi
					isDeletingExistingStyle = false;
					windowsDictionary["Stile"].enabled = true;
				}
				
				function onRetFromStyleDynList(selectedItem:String):void
				{
					hideDynamicList(windowsDictionary["Stile"]);
					var message:String;
					if (selectedItem=="<cancella stile>")
					{
						// Qui deve cancellare lo stile
						if (styleTextInput.text=="default")
						{
							createWindowedAlert("", "Style Alert", homePoint, 800, 600, 'Non si può cancellare il default!', 'Avviso', ["OK"], alertOK);	
							windowsDictionary["Stile"].enabled = false;
						} else if (styleTextInput.text=="" || DefaultsManager.getInstance().getStylesList( componentTextInput.text ).toString().indexOf( styleTextInput.text ) == -1) {
							createWindowedAlert("", "Style Alert", homePoint, 800, 600, 'Richiesta la cancellazione di uno stile inesistente.', 'Avviso', ["OK"], alertOK);					
							windowsDictionary["Stile"].enabled = false;
						} else {
							isDeletingExistingStyle = true;
							message = componentTextInput.text.toUpperCase() + " : " + styleTextInput.text + "\n\nDesidera cancellare questo stile?";					
							createWindowedAlert("", "Style Alert", homePoint, 800, 600, message, 'Conferma', ["SI","NO"], onDeletionAlertFeedback);
							windowsDictionary["Stile"].enabled = false;
						}
					} else if (selectedItem=="<nuovo stile>") {
						//* MAD 311014: Lo lascio commentato, caso dopo vogliamo aggiungere questo messaggio di alerta da qualche parte *//
						//						alert = new PYAlert(_client.clientShell.stage,'Digita un nome per il nuovo stile', 'Creazione di stile');
						//						alert.boxStyle =  _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert					
						styleTextInput.text	= "<immettere nuovo stile>";
						styleTextInput.invalidateProperties();
						styleTextInput.selectionBeginIndex = 0;
						styleTextInput.selectionEndIndex = styleTextInput.text.length;	
						styleTextInput.setFocus();
						isCreatingNewStyle = true;
					} else {
						styleTextInput.text	= selectedItem.split(" : ")[1];
						reloadStyleWindowDataGrid( componentTextInput.text, styleTextInput.text );
					}				
				}
			}
		}
		
		
		private function onStyleNameEnter(event:KeyboardEvent):void
		{			
			if (styleTextInput.text.length>2 && styleTextInput.text.substr(0,2)=="RR" && event.keyCode==Keyboard.ENTER)
			{
				var ris = styleTextInput.text.substr(2)
				var wi = ris.split("x")[0]
				var he = ris.split("x")[1]
				
				this.originalWindow.stage.nativeWindow.width = int(wi) +7+7
				this.originalWindow.stage.nativeWindow.height = int(he) +7+40
				this.originalWindow.width = int(wi)
				this.originalWindow.height = int(he) 
				objectsVector["DESKTOP"].width = int(wi)
				objectsVector["DESKTOP"].height = int(he) 
				objectsVector["DESKTOP"].drawContainer(true)
				return
			}
			var throwAlert:Function = function(msg:String):void
			{
				if (styleAlert) styleAlert.disattivaComp();
				createWindowedAlert("","Style Alert",homePoint,800,600,msg, 'Avviso', ["OK","ANNULLA"], newStyleAlertAction);
				(windowsDictionary["Stile"] as PCWindowNew).enabled = false;
			}
			
			// Se non sta creando uno stile, rispondere solo al TAB o al Ctrl+C
			if (!isCreatingNewStyle && event.keyCode!=Keyboard.TAB && event.keyCode!=Keyboard.SHIFT && !(event.ctrlKey && event.keyCode==Keyboard.C)) 
			{
				event.preventDefault();
				event.stopImmediatePropagation();
				return;
			}
			
			var regExp:RegExp = /[ºª\\!|"@·#$~%€&¬\/()='?¡¿`^\[\*+\]ñÑ´¨\{çÇ\}<>,;.:\ äáâàãëéêèïíîìöóôòõüúûù]/ig;
			//var regExpTR:RegExp = /[ºª\\!|"@·#$~%€&¬\/()='?¡¿`^\[\*+\]ñÑ´¨\{çÇ\}<>,;.:\-_ äáâàãëéêèïíîìöóôòõüúûù(\t)(\r)]/ig;
			
			// Evitare l'immissione di nuovi caratteri non permessi
			if ((String.fromCharCode(event.charCode)).match(regExp).length>0)
			{
				event.preventDefault();
				event.stopImmediatePropagation();
				return;
			}
			
			// Fare sparire il testo di aiuto
			if (styleTextInput.text.indexOf("<immettere nuovo stile>")>-1) styleTextInput.text = (styleTextInput.text).split("<immettere nuovo stile>").join("");
			
			if (styleTextInput.text.length==0)
			{
				if (!styleTextInput.hasEventListener(FocusEvent.MOUSE_FOCUS_CHANGE)) styleTextInput.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, onMouseFocusOutWhileCreatingStyle);
				
				switch(event.keyCode)
				{
					case Keyboard.BACKSPACE:
					case Keyboard.DELETE:
						// Non fare niente. È qui per non convertirlo in carattere nel caso default.
						break;
					case Keyboard.ENTER:
					case Keyboard.TAB:
						// Tasti riservati per l'inserimento, ma il nome è ancora vuoto.
						event.preventDefault();
						event.stopImmediatePropagation();
						throwAlert("Serve inserire un nome per il nuovo stile.");						
						break;
					case Keyboard.ESCAPE:
						// MAD 2015-04-30: Richiesta di modifica di comportamento (Change Request)
						//	R.B.: style -  se esc da nome stile no msg 
						// Tasto riservato all'annullamento dell'operazione.
						newStyleAlertAction(2);
						break;		
					default:
						// Scrivi, pure. Se è arrivato fino qua, è un carattere normale.
						break;
				}
			} else {
				switch(event.keyCode)
				{
					// Attenzione: Il TAB non ha break, per continuare col resto di verifiche
					case Keyboard.TAB:
						if (event.shiftKey && !isCreatingNewStyle) componentTextInput.setFocus();
					case Keyboard.ENTER:
						if (isCreatingNewStyle)
						{
							// Prova a creare il nuovo stile.
							if (!attemptCreatingNewStyle())
							{
								//* Non l'ha creato perché già esiste. *//
								throwAlert("Già esiste uno stile con questo nome per il componente selezionato.\nDigitare un nome diverso.");
								event.preventDefault();
								event.stopImmediatePropagation();
							}
						}
						break;
					case Keyboard.ESCAPE:
						// MAD 2015-04-30: Richiesta di modifica di comportamento (Change Request)
						//	R.B.: style -  se esc da nome stile no msg 
						// Come annulla
						newStyleAlertAction(2);
						break;
					default:
						break;
				}
			}
		}
		
		protected function attemptCreatingNewStyle():Boolean
		{
			// controllo di presenza dello stile inserito: se non c'è aggiungo lo stile e modifico la GUI
			
			//if (DefaultsManager.getInstance().getStylesList( componentTextInput.text ).toString().indexOf(  ) == -1)
			if (indexOfPartialStringInArray("%: "+styleTextInput.text,DefaultsManager.getInstance().getStylesList(componentTextInput.text))==-1)
			{
				// aggiorno il file di progetto con il nuovo stile
				if (! DefaultsManager.getInstance().addStyle(
					componentTextInput.text,
					styleTextInput.text
				) )
				{
					for (var i:int=0; i<styleGrid.dataProvider.length-1; i++)
					{				
						DefaultsManager.getInstance().setStyleDefault(
							componentTextInput.text,
							styleGrid.dataProvider.getItemAt(i).property,
							styleGrid.dataProvider.getItemAt(i).value,
							styleTextInput.text
						)
					}
					
				}
				// ricarico lista stili aggiornata con ultimo aggiunto
				var newDataProvider:ArrayCollection = new ArrayCollection(DefaultsManager.getInstance().getStylesList( componentTextInput.text ));
				newDataProvider.addItemAt("<cancella stile>", 0);
				newDataProvider.addItemAt("<nuovo stile>", 0);
				reloadStyleWindowDataGrid(componentTextInput.text,styleTextInput.text);
				createWindowedAlert("","Style Alert",homePoint,800,600,"Il nuovo stile è stato creato con successo.", 'Avviso', ["OK"],newStyleAlertAction);
				windowsDictionary["Stile"].enabled = false;
				isCreatingNewStyle = false;
				projectModified = true;
				saveBackup();
				return true;
			} else {
				return false;
			}
			
		}
		
		/**
		 * Callback della finestra Alert aperta in situazioni relative alla creazione
		 * 	di un nuovo stile.
		 * 
		 * @param selection Indice dell'azione di eseguire
		 * @param resp (opzionale) Messaggio da mostrare dopo aver eseguito l'azione.
		 * 
		 */
		protected function newStyleAlertAction(selection:int, resp:String=null):void
		{
			if (selection==0)
			{
				//* OK... sceglie di inserire un nuovo nome *//
				windowsDictionary["Stile"].enabled = true;
				styleTextInput.setFocus();
				(windowsDictionary["Stile"] as PCWindowNew).activate();
				styleTextInput.setFocus();
			} else if (selection==1) {
				//* Cancella inserimento *//									
				styleTextInput.text = "default";
				reloadStyleWindowDataGrid( componentTextInput.text, "default" );
				if (styleAlert) styleAlert.disattivaComp();
				createWindowedAlert("","Style Alert",homePoint,800,600,"La creazione di un nuovo stile è stata annullata", 'Avviso', ["OK"], newStyleAlertAction);
				windowsDictionary["Stile"].enabled = false;					
				isCreatingNewStyle = false;
			} else if (selection==2) {
				//* Cancella inserimento senza avvisare l'utente *//									
				styleTextInput.text = "default";
				reloadStyleWindowDataGrid( componentTextInput.text, "default" );
				isCreatingNewStyle = false;
				newStyleAlertAction(0);
			}
		}
		
		protected function onMouseFocusOutWhileCreatingStyle(event:FocusEvent):void
		{
			// BUG MAD 2016-10-04
			// Una sequenza abbastanza abituale è l'utente creare un nuovo stile, e
			//	in vece di saltare col TAB, fare click subito sul valore dell'attributo
			//	che vuole modificare. Così perdeva lo stile a mezza creazione.
			if (isCreatingNewStyle) 
			{
				attemptCreatingNewStyle();
			}
		}
		
		
		
		/**
		 * 
		 * Modifica di una proprietà di data grid.
		 * 
		 */
		protected function styleGrid_editEnd(event:DataGridEvent):void
		{
			
			var dg:PYDatagrid = event.target as PYDatagrid;
			
			var oldval:String = (event.target as PYDatagrid).dataProvider[event.rowIndex]['value'];
			var newval:String = (dg.itemEditorInstance as TextInput).text;
			var property:String = String(event.itemRenderer.data.property);
			var cellRowIndex = event.rowIndex;
			
			// esco immediatamente se l'attributo modificato non è presente sul componente
			for each (var component:Object in modifyItemsSelected )
			{
				if (!component.hasOwnProperty(property))
				{
					//					//Alert.show("Attributo: " + property + " non gestito. Contattare il produttore.", "Errore irreversibile", Alert.OK, null,
					//					alert=new PYAlert(_client.clientShell.stage,'Attributo: ' + property + ' non gestito. Contattare il produttore.', 'Avviso',['OK'], 
					//						function (event:int):void
					//						{
					//							NativeApplication.nativeApplication.exit(1);
					//						}
					//					);
					//					alert.boxStyle= _client.splashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
					//					alert.buttonStyle= _client.splashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert	
				}
			}
			
			switch (event.reason)
			{
				case DataGridEventReason.CANCELLED:
				case DataGridEventReason.OTHER:
					break;
				case DataGridEventReason.NEW_COLUMN:
				case DataGridEventReason.NEW_ROW:
				{
					
					if (oldval == null && newval >""
						||	oldval!= null && oldval != newval)
					{											
						switch (property)
						{
							
							case "style":
								// non deve fare assolutamente niente !!!!
								break;
							
							case "backgroundColor":
							case "borderColor":
							case "foregroundColor":
							case "highColor":
							case "highLightColor":
							case "iconColor":
							case "itemBackColor":	
							case "itemOverBackColor":
							case "lineColor":
							case "selectedColor":
							case "separatorColor":
							case "textColor":
							case "toColor":
								
								if (newval && newval>"") newval = cvtToHex(newval)
								
								// niente break: esegue le successive
							
							case "width":
							case "height":
								if (componentTextInput.text == DefaultsManager.getInstance().desktopsSection..gui.*[0].localName() &&
									styleTextInput.text == objectsVector["DESKTOP"].style)
								{
									var numval:Number = Number(newval);
									var nw:Number = (property=="width" && !isNaN(numval))? numval : objectsVector["DESKTOP"].width;
									var nh:Number = (property=="height" && !isNaN(numval))? numval : objectsVector["DESKTOP"].height;
									setResolution(nw/nh,nw,nh);
								}
								// niente break: esegue le successive
							
							default:
								DefaultsManager.getInstance().setStyleDefault(
									componentTextInput.text,
									property,
									newval,
									styleTextInput.text
								);
								
								
								
								// riscrivo il valore del colore riformattato nel datagrid
								if (newval && newval>"") event.itemRenderer.data.value = newval;
								//dg.dataProvider[cellRowIndex]['value'] = newval
								//dg.dataProvider.getItemAt(cellRowIndex).value = newval
								//dg.dataProvider.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE))		
								dg.invalidateProperties();
								dg.invalidateDisplayList();
								break;
						}
						// applico stile modificato a tutti i componenti coinvolti
						applyStyleToGui( componentTextInput.text, styleTextInput.text )
						drawWholeArea()
						// in caso di defaults aggiorno la gui e riaggiorno il projectdata corrente
						projectData = rebldProjectData()
						
						// AGGIORNO IL RAGNO SE ATTIVO
						if (RagnoManager.getInstance().ragnoActive) RagnoManager.getInstance().updateFromTarget();
						
						// AGGIORNO IL PHANTOM SE ATTIVO
						if (RagnoManager.getInstance().trackActive) RagnoManager.getInstance().updateTrackingFromTarget();				
						
						projectModified = true;
						saveBackup();
						
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
		private function styleGrid_editBeginning(event:DataGridEvent):void
		{
			if (event.localX < event.target.columns[0].width)
				return;
			
			
			if(originWin) originWin.hideDynamicList()
			
			var dg:PYDatagrid = event.target as PYDatagrid;
			var value:String = event.itemRenderer ? String(event.itemRenderer.data.value) : "";
			var property:String = event.itemRenderer ? String(event.itemRenderer.data.property) : "";
			var enumerate:Array = event.itemRenderer ? event.itemRenderer.data.enumerate : [];
			var renderer:String = event.itemRenderer ? event.itemRenderer.data.renderer : "";
			var newValue:String = (dg.itemEditorInstance as TextInput) ? (dg.itemEditorInstance as TextInput).text : "";
			var subComponent:String = event.itemRenderer ? String(event.itemRenderer.data.subComponent) : "";
			
			if (!dg.enabled) return
			
			if (  property == 'fontFamily' ) 
			{
				enumerate = DefaultsManager.getInstance().enumerateFonts()
			}
			if (property.substr(-5)=="Image")
			{
				event.preventDefault();
				
				imgFileFile = File.applicationDirectory
				imgFileFile.resolvePath(DefaultsManager.getInstance().defaults.skinProperties.@imgDir)
				imgFileFile.addEventListener(Event.SELECT, onImageSelected);
				var imgTypeFilter:FileFilter = new FileFilter("Image Files","*.png; *.jpg");
				imgFileFile.browse([imgTypeFilter]);
				
				//				imgFileReference = new FileReference();
				//			    imgFileReference.addEventListener(Event.SELECT, onImageSelected);
				//			    var imgTypeFilter:FileFilter = new FileFilter("Image Files","*.png; *.jpg;*.gif");
				//			    imgFileReference.browse([imgTypeFilter]);
				
				// salvo i riferimenti ai parametri per il successivo eventuale aggiornamento della GUI
				imageDatagrid = dg;
			}
				//else if ( property.indexOf("Style")>-1 || property == 'fontFamily' )
			else if ( property.indexOf('Style')>-1 && property !="borderStyle"  )
			{
				// serve a inibire con questo clic la chiusura automatica della lista; qui siamo dentro ad un editbegin, ma la grid 
				// scatena anche un mouse click, che il nostro listener sullo stage sente...
				dontCloseDynamicList = true
				// salvo l'indice per modificare la cella in seguito
				cellColumnIndex = event.columnIndex;
				cellRowIndex = event.rowIndex;
				originGrid = event.target as PYDatagrid;
				event.preventDefault();
				event.stopImmediatePropagation();
				
				var type:String =  "styles"
				var subStyle:String = (originGrid.selectedItem.value!="")? originGrid.selectedItem.value : "default";
				
				// MAD 051114: Passiamo il valore del subComponent in vece che il componentTextInput.text, 
				// e impostiamo il nuovo parametro 'addCreateDelete' a false per non fare casini tra stili dei subComponent e il Component	
				// MAD 171114: Passiamo anche il valore di stile selezionato del subComponent se già esiste
				//				showDynamicList(type, windowsDictionary["Stile"], styleTextInput.text, onRetFromStyleDynList, componentTextInput.text )
				showDynamicList(type, windowsDictionary["Stile"], subStyle, onRetFromStyleDynList, (subComponent=="")? componentTextInput.text : subComponent, null, false)
			}
				
			else if (enumerate.length>1 )
			{
				// serve a inibire con questo clic la chiusura automatica della lista; qui siamo dentro ad un editbegin, ma la grid 
				// scatena anche un mouse click, che il nostro listener sullo stage sente...
				dontCloseDynamicList = true
				// salvo l'indice per modificare la cella in seguito
				cellColumnIndex = event.columnIndex;
				cellRowIndex = event.rowIndex;
				originGrid = event.target as PYDatagrid;
				event.preventDefault();
				event.stopImmediatePropagation();
				
				// MAD 171114: Non veniva passato l'attuale valore selezionato della enumeration
				if (newValue=="" && originGrid.selectedItem) newValue = originGrid.selectedItem.value; 
				
				showDynamicList(enumerate, windowsDictionary["Stile"], newValue, onRetFromStyleDynList, null )
				
			}
				
			else if (renderer=="PYBoxColorChooser")
			{
				// serve a inibire con questo clic la chiusura automatica della lista; qui siamo dentro ad un editbegin, ma la grid 
				// scatena anche un mouse click, che il nostro listener sullo stage sente...
				dontCloseDynamicList = true
				// salvo l'indice per modificare la cella in seguito
				cellColumnIndex = event.columnIndex;
				cellRowIndex = event.rowIndex;
				originGrid = event.target as PYDatagrid;
				event.preventDefault();
				event.stopImmediatePropagation();
				
				showDynamicList(renderer, windowsDictionary["Stile"], newValue, onRetFromStyleDynList, null,value )
				
			}
			
			function onRetFromStyleDynList(selectedItem:String, hide:Boolean=true)
			{
				if (hide) hideDynamicList(windowsDictionary["Stile"])
				if (!selectedItem) return
				
				if (selectedItem.indexOf(" : ")> -1) selectedItem = selectedItem.split(" : ")[1]
				if (selectedItem=="<nessuno>") originGrid.dataProvider[cellRowIndex]['value'] = ""
				else if (selectedItem.substr(0,1) !="<" ) originGrid.dataProvider[cellRowIndex]['value'] = selectedItem
				
				originGrid.dataProvider.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE))
				DefaultsManager.getInstance().setStyleDefault(
					componentTextInput.text,
					originGrid.dataProvider[cellRowIndex]['property'],
					originGrid.dataProvider[cellRowIndex]['value'],
					styleTextInput.text
				);
				
				// indexed  - mettere qui test nome attributo o vedere qui se si riesce a capire quale renderere
				applyStyleToGui( componentTextInput.text, styleTextInput.text )
				drawWholeArea()
				
				
				
				
				// aggiorno il gestore delle fonts
				if (  property == 'fontFamily' ) 
				{
					// RUG 240914 - GL  deve aggiornare anche la fontSection del defaultsmanager !!!!!!
					PYFontsManager.getInstance().addProjectFont(selectedItem );
				}
				
				// AGGIORNO IL RAGNO SE ATTIVO
				if (RagnoManager.getInstance().ragnoActive) RagnoManager.getInstance().updateFromTarget();
				
				// AGGIORNO IL PHANTOM SE ATTIVO
				if (RagnoManager.getInstance().trackActive) RagnoManager.getInstance().updateTrackingFromTarget();	
				
				// MAD 20150105: Il project non veniva modificato perché non veniva attivato il flag
				projectModified = true;
				saveBackup();
			}
			
		}
		
		
		private function drawWholeArea():void
		{
			// in caso di compoennti suspende si ridisegna tutto!!!
			if (objectsVector["DESKTOP"].suspended)
			{
				//objectsVector["AREA"].suspended = false
				objectsVector["DESKTOP"].drawContainer(true)
				//objectsVector["AREA"].suspended = true
			}
			else if (objectsVector["AREA"].suspended) // caso desktop non suspended
			{
				//objectsVector["AREA"].suspended = false
				objectsVector["AREA"].drawContainer(true)
				//objectsVector["AREA"].suspended = true
			}
		}
		
		
		/**
		 * 
		 * Ricarica tutte le proprietà della griglia degli specifici.
		 * 
		 */
		private function reloadStyleWindowDataGrid(componentName:String, style:String):void
		{
			// l'indice di scroll viene salvato per essere ripreso dopo il refresh
			var reloadIndex:int = styleGrid ? styleGrid.selectedIndex : -1;
			
			var element:String = componentName;
			var customAttributes:Array = [];
			
			customAttributes = ComponentsManager.getInstance().getComponentAttributesV2(componentName)
			
			var defaultAttributes:XML = DefaultsManager.getInstance().defaults;
			
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
								var hexifiedValue:String;
								var alreadyPresent:Boolean = false;
								for (var i:int=0; i<customAttributes.length; i++)
								{
									if (customAttributes[i].property == attr.localName())
									{
										hexifiedValue = hexifyIfNecessary(attr.localName(), attr);
										customAttributes[i].value = hexifiedValue;
										alreadyPresent = true;
									}
								}
								//								if (!alreadyPresent)
								//								{
								//									hexifiedValue = hexifyIfNecessary(attr.localName(), attr);
								//									customAttributes.push({property:attr.localName(), value:attr, rowColor:'0x009900', enumerate:String(child.@enumerate).split(",") });
								//								}
							}
						}
					}
				}
			}
			
			styleGrid.dataProvider = new ArrayCollection( customAttributes.sortOn(['group', 'property']) );
			
			if (reloadIndex != -1)
			{
				styleGrid.scrollToIndex(reloadIndex);
				styleGrid.selectedIndex = reloadIndex;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		////////////////////////////////////////////////////////////////////////////////////
		///////////////////// INSTANCE  FUNCTIONS /////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 
		 * 
		 * 
		 */
		public function activateInstancePropertiesWindow(pyc:PYComponent):void			
		{
			var componentName:String = "";
			componentName = getQualifiedClassName(pyc).split('::')[1];
			reloadInstanceAttributesWindow( componentName, (pyc as PYComponent).name, pyc.style, pyc );
			
		}
		
		
		
		
		
		
		
		
		/**
		 * 
		 * Ricarico il dataProvider della instanceGrid. Questa è la versione ufficiale.
		 * 
		 */
		private function reloadInstanceAttributesWindow(compClass:String, componentName:String, styleName:String, compon:PYComponent):void
		{
			var i:int=0;
			var found:Boolean = false;
			
			// l'array contenente il risultato
			var customAttributes:Array = [];
			
			// le origini degli attributi
			//			var commonAttributes:XMLList = ComponentsManager.getInstance().components.commonAttr;
			//			var commonSubAttributes:XMLList = ComponentsManager.getInstance().components.subCommonAttr;
			//			var specificProperties:XML = ComponentsManager.getInstance().components.components.*.*.(localName()==compClass)[0];
			//			
			//			for each (var attribute:XML in commonAttributes.children())
			//			{
			//				var commonValue:String = hexifyIfNecessary(attribute.@name, attribute.@defaultValue);
			//				var group = orderGroup(attribute.@group)
			//				customAttributes.push({property:attribute.@name, value:commonValue, rowColor:'0x000000', enumerate:String(attribute.@enumerate).split(","), group:group });
			//			}
			//			for each (var subAttribute:XML in commonSubAttributes.children())
			//			{
			//				var subcommonValue:String = hexifyIfNecessary(subAttribute.@name, subAttribute.@defaultValue);
			//				var group = orderGroup(subAttribute.@group)
			//				customAttributes.push({property:subAttribute.@name, value:subcommonValue, rowColor:'0x000000', enumerate:String(subAttribute.@enumerate).split(","), group:group });
			//			}
			//			for each (var child:XML in specificProperties.children())
			//			{
			//				var specificValue:String = hexifyIfNecessary(child.@name, child.@defaultValue);
			//				var group = orderGroup(child.@group)
			//				customAttributes.push({property:String(child.@name), value:specificValue, rowColor:'0x000000', enumerate:String(child.@enumerate).split(","), group:group });
			//			}
			
			
			customAttributes = ComponentsManager.getInstance().getComponentAttributesV2(compClass)
			
			
			// carico i valori di stile in verde
			applyValues( DefaultsManager.getInstance().getStyleAttributesXml( compClass, styleName ) , '0x009900')
			
			// carico valori di istanza in blu
			applyValues( InstanceManager.getInstance().getElement(componentName) , '0x0000BB')
			// man - tutti - 201117 - gestione pannelli con displayfile
			if (isPanelManagement)
			{
				// carico valori modificati a mano in rosso
				applyValues( InstanceManager4Panels.getInstance().getPrjManualElement(componentName) , '0x990000')
			}
			else
			{
				// carico valori modificati a mano in rosso
				applyValues( InstanceManager.getInstance().getAllManualElement(componentName) , '0x990000')
				
				// carico valori modificati a mano in rosso
				applyValues( InstanceManager.getInstance().getPrjManualElement(componentName) , '0x995500')
				
				// carico valori modificati a mano in rosso
				applyValues( InstanceManager.getInstance().getLastManualElement(componentName) , '0x999900')
			}
			
			
			applyComponValues( compon , '0x666666')
			
			// valorizzo il dataProvider della instanceGrid
			var vsp:Number = instanceGrid.verticalScrollPosition
			instanceGrid.dataProvider = new ArrayCollection( customAttributes.sortOn(['group', 'property']) );
			instanceGrid.verticalScrollPosition = vsp
			
			function applyValues(instanceXml:XML, color:String)
			{
				if (instanceXml != null)
				{
					// aggiorno l'elemento selezionato con i valori del nuovo skin
					for (i=0; i<customAttributes.length; i++)
					{
						var val:String = instanceXml.attribute(customAttributes[i].property);
						if (val>"")
						{
							var customValue:String = hexifyIfNecessary(String(customAttributes[i].property), val);
							customAttributes[i].value = customValue;
							customAttributes[i].rowColor = color;
						}
					}
				}
			}
			
			function applyComponValues(compon:PYComponent, color:String):void
			{
				
				// aggiorno l'elemento selezionato con i valori del nuovo skin
				for (i=0; i<customAttributes.length; i++)
				{
					
					if (compon && compon.hasOwnProperty(customAttributes[i].property) )
					{
						// MAD 2015-07-24 hexify forzava la conversione a String dell'oggetto Bitmap
						var componValue:* = (customAttributes[i].property.substr(-5)=="Image")?
												compon[customAttributes[i].property]
												:
												hexifyIfNecessary(String(customAttributes[i].property), compon[customAttributes[i].property]);
						
						if (customAttributes[i].property.substr(-5)=="Image" && componValue)
						{
							// MAD 2015-07-24
							// Per non comparare pere con mele, serve ottenere la nativePath della customAttributes[i].value 
							//	e quella della componValue.loaderInfo.url se è Bitmap, o la nativePath della componValue se è String
							// Per la customAttributes[i].value serve applicare gli stessi raggionamenti che applicherà il
							//	PYComponent alla sua volta. Magari dovremmo spostare questi raggionamenti a qualche classe utils.
							var appDir:String 	= ConnectionsPack.getInstance().appDirectory;
							var baseDir:String 	= ConnectionsPack.getInstance().baseDirectory;
							var imgDir:String 	= ConnectionsPack.getInstance().imageDirectory;
							var value:String	= setProperImagePath(customAttributes[i].value);
							var cValue:String 	= (componValue is Bitmap)? "" : setProperImagePath(componValue);
							
							// MAD 2015-11-03
							// Quando l'immagine non è stata trovata, e la voidBitmap è quella embed, non riesce a ottenere 
							//	la sua nativePath per poter comparare il vecchio valore col nuovo. Verificare prima che il 
							//	suo valore nella cache non coincida con quello della voidB
							if (CacheBitmapManager.getInstance().getImage(value) != CacheBitmapManager.getInstance().getImage("voidB"))
							{
								var caImgPath:String = File.documentsDirectory.resolvePath(value).nativePath;
								var coImgPath:String = File.documentsDirectory.resolvePath((cValue=="")? componValue.loaderInfo.url : cValue).nativePath;
								var imgPath:String	 = File.documentsDirectory.resolvePath(baseDir + "/" + imgDir + "/").nativePath;
								var basePath:String	 = File.documentsDirectory.resolvePath(baseDir + "/").nativePath;
								
								if ( caImgPath != coImgPath )
								{
									// E adesso serve il ricalcolo alla rovescia.
									if (coImgPath.indexOf(imgPath)>-1) 	coImgPath = coImgPath.substr((imgPath).length + 1);
									if (coImgPath.indexOf(basePath)>-1) coImgPath = coImgPath.substr((basePath).length + 1);
									customAttributes[i].value 		= coImgPath;
									customAttributes[i].rowColor 	= color;
								}
							}
						}
						else 
						{
							if ( customAttributes[i].value != componValue)
							{
								customAttributes[i].value = componValue;
								customAttributes[i].rowColor = color;
							}	
						}						
					}
					
				}
			}
			
			
		} 
		
		/**
		 * Funzione ausiliare per ottenere il path completo di una immagine
		 * 
		 * @param value Il nome dell'immagine, la sua URL, o il nome dell'immagine embeddata
		 * @return Il path dell'immagine nel direttorio base, o il valore inalterato (http://... embed:...)
		 * 
		 */		
		private function setProperImagePath(value:String):String
		{
			var appDir:String 		= ConnectionsPack.getInstance().appDirectory;
			var baseDir:String 		= ConnectionsPack.getInstance().baseDirectory;
			var imgDir:String 		= ConnectionsPack.getInstance().imageDirectory;
			
			if ( ( appDir == "" || value.indexOf(appDir)<0 ) && value.indexOf("embed:")<0) // Se ha già la applicationDirectory come inizio del path, o è embeddata, non modifica nulla
			{
				// BUG CAPGEMINI/ALL 2015-12-02: Inviava http: come HTTP:. Questa parte di una URL è case insensitive (anche in linux).
				//	Quindi la comparazione di questa parte del value va fatta indipendentemente di se è minuscola o meno.
				if (imgDir!=null && 
					value.substr(0,7).toLowerCase()!="file://" && 
					value.substr(0,7).toLowerCase()!="http://" && 
					value.substr(0,8).toLowerCase()!="https://")
				{ 
					// Se non esiste ancora imgDir, o se il valore originale è un indirizzo di OS (e.g. C:\...), un path di rete, o è una URL completa, 
					//	la caricherà così come'è. Altrimenti Sistema il path per localizzarla correttamente.
					if (imgDir.substr(-1)=="/")	imgDir = imgDir.substr(0,imgDir.length-1);								// Normalize imgDir
					
					var goesTwoLevelsUp:Boolean	= ( value.substr(0,6) == "../../" );									// Lo lascierà com'è
					var goesOneLevelUp:Boolean	= ( value.substr(0,3) == "../" && !goesTwoLevelsUp );					// Backwards compatibility
					var hasJustTwoDots:Boolean	= ( value.substr(0,2) == ".." && !goesTwoLevelsUp && !goesOneLevelUp ); // idem (CapGemini)
					
					if (goesOneLevelUp) value 	= value.replace("../","");
					if (hasJustTwoDots) value	= value.replace("..","");
					
					// Aggiungere baseDir se c'è, e la imgDir
					value	= ((baseDir)? baseDir + "/" : "") + ((value.substr(0,7)=="assets/")? "" : imgDir + "/") + value;
				}
			}
			
			return value;
		}
		
		
		
		
		/**
		 * 
		 * Modifica di una proprietà di data grid.
		 * 
		 */
		protected function instanceGrid_editEnd(event:DataGridEvent):void
		{
			
			var dg:PYDatagrid = event.target as PYDatagrid;
			
			var oldval:String = (event.target as PYDatagrid).dataProvider[event.rowIndex]['value'];
			var newval:String = (dg.itemEditorInstance as TextInput).text;
			var property:String = String(event.itemRenderer.data.property);
			var component:PYComponent;
			// esco immediatamente se l'attributo modificato non è presente sul componente
			for each (component in modifyItemsSelected)
			{
				if (!component.hasOwnProperty(property))
				{
					//Alert.show("Attributo: " + property + " non gestito. Contattare il produttore.", "Errore irreversibile", Alert.OK, null,
					//						alert=new PYAlert(_client.clientShell.stage,'Attributo: ' + property + ' non gestito. Contattare il produttore.', 'Avviso',['OK'], 
					//							function (event:int):void
					//							{
					//								NativeApplication.nativeApplication.exit(1);
					//							}
					//						);
					//						alert.boxStyle= _client.splashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
					//						alert.buttonStyle= _client.splashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert	
				}
			}
			
			switch (event.reason)
			{
				case DataGridEventReason.CANCELLED:
				case DataGridEventReason.OTHER:
					break;
				case DataGridEventReason.NEW_COLUMN:
				case DataGridEventReason.NEW_ROW:
				{
					
					if (oldval == null && newval >""
						||	oldval!= null && oldval != newval)
					{											
						switch (property)
						{
							case "name":
								// Riportare il valore originale. I nomi non sono editabili
								(dg.itemEditorInstance as TextInput).text = oldval;
								dg.invalidateProperties();
								dg.invalidateDisplayList();
								break;
							
							case "x":
							case "y":
								// SENZA break; IN MODO DI ANDARE AVANTI COL RESTO DI MODIFICHE SE includeInLayout È FALSE!!!	
								for each (component in modifyItemsSelected)
								{
									if (component.hasOwnProperty("includeInLayout") && component.includeInLayout==true)
									{
										(dg.itemEditorInstance as TextInput).text = oldval;
										dg.invalidateProperties();
										dg.invalidateDisplayList();
										return;
									}
								}
								
							// scegliere altra soluzione
							/*case "align":
							if ( newval != "left" && newval != "center" && newval != "right" )
							{
							event.preventDefault();
							event.stopImmediatePropagation();
							//Alert.show("Il valore inserito non è previsto dall'attributo.", "Avviso");
							alert=new PYAlert(_client.clientShell.stage,"Valore non valido.", 'Avviso',['OK']);
							alert.boxStyle= _client.splashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
							alert.buttonStyle= _client.splashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
							break;
							}
							
							case "borderStyle":
							if ( newval != "none" && newval != "solid" )
							{
							event.preventDefault();
							event.stopImmediatePropagation();
							//Alert.show("Il valore inserito non è previsto dall'attributo.", "Avviso");
							alert=new PYAlert(_client.clientShell.stage,"Valore non valido.", 'Avviso',['OK']);
							alert.boxStyle= _client.splashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
							alert.buttonStyle= _client.splashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
							break;
							}*/
							
							case "backgroundColor":
							case "borderColor":
							case "foregroundColor":
							case "highColor":
							case "highLightColor":
							case "iconColor":
							case "itemBackColor":
							case "itemOverBackColor":
							case "lineColor":
							case "selectedColor":
							case "separatorColor":
							case "textColor":
							case "toColor":
								
								newval = cvtToHex(newval);
								
								// niente break: esegue le successive
								
							default:
								// ATTENZIONE: Avevamo messo una var comp che entrava in conflitto col package comp
								for each (component in modifyItemsSelected)
								{
									//if (property=="style") PYComponent(comp).clearAttributes();
									
									// debug 13 marzo: applicazione diretta della modifica al componente
									if (component[property] is Boolean && newval=="false" ) 
										component[property] =  false 
									else if (component[property] is Boolean && newval=="true" ) 
										component[property] =  true
									else if (! (component[property] is Boolean) ) 
										component[property] = newval;
									
									// new - tutti - 010317 - gestione instancevalues: quando modifico attributo manuale al componente, 
									// modifico anche il suo instanceValues
									if (component["instanceValues"] != null )
									{
										if (newval=="")
											delete component["instanceValues"][property]
										else
											component["instanceValues"][property] = newval
									}
									
									if (PYComponent(component).suspended)
									{
										if (component is IMeasurable)
											IMeasurable(component).drawContainer()
										else

											PYComponent(component).drawComponent()
									}
									
									
									
									// aggiorno l'xml dell'instanceManager
									modifyXmlGuiAttribute(component, property, newval);
									// BUG ALL 2015-11-17: Quando cambia x o y, deve salvare entrambi valori
									if (property=="x")
									{
										modifyXmlGuiAttribute(component, "y", component.y);
									} else if (property=="y") {
										modifyXmlGuiAttribute(component, "x", component.x);
									} else if (property=="width") {
										modifyXmlGuiAttribute(component, "height", component.height);
									} else if (property=="height") {
										modifyXmlGuiAttribute(component, "width", component.width);
									}
									
									// AGGIORNO IL RAGNO SE ATTIVO
									if (RagnoManager.getInstance().ragnoActive) RagnoManager.getInstance().updateFromTarget();
									
									// BUG  - TUTTI - 010317 - disegnava il tracking anche durante la modifica
									///*************************************************
									// ALEX QUESTE CAZZATE NON LE VOGLIO!!!!!!!!!!!!!
									///*************************************************
									// 1- MANCANO BUG/MAN, PER CHI E DATA !!!!!!!
									// 2 - MODIFICA FATTA CON SUPERFICIALITA!!! - PRIMA QUI NON  CERA NESSUN RIFERIMENTO AL PHANTOM, 
									// PERCHE QUESTA FUNZIONE DI INSTANCE AGISCE SOLO QUANDO E' ATTIVA LA MODIFICA LA PANNELLO!! QUANDO L'HAI INSERITA?????						
									// (COMMENTO ALEX) AGGIORNO IL PHANTOM SE ATTIVO
									// if (RagnoManager.getInstance().trackActive) RagnoManager.getInstance().updateTrackingFromTarget();				
								}
								// in caso di compoennti suspende si ridisegna tutto!!!
								drawWholeArea();								
								
								
								// riscrivo il valore del colore riformattato nel datagrid
								event.itemRenderer.data.value = newval;
								
								if (modifyItemsSelected.length==1) 
								{
									//  occorre calcolare di quale colore deve essere la cella
									setCellColor(dg.dataProvider[event.rowIndex],  getQualifiedClassName(modifyItemsSelected[0]).split("::")[1] , modifyItemsSelected[0].name, modifyItemsSelected[0].style )
									
								}
								dg.dataProvider.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE))		
								dg.invalidateProperties();
								dg.invalidateDisplayList();
								break;
						}							
						projectModified = true;
						saveBackup();
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
		private function instanceGrid_editBeginning(event:DataGridEvent):void
		{
			if (event.localX < event.target.columns[0].width)
				return;
			
			if(originWin) originWin.hideDynamicList()
			
			
			var dg:PYDatagrid = event.target as PYDatagrid;
			var value:String = event.itemRenderer ? String(event.itemRenderer.data.value) : "";
			var property:String = event.itemRenderer ? String(event.itemRenderer.data.property) : "";
			var enumerate:Array = event.itemRenderer ? event.itemRenderer.data.enumerate : [];
			var renderer:String = event.itemRenderer ? event.itemRenderer.data.renderer : "";
			var newValue:String = (dg.itemEditorInstance as TextInput) ? (dg.itemEditorInstance as TextInput).text : "";
			var subComponent:String = event.itemRenderer ? String(event.itemRenderer.data.subComponent) : "";
			
			if (!dg.enabled || property=="name") return
			
			if (property.substr(-5) == "Image")
			{
				event.preventDefault();
				
				imgFileFile = File.applicationDirectory
				imgFileFile.resolvePath(DefaultsManager.getInstance().defaults.skinProperties.@imgDir)
				imgFileFile.addEventListener(Event.SELECT, onImageSelected);
				var imgTypeFilter:FileFilter = new FileFilter("Image Files","*.png; *.jpg");
				imgFileFile.browse([imgTypeFilter]);
				
				//					imgFileReference = new FileReference();
				//				    imgFileReference.addEventListener(Event.SELECT, onImageSelected);
				//				    var imgTypeFilter:FileFilter = new FileFilter("Image Files","*.png; *.jpg;*.gif");
				//				    imgFileReference.browse([imgTypeFilter]);
				
				// salvo i riferimenti ai parametri per il successivo eventuale aggiornamento della GUI
				imageDatagrid = dg;
			}
				//else if ( (property.indexOf('Style')>-1 && property !="borderStyle" ) ||  property == "style" || property == 'fontFamily' )
			else if ( (property.indexOf('Style')>-1 && property !="borderStyle" ) ||  property == "style" )
			{
				// serve a inibire con questo clic la chiusura automatica della lista; qui siamo dentro ad un editbegin, ma la grid 
				// scatena anche un mouse click, che il nostro listener sullo stage sente...
				dontCloseDynamicList = true
				// salvo l'indice per modificare la cella in seguito
				cellColumnIndex = event.columnIndex;
				cellRowIndex = event.rowIndex;
				originGrid = event.target as PYDatagrid;
				event.preventDefault();
				event.stopImmediatePropagation();
				if (  property == 'fontFamily' ) var type:String = "fonts"
				else var type:String =  "styles"
					
				var subStyle:String = (originGrid.selectedItem.value!="")? originGrid.selectedItem.value : "default";
				
				// MAD 090515: Passiamo il valore del subComponent in vece che il componentTextInput.text, 
				// e impostiamo il nuovo parametro 'addCreateDelete' a false per non fare casini tra stili dei subComponent e il Component	
				// MAD 090515: Passiamo anche il valore di stile selezionato del subComponent se già esiste
				//showDynamicList(type, windowsDictionary["Istanza"], styleTextInput.text, onRetFromStyleDynList, componentTextInput.text )
				showDynamicList(type, windowsDictionary["Istanza"], subStyle, onRetFromStyleDynList, (subComponent=="")? componentTextInput.text : subComponent, null, false);
			}
			else if (enumerate.length>1)
			{
				// serve a inibire con questo clic la chiusura automatica della lista; qui siamo dentro ad un editbegin, ma la grid 
				// scatena anche un mouse click, che il nostro listener sullo stage sente...
				dontCloseDynamicList = true
				// salvo l'indice per modificare la cella in seguito
				cellColumnIndex = event.columnIndex;
				cellRowIndex = event.rowIndex;
				originGrid = event.target as PYDatagrid;
				event.preventDefault();
				event.stopImmediatePropagation();
				
				// MAD 090515: Non veniva passato l'attuale valore selezionato della enumeration
				if (newValue=="" && originGrid.selectedItem) newValue = originGrid.selectedItem.value;
				
				showDynamicList(enumerate, windowsDictionary["Istanza"], newValue, onRetFromStyleDynList, null )
				
			}
				
			else if (renderer=="PYBoxColorChooser")
			{
				// serve a inibire con questo clic la chiusura automatica della lista; qui siamo dentro ad un editbegin, ma la grid 
				// scatena anche un mouse click, che il nostro listener sullo stage sente...
				dontCloseDynamicList = true
				// salvo l'indice per modificare la cella in seguito
				cellColumnIndex = event.columnIndex;
				cellRowIndex = event.rowIndex;
				originGrid = event.target as PYDatagrid;
				event.preventDefault();
				event.stopImmediatePropagation();
				
				showDynamicList(renderer, windowsDictionary["Istanza"], newValue, onRetFromStyleDynList, null,value )
				
			}
			
			function onRetFromStyleDynList(selectedItem:String, hide:Boolean=true):void
			{
				var i:int;
				
				if (hide) hideDynamicList(windowsDictionary["Istanza"])
				if (selectedItem.indexOf(" : ")> -1) selectedItem = selectedItem.split(" : ")[1]
				if (selectedItem=="<nessuno>") originGrid.dataProvider[cellRowIndex]['value'] = ""
				else if (selectedItem.substr(0,1) !="<" ) originGrid.dataProvider[cellRowIndex]['value'] = selectedItem
				
				originGrid.dataProvider.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE))
				
				// aggiorno il gestore delle fonts
				if (  property == 'fontFamily' ) PYFontsManager.getInstance().addProjectFont( selectedItem );
				
				
				_client.clientShell.stage.nativeWindow
				// aggiorno l'xml dell'instanceManager
				modifyXmlGuiAttribute(modifyItemsSelected[0], originGrid.selectedItem.property, originGrid.dataProvider[cellRowIndex]['value']);
				
				componentTextInput.text = getQualifiedClassName(modifyItemsSelected[0]).split("::")[1] 
				if(property=="style") styleTextInput.text = originGrid.dataProvider[cellRowIndex]['value']
				reloadStyleWindowDataGrid(componentTextInput.text , styleTextInput.text)	
				
				//applyStyleToGui( componentTextInput.text, styleTextInput.text )
				
				//  occorre calcolare di quale colore deve essere la cella
				setCellColor(originGrid.dataProvider[cellRowIndex], componentTextInput.text, modifyItemsSelected[0].name, styleTextInput.text )
				
				// AGGIORNO IL COMPONENTE ///////////////////////////////////////////////////////
				var valueToApply = originGrid.dataProvider[cellRowIndex]['value'] == "true" ? true :  
					originGrid.dataProvider[cellRowIndex]['value'] == "false" ? false : 
					originGrid.dataProvider[cellRowIndex]['value']
				modifyItemsSelected[0][originGrid.selectedItem.property] = valueToApply
				// new - tutti - 010317 - gestione instancevalues: quando modifico attributo manuale al componente, 
				// modifico anche il suo instanceValues
				if (modifyItemsSelected[0]["instanceValues"] != null )
				{
					if (originGrid.dataProvider[cellRowIndex]['value']=="")
						delete modifyItemsSelected[0]["instanceValues"][property]
					else
						modifyItemsSelected[0]["instanceValues"][property] = originGrid.dataProvider[cellRowIndex]['value']
				}
					
				if (modifyItemsSelected[0].suspended)
				{
					if (modifyItemsSelected[0] is IMeasurable)
						modifyItemsSelected[0].drawContainer()
					else

						modifyItemsSelected[0].drawComponent()
				}
				// BUG - TUTTI - 2017-01-26: il drawWholeArea veniva applicato prima della modifica dell'attributo del componente
				//	per cui non si vedeva subito l'efetto di impostare includeInLayout a false o true, ad esempio, ma solo dopo che 
				//	veniva modificato qualche altro attributo.
				drawWholeArea()
				/////////////////////////////////////////////////////////////////////////////	
				
				// AGGIORNO IL RAGNO SE ATTIVO
				if (RagnoManager.getInstance().ragnoActive) RagnoManager.getInstance().updateFromTarget();
				// BUG  - TUTTI - 010317 - disegnava il tracking anche durante la modifica
				///*************************************************
				// ALEX QUESTE CAZZATE NON LE VOGLIO!!!!!!!!!!!!!
				///*************************************************
				// 1- MANCANO BUG/MAN, PER CHI E DATA !!!!!!!
				// 2 - MODIFICA FATTA CON SUPERFICIALITA!!! - PRIMA QUI NON  CERA NESSUN RIFERIMENTO AL PHANTOM, 
				// PERCHE QUESTA FUNZIONE DI INSTANCE AGISCE SOLO QUANDO E' ATTIVA LA MODIFICA LA PANNELLO!! QUANDO L'HAI INSERITA?????						
				// (COMMENTO ALEX) AGGIORNO IL PHANTOM SE ATTIVO
				// if (RagnoManager.getInstance().trackActive) RagnoManager.getInstance().updateTrackingFromTarget();

				
				// Caso speciale: calcSize -> modifica width e height
				if (originGrid.selectedItem.property=="calcSize")
				{
					var newW:Number = modifyItemsSelected[0]["width"];
					var newH:Number = modifyItemsSelected[0]["height"];

					modifyXmlGuiAttribute(modifyItemsSelected[0], "width", newW);
					modifyXmlGuiAttribute(modifyItemsSelected[0], "height", newH);
					
					// Manca ancora aggiornare il datagrid coi nuovi valori.
					// calcSize viene sempre dopo di width, e width sempre dopo di height... 
					// 	quindi, le trovo più velocemente con un loop a ritroso partendo
					//	dall'indice del calcSize.
					i = cellRowIndex;
					while ((originGrid.dataProvider[i]["property"]!="height") && (i>=0))
					{
						if (originGrid.dataProvider[i]["property"]=="width") originGrid.dataProvider[i]["value"] = newW;
						i--;
					}
					if (originGrid.dataProvider[i]["property"]=="height") originGrid.dataProvider[i]["value"] = newH;
				}
				
				// Caso speciale: includeInLayout -> modifica x e y
				if (originGrid.selectedItem.property=="includeInLayout")
				{
					var newX:Number = modifyItemsSelected[0]["x"];
					var newY:Number = modifyItemsSelected[0]["y"];
					
					modifyXmlGuiAttribute(modifyItemsSelected[0], "x", newX);
					modifyXmlGuiAttribute(modifyItemsSelected[0], "y", newY);
					
					// Manca ancora aggiornare il datagrid coi nuovi valori.
					// includeInLayout viene sempre prima di x, e x sempre prima di y... 
					// 	quindi, le trovo più velocemente con un loop in avanti partendo
					//	dall'indice del includeInLayout.
					i = cellRowIndex;
					while ((originGrid.dataProvider[i]["property"]!="y") && (i<originGrid.dataProvider.length))
					{
						if (originGrid.dataProvider[i]["property"]=="x") originGrid.dataProvider[i]["value"] = newX;
						i++;
					}
					if (originGrid.dataProvider[i]["property"]=="y") originGrid.dataProvider[i]["value"] = newY;
				}
				
				originGrid.invalidateProperties();
				originGrid.invalidateDisplayList();
			}
			
		}
		
		
		private function setCellColor(cell:*, compClass:String, componentName:String, styleName:String):void
		{
			cell['rowColor'] = 0x990000
			
			// carico i vaLORI DI default in nero
			applyValues( ComponentsManager.getInstance().getComponentAttributesV2( compClass ) , '0x000000')
			
			// carico i vaLORI DI STILE IN VERDE
			applyValues( DefaultsManager.getInstance().getStyleAttributesXml( compClass, styleName ) , '0x009900')
			// carico valori di istanza in blu
			applyValues( InstanceManager.getInstance().getElement(componentName) , '0x0000BB')
			// carico valori modificati a mano globali in rosso
			applyValues( InstanceManager.getInstance().getAllManualElement(componentName) , '0x990000')
			
			// carico valori modificati a mano per project in arancio
			applyValues( InstanceManager.getInstance().getPrjManualElement(componentName) , '0x995500')
			
			// carico valori modificati a mano ultimi in giallo
			applyValues( InstanceManager.getInstance().getLastManualElement(componentName) , '0x999900')
			
			function applyValues(instanceXml:*, color:String)
			{
				if (instanceXml != null)
				{
					if (instanceXml is XML) var val:String = instanceXml.attribute(cell['property']);
					if (instanceXml is Array)
					{
						// to do
						//var val:String = instanceXml.attribute(cell['property']);
					}
					if (val>"" && val == cell['value']) cell['rowColor'] = color;
				}
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////    dspf tree functions                   //////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function treeClick(event:ListEvent):void
		{
			structureArea.text =  String(event.itemRenderer.data )
			//rug windowsDictionary["winXml"].visible = true
			//rug windowsDictionary["winXml"].contenuto.height=areaTree.height
			
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function treeAperto(event:Event):void
		{
			dspfTree.validateNow();
			
			//rug if (tree.height > windowsDictionary["winTree"].contenuto.height)
			//rug 	windowsDictionary["winTree"].contenuto.height=tree.height
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////    OUTLINE TREE                     //////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		var outlineDpIndex:int 
		private function positionOutlineTree(pyc:PYComponent)
		{
			try // a causa di loop su xmllist
			{
				
				var dp:XMLListCollection = outlineTree.dataProvider as XMLListCollection
				outlineDpIndex = 0	
				for each (var xml:XML in dp.children())
				{
					subPositionOutlineTree(xml, pyc.name)
				}
				
			}
			catch (e:Error)
			{
				
			}
			
		}
		
		private function subPositionOutlineTree(xml:XML, name:String):void
		{
			outlineDpIndex++
			if (xml.@name == name)
			{
				outlineTree.selectedIndex = outlineDpIndex
				outlineTree.liveScrolling = true
				outlineTree.scrollToIndex(outlineDpIndex )
				return
			}
			for each (var child:XML in xml.children() )
			{
				subPositionOutlineTree(child, name)
			}	
		}
		
		
		/**
		 * 
		 * 
		 * 
		 */
		private function outlineTreeLabels(item:Object):String
		{
			return (item as XML).localName() + ": " + (item as XML).@name + (((item as XML).@manuals=="true")? "  [MANUALS]" : "");  
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		private function outlineTree_mouseClick(event:MouseEvent):void
		{
			if (event.target is TextField)
			{
				var ar:Array = (event.target as TextField).text.split(" ");
				
				var guiComp:PYComponent = getComponentFromClient(ar[1])
				// nel caso di sfl: non gestito per ora
				if ( ! guiComp ) return;
				
				// marchio il componente selezionato
				modifyItemsSelected = [];
				modifyItemsSelected[0] = guiComp;
				
				// control panel
				updateControlPanel();

				activateInstancePropertiesWindow(guiComp);
				// disegno componente sul ragno
				if (RagnoManager.getInstance().ragnoActive
					||  RagnoManager.getInstance().trackActive) RagnoManager.getInstance().selectComponentToDraw(guiComp);
				
				// imposto la grid di stile;
				reloadStyleWindowDataGrid( String(ar[0]).split(':')[0], guiComp.style );
				componentTextInput.text = String(ar[0]).split(':')[0]
				styleTextInput.text = guiComp.style 
				
				// imposto la grid instance
				reloadInstanceAttributesWindow(componentTextInput.text,  ar[1] , styleTextInput.text, guiComp);
			}
		}
		
		
		private function getComponentFromClient(name:String):PYComponent
		{
			// TEMPORANEO: 201212 - PER ORA USIAMO ANCORA OBJECT VECTORS
			// PERCHE IL LOOP NON PESCAVA BASECOLUMNS ETC
			// OCCHIO CHE IL LOOP NON DOVRA ANDARE SULLE SINGOLE RIGHE DI SFL
			
			return _objectsVector[name]
			
			
			for each (var dspf in objectsVector["AREA"].getChildren())
			{
				if (dspf is PYComponent && name.indexOf(dspf.name)>-1)
				{
					for each (var fmt in dspf.getChildren())
					{
						if (fmt is PYComponent ) // && name.indexOf(fmt.name)>-1)
						{
							for each (var fld in fmt.getChildren())
							{
								if (fld is PYComponent && name.indexOf(fld.name)>-1)
								{
									return fld
								}
							}
						}
					}
				}
			}
			return null
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/////////////////////////////////////////////////////////////////////////////////
		///////////////////// dynamic List  FUNCTIONS /////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/////////////////////////////////////////////////////////////////////////////////
		///////////////////// dynamic List  FUNCTIONS /////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 
		 * 
		 * 
		 */
		
		private var itemToUpdate:*
		private var attrToUpdate:String
		private var originWin:PCWindowNew
		private var originWinWidth:Number
		private var funcToExecute:Dictionary = new Dictionary()
		
		private function showDynamicList(type:*, parentPcWindow:PCWindowNew, itemToSelect:String, f:Function, compClass:String="", value:String=null, addCreateDelete:Boolean=true):void
		{
			//// Controllo per eliminare il COlorChooser se esiste
			if(originWin) originWin.hideDynamicList()
			
			originWin = parentPcWindow
			originWinWidth = originWin.width
			funcToExecute[originWin.title] = f
			// serve per far sparire eventuali liste dinamiche	
			originWin.stage.addEventListener(MouseEvent.CLICK, hideDyn)
			
			if (type is String)
			{
				
				// da implementare il suo dataprovider (fontFamily)
				if (type == "fonts")
				{
					
					return;
				}
				
				if (type=="components")
				{
					var ar:Array = ComponentsManager.getInstance().getComponentNames() 
					ar.splice(0, 0, "global" )
					originWin.dynamicList.dataProvider = new ArrayCollection(ar);
				}
				else if (type=="styles")
				{
					var newDataProvider:ArrayCollection = new ArrayCollection(DefaultsManager.getInstance().getStylesList( compClass ));
					
					// MAD 051114: Aggiunto nuovo parametro per scegliere se mostrare le opzioni di cancellare/creare stile o meno
					//	Utile per nasconderle quando mostra gli style dei subComponent
					if (addCreateDelete)
					{
						newDataProvider.addItemAt("<cancella stile>", 0);
						newDataProvider.addItemAt("<nuovo stile>", 0);						
					}
					newDataProvider.addItemAt("<nessuno>", 0);
					originWin.dynamicList.dataProvider = newDataProvider
				}
				else if (type == "keywords")
				{
					var keywordsDataProvider = new ArrayCollection(DefaultsManager.getInstance().getGlobalStyles());
					originWin.dynamicList.dataProvider = keywordsDataProvider;
				}
				else if (type == "attribute")
				{
					//var ar:Array = ComponentsManager.getInstance().getGlobalProperties();
					var ar:Array = ComponentsManager.getInstance().getComponentAttributesV2('global');
					var a:Array= new Array()
					for (var i:int=0; i<ar.length; i++)
					{
						a.push(ar[i].property);
					}
					originWin.dynamicList.dataProvider = new ArrayCollection(a);
				}
				else // è il nome di un itemrenderer
				{
					var pyc:PYComponent = new PYComponent();
					pyc.percentHeight = 100;
					pyc.width = 670;
					var p:PYBoxColorChooser = new PYBoxColorChooser();
					oldColor				= value;
					p.data					= DefaultsManager.getInstance().getColors();   // xmlColors  colori;
					p.scrollBarStyle		= "ComposerStyle:TransformScrollBar";					
					pyc.addChild(p);
					pyc.drawComponent(true);
					p.defer(3,applyColor,true);
					originWin.addContent(pyc);
					
					p.addEventListener(PYColorChooserEvent.CHANGE_COLOR,updatecolor);   
					
					function applyColor():void
					{
						p.color = value;
					}
					// colore è itemtoselect
					// passare anche array colori
					//var index:int = (originWin.dynamicList.dataProvider as ArrayCollection).source.indexOf(itemToSelect);
					//originWin.dynamicList.selectedIndex = index;
					originWin.showDynamicList()
					originWin.innerComp.addEventListener(MouseEvent.CLICK, onDynamicList, true, 1000000);
					originWin.dynamicList.getFocus();
					return
				}				
			}
			else if (type is Array)
			{
				originWin.dynamicList.dataProvider = new ArrayCollection(type );
			}
			// MAD 131114: indexOf su un Array usa Strict Equality 
			var index:int = (originWin.dynamicList.dataProvider as ArrayCollection).source.indexOf(itemToSelect);
			if (type=="components" || type=="styles")
			{
				var correctString:String = ((itemToSelect=="global" && type=="components")? "global" : "%: "+itemToSelect);
				index = indexOfPartialStringInArray(correctString,(originWin.dynamicList.dataProvider as ArrayCollection).source);
			}
			
			originWin.showDynamicList();
			originWin.dynamicList.addEventListener(MouseEvent.CLICK, onDynamicList, true, 1000000);
			originWin.dynamicList.getFocus();
			
			originWin.dynamicList.callLater(delayedPosition,[index]);
			
			function delayedPosition(index:int):void
			{
				originWin.dynamicList.selectedIndex = index;
				if (index>-1) originWin.dynamicList.callLater(originWin.dynamicList.scrollToIndex,[index]);
			}
			
		}
		
		// MAD 131114: Poi vediamo se lo passiamo a una classe dal package it.prodigyt.utils
		protected function indexOfPartialStringInArray(string:String, array:Array, fromIndex:int=0):int
		{
			var strictStart:Boolean = true;
			var strictEnd:Boolean	= true;
			if (string.substr(0,1)=="%")
			{
				string = string.substr(1,string.length);
				strictStart = false;
			} else {
				string = "ʘ·ʘ" + string;
			}
			if (string.substr(-1)=="%")
			{
				string = string.substr(0,string.length-1);
				strictEnd = false;
			} else {
				string += "ʘ·ʘ";
			}
			array = array.slice(fromIndex);
			var longanizas:String = array.join("ʘ·ʘ");
			var longaniza:String = (longanizas.indexOf(string)!=-1)? longanizas.split(string)[0] : "";
			var index:int = (longaniza!="")? longaniza.split("ʘ·ʘ").length-1 : -1;
			return index;
		}
		
		
		protected function updatecolor(event:PYColorChooserEvent):void
		{
			
			
			if (PYColorChooserEvent(event).index >-1 && ConnectionsPack.getInstance().useIndexedColors) 
			{
				var coco = PYColorChooserEvent(event).index
				//DefaultsManager.getInstance().setColors(PYBoxColorChooser(event.currentTarget).data )
				
			}
			else coco = event.target.color
			//var coco = event.target.color	
			// MAD 20150105: Sostituito PYColorChooserBasic per PYColorHolder
			//				if(event.target is PYColorChooserBasic ) funcToExecute[originWin.title](String(cvtToHex("0x"+coco.toString(16))), false)
			if(event.target is PYColorHolder) funcToExecute[originWin.title](String(cvtToHex("0x"+coco.toString(16))), false)
			
			
			
		}		
		
		
		
		private function hideDynamicList(originWin:PCWindowNew):void
		{
			if (!originWin.dynamicList.stage) return 
			// serve per far sparire eventuali liste dinamiche	
			originWin.stage.removeEventListener(MouseEvent.CLICK, hideDyn)	
			originWin.dynamicList.removeEventListener(MouseEvent.CLICK, onDynamicList, true);
			originWin.hideDynamicList()
			funcToExecute[originWin.title]= null; 	
			
			
			//
			
			
		}
		
		
		/**
		 * 
		 * Gestione della selezione di un elemento 
		 * 
		 */
		
		private function onDynamicList(event:MouseEvent):void
		{			
			var originWin:PCWindowNew;
			var pybcc:PYBoxColorChooser;
			if (event.target is UITextField && !(event.target.owner is PYDatagrid) )
			{
				originWin = DisplayObject(event.target).stage.nativeWindow as PCWindowNew
				funcToExecute[originWin.title]( (event.target as UITextField ).text )
			}
			
			if ( (event.target is PYLabel 
				&& 	((event.target as PYLabel).name.toLowerCase()=="ok" || (event.target as PYLabel).name=="cancel" ) ) )
			{
				originWin = DisplayObject(event.target).stage.nativeWindow as PCWindowNew
				pybcc = event.currentTarget.getChildAt(0) as PYBoxColorChooser;
				
				if ( (event.target as PYLabel).name.toLowerCase()=="ok"  ) pybcc.defer(0,upDateColorXml);
				else pybcc.defer(0,upDateColorXmlBack);
				
			}
			
			if  ( (event.target is TextField 
				&& 	((event.target as TextField).text.toLowerCase()=="ok"  || (event.target as TextField).text=="CANCEL" ) ) )
			{
				originWin = DisplayObject(event.target).stage.nativeWindow as PCWindowNew
				pybcc = event.currentTarget.getChildAt(0) as PYBoxColorChooser;
				
				if ( (event.target as TextField).text.toLowerCase()=="ok"  ) pybcc.defer(0,upDateColorXml);
				else  pybcc.defer(0,upDateColorXmlBack);
				
			}
			
			function upDateColorXml():void
			{
				DefaultsManager.getInstance().setColors( pybcc.data )
				funcToExecute[originWin.title]( ConnectionsPack.getInstance().useIndexedColors ? pybcc.index : pybcc.color )
				originWin.hideDynamicList();
			}
			function upDateColorXmlBack():void
			{
				funcToExecute[originWin.title](oldColor)
				originWin.hideDynamicList();
				
			}
			
			//// se ho cambiato attributo apro un'altra dunamic list con gli enumerate o setto a "" la cella attrValue
			if (originWin!=null && originWin.title=='Keywords' && cellColumnIndex==3)
			{
				
				
				var att:String=originGrid.dataProvider[cellRowIndex]['attributo'].toString();
				//var commonAttribute:XML = ComponentsManager.getInstance().components.commonAttr.attr.(@name==att)[0];
				
				
				var a:Array=ComponentsManager.getInstance().getComponentAttributesV2('global');
				var enumerate:Array=new Array();
				
				var enumerateExist:Boolean=false;
				for (var i:int=0; i<a.length; i++)
				{
					if(a[i].property==att && a[i].enumerate.length>0)
					{
						for (var j:int=0; j<a[i].enumerate.length; j++)
						{
							enumerate.push(a[i].enumerate[j]);
							if(a[i].enumerate[0]!="")enumerateExist=true;
						}
						
					}
				}
				
				
				
				if (enumerateExist==true && enumerate.length>0)	
				{
					dontCloseDynamicList = true;
					originGrid.dataProvider[cellRowIndex]['attrValue']=enumerate[0];
				}
				else if (att=="backgroundImage") // Nelle keywords non ci sarano altre Image
				{
					// la setto a vuoto nel caso l'utente non selezioni nessuna immagine
					originGrid.dataProvider[cellRowIndex]['attrValue']=" ";
					event.preventDefault();
					
					
					imgFileReference = new FileReference();
					imgFileReference.addEventListener(Event.SELECT, onImageSelected);
					var imgTypeFilter:FileFilter = new FileFilter("Image Files","*.png; *.jpg;*.gif");
					imgFileReference.browse([imgTypeFilter]);
					
					imageDatagrid = keywordsGrid;
				}
				else
				{
					//// simulo il click della cella ////
					originGrid.dataProvider[cellRowIndex]['attrValue']=" ";
					//
					var evt:DataGridEvent= new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGINNING);
					evt.columnIndex=4;
					evt.rowIndex=cellRowIndex;
					evt.dataField = (event.target as UITextField ).text;
					
					keywordsGrid.dispatchEvent(evt);
				}
				
				updateKeiwordsProject(cellRowIndex);
				
			}
		}
		
		
		protected function updateKeiwordsProject(_cellRowIndex:int):void
		{
			KeywordsManager.getInstance().setKeywordStyle(
				originGrid.dataProvider[_cellRowIndex]['keyword'],
				originGrid.dataProvider[_cellRowIndex]['value'],
				originGrid.dataProvider[_cellRowIndex]['component'],
				originGrid.dataProvider[_cellRowIndex]['attrValue'],
				originGrid.dataProvider[_cellRowIndex]['attributo']
				
			);
			
			DefaultsManager.getInstance().keywordsSection = KeywordsManager.getInstance().keywords;
			DefaultsManager.getInstance().keywordsSectionRich = KeywordsManager.getInstance().keywordsRich
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////  CARICAMENTO IMMAGINI  //////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		/**
		 * 
		 * 
		 * 
		 */
		private function onImageSelected(event:Event):void
		{
			var baseDir:String 	= ConnectionsPack.getInstance().baseDirectory;
			var imgDir:String 	= ConnectionsPack.getInstance().imageDirectory;
			var imgFile:File	= File.documentsDirectory.resolvePath((event.target as File).nativePath);
			var imgUrl:String	= imgFile.url;
			
			// Alcuni clienti aggiungono "/" alla fine della imgDir, altri no... standardiziamo.
			if (imgDir.substr(-1)=="/")	imgDir = imgDir.substr(0,imgDir.length-1);
			
			// Il PanelComposer lavora con immagini locali, per cui, dobbiamo gestire qua una imgDir con http: o https: 
			if (imgDir.substr(0,7)=="http://" || imgDir.substr(0,8)=="https://")
			{
				var indx:int = imgDir.indexOf("/assets/");
				if (indx>-1)
				{
					// Ha un "/assets/" in questo indirizzo, quindi rendiamo la parte del path prima
					//	 di questo "/assets/" equivalente al "ProdigytClient" dei documenti locali.
					imgDir = imgDir.substr(indx);
				} else {
					// Non c'è modo di ricavare la corrispondenza tra la cartella remota e quella locale.
					// Storicamente e per analogia a solito "assets/demo", le due ultime cartelle del path 
					//	dovrebbero corrispondere con quelle che si trovano nel ProdigytClient. 
					// Ma è solo una convenzione. Altrimenti, potremmo lanciare un alert e chiedere il path.
					var c:int = 0;
					indx = imgDir.length;
					while (c<2)
					{
						if (imgDir.substr(--indx,1)=="/") c++;
					}
					// Ad es.: http://www.touch400.com/test/pydemo/imgs/demo -> imgs/demo
					imgDir = imgDir.substr(indx+1);
				}
			}

			// Normalizzare la imgDir (alcuni la scrivono con "/" iniziale, altri senza)
			if (imgDir.substr(0,1)=="/") imgDir = imgDir.substr(1,imgDir.length-1);

			var fileReference:FileReference = event.target as FileReference;    
			var imgByteArray:ByteArray = fileReference["data"];
			if (imgUrl.indexOf(baseDir+"/"+imgDir+"/")>-1)
			{
				imgUrl = imgUrl.split(baseDir+"/"+imgDir+"/").join("");
			}
			// IMPL TUTTI Composer 2016-10-12 AM Copiare sempre le immagini che non siano nella imgDir
			//	Prima copiava solo quelle fuori della ProdigytClient
//			else if (imgUrl.indexOf(baseDir+"/")>-1)
//			{
//				imgUrl = imgUrl.split(baseDir+"/").join("");
//			}
			
			if (imgUrl.substr(0,8)=="file:///")
			{
			 	// Ha selezionato una immagine fuori della cartella ProdigytClient (baseDir) / imgDir.
				var newFile:File = File.documentsDirectory.resolvePath(baseDir + "/" + imgDir + "/" + fileReference.name);
				if (newFile.exists)
				{
					alert 				= new PYAlert(_client.clientShell.stage,"Esiste già un file con questo nome in " + imgDir, 'Avviso',['OK']);
					alert.boxStyle		= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
					alert.buttonStyle	= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
					// Non va più avanti perché non sapiamo se quella che esiste già è quella che vuole o meno.
					// Cioè, lo forziamo a scegliere l'immagine dalla propria cartella assets nella ProdigytClient
					return;
				}
				else
				{
					//	La copiamo nella imageDirectory (baseDir+"/"+imgDir) e conserviamo solo il nome dell'immagine.
					imgFile.copyTo(newFile,false);
					imgUrl = fileReference.name;
				}
			}
			imagePropertyValue = imgUrl;
			
			if (imageDatagrid.name == "Stile")
			{
				updateImageProperty(imageDatagrid, imageDatagrid.selectedItem.property, imagePropertyValue, componentTextInput.text, styleTextInput.text);
				projectModified = true;
				saveBackup();
			}
			else if (imageDatagrid.name == "Istanza")
			{
				// BUG ALL Se seleziona componente dalla finestra Schema
				//	prima di attivare modifiche pannello, l'applicazione 
				// 	non localizza il componente selezionato.
				var selectedComponent:PYComponent = (RagnoManager.getInstance().selectedComponent!=null)?
														RagnoManager.getInstance().selectedComponent
														:
														objectsVector[outlineTree.selectedItem.@name.toString()];
				
				// MAD 2015-10-22: Error #1009: Cannot access a property or method of a null object reference.
				//	quindi... aggiunto il controllo !=null (non dovrebbe capitare, ma...)
				if (selectedComponent!=null)
				{
					// MAD 2015-07-24 A questo punto non sapiamo se l'immagine verrà caricata subito o meno, 
					//	aggiungiamo un listener per aggiornare i dati quando avrà finito di caricare
					var maybe:* = (CacheBitmapManager.getInstance() as CacheBitmapManager).getImage(imgFile.url);
					
					function bitmapLoadedHandler(event:PYEvent):void
					{
						event.currentTarget.removeEventListener(PYEvent.BITMAP_LOADED,bitmapLoadedHandler);
						refreshInstanceGrid();
					}
					function refreshInstanceGrid():void
					{
						if (PYComponent(selectedComponent).suspended)
						{
							if (selectedComponent is IMeasurable)
								IMeasurable(selectedComponent).drawContainer();
							else
								PYComponent(selectedComponent).drawComponent();
						}
						modifyXmlGuiAttribute(selectedComponent, imageDatagrid.selectedItem.property, imagePropertyValue);
						reloadInstanceAttributesWindow(getQualifiedClassName(selectedComponent).split("::")[1], selectedComponent.name, selectedComponent.style, selectedComponent);
					}

					selectedComponent[imageDatagrid.selectedItem.property] = imagePropertyValue;
					if (maybe==null || maybe==undefined)
					{
						selectedComponent.addEventListener(PYEvent.BITMAP_LOADED,bitmapLoadedHandler);
					} else {
						refreshInstanceGrid();
					}
				}
			}
			
			//				imgFileReference.addEventListener(Event.COMPLETE, onImageLoaded);
			//			    imgFileReference.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
			//			    imgFileReference.load();			
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		private function onImageLoaded(event:Event):void
		{
			imgFileReference.removeEventListener(Event.COMPLETE, onImageLoaded);
			imgFileReference.removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
			
			var fileReference:FileReference = event.target as FileReference;    
			var imgByteArray:ByteArray = fileReference["data"];
			imagePropertyValue = fileReference.name;
			
			var imageDirectory:String = DefaultsManager.getInstance().defaults.skinProperties.@imgDir;
			var imageFile:File = new File(File.applicationDirectory.nativePath + File.separator + imageDirectory + fileReference.name);
			
			// salvataggio su disco (nella directory delle immagini) senza interazione con l'utente
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(Event.CLOSE, closeHandler);
			imageFile.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			function closeHandler(event:Event):void
			{
				fileStream.removeEventListener(Event.CLOSE, closeHandler);
				imageFile.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				
				
				if (imageDatagrid.name == "Stile")
				{
					updateImageProperty(imageDatagrid, imageDatagrid.selectedItem.property, imagePropertyValue, componentTextInput.text, styleTextInput.text);
				}
				if (imageDatagrid.name == 'Keywords')
				{
					imageDatagrid.dataProvider[cellRowIndex]['attrValue']=imagePropertyValue;
					imageDatagrid.dataProvider.refresh();
					
					updateKeiwordsProject(cellRowIndex);
				}
				
			}
			
			function ioErrorHandler(event:IOErrorEvent):void
			{
				fileStream.removeEventListener(Event.CLOSE, closeHandler);
				imageFile.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				trace("IOErrorEvent " + event.errorID);
			}
			
			try
			{
				fileStream.openAsync(imageFile, FileMode.WRITE);
				fileStream.writeBytes(imgByteArray);
				fileStream.close();
			}
			catch (e:Error) { trace(e.message); }
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		private function updateImageProperty(datagrid:PYDatagrid, property:String, value:String, componentName:String=null, style:String=null):void
		{
			if (datagrid.name == "Stile")
			{
				DefaultsManager.getInstance().setStyleDefault(componentName, property, value, style);
				// applico stile modificato a tutti i componenti coinvolti
				applyStyleToGui( componentName, style )
				drawWholeArea()
			}
			
			// in caso di defaults aggiorno la gui e riaggiorno il projectdata corrente
			projectData = rebldProjectData();			
			// aggiorno la grid
			(datagrid.dataProvider as ArrayCollection).refresh();
			if (datagrid.name == "Stile")
			{
				reloadStyleWindowDataGrid( componentName, style );
			}
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		private function onImageLoadError(event:Event):void
		{
			imgFileReference.removeEventListener(Event.COMPLETE, onImageLoaded);
			imgFileReference.removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
			
			//Alert.show("Impossibile importare l'immagine per un errore occorso durante il caricamento", "Errore");
			alert=new PYAlert(_client.clientShell.stage,"Errore nel caricamento dell immagine.", 'Avviso',['OK']);
			alert.boxStyle= _client.cleanSplashStyle + ":RiquadroAvvertenza"; // OLD:BoxAlert
			alert.buttonStyle= _client.cleanSplashStyle + ":PulsanteAvvertenza"; // OLD:ButtonAlert
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		///////////////////// ///////////////////// ///////////////////// 
		///////////////////// UNDO FUNCTIONS /////////////////////////////////
		///////////////////// ///////////////////// ///////////////////// 
		
		
		
		
		
		
		
		
		
		
		private var whichUndoGrid:Object
		private var whichUndoItem:Object
		private var rClickGrid:Object;
		private var rClickItem:Object;
		
		private var utilityControls:PYNbox;
		private var utilityMenuVBox:PYNbox;
		private var isPanelManagement:Boolean;
		private var panelNamesProgress:int;
		
		// MAD 2016-12-14 Vecchio undo / redo
//		private function undoRedo(op:String)
//		{
//			
//			if (op == "Annulla" ) var operations:Array = UndoManager.getInstance("").undo()
//			if (op == "Ripristina" ) var operations:Array = UndoManager.getInstance("").redo() 
//			
//			for each (var operation:Object in operations)
//			{
//				
//				var dg:PYDatagrid = operation.component	
//				var newVal = op == "Annulla" ? operation.originalValue : operation.finalValue	
//				switch (operation.attribute)
//				{
//					
//					case "style":
//						// non deve fare assolutamente niente !!!!
//						break;
//					
//					case "backgroundColor":
//					case "borderColor":
//					case "foregroundColor":
//					case "highColor":
//					case "highLightColor":
//					case "iconColor":
//					case "itemBackColor":	
//					case "itemOverBackColor":
//					case "lineColor":
//					case "selectedColor":
//					case "separatorColor":
//					case "textColor":
//					case "toColor":
//						
//						newVal = cvtToHex(newVal)
//						
//						// niente break: esegue le successive
//						
//						
//					default:
//						
//						if (dg == styleGrid)
//						{
//							////////
//							if (componentTextInput.text != operation.compClass
//								||  styleTextInput.text != operation.style )
//							{
//								componentTextInput.text = operation.compClass
//								styleTextInput.text = operation.style 
//								reloadStyleWindowDataGrid(componentTextInput.text , styleTextInput.text)		
//							}
//							
//							DefaultsManager.getInstance().setStyleDefault(
//								operation.compClass,
//								operation.attribute,
//								newVal,
//								operation.style)
//							// applico stile modificato a tutti i componenti coinvolti
//							applyStyleToGui( componentTextInput.text, styleTextInput.text )
//							drawWholeArea()
//							// riaggiorno il projectdata corrente
//							projectData = rebldProjectData()
//						}	
//							
//						else if (dg == instanceGrid)
//						{	
//							var pycomp:PYComponent = objectsVector[operation.compName] as PYComponent;							
//							
//							if (pycomp != operation.compClass
//								||  styleTextInput.text != modifyItemsSelected[0] )
//							{
//								modifyItemsSelected[0] = pycomp;
//								reloadInstanceAttributesWindow( operation.compClass, pycomp.name, pycomp.style, pycomp );		
//							}
//							
//							//if (operation.attribute=="style") PYComponent(comp).clearAttributes();
//							
//							// debug 13 marzo: applicazione diretta della modifica al componente
//							if (pycomp[operation.attribute] is Boolean && newVal=="false" ) 
//								pycomp[operation.attribute] =  false 
//							else if (pycomp[operation.attribute] is Boolean && newVal=="true" ) 
//								pycomp[operation.attribute] =  true
//							else if (! (pycomp[operation.attribute] is Boolean) ) 
//								pycomp[operation.attribute] = newVal;
//							
//							// aggiorno l'xml dell'instanceManager
//							modifyXmlGuiAttribute(pycomp, operation.attribute, newVal);
//							
//							// AGGIORNO IL RAGNO SE ATTIVO
//							if (RagnoManager.getInstance().ragnoActive) RagnoManager.getInstance().updateFromTarget();
//							
//							// AGGIORNO IL PHANTOM SE ATTIVO
//							if (RagnoManager.getInstance().trackActive) RagnoManager.getInstance().updateTrackingFromTarget();			
//						}	
//						
//						// riscrivo il valore del colore riformattato nel datagrid
//						for (var i:int=0; i<dg.dataProvider.length; i++)
//						{
//							if (dg.dataProvider.getItemAt(i).property==operation.attribute )
//							{
//								dg.dataProvider.getItemAt(i).value = newVal;
//								if (dg == instanceGrid)
//									setCellColor(dg.dataProvider[i],  operation.compClass ,  operation.compName,  operation.style )
//								dg.dataProvider.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE))		
//								dg.invalidateProperties();
//								dg.invalidateDisplayList();
//								break;
//							}
//						}
//						break;
//				}	
//				
//				
//			}
//		}
		
		
		
		
		
		
		////////////////////////////////////////////////////////////////////////////////////
		/////////////////////   GUI  FUNCTIONS         /////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		private function reapplyInstanceToGui(gui:PYComponent=null):void
		{
			
			
			
			
			return; // !!!!!!SOSPESISSIMO!!!!!!!!
			
			
			
			
			// se l'applicazione non è ancora stata caricata
			if (gui==null)
				return;
			
//			// se il componente è lui, e lo stile è lo stesso, forzo lo stile per provocare draw del componente
//			if ( getQualifiedClassName(gui).split("::")[1] == compName && gui.style == style
//				|| "global" == compName && gui.style == style)
//			{
//				//gui.clearAttributes()
				gui.style = gui.style;
				// dopodiché applico gli attributi d'istanza
				// e manuali per rispetto della gerarchia
				applyInstanceToGui(gui);
				//				if (gui.suspended)
				//				{
				//					if (gui is IMeasurable)
				//						IMeasurable(gui).drawContainer()
				//					else
				//						gui.drawComponent()
				//				}
				//trace("---COMPOSER: style appliced to:", gui, gui.name, " style:",style )	
//			}
			
			if (gui.numChildren == 0)
				return;
			
			// loop all'nterno
			for (var i:int=0; i<gui.getChildren().length; i++)
			{
				if (gui.getChildAt(i) is PYComponent)
				{
					reapplyInstanceToGui( gui.getChildAt(i) as PYComponent );
				}
			}	
		}

		
		
		
		
		private function applyStyleToGui(compName:String, style:String, gui:PYComponent=null):void
		{
			if (!gui) gui = objectsVector["DESKTOP"];
			// se l'applicazione non è ancora stata caricata
			if (!gui)
				return;
			
			// se il componente è lui, e lo stile è lo stesso, forzo lo stile per provocare draw del componente
			if ( getQualifiedClassName(gui).split("::")[1] == compName && gui.style == style
				|| "global" == compName && gui.style == style)
			{
				//gui.clearAttributes()
				gui.style = style
				// dopodiché applico gli attributi d'istanza
				// e manuali per rispetto della gerarchia
				applyInstanceToGui(gui);
				//				if (gui.suspended)
				//				{
				//					if (gui is IMeasurable)
				//						IMeasurable(gui).drawContainer()
				//					else
				//						gui.drawComponent()
				//				}
				//trace("---COMPOSER: style appliced to:", gui, gui.name, " style:",style )	
			}
			
			if (gui.numChildren == 0)
				return;
			
			
			// loop all'nterno
			for (var i:int=0; i<gui.getChildren().length; i++)
			{
				if (gui.getChildAt(i) is PYComponent)
				{
					applyStyleToGui( compName, style, gui.getChildAt(i) as PYComponent )
				}
			}	
		}
		
		
		private function applyInstanceToGui(component:PYComponent):void
		{
			// RUG - SOSPESA DOPO MERGE MODIFICHE ALEX PERCHE SVUO0TA IL DISPLAYFILE
			// AGGIORNAMENTO 200117: NN VA BENE, PERCHE MANCANO LE IMPOSTAZIONI DEGLI ATTRIBUTI DI RUNTIME
			// INFATTI SE AGGIORNO UN FORMATO, QUESTO SCOMPARE PERCHE DI DEFAULT è INVISIBILE, E VIENE MESSO VISIBILE IN RUNTIME
			// PER REGOLA LO SVILUPPATORE DOVRA SEMPRE FARE INDIETRO AVANTI - FUNZIONE DISATTIVATA -
			
			if (component!=null)
				component.applyManuals()
					
					
			return;
			
			var exml:XML = InstanceManager.getInstance().getElement(component.name);
			var axml:XML = InstanceManager.getInstance().getAllManualElement(component.name);
			apply( exml );
			apply( axml ); 
			
			function apply(xml:XML):void
			{
				if (xml==null) return;
				
				for each (var attribute:XML in xml.attributes())
				{
					var attrName:String = attribute.localName().toString();
					var value:String = attribute.toString();
					
					if (!component.hasOwnProperty(attrName) || attrName=="name" || attrName=="style") continue;
					
					var attr:* = component[attrName];
					if (attr is Boolean)
					{
						component[attrName] = value == "true";
					}
					else if (attr is Number)
					{
						component[attrName] = Number(value);
					}
					else if (attr is uint)
					{
						component[attrName] = uint(value);
					}
					else if (attr is int)
					{
						component[attrName] = int(value);
					}
					else if (attr is String)
					{
						component[attrName] = String(value);
					}
					else
					{
						component[attrName] = value;
					}
				}
			}
		}
		
		
		
		
		/**
		 * 
		 * Modifica l'xml convertito dal DSPF dal Converter.
		 * 
		 */
		public function modifyXmlGuiAttribute(component:PYComponent, attribute:String, value:*):void				// <== BAD, BAD DOG !!!
		{
			xmlGuiModified = true;
			
			var nome:String
			
			if (isPanelManagement)
			{
				InstanceManager4Panels.getInstance().setManualAttributeForPanel(component.name, attribute, value, component.name )
				
				// speciale tabella!!!
				// se modificato il testo della costante di una colonna, lo stesso va messo nel campo tempText della colonna parente
				if (component is Constant && component.parent is BaseColumnV2 && attribute == "text")
				{
					InstanceManager4Panels.getInstance().setManualAttributeForPanel(component.parent.name, "tempText", value, component.name )
				}
			}
			else
			{
				// NEW - v4.2 - 151116 - MODIFICHE MANUALI ALLA RIGA
				if ( component !=null && component.parent && component.parent.parent is SflRow)
					nome = component.name.substr(0, component.name.indexOf("_")) + "_0_" + component.name.substr(component.name.lastIndexOf("_")+1)
				// bug - eco87 - 200117 - GRAVISSIMO!!! - non memorizzava piu l attributo manualSet della header di tabella, quindi non riapplicava piu le modifiche manuali
//				else if( component.name.indexOf("_") >-1 )
//					nome = component.name.substr(0, component.name.indexOf("_")) + "_" + component.name.substr(component.name.lastIndexOf("_")+1)
				else 
					nome = component.name
						
				InstanceManager.getInstance().setManualAttribute(nome, attribute, value )
				
				// speciale tabella!!!
				// se modificato il testo della costante di una colonna, lo stesso va messo nel campo tempText della colonna parente
				if (component is Constant && component.parent is BaseColumnV2 && attribute == "text")
				{
					InstanceManager.getInstance().setManualAttribute(component.parent.name, "tempText", value )
				}
			}
			
			
			
//			
//			InstanceManager.getInstance().setManualAttribute(component.name, attribute, value )
//			
//			// speciale tabella!!!
//			// se modificato il testo della costante di una colonna, lo stesso va messo nel campo tempText della colonna parente
//			if (component is Constant && component.parent is BaseColumnV2 && attribute == "text")
//			{
//				InstanceManager.getInstance().setManualAttribute(component.parent.name, "tempText", value )
//			}
			
		}
		
		
		
		
		/**
		 * 
		 * va in ascolto delle modifiche alla tabella.
		 * 
		 */
		protected function setTableListeners(obj:PYComponent):void			
		{
			if (obj is BaseHeaderV2)
			{
				obj.addEventListener( HeaderV2Event.SEND_STRUCTURE, changeTableHeaders)
			}
			if (obj is BaseTableV2)
			{
				obj.addEventListener( HeaderV2Event.SEND_COLUMNS, changeTableHeaders );
				BaseTableV2(obj).modifiable = true
			}
			var ch:Array = obj.getChildren()
			for each (var obj2 in ch)
			{
				if (obj2 is PYComponent) setTableListeners(obj2)
				
			}
		}
		
		
		
		
		/**
		 * 
		 * resetta tabeller.
		 * 
		 */
		protected function removeTableListeners(obj:PYComponent):void			
		{
			if (obj is BaseHeaderV2)
			{
				obj.removeEventListener( HeaderV2Event.SEND_STRUCTURE, changeTableHeaders)
			}
			if (obj is BaseTableV2)
			{
				obj.removeEventListener( HeaderV2Event.SEND_COLUMNS, changeTableHeaders );
				BaseTableV2(obj).modifiable = false
			}
			var ch:Array = obj.getChildren()
			for each (var obj2 in ch)
			{
				if (obj2 is PYComponent) removeTableListeners(obj2)
				
			}
		}
		
		
		protected function changeTableHeaders(event:HeaderV2Event):void
		{
			modifyXmlGuiAttribute(event.target as PYComponent, "manualSet", "true");
			
			for each (var col:BaseColumnV2 in event.columns)
			{
				// Update XML (via Dictionary)
				modifyXmlGuiAttribute(col, "x", col.x);
				modifyXmlGuiAttribute(col, "y", col.y);
				modifyXmlGuiAttribute(col, "width", col.width);
				modifyXmlGuiAttribute(col, "manualWidth", col.manualWidth);
				modifyXmlGuiAttribute(col, "height", col.height);
				modifyXmlGuiAttribute(col, "row", col.row);
				// Attributi di menu contestuale
				modifyXmlGuiAttribute(col, "sort", col.sort);
				//modifyXmlGuiAttribute(col, "filterText", col.filterText); - rug read only. va salvata???
				modifyXmlGuiAttribute(col, "hide", col.hide);
				modifyXmlGuiAttribute(col, "formula", col.formula);
			}
			// in caso di compoennti suspende si ridisegna tutto!!!
			if (objectsVector["AREA"].suspended)
			{
				objectsVector["AREA"].suspended = false
				//objectsVector["AREA"].drawImmediate(true)
				objectsVector["AREA"].drawContainer(true)
				objectsVector["AREA"].suspended = true
			}
		}	
		
		
		
		
		
		
		////////////////////////////////////////////////////////////////////////////////////
		/////////////////////   service  FUNCTIONS         /////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		private function hexifyIfNecessary(colorAttribute:String, colorValue:String):String
		{
			var outcome:String;
			if (colorAttribute.indexOf('Color') != -1 &&
				colorAttribute.indexOf('Colors') == -1 &&
				colorAttribute.indexOf('Ratio') == -1 &&
				colorAttribute.indexOf('Alpha') == -1 )
			{								
				outcome = cvtToHex(colorValue);
			}
			else
			{
				outcome = colorValue;
			}
			return outcome;
		}

		private function orderGroup(colorAttribute:String):String
		{
			if (colorAttribute == "style") return "1style"
			else if (colorAttribute == "layout") return "2layout"
			else if (colorAttribute == "text") return "3text"
			else if (colorAttribute == "other") return "4other"
			else return colorAttribute
			
		}	

		private function cvtToHex( input:* ):String
		{
			if (input =="" ) return ""
			
			var hex:String = uint(input).toString(16)
			if (hex.length == 0) hex = "000000"
			if (hex.length == 1) hex = "00000" + hex
			if (hex.length == 2) hex = "0000" + hex
			if (hex.length == 3) hex = "000" + hex
			if (hex.length == 4) hex = "00" + hex
			if (hex.length == 5) hex = "0" + hex
			return  "0x" + hex
		}
		
	}
}