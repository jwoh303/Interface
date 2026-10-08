package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoOrderExchangeRateAlterDao {

	// 리스트조회 ( 일괄)
	public List<Map<String,String>> getMasterMpSoOrderExchangeRateList(Map<String,Object>  param);

	// 저장  ( 일괄)
	public String saveMasterMpSoOrderExchangeRateList(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제 ( 일괄) 
	public String delMasterMpSoOrderExchangeRateList(Map<String,String>  formData, List<Object> gridData);

}
