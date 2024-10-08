namespace itemtrading
{
	class TradingWindow : AWindowObject
	{

		ScalableSpriteButtonWidget@ m_buttonConfirmWidget;
		ScalableSpriteButtonWidget@ m_buttonLockWidget;
		TextWidget@ m_textWidget;

		TradingWindow(GUIBuilder@ b) 
		{
			super(b, "gui_itemtrade/thyraxxitemtrade.gui");

			@m_buttonConfirmWidget = cast<ScalableSpriteButtonWidget>(m_widget.GetWidgetById("tradeconfirm"));
			@m_buttonLockWidget = cast<ScalableSpriteButtonWidget>(m_widget.GetWidgetById("tradelock"));
			@m_textWidget = cast<TextWidget>(m_widget.GetWidgetById("amountlocked"));

			@m_equipmentTradingInventoryWidget = cast<TradingEquipmentInventoryWidget>(m_widget.GetWidgetById("equipment-inventory"));
			@m_equipmentTradingInventoryWidget.m_itemTemplate = cast<EquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template"));

			@m_equipmentInventoryWidgetOffer = cast<TradingEquipmentInventoryOfferWidget>(m_widget.GetWidgetById("equipment-inventory-offer"));
			@m_equipmentInventoryWidgetOffer.m_itemTemplate = cast<EquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template-offer"));
			
			@m_equipmentInventoryWidgetCounterOffer = cast<TradingEquipmentInventoryCounterOfferWidget>(m_widget.GetWidgetById("equipment-inventory-counter-offer"));
			@m_equipmentInventoryWidgetCounterOffer.m_itemTemplate = cast<EquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template-counter-offer"));
		}

		void OnClose() override
		{
			equipInventoryOffer.Clear();
			equipInventoryCounterOffer.Clear();
			m_equipmentTradingInventoryWidget.Refresh();
			m_equipmentInventoryWidgetOffer.Refresh();
			m_equipmentInventoryWidgetCounterOffer.Refresh();

			m_closing = false;
		}

		void OnFunc(Widget@ sender, const string &in name) { 
			//auto parse = name.split(" ");
			print("TradingWindow confirm: " + name);
			if(name == "tradelock") {
				if(m_tradeStatus.m_tradeLock == false){
					m_tradeStatus.m_tradeLock = true;
					m_tradeStatus.m_lockAmount++;

					m_buttonLockWidget.SetText("Unlock");
				}else{
					m_tradeStatus.m_tradeLock = false;
					m_tradeStatus.m_lockAmount--;
					m_buttonLockWidget.SetText("Lock");

				}
					
				m_textWidget.SetText(m_tradeStatus.m_lockAmount + "/2");

				if(m_tradeStatus.m_lockAmount == 2)
					m_tradingWindow.m_buttonConfirmWidget.m_enabled = true;
				else
					m_tradingWindow.m_buttonConfirmWidget.m_enabled = false;

				if(GetLocalPlayerRecord().peer == m_tradeStatus.starterPeer)
					(Network::Message("IsTradeLocked") << m_tradeStatus.m_tradeLock).SendToPeer(m_tradeStatus.receiverPeer);
				else
					(Network::Message("IsTradeLocked") << m_tradeStatus.m_tradeLock).SendToPeer(m_tradeStatus.starterPeer);
			}

			if(name == "tradeconfirm"){
				m_tradeStatus.m_tradeConfirm = true;
				if(GetLocalPlayerRecord().peer == m_tradeStatus.starterPeer)
					(Network::Message("CheckConfirm")).SendToPeer(m_tradeStatus.receiverPeer);
				else
					(Network::Message("CheckConfirm")).SendToPeer(m_tradeStatus.starterPeer);
			}
		}

	}
}
