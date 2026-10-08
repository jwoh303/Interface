package com.koreab2b.mro.search.diquest.catalog;

import java.util.ArrayList;
import java.util.List;

import com.diquest.ir.client.util.RequestHandler;
import com.diquest.ir.common.msg.protocol.Protocol;
import com.diquest.ir.common.msg.protocol.query.OrderBySet;

public class AutoOrderByPhrase {
	

	public OrderBySet[] get(RequestHandler pRequestHandler) {
		List<OrderBySet> _orderByList = new ArrayList<OrderBySet>();		 
		_orderByList.add(new OrderBySet(true,"SORT_DISPLAY",Protocol.OrderBySet.OP_NONE));
 
		
		OrderBySet[] _orderBySet = new OrderBySet[_orderByList.size()];
		_orderByList.toArray(_orderBySet);

		return _orderBySet;
	}
}
