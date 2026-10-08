package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBuyerRemarkDao {
	public List<Map<String,String>> getList(Map<String,String>  pMap);
	
	// 저장
	public String updateSelectedData(Map<String,String> formData);
}
