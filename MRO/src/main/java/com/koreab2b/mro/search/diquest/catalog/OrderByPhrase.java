package com.koreab2b.mro.search.diquest.catalog;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.diquest.ir.client.util.RequestHandler;
import com.diquest.ir.common.msg.protocol.Protocol;
import com.diquest.ir.common.msg.protocol.query.OrderBySet;

public class OrderByPhrase {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(OrderByPhrase.class);

	public OrderBySet[] get(RequestHandler pRequestHandler) {
		List<OrderBySet> _orderByList = new ArrayList<OrderBySet>();
		
		String _searchSort = pRequestHandler.getParameter("searchSort", "WEIGHT");
		
		LOGGER.debug("searchSort : {}", _searchSort);
		
		if (_searchSort.equals("WEIGHT")) {
			_orderByList.add(new OrderBySet(true, "SORT_DESCRIPTION_LOC", Protocol.OrderBySet.OP_PREWEIGHT));
		} else if (_searchSort.equals("BUYER_ITEM_NO_DOWN")) {
			_orderByList.add(new OrderBySet(true, "SORT_BUYER_ITEM_NO", Protocol.OrderBySet.OP_POSTWEIGHT));
		} else if (_searchSort.equals("BUYER_ITEM_NO_UP")) {
			_orderByList.add(new OrderBySet(false, "SORT_BUYER_ITEM_NO", Protocol.OrderBySet.OP_POSTWEIGHT));
		} else if (_searchSort.equals("DESCRIPTION_DOWN")) {
			_orderByList.add(new OrderBySet(true, "SORT_DESCRIPTION_LOC", Protocol.OrderBySet.OP_POSTWEIGHT));
		} else if (_searchSort.equals("DESCRIPTION_UP")) {
			_orderByList.add(new OrderBySet(false, "SORT_DESCRIPTION_LOC", Protocol.OrderBySet.OP_POSTWEIGHT));
		} else if (_searchSort.equals("SPECIFICATION_DOWN")) {
			_orderByList.add(new OrderBySet(true, "SORT_SPECIFICATION", Protocol.OrderBySet.OP_POSTWEIGHT));
		} else if (_searchSort.equals("SPECIFICATION_UP")) {
			_orderByList.add(new OrderBySet(false, "SORT_SPECIFICATION", Protocol.OrderBySet.OP_POSTWEIGHT));
		} else if (_searchSort.equals("MAKER_NAME_DOWN")) {
			_orderByList.add(new OrderBySet(true, "SORT_MAKER_NAME", Protocol.OrderBySet.OP_POSTWEIGHT));
		} else if (_searchSort.equals("MAKER_NAME_UP")) {
			_orderByList.add(new OrderBySet(false, "SORT_MAKER_NAME", Protocol.OrderBySet.OP_POSTWEIGHT));
		} else if (_searchSort.equals("TARGET_PRICE_DOWN")) {
			_orderByList.add(new OrderBySet(true, "SORT_TARGET_PRICE", Protocol.OrderBySet.OP_POSTWEIGHT));
		} else if (_searchSort.equals("TARGET_PRICE_UP")) {
			_orderByList.add(new OrderBySet(false, "SORT_TARGET_PRICE", Protocol.OrderBySet.OP_POSTWEIGHT));
		} else if (_searchSort.equals("LAST_PO_DATE_DOWN")) {
			_orderByList.add(new OrderBySet(true, "SORT_LAST_PO_DATE", Protocol.OrderBySet.OP_POSTWEIGHT));
		} else if (_searchSort.equals("LAST_PO_DATE_UP")) {
			_orderByList.add(new OrderBySet(false, "SORT_LAST_PO_DATE", Protocol.OrderBySet.OP_POSTWEIGHT));
		}
		
		OrderBySet[] _orderBySet = new OrderBySet[_orderByList.size()];
		_orderByList.toArray(_orderBySet);

		return _orderBySet;
	}
}
