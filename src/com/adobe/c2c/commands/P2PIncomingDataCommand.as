package com.adobe.c2c.commands
{
	import com.adobe.c2c.events.P2PIncomingDataEvent;
	import com.adobe.c2c.events.ReadClipboardEvent;
	import com.adobe.c2c.model.ModelLocator;
	import com.adobe.c2c.vo.OutgoingItem;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	public class P2PIncomingDataCommand implements ICommand
	{
		public function execute(e:CairngormEvent):void
		{
			NativeApplication.nativeApplication.activate();
			
			var ml:ModelLocator = ModelLocator.getInstance();
			var ee:P2PIncomingDataEvent = e as P2PIncomingDataEvent;
			
			if (ee.from == null || ee.clipboardType == null || ee.clipboardData == null) return;
			
			var from:String = ee.from;
			var clipboardType:String = ee.clipboardType;
			var clipboardData:* = ee.clipboardData;
			var arg:* = ee.arg;
			
			Alert.show("Accept incoming " + clipboardType + " from " + from + "?",
					   "Incoming Data",
						Alert.YES|Alert.NO,
						null,
						function (e:CloseEvent):void
						{
							if (e.detail == Alert.NO) return;
							var ml:ModelLocator = ModelLocator.getInstance();
							if (clipboardType == OutgoingItem.TEXT)
							{
								Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, clipboardData);
								ml.clipboardContentsIndex = 1;
							}
							else if (clipboardType == OutgoingItem.FILE)
							{
								var file:File = File.createTempDirectory().resolvePath(String(arg));
								var fs:FileStream = new FileStream();
								fs.open(file, FileMode.WRITE);
								fs.writeBytes(ByteArray(clipboardData));
								fs.close();
								Clipboard.generalClipboard.setData(ClipboardFormats.FILE_LIST_FORMAT, [file]);
								ml.clipboardContentsIndex = 0;
							}
							else if (clipboardType == OutgoingItem.IMAGE)
							{
								var bytes:ByteArray = ByteArray(clipboardData);
								var rec:Rectangle = new Rectangle(arg.x, arg.y, arg.width, arg.height);
								var bitmapData:BitmapData = new BitmapData(rec.width, rec.height);
								bitmapData.setPixels(rec, bytes);
								Clipboard.generalClipboard.setData(ClipboardFormats.BITMAP_FORMAT, bitmapData);
								ml.clipboardContentsIndex = 2;
							}
							new ReadClipboardEvent().dispatch();
						 });
		}
	}
}