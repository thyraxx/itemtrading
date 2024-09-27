class TradingEquipmentInventoryCounterOfferWidget : EquipmentInventoryWidget
{
	int counterOfferPeer;

	TradingEquipmentInventoryCounterOfferWidget() {
		super();
	}

	void SetOwner(PlayerRecord@ plr) override
	{
		Refresh();
	}

	void OnClick(Equipment::Equipment@ item) override
	{
		if(item is null)
			return;

		print("onclick " + item.GetName());


		//auto equip = cast<Equipment::Equipment>(item);
		if (item !is null) {
			equipInventoryCounterOffer.Remove(item);

			SValueBuilder builder;
			Item::SaveItem(builder, item);

			// Peer hardcoded temporarily
			if(GetLocalPlayerRecord().peer == 0)
				(Network::Message("SyncRemoveItem") << builder.Build()).SendToPeer(1);
			else
				(Network::Message("SyncRemoveItem") << builder.Build()).SendToPeer(0);
			
			m_equipmentTradingInventoryWidget.m_owner.equipInventory.m_isDirty = true;
		}

		m_host.OnFunc(this, "refresh");
	}

	void Refresh() override
	{
		ClearChildren();
		vec2 baseSize = vec2(m_width / m_itemTemplate.m_width, int(ceil(m_height / float(m_itemTemplate.m_height))));

		vec2 offset = vec2(0);
		ivec2 navOffset = ivec2(0);

		for (uint i = 0; i < uint(max(equipInventoryCounterOffer.m_items.length(), baseSize.x * baseSize.y)); i++)
		{
			auto item = cast<EquipmentItemWidget>(m_itemTemplate.Clone());

			//item.SetID(cast<Equipment::Item>(equipInventoryCounterOffer.m_items[i]).baseItem.m_idHash);
			//item.SetID( equipInventoryCounterOffer.m_items[i].GetIDHash() );
			item.SetID("");
			item.m_offset = offset;
			if (i < equipInventoryCounterOffer.m_items.length())
				item.Set(equipInventoryCounterOffer.m_items[i], this);

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

				if (equipInventoryCounterOffer.m_items.length() / baseSize.x > baseSize.y)
					baseSize.y++;
			}
		}

		m_height = navOffset.y * m_itemTemplate.m_height;
	}

	void Update(int dt) override
	{
		if (!m_visible)
			return;

		if (equipInventoryCounterOffer.m_isDirty)
		{
			Refresh();
			equipInventoryCounterOffer.m_isDirty = false;
		}
	}

	void DoLayout(vec2 origin, vec2 parentSz) override
	{
		if (!m_visible)
			return;

		for (uint i = 0; i < m_children.length(); i++)
		{
			auto child = cast<EquipmentItemWidget>(m_children[i]);
			if (child is null)
				continue;
			
			auto equip = cast<Equipment::Equipment>(child.m_item);
			if (equip !is null && !GetLocalPlayerRecord().equipped.MayEquip(equip))
				child.m_color = vec4(1.0f, 0.0f, 0.0f, 1.0f);
			else
				child.m_color = vec4(1.0f);
		}
		RectWidget::DoLayout(origin, parentSz);
	}
}

ref@ LoadTradingEquipmentInventoryCounterOfferWidget(WidgetLoadingContext &ctx)
{
	TradingEquipmentInventoryCounterOfferWidget@ w = TradingEquipmentInventoryCounterOfferWidget();
	w.Load(ctx);
	return w;
}