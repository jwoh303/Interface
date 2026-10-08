package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

public interface MasterMpDsPckpaprDesignManageRegPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	/*등록*/
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	

}
