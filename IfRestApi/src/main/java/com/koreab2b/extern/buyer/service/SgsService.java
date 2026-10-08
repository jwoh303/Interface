package com.koreab2b.extern.buyer.service;

import java.util.List;
import java.util.Map;

public interface SgsService {

	public String saveSgsPurchaseOrder(List<Map<String, String>> pMaps, Map<String, String> pMap) throws Exception;
	
	public void saveLog(Map<String, String> pMap) throws Exception;
}
