package com.adobe.c2c.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class P2PIncomingDataEvent extends CairngormEvent
	{
		public static var P2P_INCOMING_DATA_EVENT:String = "p2pIncomingDataEvent";

		public var from:String;
		public var clipboardType:String;
		public var arg:*;
		public var clipboardData:*;

		public function P2PIncomingDataEvent()
		{
			super(P2P_INCOMING_DATA_EVENT);
		}

	}
}
