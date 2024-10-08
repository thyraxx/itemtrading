namespace itemtrading
{
	void SendCancelTradeMessage() {
		
	}

	// Starter and receiver side
	void SyncAddItem(uint8 peer, SValue@ itemData) { // equipment/items must be send as SValue data
		print("SyncAddItem called");
		auto item = Equipment::LoadItem(itemData);
		if (item is null)
			return;

		print("Added item to counteroffer and refreshing trade window: " + item.baseItem.name);

		equipInventoryCounterOffer.Add(item);
		equipInventoryCounterOffer.m_isDirty = true;

		m_equipmentTradingInventoryWidget.Refresh();
		m_equipmentInventoryWidgetOffer.Refresh();
		m_equipmentInventoryWidgetCounterOffer.Refresh();
	}

	// Starter and receiver side
	void SyncRemoveItem(uint8 peer, SValue@ itemData) {
		print("SyncRemoveItem called");
		auto item = Equipment::LoadItem(itemData);
		if (item is null)
			return;

		print("Remove item to counteroffer and refreshing trade window");
		
		for(uint i = 0; i < equipInventoryCounterOffer.m_items.length(); i++) {
			if(equipInventoryCounterOffer.m_items[i].GetIDHash() == item.GetIDHash()) {
				equipInventoryCounterOffer.m_items.removeAt(i);
				equipInventoryCounterOffer.m_isDirty = true;
			}
		}

		print("inventory length: " + equipInventoryCounterOffer.m_items.length());

		m_equipmentTradingInventoryWidget.Refresh();
		m_equipmentInventoryWidgetCounterOffer.Refresh();
	}

	// Receivers side
	void SendTradeRequest(uint8 peer, int starterPeer, int receiverPeer) {
		print(starterPeer + " -> " + receiverPeer);
		m_tradeStatus.setTradePeers(starterPeer, receiverPeer);
		(Network::Message("SyncTradeStatus") << starterPeer << receiverPeer).SendToPeer(starterPeer);

		// this GUI is shown on the receivers side, so it must contain the starter peer
		// to know to which peer the reply must return to
		m_tradeRequest.m_widgetTradeAccept.m_func = "accept " + starterPeer;
		m_tradeRequest.m_widgetTradeDeny.m_func = "deny " + starterPeer;
		m_tradeRequest.m_textWidget.SetText(Lobby::GetPlayerName(starterPeer) + " wants to trade");
		m_tradeRequest.m_visible = true;
	}

	// Starter side receives reply
	void TradeRequestAccept(uint8 peer) {
		auto gm = cast<BaseGameMode>(g_gameMode);
		gm.m_windowManager.AddWindowObject(m_tradingWindow);
	}

	// Starter side receives reply
	void TradeRequestDeny(uint8 peer) {
		g_gameMode.ShowDialog("", GetPlayerRecordByPeer(m_tradeStatus.receiverPeer).name + " denied your trade request.", Resources::GetString(".menu.ok"), null);
		(Network::Message("SyncTradeStatus") << -1 << -1).SendToPeer(m_tradeStatus.receiverPeer);
		m_tradeStatus.starterPeer = -1;
		m_tradeStatus.receiverPeer = -1;
		
		m_tradeRequest.m_visible = false;
	}

	// Starters side
	void SyncTradeStatus(uint8 peer, int starterPeer, int receiverPeer) {
		print(receiverPeer + " -> " + starterPeer);
		m_tradeStatus.setTradePeers(starterPeer, receiverPeer);
	}

	// Both sides
	void CheckConfirm(uint8 peer) {
		print("peer: " + peer);
		if(m_tradeStatus.m_tradeConfirm){
			print("both confirmed");

			print("peer: " + peer + " Localpeer: " + GetLocalPlayerRecord().peer + " vs " + m_tradeStatus.starterPeer);
			if(GetLocalPlayerRecord().peer == m_tradeStatus.starterPeer)
				(Network::Message("AcceptItems")).SendToPeer(m_tradeStatus.receiverPeer);
			else
				(Network::Message("AcceptItems")).SendToPeer(m_tradeStatus.starterPeer);

			for(uint i = 0; i < equipInventoryOffer.m_items.length(); i++)
				GetLocalPlayerRecord().equipInventory.Remove(equipInventoryOffer.m_items[i]);

			for(uint i = 0; i < equipInventoryCounterOffer.m_items.length(); i++)
				GetLocalPlayerRecord().equipInventory.Add(equipInventoryCounterOffer.m_items[i]);

			auto gm = cast<BaseGameMode>(g_gameMode);
			gm.m_windowManager.CloseWindow(m_tradingWindow);
			g_gameMode.ShowDialog("", "All items are put in your inventory.", Resources::GetString(".menu.ok"), null);
			
			m_tradingWindow.m_buttonConfirmWidget.m_enabled = false;
			m_tradeStatus.Reset();
		}
		//else{
		//	print("peer: " + peer + " hasn't confirmed");
		//}
	}

	// Both sides
	void AcceptItems(uint8 peer) {
		print("peer: " + peer);
		for(uint i = 0; i < equipInventoryOffer.m_items.length(); i++)
			GetLocalPlayerRecord().equipInventory.Remove(equipInventoryOffer.m_items[i]);

		for(uint i = 0; i < equipInventoryCounterOffer.m_items.length(); i++)
			GetLocalPlayerRecord().equipInventory.Add(equipInventoryCounterOffer.m_items[i]);

		auto gm = cast<BaseGameMode>(g_gameMode);
		gm.m_windowManager.CloseWindow(m_tradingWindow);
		g_gameMode.ShowDialog("", "All items are put in your inventory.", Resources::GetString(".menu.ok"), null);
		
		m_tradeStatus.Reset();
	}

	void ReplyDeny(uint8 peer) {

	}

	// Both sides
	void IsTradeLocked(uint8 peer, bool isLocked) {

		//int i = 0;
		//m_tradingWindow.m_buttonLockWidget.SetText("Lock");
		if(m_tradeStatus.m_tradeLock && isLocked){
			m_tradingWindow.m_buttonLockWidget.SetText("Unlock");
			m_tradeStatus.m_lockAmount = 2;
		}

		if(!m_tradeStatus.m_tradeLock && isLocked){
			m_tradingWindow.m_buttonLockWidget.SetText("Lock");
			m_tradeStatus.m_lockAmount = 1;
		}else if(m_tradeStatus.m_tradeLock && !isLocked) {
			m_tradingWindow.m_buttonLockWidget.SetText("Unlock");
			m_tradeStatus.m_lockAmount = 1;
		}


		// Not necessary cause 'i' starts at 0, no need to set it.
		if(!m_tradeStatus.m_tradeLock && !isLocked) {
			m_tradeStatus.m_lockAmount = 0;
			m_tradingWindow.m_buttonLockWidget.SetText("Lock");
		}

		m_tradingWindow.m_textWidget.SetText(m_tradeStatus.m_lockAmount + "/2");

		if(m_tradeStatus.m_lockAmount == 2)
			m_tradingWindow.m_buttonConfirmWidget.m_enabled = true;
		else
			m_tradingWindow.m_buttonConfirmWidget.m_enabled = false;
	}

	void SendTradeAccepted(uint8 peer, bool isConfirmed) {

	}



}