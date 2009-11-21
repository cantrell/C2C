package com.adobe.c2c.commands
{
	import com.adobe.c2c.events.P2PIncomingDataEvent;
	import com.adobe.c2c.events.P2PInitStreamEvent;
	import com.adobe.c2c.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.jivesoftware.xiff.core.JID;
	import org.jivesoftware.xiff.data.im.RosterItemVO;
	import org.jivesoftware.xiff.im.Roster;
	
	public class P2PInitStreamCommand implements ICommand
	{
		public function execute(e:CairngormEvent):void
		{
			var ee:P2PInitStreamEvent = e as P2PInitStreamEvent;
			var ml:ModelLocator = ModelLocator.getInstance();
			
			var jid:JID = ee.jid;
			var peerId:String = ee.peerId;
			
			if (jid == null || peerId == null) return;
			
			// Add the peerId to the roster
			var roster:Roster = ml.roster;
			for each (var item:RosterItemVO in roster)
			{
				if (item.jid.equals(jid, true))
				{
					item.peerId = peerId;
					break;
				}
			}
			
			var nc:NetConnection = ml.netConnection;

			if (!ml.incomingStreams[jid.node])
			{
				var incomingStream:NetStream = new NetStream(nc, peerId);
				incomingStream.addEventListener(NetStatusEvent.NET_STATUS,
					function(e:NetStatusEvent):void
					{
						trace("incomingStream NET_STATUS", e.info.code, e.info.description);
						if (e.info.code == "NetStream.Play.Start")  // Incoming stream is ready
						{
							var peerId:String = NetStream(e.target).farID;
							var roster:Roster = ml.roster;
							for each (var item:RosterItemVO in roster)
							{
								if (item.peerId == peerId)
								{
									item.pasteable = true;
									break;
								}
							}
						}
					});
				var client:Object = new Object();
				client.onData = function(from:String, clipboardType:String, clipboardData:*, arg:*):void
				{
					var ee:P2PIncomingDataEvent = new P2PIncomingDataEvent();
					ee.from = from;
					ee.clipboardType = clipboardType;
					ee.clipboardData = clipboardData;
					ee.arg = arg;
					ee.dispatch();
				};
				incomingStream.client = client;		
				incomingStream.play(peerId);
				ml.incomingStreams[jid.node] = incomingStream;
			}
		}
	}
}