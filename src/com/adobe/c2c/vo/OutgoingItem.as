package com.adobe.c2c.vo
{
	import org.jivesoftware.xiff.core.JID;
	
	public class OutgoingItem
	{

		public static const TEXT:String = "text";
		public static const IMAGE:String = "image";
		public static const FILE:String = "file";

		private var _type:String;
		private var _item:*;
		private var _recipient:JID;
		private var _arg:*;

		public function OutgoingItem(type:String, recipient:JID, item:*, arg:* = null)
		{
			this._type = type;
			this._recipient = recipient;
			this._item = item;
			this._arg = arg;
		}
		
		public function getType():String
		{
			return this._type;
		}

		public function getRecipient():JID
		{
			return this._recipient;
		}

		public function getArg():*
		{
			return this._arg;
		}

		public function getItem():*
		{
			return this._item;
		}
	}
}