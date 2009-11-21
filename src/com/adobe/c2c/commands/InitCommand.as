package com.adobe.c2c.commands
{
	import com.adobe.air.preferences.Preference;
	import com.adobe.c2c.events.P2PInitConnectionEvent;
	import com.adobe.c2c.events.ReadClipboardEvent;
	import com.adobe.c2c.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.Screen;
	import flash.geom.Rectangle;
	
	public class InitCommand implements ICommand
	{
		public function execute(e:CairngormEvent):void
		{
			var ml:ModelLocator = ModelLocator.getInstance();
			
			// Manage preferences
			var prefs:Preference = new Preference();
			prefs.load();
			ml.preferences = prefs;
			
			if (ml.preferences.getValue("username") == null || ml.preferences.getValue("password") == null)
			{
				ml.showAccountDrawer = true;
			}
			else
			{
				// Initialize the NetConnection
				new P2PInitConnectionEvent().dispatch();
			}

			// Read the clipboard			
			new ReadClipboardEvent().dispatch();
			
			// Show the application window.
			var win:NativeWindow = NativeApplication.nativeApplication.openedWindows[0];
			var initialBounds:Rectangle = new Rectangle((Screen.mainScreen.bounds.width / 2 - (win.width/2)), (Screen.mainScreen.bounds.height / 2 - (win.height/2)), win.width, win.height);
			win.bounds = initialBounds;
			win.visible = true;
		}
	}
}
