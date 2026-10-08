package com.koreab2b.mro.webservice.erp.bond;

import java.util.List;
import java.util.Map;

import com.esp.grpeccfi.k2pkbb.DTGRPFI0150Con;
import com.koreab2b.mro.util.ObjectConverter;

public class BondInBody {

	@SuppressWarnings("unchecked")
	public DTGRPFI0150Con.Body getBody(List<Map<String, String>> pHeaderList, List<Map<String, String>> pArLineList,
			List<Map<String, String>> pGlLineList, List<Map<String, String>> pTaxLineList) {
		DTGRPFI0150Con.Body _body = new DTGRPFI0150Con.Body();

		Object _headerList = ObjectConverter.listMapToListObject(pHeaderList, DTGRPFI0150Con.Body.ITHEADER.class);
		_body.getITHEADER().addAll((List<DTGRPFI0150Con.Body.ITHEADER>) _headerList);

		Object _arLineList = ObjectConverter.listMapToListObject(pArLineList, DTGRPFI0150Con.Body.ITARLINE.class);
		_body.getITARLINE().addAll((List<DTGRPFI0150Con.Body.ITARLINE>) _arLineList);

		Object _glLineList = ObjectConverter.listMapToListObject(pGlLineList, DTGRPFI0150Con.Body.ITGLLINE.class);
		_body.getITGLLINE().addAll((List<DTGRPFI0150Con.Body.ITGLLINE>) _glLineList);

		Object _taxLineList = ObjectConverter.listMapToListObject(pTaxLineList, DTGRPFI0150Con.Body.ITTAXLINE.class);
		_body.getITTAXLINE().addAll((List<DTGRPFI0150Con.Body.ITTAXLINE>) _taxLineList);

		return _body;
	}
}
