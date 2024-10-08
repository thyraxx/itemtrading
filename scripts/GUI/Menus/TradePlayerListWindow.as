namespace itemtrading
{
	class TradePlayerListWindow : AWindowObject
	{
		Widget@ m_list;
		Widget@ m_playerTemplate;

		int m_lastNumPlayers = 0;
		int m_pingC = 0;

		TradePlayerListWindow(GUIBuilder@ b)
		{
			super(b, "gui_itemtrade/playerslistfortrading.gui");

			@m_playerTemplate = m_widget.GetWidgetById("player-template");
			@m_list = m_widget.GetWidgetById("list");
		}

		int GetPeerPing(int peer)
		{
			int localPeer = Lobby::GetLocalPeer();
			if (!Lobby::IsPlayerHost(localPeer))
			{
				if (peer == localPeer)
					return Lobby::GetPlayerPing(0);
				else if (peer == 0)
					return Lobby::GetPlayerPing(localPeer);
			}

			return Lobby::GetPlayerPing(peer);
		}

		void UpdatePlayerList()
		{
			m_lastNumPlayers = g_players.length();

			m_list.ClearChildren();
			for (int i = 0; i < g_players.length(); i++)
			{
				if(Lobby::IsPlayerLocal(g_players[i].peer))
					continue;

				auto newPlayer = cast<AInteractableWidget>(m_playerTemplate.Clone());
				newPlayer.SetID("player-" + g_players[i].peer);
				newPlayer.m_visible = true;
				newPlayer.m_func = "trade " + GetLocalPlayerRecord().peer + " " + g_players[i].peer;
				newPlayer.m_navPos = ivec2(0, i);

				m_list.AddChild(newPlayer);

				RefreshPlayer(i);
			}
		}

		void SendMessage(const string &in name, SValue@ data) override
		{
			if (name == "SendPlayerString")
			{
				UnitPtr u;

				string playerName = GetParamString(u, data, "player");
				int peer = GetParamInt(u, data, "peer");

				auto playerWidget = m_widget.GetWidgetById("player-" + peer);
				if (playerWidget !is null)
					UpdatePlayer(playerWidget, playerName, peer);
			}
		}

		void RefreshPlayer(int peer)
		{
			auto gm = cast<MainMenuGameMode>(g_gameMode);
			if (gm !is null && gm.m_state == MenuState::InGameMenu)
			{
				SendSystemMessage("GetPlayerString " + peer, null);
			}
			else
			{
				auto playerWidget = m_widget.GetWidgetById("player-" + peer);
				if (playerWidget !is null)
					UpdatePlayer(playerWidget, Lobby::GetPlayerName(peer), peer);
			}
		}

		void UpdatePlayer(Widget@ playerWidget, const string &in playerName, int peer)
		{
			auto nameWidget = cast<TextWidget>(playerWidget.GetWidgetById("name"));
			if (nameWidget !is null)
			{
				nameWidget.SetText(playerName);
				nameWidget.SetColor(ParseColorRGBA("#" + GetPlayerColor(peer) + "ff"));
			}
		}

		bool Update(int ms, GameInput& gameInput, MenuInput& menuInput) override
		{
			m_pingC -= ms;
			if (m_pingC <= 0)
			{
				m_pingC += 1000;

				int numPlayers = Lobby::GetLobbyPlayerCount();
				if (m_lastNumPlayers != numPlayers)
					UpdatePlayerList();
				else
				{
					for (int i = 0; i < numPlayers; i++)
						RefreshPlayer(i);
				}
			}

			return AWindowObject::Update(ms, gameInput, menuInput);
		}

		void OnClose() override {
			m_closing = false;
		}

		void OnFunc(Widget@ sender, const string &in name) override
		{
			auto parse = name.split(" ");

			// GetLocalPlayerRecord: parse[1] 
			// Peer = parse[2]

			// Send request to person
			// Person receives TradeRequest.as
			// Person clicks accept/deny or window timeout
			// Request is sent back to starter
			if (parse[0] == "trade") {
				int starterPeer = parseInt(parse[1]);
				int receiverPeer = parseInt(parse[2]);
				(Network::Message("SendTradeRequest") << starterPeer << receiverPeer).SendToPeer(receiverPeer);
				print("GetLocalPlayerRecord: " + starterPeer + " peer: " + receiverPeer);
				print(GetPlayerRecordByPeer(receiverPeer).name + " : " + GetPlayerRecordByPeer(starterPeer).name );
			}
		}
	}
}