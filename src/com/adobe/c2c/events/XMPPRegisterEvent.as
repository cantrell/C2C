package com.adobe.c2c.events
{
	import com.adobe.c2c.commands.CommandResponder;
	import com.adobe.cairngorm.control.CairngormEvent;

	public class XMPPRegisterEvent extends CairngormEvent
	{
		public static var XMPP_REGISTER_EVENT:String = "xmppRegisterEvent";

		public var username:String;
		public var password:String;
		
		public function XMPPRegisterEvent()
		{
			super(XMPP_REGISTER_EVENT);
		}

	}
}
