package com.koreab2b.mro.common.none.dao;

import java.util.List;
import java.util.Map;

public interface CommonNoNeSendSmsPopDao {
	/*전송*/
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
}
