package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoOrderInfoAlterAfterQtyPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	
	public List<Map<String,String>> getSysopOrderChangePoAfterHDPop(Map<String,String>  formData);
	public List<Map<String,String>> getSysopOrderChangePoAfterDTPop(Map<String, Object>  formData);
	
	
	public String setSysopOrderChangeAfterQtyChange(Map<String,String>  formData, List<Object> gridData);

}
