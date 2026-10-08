package com.koreab2b.mro.webservice.erp.customer;

import java.util.List;
import java.util.Map;

import com.esp.grpeccfi.k2pkbb.DTGRPFI0070Con;
import com.koreab2b.mro.util.ObjectConverter;

public class CustomerBody {

	@SuppressWarnings("unchecked")
	public DTGRPFI0070Con.Body getBody(List<Map<String, String>> pSearchList) {
		DTGRPFI0070Con.Body _body = new DTGRPFI0070Con.Body();
		Object _searchList = ObjectConverter.listMapToListObject(pSearchList, DTGRPFI0070Con.Body.BSEARCH.class);
		_body.getBSEARCH().addAll((List<DTGRPFI0070Con.Body.BSEARCH>) _searchList);
		return _body;
	}
}
