package com.adobe.c2c.commands
{
	import com.adobe.c2c.events.XMPPAddContactEvent;
	import com.adobe.c2c.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import org.jivesoftware.xiff.core.JID;
	import org.jivesoftware.xiff.core.XMPPSocketConnection;
	import org.jivesoftware.xiff.data.Presence;
			
	public class XMPPAddContactCommand implements ICommand
	{
		public function execute(e:CairngormEvent):void
		{
			var ee:XMPPAddContactEvent = e as XMPPAddContactEvent;

			if (ee.username == null) return;

			var ml:ModelLocator = ModelLocator.getInstance();
			
			//var jid:JID = new JID(ee.username + "@" + ModelLocator.XMPP_HOST + "/" + ModelLocator.XMPP_RESOURCE);
			var jid:JID = new JID(ee.username + "@" + ModelLocator.XMPP_HOST);
			ml.roster.addContact(jid, ee.username, null, true);
		}
	}
}
