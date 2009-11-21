package com.adobe.c2c.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.c2c.commands.CommandResponder;

	public class XMPPAddContactEvent extends CairngormEvent
	{
		public static var XMPP_ADD_CONTACT_EVENT:String = "xmppAddContactEvent";

		public var username:String;

		public function XMPPAddContactEvent()
		{
			super(XMPP_ADD_CONTACT_EVENT);
		}
	}
}
