package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqItemReqStndService {
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
