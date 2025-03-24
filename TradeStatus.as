class TradeStatus
{
	int starterPeer = -1;
	int receiverPeer = -1;
	int m_lockAmount = 0;

	bool m_tradeRequested = false;
	bool m_tradeRequestReceived = false;
	bool m_tradeRequestAccepted = false;
	bool m_tradeRequestDenied = false;
	bool m_tradeConfirm = false;
	bool m_tradeLock = false;
	bool m_tradeCanceled = false;

	void setTradePeers(int _starterPeer, int _receiverPeer) {
		starterPeer = _starterPeer;
		receiverPeer = _receiverPeer;
	}

	void Reset() {
		m_lockAmount = 0;
		m_tradeRequested = false;
		m_tradeRequestReceived = false;
		m_tradeRequestAccepted = false;
		m_tradeRequestDenied = false;
		m_tradeConfirm = false;
		m_tradeLock = false;
		m_tradeCanceled = false;
	}
}