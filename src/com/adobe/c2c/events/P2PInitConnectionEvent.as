package com.adobe.c2c.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.c2c.commands.CommandResponder;

	public class P2PInitConnectionEvent extends CairngormEvent
	{
		public static var P2P_INIT_CONNECTION_EVENT:String = "p2pInitConnectionEvent";

		public function P2PInitConnectionEvent()
		{
			super(P2P_INIT_CONNECTION_EVENT);
		}
	}
}
