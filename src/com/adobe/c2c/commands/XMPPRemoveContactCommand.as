package com.adobe.c2c.commands
{
	import com.adobe.c2c.events.XMPPRemoveContactEvent;
	import com.adobe.c2c.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import org.jivesoftware.xiff.im.Roster;
	
	public class XMPPRemoveContactCommand implements ICommand
	{
		public function execute(e:CairngormEvent):void
		{
			var ee:XMPPRemoveContactEvent = e as XMPPRemoveContactEvent;

			if (ee.rosterItem == null) return;

			var ml:ModelLocator = ModelLocator.getInstance();
			
			var roster:Roster = ml.roster;
			
			roster.removeContact(ee.rosterItem);
		}
	}
}
