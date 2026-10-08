package com.koreab2b.extern.buyer.dao;

import java.util.List;
import java.util.Map;

public interface SgsDao {

	public String saveSgsPurchaseOrder(List<Map<String, String>> pMaps) throws Exception;
	
	public void saveLog(Map<String, String> pMap) throws Exception;
}
