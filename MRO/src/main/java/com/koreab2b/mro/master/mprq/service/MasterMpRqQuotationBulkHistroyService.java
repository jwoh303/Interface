package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqQuotationBulkHistroyService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	// 저장
	public String insertSelectedData(Map<String,String>  formData, List<Object> gridData);

}
