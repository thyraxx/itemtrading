class TradingEquipmentInventoryWidget : EquipmentInventoryWidget
{
	TradingEquipmentInventoryWidget() {
		super();
	}

	//void Update(int dt) override
	//{
	//	if (!m_visible)
	//		return;
//
	//	Widget::Update(dt);
//
	//	print("m_owner: " + (m_owner != null) );
		//print("m_owner.equipInventory: " + (m_owner.equipInventory != null) );
//
	//	if (m_owner.equipInventory.m_isDirty)
	//	{
	//		Refresh();
	//		m_owner.equipInventory.m_isDirty = false;
	//	}
	//}
	void OnClick(Equipment::Equipment@ item)
	{
		EquipmentInventoryWidget::OnClick(item);
		print("onclick " + item.GetName());
	}

	void DoLayout(vec2 origin, vec2 parentSz) override
	{
		if(m_owner is null)
			@m_owner = GetLocalPlayerRecord();

		EquipmentInventoryWidget::DoLayout(origin, parentSz);

		//if (!m_visible)
		//	return;
////
		//for (uint i = 0; i < m_children.length(); i++)
		//{
		//	auto child = cast<EquipmentItemWidget>(m_children[i]);
		//	if (child is null)
		//		continue;
		//	
		//	auto equip = cast<Equipment::Equipment>(child.m_item);
		//	if (equip !is null && !m_owner.equipped.MayEquip(equip))
		//		child.m_color = vec4(1.0f, 0.0f, 0.0f, 1.0f);
		//	else
		//		child.m_color = vec4(1.0f);
		//}
////
		//RectWidget::DoLayout(origin, parentSz);
	}

}

ref@ LoadTradingEquipmentInventoryWidget(WidgetLoadingContext &ctx)
{
	TradingEquipmentInventoryWidget@ w = TradingEquipmentInventoryWidget();
	w.Load(ctx);
	return w;
}