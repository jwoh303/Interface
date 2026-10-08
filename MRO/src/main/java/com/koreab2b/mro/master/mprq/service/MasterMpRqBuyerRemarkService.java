package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBuyerRemarkService {
	public List<Map<String,String>> getList(Map<String,String>  pMap);
	
	public String updateSelectedData(Map<String,String>  formData);
}
