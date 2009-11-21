package com.adobe.c2c.commands
{
	import com.adobe.c2c.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.collections.ArrayCollection;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	
	public class ReadClipboardCommand implements ICommand
	{
		public function execute(e:CairngormEvent):void
		{
			var ml:ModelLocator = ModelLocator.getInstance();
			
			var cb:Clipboard = Clipboard.generalClipboard;
			
			ml.clipboardText = (cb.hasFormat(ClipboardFormats.TEXT_FORMAT)) ? cb.getData(ClipboardFormats.TEXT_FORMAT) as String : "";
			ml.clipboardBitmap = (cb.hasFormat(ClipboardFormats.BITMAP_FORMAT)) ? cb.getData(ClipboardFormats.BITMAP_FORMAT) : null;
			ml.clipboardFiles = (cb.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)) ? new ArrayCollection(cb.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array) : null;
		}
	}
}
