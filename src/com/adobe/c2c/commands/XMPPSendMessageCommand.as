package com.adobe.c2c.commands
{
	import com.adobe.c2c.events.XMPPSendMessageEvent;
	import com.adobe.c2c.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import org.jivesoftware.xiff.core.XMPPConnection;
	import org.jivesoftware.xiff.data.Message;
	
	public class XMPPSendMessageCommand implements ICommand
	{
		public function execute(e:CairngormEvent):void
		{
			var ee:XMPPSendMessageEvent = e as XMPPSendMessageEvent;
			
			if (ee.recipient == null || ee.message == null) return;
			
			var ml:ModelLocator = ModelLocator.getInstance();
			var xmppConnection:XMPPConnection = ml.xmppConnection;
			
			var message:Message = new Message(ee.recipient, null, ee.message);
			xmppConnection.send(message);
		}
	}
}
