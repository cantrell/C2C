package com.adobe.c2c.commands
{
	import com.adobe.c2c.events.P2PInitStreamEvent;
	import com.adobe.c2c.events.XMPPInitConnectionEvent;
	import com.adobe.c2c.events.XMPPRegisterEvent;
	import com.adobe.c2c.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import org.jivesoftware.xiff.core.JID;
	import org.jivesoftware.xiff.core.XMPPSocketConnection;
	import org.jivesoftware.xiff.data.IQ;
	import org.jivesoftware.xiff.events.ConnectionSuccessEvent;
	import org.jivesoftware.xiff.events.DisconnectionEvent;
	import org.jivesoftware.xiff.events.IncomingDataEvent;
	import org.jivesoftware.xiff.events.LoginEvent;
	import org.jivesoftware.xiff.events.PresenceEvent;
	import org.jivesoftware.xiff.events.RegistrationSuccessEvent;
	import org.jivesoftware.xiff.events.RemoveRegistrationSuccessEvent;
	import org.jivesoftware.xiff.events.RosterEvent;
	import org.jivesoftware.xiff.events.XIFFErrorEvent;
	import org.jivesoftware.xiff.im.Roster;
		
	public class XMPPInitConnectionCommand implements ICommand
	{
		public function execute(e:CairngormEvent):void
		{
			var xie:XMPPInitConnectionEvent = e as XMPPInitConnectionEvent;
			var ml:ModelLocator = ModelLocator.getInstance();
			
			if (ml.xmppConnection != null && ml.xmppConnection.isActive())
			{
				ml.xmppConnection.disconnect();
			}

			// Set up the XMPPSocketConnection

			var xsc:XMPPSocketConnection = new XMPPSocketConnection();
			ml.xmppConnection = xsc;

			xsc.addEventListener(XIFFErrorEvent.XIFF_ERROR,
				function(e:XIFFErrorEvent):void
				{
					trace("XIFFErrorEvent.ERROR", e.errorMessage);
				});

			xsc.addEventListener(DisconnectionEvent.DISCONNECT,
				function(e:DisconnectionEvent):void
				{
					trace("DisconnectionEvent.DISCONNECTION");
					ModelLocator.getInstance().statusMessage = "Disconnected.";
					ModelLocator.getInstance().connected = false;
					ModelLocator.getInstance().roster = null;
				});

			xsc.addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS,
				function(e:ConnectionSuccessEvent):void
				{
					trace("ConnectionSuccessEvent.CONNECTION");
					ModelLocator.getInstance().statusMessage = "Connected anonymously.";
					ModelLocator.getInstance().connected = true;
					if (ml.registrationPending)
					{
						ml.registrationPending = false;
						var xre:XMPPRegisterEvent = new XMPPRegisterEvent();
						xre.username = ml.preferences.getValue("username");
						xre.password = ml.preferences.getValue("password");
						xre.dispatch();
					}
				});

			xsc.addEventListener(LoginEvent.LOGIN,
				function(e:LoginEvent):void
				{
					trace("LoginEvent.LOGIN");
					ModelLocator.getInstance().statusMessage = "Connected as " + ml.preferences.getValue("username") + ".";
					ModelLocator.getInstance().showAccountDrawer = false;
				});

			xsc.addEventListener(PresenceEvent.PRESENCE,
				function(e:PresenceEvent):void
				{
					trace("PresenceEvent.PRESENCE", e.data);
				});

			xsc.addEventListener(IncomingDataEvent.INCOMING_DATA,
				function(e:IncomingDataEvent):void
				{
					trace("IncomingDataEvent.INCOMING_DATA", e.data);
					var from:String = e.data.firstChild.attributes.from;
					var ml:ModelLocator = ModelLocator.getInstance();
					if (e.data.firstChild.attributes["type"] == "error") // handle errors
					{
						for each (var child:XMLNode in e.data.firstChild.childNodes)
						{
							if (child.nodeName == "error" && child.attributes["code"] == 401)
							{
								Alert.show("Your username or password is incorrect.", "Error", Alert.OK);
								ml.showAccountDrawer = true;
								ml.statusMessage = "Login failed.";
								return;
							}
						}
					}
					else if (e.data.firstChild.nodeName == "iq") // handle IQ packets
					{
						if (!e.data.firstChild.firstChild) return;
						if (e.data.firstChild.firstChild.nodeName == "query")  // handle query packets
						{
							if (e.data.firstChild.firstChild.attributes.xmlns == ModelLocator.PEERID_QUERY_NS) // handle incoming peer IDs
							{
								if (e.data.firstChild.attributes.type == "set") // incoming peerID
								{
									var initStreamEvent:P2PInitStreamEvent = new P2PInitStreamEvent();
									initStreamEvent.jid = new JID(from);
									initStreamEvent.peerId = e.data.firstChild.firstChild.firstChild.nodeValue;
									initStreamEvent.dispatch();
								}
							}
							else if (e.data.firstChild.firstChild.firstChild && e.data.firstChild.firstChild.firstChild.nodeName == "item" && e.data.firstChild.firstChild.firstChild.attributes["subscription"] == "none") // Handle subscription cancelations
							{
								var name:String = e.data.firstChild.firstChild.firstChild.attributes["name"];
								trace("Subscription being removed", name);
								ModelLocator.getInstance().incomingStreams[name] = null;
							}
						}
					}
				});

			xsc.addEventListener(RegistrationSuccessEvent.REGISTRATION_SUCCESS,
				function(e:RegistrationSuccessEvent):void
				{
					trace("RegistrationSuccessEvent.REGISTRATION_SUCCESS");
					var ml:ModelLocator = ModelLocator.getInstance();
					ml.statusMessage = "Registration successful!";
					ml.showAccountDrawer = false;
					var xic:XMPPInitConnectionEvent = new XMPPInitConnectionEvent();
					xic.username = ml.preferences.getValue("username");
					xic.password = ml.preferences.getValue("password");
					xic.dispatch();
					Alert.show("You have successfully registered!", "Success!", Alert.OK);
				});

			xsc.addEventListener(RemoveRegistrationSuccessEvent.REMOVE_REGISTRATION_SUCCESS,
				function(e:RemoveRegistrationSuccessEvent):void
				{
					trace("RemoveRegistrationSuccessEvent.REMOVE_REGISTRATION_SUCCESS");
					ModelLocator.getInstance().showAccountDrawer = false;
					ModelLocator.getInstance().xmppConnection.disconnect();
					Alert.show("You have successfully deleted your account!", "Success!", Alert.OK);
				});

			xsc.server = ModelLocator.XMPP_HOST;
			xsc.port = ModelLocator.XMPP_PORT;

			if (xie.username && xie.password)
			{
				xsc.username = xie.username;
				xsc.password = xie.password;
			}

			xsc.resource = ModelLocator.XMPP_RESOURCE;

			// Set up the Roster

			var roster:Roster = new Roster(xsc);
			ml.roster = roster;

			roster.addEventListener(RosterEvent.ROSTER_LOADED,
				function(e:RosterEvent):void
				{
					trace("RosterEvent.ROSTER_LOADED");
				});

			roster.addEventListener(RosterEvent.SUBSCRIPTION_DENIAL,
				function(e:RosterEvent):void
				{
					trace("RosterEvent.SUBSCRIPTION_DENIAL", e.data);
				});

			roster.addEventListener(RosterEvent.SUBSCRIPTION_REQUEST,
				function(e:RosterEvent):void
				{
					trace("RosterEvent.SUBSCRIPTION_REQUEST", e.data);
					Alert.show("Allow " + e.jid.node + " to connect to you?",
							   "Connection Request",
								Alert.YES|Alert.NO,
								null,
								function(ee:CloseEvent):void
								{
									if (ee.detail == Alert.YES)
									{
										ModelLocator.getInstance().roster.grantSubscription(e.jid, true);
									}
									else
									{
										ModelLocator.getInstance().roster.denySubscription(e.jid);
									}
								});
				});

			roster.addEventListener(RosterEvent.USER_ADDED,
				function(e:RosterEvent):void
				{
					trace("RosterEvent.USER_ADDED", e.data);
					ModelLocator.getInstance().roster.refresh();
				});

			roster.addEventListener(RosterEvent.USER_AVAILABLE,
				function(e:RosterEvent):void
				{
					trace("RosterEvent.USER_AVAILABLE", e.jid, e.jid.resource);
					ModelLocator.getInstance().roster.refresh();

					if (e.jid.resource == null || e.jid.resource != ModelLocator.XMPP_RESOURCE) return;

					var iq:IQ = new IQ(e.jid, IQ.SET_TYPE);
					var queryNode:XMLNode = iq.ensureNode(null, "query");
					queryNode.attributes.xmlns = ModelLocator.PEERID_QUERY_NS;
					var peerId:XMLNode = new XMLNode(XMLNodeType.TEXT_NODE, ModelLocator.getInstance().netConnection.nearID);
					queryNode.appendChild(peerId);
					ModelLocator.getInstance().xmppConnection.send(iq);
				});

			roster.addEventListener(RosterEvent.USER_PRESENCE_UPDATED,
				function(e:RosterEvent):void
				{
					trace("RosterEvent.USER_PRESENCE_UPDATED", e.data);
					ModelLocator.getInstance().roster.refresh();
				});

			roster.addEventListener(RosterEvent.USER_UNAVAILABLE,
				function(e:RosterEvent):void
				{
					trace("RosterEvent.USER_UNAVAILABLE", e.data);
					ModelLocator.getInstance().roster.refresh();
					var ml:ModelLocator = ModelLocator.getInstance();
					ml.incomingStreams[e.jid.node] = null;
				});

			// Connect to the XMPP server.
			xsc.connect();
		}
	}
}
