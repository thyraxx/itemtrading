namespace itemtrading
{
	void SendCancelTradeMessage() {
		
	}

	void SyncAddItem(uint8 peer, SValue@ itemData) { // equipment/items must be send as SValue data
		print("SyncAddItem called");
		auto item = Equipment::LoadItem(itemData);
		if (item is null)
			return;

		print("Added item to counteroffer and refreshing trade window: " + item.baseItem.name);

		equipInventoryCounterOffer.Add(item);
		m_equipmentTradingInventoryWidget.Refresh();
		m_equipmentInventoryWidgetCounterOffer.Refresh();
	}

	void SyncRemoveItem(uint8 peer, SValue@ itemData) {
		print("SyncRemoveItem called");
		auto item = Equipment::LoadItem(itemData);
		if (item is null)
			return;

		print("Added item to counteroffer and refreshing trade window");
		equipInventoryCounterOffer.Remove(item);
		m_equipmentTradingInventoryWidget.Refresh();
	}

	void SendTradeRequest(uint8 peer, int senderPeer) {
		if(peer == GetLocalPlayerRecord().peer)
			return;

		m_trade.receivingPeer = peer;
		m_trade.senderPeer = senderPeer;

		auto gm = cast<BaseGameMode>(g_gameMode);
		if(gm != null) {
			m_tradeRequest.m_visible = true;
			//gm.m_windowManager.CloseWindow(m_tradeRequest);
			//gm.m_windowManager.AddWindowObject(m_tradeRequest);
		}
	}

	void ReplyAccept(uint8 peer) {
		if(peer == GetLocalPlayerRecord().peer)
			return;


	}

	void ReplyDeny(uint8 peer) {

	}

	void SendTradeRequestAccepted(uint8 peer) {

	}

	void SendTradeRequestDenied(uint8 peer) {

	}


	void SendTradeLock(uint8 peer, bool isLocked) {

	}

	void SendTradeAccepted(uint8 peer, bool isConfirmed) {

	}



}