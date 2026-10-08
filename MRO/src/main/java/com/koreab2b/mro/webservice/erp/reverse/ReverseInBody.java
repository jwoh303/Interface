package com.koreab2b.mro.webservice.erp.reverse;

import java.util.List;
import java.util.Map;

import com.esp.grpeccfi.k2pkbb.DTGRPFI0250Con;
import com.koreab2b.mro.util.ObjectConverter;

public class ReverseInBody {

	@SuppressWarnings("unchecked")
	public DTGRPFI0250Con.Body getBody(List<Map<String, String>> pReverseList) {
		DTGRPFI0250Con.Body _body = new DTGRPFI0250Con.Body();
		Object _reverseList = ObjectConverter.listMapToListObject(pReverseList, DTGRPFI0250Con.Body.ITREVERSE.class);
		_body.getITREVERSE().addAll((List<DTGRPFI0250Con.Body.ITREVERSE>) _reverseList);
		return _body;
	}
}
