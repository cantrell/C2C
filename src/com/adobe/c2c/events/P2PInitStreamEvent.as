package com.adobe.c2c.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import org.jivesoftware.xiff.core.JID;
	
	public class P2PInitStreamEvent extends CairngormEvent
	{
		public static var P2P_INIT_STREAM_EVENT:String = "p2pInitStreamEvent";

		public var jid:JID;
		public var peerId:String;

		public function P2PInitStreamEvent()
		{
			super(P2P_INIT_STREAM_EVENT);
		}

	}
}
