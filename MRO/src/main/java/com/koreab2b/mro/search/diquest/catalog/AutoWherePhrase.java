package com.koreab2b.mro.search.diquest.catalog;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.diquest.ir.client.util.RequestHandler;
import com.diquest.ir.common.msg.protocol.Protocol;
import com.diquest.ir.common.msg.protocol.query.WhereSet;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

public class AutoWherePhrase {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AutoWherePhrase.class);
		
	public WhereSet[] get(RequestHandler pRequestHandler) throws Exception{	
		String _searchTerm = CommonUtil.nvl(pRequestHandler.getParameter("searchTerm", ""),""); 
		
		LOGGER.debug("WhereSet searchTerm : {}", _searchTerm);  
		String _st_SessionComCode = ((SessionInfo) pRequestHandler.getSession().getAttribute("sessionInfo")).getComCode();
		String _using_catal_type = ((SessionInfo) pRequestHandler.getSession().getAttribute("sessionInfo")).getUsingCatalType();
		String _byca_comorg_code = ((SessionInfo) pRequestHandler.getSession().getAttribute("sessionInfo")).getBycaComorgCode();
		
		LOGGER.debug("sessionComCode : {}", _st_SessionComCode);
		LOGGER.debug("using_catal_type : {}", _using_catal_type);
		LOGGER.debug("byca_comorg_code : {}", _byca_comorg_code);
 
		 

		List<WhereSet> _whereList = new ArrayList<WhereSet>();
		   
	 	_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));	
	 	_whereList.add(new WhereSet("IDX_KEYWORD", Protocol.WhereSet.OP_HASALL, _searchTerm, 100));	
	 	_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));	
	 	_whereList.add(new WhereSet("IDX_FKEY", Protocol.WhereSet.OP_HASALL, _searchTerm, 100));	
	 	_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));	
	 	_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));	
	 	_whereList.add(new WhereSet("IDX_BUYER", Protocol.WhereSet.OP_HASALL, _byca_comorg_code, 100));	
		
		WhereSet[] _whereSet = new WhereSet[_whereList.size()];
		_whereList.toArray(_whereSet);
		return _whereSet;
	}

}
