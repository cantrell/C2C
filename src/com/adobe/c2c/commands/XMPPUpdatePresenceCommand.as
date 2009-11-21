package com.adobe.c2c.commands
{
	import com.adobe.c2c.events.XMPPUpdatePresenceEvent;
	import com.adobe.c2c.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import org.jivesoftware.xiff.im.Roster;
	
	public class XMPPUpdatePresenceCommand implements ICommand
	{
		public function execute(e:CairngormEvent):void
		{
			var ee:XMPPUpdatePresenceEvent = e as XMPPUpdatePresenceEvent;

			var ml:ModelLocator = ModelLocator.getInstance();
			
			var roster:Roster = ml.roster;
			
			roster.setPresence(ee.presence, ee.presence, 0);
		}
	}
}
