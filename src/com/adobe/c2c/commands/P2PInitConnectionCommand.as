package com.adobe.c2c.commands
{
	import com.adobe.c2c.events.XMPPInitConnectionEvent;
	import com.adobe.c2c.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.errors.IOError;
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.controls.Alert;
	
	public class P2PInitConnectionCommand implements ICommand
	{
		public function execute(e:CairngormEvent):void
		{
			var ml:ModelLocator = ModelLocator.getInstance();
			
			if (ml.netConnection != null && ml.netConnection.connected)
			{
				if (ml.incomingStreams != null)
				{
					for each (var ns:NetStream in ml.incomingStreams)
					{
						if (ns == null) continue;
						ns.close();
					}
				}
				ml.netConnection.close();
				ml.netConnection = null;
			}
			
			var nc:NetConnection = new NetConnection();

			ml.netConnection = nc;
			ml.incomingStreams = new Object();

			nc.addEventListener(IOErrorEvent.IO_ERROR,
				function(e:IOError):void
				{
					Alert.show("Please make sure you have an internet connection.", "Connection Error", Alert.OK);
				});

			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
				function(e:SecurityErrorEvent):void
				{
					Alert.show("Unable to complete connection due to a security error.", "Security Error", Alert.OK);
				});

			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,
				function(e:AsyncErrorEvent):void
				{
					trace("AsyncErrorEvent.ASYNC_ERROR", e.error);
				});

			nc.addEventListener(NetStatusEvent.NET_STATUS,
				function(e:NetStatusEvent):void
				{
					if (e.info.code == "NetConnection.Connect.Success")
					{
						// Initialize the OutgoingStream
						initOutgoingStream();
					}
					else if (e.info.code == "NetConnection.Connect.Failed")
					{
						Alert.show("Cannot connect with your current network configuration.", "Connection Error", Alert.OK);
					}
					else if (e.info.code == "NetConnection.Connect.Closed")
					{
						trace("NetConnection.Connect.Closed", e.info.description);
						// This is ok.  The app is probably exiting.
					}
					else if (e.info.code == "NetStream.Connect.Success")
					{
						trace("NetStream.Connect.Success", e.info.description);
						// Cool, it worked.
					}
					else if (e.info.code == "NetStream.Connect.Closed")
					{
						trace("NetStream.Connect.Closed", e.info.description);
						// The other person probably went offline.  Hopefully.
					}
					else
					{
						Alert.show("Connecton error: " + e.info.code, "Connection Error", Alert.OK);
					}
				});

			nc.connect(ModelLocator.FMS_SERVER);
		}
		
		private function initOutgoingStream():void
		{
			var ml:ModelLocator = ModelLocator.getInstance();
			var outgoingStream:NetStream = new NetStream(ml.netConnection, NetStream.DIRECT_CONNECTIONS);
			outgoingStream.addEventListener(NetStatusEvent.NET_STATUS,
				function(e:NetStatusEvent):void
				{
					trace("outgoingStream NET_STATUS", e.info.code, e.info.description);
					if (e.info.code == "NetStream.Publish.Start")
					{
						// Initialize the XMPP connection
						var xice:XMPPInitConnectionEvent = new XMPPInitConnectionEvent();
						xice.username = ml.preferences.getValue("username");
						xice.password = ml.preferences.getValue("password");
						xice.dispatch();
					}
				});
			ml.outgoingStream = outgoingStream;
			outgoingStream.publish(ml.netConnection.nearID);
		}
	}
}
