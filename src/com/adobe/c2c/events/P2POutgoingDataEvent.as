package com.adobe.c2c.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import org.jivesoftware.xiff.core.JID;

	public class P2POutgoingDataEvent extends CairngormEvent
	{
		public static var P2P_OUTGOING_DATA_EVENT:String = "p2pOutgoingDataEvent";

		public var peerId:String;
		public var recipient:JID;

		public function P2POutgoingDataEvent()
		{
			super(P2P_OUTGOING_DATA_EVENT);
		}
	}
}
