package com.koreab2b.mro.webservice.erp.debt;

import java.util.List;
import java.util.Map;

public interface DebtInWebService {
	List<Map<String, String>> addList(List<Map<String, String>> pHeaderList, List<Map<String, String>> pApLineList,
			List<Map<String, String>> pGlLineList, List<Map<String, String>> pTaxLineList);
}
