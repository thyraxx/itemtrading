class TradingEquipmentInventoryWidget : EquipmentInventoryWidget
{
	EquipmentItemWidget@ m_tradingItemTemplate;
	EquipmentInventory@ m_equipmentInventory;

	Widget@ m_widget;

	TradingEquipmentInventoryWidget() {
		super();

		@m_tradingItemTemplate = cast<EquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template"));
		@m_equipmentInventory = EquipmentInventory(GetLocalPlayerRecord());
		m_equipmentInventory.m_maxItems = 9;
		//@m_owner = GetLocalPlayerRecord();


		//@m_equipmentInventoryWidget = cast<TradingEquipmentInventoryWidget>(m_widget.GetWidgetById("equipment-inventory-offer"));
   		//@m_equipmentInventoryWidget.m_itemTemplate = cast<TradingEquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template-offer"));
	}

	void OnClick(Equipment::Equipment@ item)
	{

		//EquipmentInventoryWidget::OnClick(item);

		if(item is null)
			return;

		print("onclick " + item.GetName());


		auto equip = cast<Equipment::Equipment>(item);
		if (equip !is null)
			m_equipmentInventory.Add(item);
		//if (!m_owner.equipInventory.Remove(item))
		//	return;

	}

	void DoLayout(vec2 origin, vec2 parentSz) override
	{
		//if(m_owner is null)
		//	@m_owner = GetLocalPlayerRecord();

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


	void Refresh() override
	{
		EquipmentInventoryWidget::Refresh();

		ClearChildren();

		vec2 baseSize = vec2(m_width / m_tradingItemTemplate.m_width, int(ceil(m_height / float(m_tradingItemTemplate.m_height))));

		vec2 offset = vec2(0);
		ivec2 navOffset = ivec2(0);

		for (uint i = 0; i < uint(max(m_equipmentInventory.m_items.length(), baseSize.x * baseSize.y)); i++)
		{
			auto item = cast<EquipmentItemWidget>(m_tradingItemTemplate.Clone());

			item.SetID("");
			item.m_offset = offset;
			if (i < m_equipmentInventory.m_items.length())
				item.Set(m_equipmentInventory.m_items[i], this);

			item.m_visible = true;
			item.m_navPos += navOffset;
			@item.m_inventory = this;

			AddChild(item);

			navOffset.x += 1;

			offset.x += item.m_width;
			if ((offset.x + item.m_width) > m_width)
			{
				offset.x = 0;
				offset.y += item.m_height;

				navOffset.x = 0;
				navOffset.y += 1;

				if (m_equipmentInventory.m_items.length() / baseSize.x > baseSize.y)
					baseSize.y++;
			}
		}

		m_height = navOffset.y * m_tradingItemTemplate.m_height;
	}
}

ref@ LoadTradingEquipmentInventoryWidget(WidgetLoadingContext &ctx)
{
	TradingEquipmentInventoryWidget@ w = TradingEquipmentInventoryWidget();
	w.Load(ctx);
	return w;
}