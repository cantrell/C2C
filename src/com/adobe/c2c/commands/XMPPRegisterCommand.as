package com.adobe.c2c.commands
{
	import com.adobe.c2c.events.XMPPRegisterEvent;
	import com.adobe.c2c.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	import org.jivesoftware.xiff.core.XMPPSocketConnection;
			
	public class XMPPRegisterCommand implements ICommand
	{
		public function execute(e:CairngormEvent):void
		{
			var xre:XMPPRegisterEvent = e as XMPPRegisterEvent;

			if (xre.username == null || xre.password == null) return;

			var ml:ModelLocator = ModelLocator.getInstance();
			var xmppConnection:XMPPSocketConnection = ml.xmppConnection;
			
			var regInfo:Object = new Object();
			regInfo.username = xre.username;
			regInfo.password = xre.password;
			xmppConnection.sendRegistrationFields(regInfo, null);
		}
	}
}
