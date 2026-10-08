package com.koreab2b.mro.webservice.erp.buyer;

import java.util.List;
import java.util.Map;

public interface BuyerWebService {
	List<Map<String,String>> getList(List<Map<String, String>> pSearchList);
}
