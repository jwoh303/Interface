package com.koreab2b.mro.webservice.erp.buyer;

import java.util.List;
import java.util.Map;

import com.esp.grpeccfi.k2pkbb.DTGRPFI0450Con;
import com.koreab2b.mro.util.ObjectConverter;

public class BuyerBody {
	
	@SuppressWarnings("unchecked")
	public DTGRPFI0450Con.Body getBody(List<Map<String, String>> pSearchList) {
		DTGRPFI0450Con.Body _body = new DTGRPFI0450Con.Body();
		Object _searchList = ObjectConverter.listMapToListObject(pSearchList, DTGRPFI0450Con.Body.SSEARCH.class);
		_body.getSSEARCH().addAll((List<DTGRPFI0450Con.Body.SSEARCH>) _searchList);
		return _body;
	}
}
