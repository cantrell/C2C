package com.adobe.c2c.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.c2c.commands.CommandResponder;

	public class ReadClipboardEvent extends CairngormEvent
	{
		public static var READ_CLIPBOARD_EVENT:String = "readClipboardEvent";

		public function ReadClipboardEvent()
		{
			super(READ_CLIPBOARD_EVENT);
		}
	}
}
