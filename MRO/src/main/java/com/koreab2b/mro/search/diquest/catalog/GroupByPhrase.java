package com.koreab2b.mro.search.diquest.catalog;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.diquest.ir.client.util.RequestHandler;
import com.diquest.ir.common.msg.protocol.Protocol;
import com.diquest.ir.common.msg.protocol.query.GroupBySet;

public class GroupByPhrase {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(GroupByPhrase.class);
	
	public GroupBySet[] get(RequestHandler pRequestHandler) throws Exception {
		String _groupMakerName = pRequestHandler.getParameter("groupMakerName", ""); // 제조사
		String _groupCategoryText = pRequestHandler.getParameter("groupCategoryText", ""); // 카테고리명 
		
		LOGGER.debug("groupMakerName : {}", _groupMakerName);
		LOGGER.debug("groupCategoryText : {}", _groupCategoryText);

		if (!_groupMakerName.equals("")) {
			return new GroupBySet[] {
					new GroupBySet("GROUP_MAKER_NAME", (byte) (Protocol.GroupBySet.OP_COUNT | Protocol.GroupBySet.ORDER_COUNT), "DESC",
							_groupMakerName),
					new GroupBySet("GROUP_CATEGORY_TEXT", (byte) (Protocol.GroupBySet.OP_COUNT | Protocol.GroupBySet.ORDER_COUNT), "DESC") };
		} else if (!_groupCategoryText.equals("")) {
			return new GroupBySet[] {
					new GroupBySet("GROUP_MAKER_NAME", (byte) (Protocol.GroupBySet.OP_COUNT | Protocol.GroupBySet.ORDER_COUNT), "DESC"),
					new GroupBySet("GROUP_CATEGORY_TEXT", (byte) (Protocol.GroupBySet.OP_COUNT | Protocol.GroupBySet.ORDER_COUNT), "DESC",
							_groupCategoryText) };
		} else {
			return new GroupBySet[] {
					new GroupBySet("GROUP_MAKER_NAME", (byte) (Protocol.GroupBySet.OP_COUNT | Protocol.GroupBySet.ORDER_COUNT), "DESC"),
					new GroupBySet("GROUP_CATEGORY_TEXT", (byte) (Protocol.GroupBySet.OP_COUNT | Protocol.GroupBySet.ORDER_COUNT), "DESC") };
		}

	}
}
