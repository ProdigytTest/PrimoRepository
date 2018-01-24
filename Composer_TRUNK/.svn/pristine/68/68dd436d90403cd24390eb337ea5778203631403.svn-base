package comp
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	import it.prodigyt.utils.StringUtils;
	
	public class NativeAppLauncherDirect extends EventDispatcher
	{
		
		protected var process:NativeProcess
		protected var appName:String
		
		public function NativeAppLauncherDirect(appName:String)
		{
			this.appName = appName
			process = new NativeProcess()  
			process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
			process.addEventListener(Event.STANDARD_ERROR_CLOSE, standardErrorClose);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
			process.addEventListener(IOErrorEvent.	STANDARD_ERROR_IO_ERROR, onIOError);
			process.addEventListener(Event.STANDARD_INPUT_CLOSE, standardInputClose);
			process.addEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, onIOError);
			process.addEventListener(ProgressEvent.STANDARD_INPUT_PROGRESS, standardInputProgress);
			process.addEventListener(Event.STANDARD_OUTPUT_CLOSE, standardOutpoutClose);
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
		}
		
		public function execute(file:String):void
		{

			var cmd:File = new File(appName)
			if (!cmd.exists)
			{
				var le:NativeAppLauncherEvent = new NativeAppLauncherEvent(NativeAppLauncherEvent.EXECUTED)
				le.exitCode =  9
				this.dispatchEvent(le )
				return
			}
				
		
			var args:Vector.<String> = new Vector.<String>();                    
			args[0] = file

			
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();                    
			nativeProcessStartupInfo.executable = cmd;
			nativeProcessStartupInfo.arguments = args;
			
			process.start(nativeProcessStartupInfo)
		}
		
		
		public function standardOutpoutClose(evt:Event):void
		{
			trace(standardOutpoutClose);
		}
		
		public function standardInputProgress(evt:ProgressEvent):void
		{
			trace(standardInputProgress);
		}
		
		public function standardInputClose(event:Event):void
		{
			trace(standardInputClose);
		}
		
		public function standardErrorClose(event:Event):void
		{
			trace(standardErrorClose);
		}
		
		public function onOutputData(event:ProgressEvent):void
		{
			trace("Got:" , process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable)); 
		}
		
		public function onErrorData(event:ProgressEvent):void
		{
			trace("ERROR -", process.standardError.readUTFBytes(process.standardError.bytesAvailable)); 
		}
		
		public function onExit(event:NativeProcessExitEvent):void
		{
			trace("Process exited with ", event.exitCode);
			var le:NativeAppLauncherEvent = new NativeAppLauncherEvent(NativeAppLauncherEvent.EXECUTED)
			le.exitCode =  event.exitCode
			this.dispatchEvent(le )
		}
		
		public function onIOError(event:IOErrorEvent):void
		{
			trace(event.toString());
		}
	}
}