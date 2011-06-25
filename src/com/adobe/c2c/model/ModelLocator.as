package com.adobe.c2c.model
{
	import com.adobe.air.preferences.Preference;
	import com.adobe.cairngorm.model.IModelLocator;
	
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.collections.ArrayCollection;
	
	import org.jivesoftware.xiff.core.XMPPSocketConnection;
	import org.jivesoftware.xiff.im.Roster;
	
	public class ModelLocator implements com.adobe.cairngorm.model.IModelLocator
	{
		protected static var inst:ModelLocator;

		public static const XMPP_HOST:String = "christiancantrell.com";
		public static const XMPP_PORT:uint = 5222;
		public static const XMPP_RESOURCE:String = "c2c";
		public static const FMS_SERVER:String = "rtmfp://stratus.adobe.com/HawkPrerelease-4e4efa13755c/ccantrel.adobe.com";
		public static const PEERID_QUERY_NS:String = "c2c:peerid";

		[Bindable] public var xmppConnection:XMPPSocketConnection;
		[Bindable] public var roster:Roster;
		[Bindable] public var preferences:Preference;
		[Bindable] public var showAccountDrawer:Boolean;
		[Bindable] public var showAddUserDrawer:Boolean;
		[Bindable] public var registrationPending:Boolean;
		[Bindable] public var statusMessage:String;
		[Bindable] public var connected:Boolean;
		[Bindable] public var clipboardContentsIndex:uint;

		[Bindable] public var clipboardText:String = "";
		[Bindable] public var clipboardBitmap:Object;
		[Bindable] public var clipboardFiles:ArrayCollection;

		[Bindable] public var netConnection:NetConnection;
		[Bindable] public var incomingStreams:Object;
		[Bindable] public var outgoingStream:NetStream;

		public function ModelLocator()
		{
		}
		
		public static function getInstance():ModelLocator
		{
			if (inst == null)
			{
				inst = new ModelLocator();
			}
			return inst;
		}

	}
}
