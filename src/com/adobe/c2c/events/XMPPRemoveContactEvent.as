package com.adobe.c2c.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import org.jivesoftware.xiff.data.im.RosterItemVO;

	public class XMPPRemoveContactEvent extends CairngormEvent
	{
		public static var XMPP_REMOVE_CONTACT_EVENT:String = "xmppRemoveContactEvent";
		
		public var rosterItem:RosterItemVO;
		
		public function XMPPRemoveContactEvent()
		{
			super(XMPP_REMOVE_CONTACT_EVENT);
		}
	}
}
