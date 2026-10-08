package com.koreab2b.mro.webservice.erp.bond;

import java.util.List;
import java.util.Map;

public interface BondInWebService {
	List<Map<String, String>> addList(List<Map<String, String>> pHeaderList, List<Map<String, String>> pArLineList,
			List<Map<String, String>> pGlLineList, List<Map<String, String>> pTaxLineList);
}
