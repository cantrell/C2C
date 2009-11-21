package com.adobe.c2c.controller
{
	import com.adobe.cairngorm.control.FrontController;
	
	public class Controller extends FrontController
	{

		import com.adobe.c2c.events.*;
		import com.adobe.c2c.commands.*;

		public function Controller()
		{
			this.addCommands();
		}
		
		private function addCommands():void
		{
			this.addCommand(InitEvent.INIT_EVENT, InitCommand);
			this.addCommand(P2PInitConnectionEvent.P2P_INIT_CONNECTION_EVENT, P2PInitConnectionCommand);
			this.addCommand(P2PInitStreamEvent.P2P_INIT_STREAM_EVENT, P2PInitStreamCommand);
			this.addCommand(P2PIncomingDataEvent.P2P_INCOMING_DATA_EVENT, P2PIncomingDataCommand);
			this.addCommand(P2POutgoingDataEvent.P2P_OUTGOING_DATA_EVENT, P2POutgoingDataCommand);
			this.addCommand(XMPPInitConnectionEvent.XMPP_INIT_CONNECTION_EVENT, XMPPInitConnectionCommand);
			this.addCommand(CloseConnectionsEvent.CLOSE_CONNECTIONS_EVENT, CloseConnectionsCommand);
			this.addCommand(XMPPRegisterEvent.XMPP_REGISTER_EVENT, XMPPRegisterCommand);
			this.addCommand(XMPPAddContactEvent.XMPP_ADD_CONTACT_EVENT, XMPPAddContactCommand);
			this.addCommand(XMPPRemoveContactEvent.XMPP_REMOVE_CONTACT_EVENT, XMPPRemoveContactCommand);
			this.addCommand(XMPPUpdatePresenceEvent.XMPP_UPDATE_PRESENCE_EVENT, XMPPUpdatePresenceCommand);
			this.addCommand(XMPPSendMessageEvent.XMPP_SEND_MESSAGE_EVENT, XMPPSendMessageCommand);
			this.addCommand(ReadClipboardEvent.READ_CLIPBOARD_EVENT, ReadClipboardCommand);
		}
	}
}
