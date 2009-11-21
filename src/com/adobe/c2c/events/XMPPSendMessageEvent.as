package com.adobe.c2c.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import org.jivesoftware.xiff.core.JID;

	public class XMPPSendMessageEvent extends CairngormEvent
	{
		public static var XMPP_SEND_MESSAGE_EVENT:String = "xmppSendMessageEvent";

		public var recipient:JID;
		public var message:String;

		public function XMPPSendMessageEvent()
		{
			super(XMPP_SEND_MESSAGE_EVENT);
		}

	}
}
