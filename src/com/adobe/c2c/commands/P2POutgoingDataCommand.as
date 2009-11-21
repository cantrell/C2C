package com.adobe.c2c.commands
{
	import com.adobe.c2c.events.P2POutgoingDataEvent;
	import com.adobe.c2c.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.jivesoftware.xiff.core.JID;
	
	public class P2POutgoingDataCommand implements ICommand
	{
		public function execute(e:CairngormEvent):void
		{
			/*
			var ml:ModelLocator = ModelLocator.getInstance();
			var ee:P2POutgoingDataEvent = e as P2POutgoingDataEvent;
			
			if (ee.peerId == null || ee.recipient == null) return;
			
			var peerId:String = ee.peerId;
			var recipient:JID = ee.recipient;

			var nc:NetConnection = ml.netConnection;

			var outgoingStream:NetStream = new NetStream(nc, peerId);
			*/
		}
	}
}