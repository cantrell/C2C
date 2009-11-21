package com.adobe.c2c.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.c2c.commands.CommandResponder;

	public class XMPPUpdatePresenceEvent extends CairngormEvent
	{
		public static var XMPP_UPDATE_PRESENCE_EVENT:String = "xmppUpdatePresenceEvent";

		public var presence:String;

		public function XMPPUpdatePresenceEvent()
		{
			super(XMPP_UPDATE_PRESENCE_EVENT);
		}
	}
}
