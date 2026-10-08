package com.kep.supplyon.dao;

import java.util.Map;

public interface ParseEDIDao {

	public void insertPurchaseOrder(Map<String, String> pMap) throws Exception;
	
	public void informErrorOccurs(Map<String, String> pMap) throws Exception;
}
