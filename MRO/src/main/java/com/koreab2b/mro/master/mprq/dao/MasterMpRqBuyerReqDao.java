package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBuyerReqDao {
	
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData);
	public String nextVal(String cmpyId, String docType);
}
