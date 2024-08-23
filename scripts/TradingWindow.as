namespace itemtrading
{
	class TradingWindow : UserWindow
	{
		EquipmentWidget@ m_equipmentWidget;
		EquipmentInventoryWidget@ m_equipmentInventoryWidget;

		TradingWindow(GUIBuilder@ b) 
		{
			super(b, "gui_itemtrade/thyraxxitemtrade.gui");

			@m_equipmentInventoryWidget = cast<EquipmentInventoryWidget>(m_widget.GetWidgetById("equipment-inventory"));
			@m_equipmentInventoryWidget.m_itemTemplate = cast<EquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template"));
			//@m_equipmentInventoryWidget.m_window = this;
		}

		void Initialize(GUIBuilder@ b, const string &in filename) override
		{
			PlayerRecord@ m_record = GetLocalPlayerRecord();
			m_equipmentWidget.SetOwner(m_record);
			m_equipmentInventoryWidget.SetOwner(m_record);
		}
	}
}