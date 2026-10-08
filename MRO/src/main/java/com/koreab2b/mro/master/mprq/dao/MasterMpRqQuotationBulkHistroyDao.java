package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqQuotationBulkHistroyDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	// 저장
	public String insertSelectedData(Map<String,String>  formData, List<Object> gridData);

}
