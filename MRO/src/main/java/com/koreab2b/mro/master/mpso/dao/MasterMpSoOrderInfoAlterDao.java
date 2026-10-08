package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoOrderInfoAlterDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	
	
	
	
	
	
	
	
	
	
	
	// 리스트조회 ( 일괄)
	public List<Map<String,String>> getMasterMpSoOrderInfoAlterMultiList(Map<String,Object>  param);
	public List<Map<String,String>> getMasterMpSoOrderInfoAlterMultiList_v2(Map<String,Object>  param);

	// 저장  ( 일괄)
	public String saveMasterMpSoOrderInfoAlterMultiList(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제 ( 주문정보수정  일괄) -- 승인후
	public String delMasterMpSoOrderInfoAlterMultList(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제 ( 주문정보수정 일괄) -- 상신전 삭제하는거 추가 2014.12.3
	public String delMasterMpSoOrderInfoAlterMultList2(Map<String,String>  formData);
	

}
