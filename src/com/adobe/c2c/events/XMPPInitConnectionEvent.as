package com.adobe.c2c.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.c2c.commands.CommandResponder;

	public class XMPPInitConnectionEvent extends CairngormEvent
	{
		public static var XMPP_INIT_CONNECTION_EVENT:String = "xmppInitEvent";

		public var username:String;
		public var password:String;

		public function XMPPInitConnectionEvent()
		{
			super(XMPP_INIT_CONNECTION_EVENT);
		}

	}
}
