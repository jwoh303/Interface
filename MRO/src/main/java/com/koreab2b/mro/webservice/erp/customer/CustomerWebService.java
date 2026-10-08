package com.koreab2b.mro.webservice.erp.customer;

import java.util.List;
import java.util.Map;

public interface CustomerWebService {
	List<Map<String,String>> getList(List<Map<String, String>> pSearchList);
}
