package com.adobe.c2c.commands
{
	import com.adobe.c2c.events.CloseConnectionsEvent;
	import com.adobe.c2c.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	import flash.net.NetStream;
	
	import org.jivesoftware.xiff.core.XMPPSocketConnection;
	import org.jivesoftware.xiff.data.Presence;
	
	public class CloseConnectionsCommand implements ICommand
	{
		public function execute(e:CairngormEvent):void
		{
			var ee:CloseConnectionsEvent = e as CloseConnectionsEvent;
			var ml:ModelLocator = ModelLocator.getInstance();
			if (ml.xmppConnection != null && ml.xmppConnection.isActive() && ml.xmppConnection.isConnected())
			{
				var presence:Presence = new Presence(null, null, Presence.UNAVAILABLE_TYPE);
				var xmppConnection:XMPPSocketConnection = ModelLocator.getInstance().xmppConnection;
				xmppConnection.send(presence);
				xmppConnection.disconnect();
				ml.xmppConnection = null;
				if (ml.roster != null)
				{
					ml.roster.refresh();
					ml.roster = null;
				}
			}
			
			if (ml.incomingStreams != null)
			{
				for each (var ns:NetStream in ml.incomingStreams)
				{
					if (ns == null) continue;
					ns.close();
				}
			}

			if (ml.outgoingStream != null)
			{
				ml.outgoingStream.close();
			}
			
			if (ml.netConnection != null)
			{
				ml.netConnection.close();
			}
			
			if (ee.responder != null)
			{
				ee.responder.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}
