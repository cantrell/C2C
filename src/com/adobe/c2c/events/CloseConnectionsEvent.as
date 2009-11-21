package com.adobe.c2c.events
{
	import com.adobe.c2c.commands.CommandResponder;
	import com.adobe.cairngorm.control.CairngormEvent;

	public class CloseConnectionsEvent extends CairngormEvent
	{
		public static var CLOSE_CONNECTIONS_EVENT:String = "closeConnectionsEvent";

		public var responder:CommandResponder;

		public function CloseConnectionsEvent()
		{
			super(CLOSE_CONNECTIONS_EVENT);
		}

	}
}
