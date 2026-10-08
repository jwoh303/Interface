package com.koreab2b.mro.webservice.erp.debt;

import java.util.List;
import java.util.Map;

import com.esp.grpeccfi.k2pkbb.DTGRPFI0610Con;
import com.koreab2b.mro.util.ObjectConverter;

public class DebtInBody {

	@SuppressWarnings("unchecked")
	public DTGRPFI0610Con.Body getBody(List<Map<String, String>> pHeaderList, List<Map<String, String>> pApLineList,
			List<Map<String, String>> pGlLineList, List<Map<String, String>> pTaxLineList) {
		DTGRPFI0610Con.Body _body = new DTGRPFI0610Con.Body();

		Object _headerList = ObjectConverter.listMapToListObject(pHeaderList, DTGRPFI0610Con.Body.ITHEADER.class);
		_body.getITHEADER().addAll((List<DTGRPFI0610Con.Body.ITHEADER>) _headerList);

		Object _apLineList = ObjectConverter.listMapToListObject(pApLineList, DTGRPFI0610Con.Body.ITAPLINE.class);
		_body.getITAPLINE().addAll((List<DTGRPFI0610Con.Body.ITAPLINE>) _apLineList);

		Object _glLineList = ObjectConverter.listMapToListObject(pGlLineList, DTGRPFI0610Con.Body.ITGLLINE.class);
		_body.getITGLLINE().addAll((List<DTGRPFI0610Con.Body.ITGLLINE>) _glLineList);

		Object _taxLineList = ObjectConverter.listMapToListObject(pTaxLineList, DTGRPFI0610Con.Body.ITTAXLINE.class);
		_body.getITTAXLINE().addAll((List<DTGRPFI0610Con.Body.ITTAXLINE>) _taxLineList);

		return _body;
	}
}
