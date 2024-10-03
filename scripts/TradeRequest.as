namespace itemtrading
{
	//class TradeRequest : AWindowObject
	class TradeRequest : AWindowObject
	{
		TradeRequest(GUIBuilder@ b) 
		{
			super(b, "gui_itemtrade/traderequest.gui");
		}

		void OnFunc(Widget@ sender, const string &in name) override 
		{
			auto gm = cast<BaseGameMode>(g_gameMode);

			auto parse = name.split(" ");
			if(parse[0] == "accept") {
				print("trade accepted");
				//(Network::Message("TradeAccept")).SendToPeer( parseInt(parse[1]) );
				//gm.m_windowManager.AddWindowObject(m_tradeRequest);

			}

			if(parse[0] == "deny") {
				print("trade denied");
				//gm.m_windowManager.CloseWindow(m_tradeRequest);
				//(Network::Message("TradeDeny")).SendToPeer( parseInt(parse[1]) );
			}
		}
	}
}