package com.koreab2b.mro.master.wmgr.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmGrTrGrCreDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 리스트 조회
	public List<Map<String,String>> selectPop(Map<String,String> param);
	
	// 입고저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData);
	
	// 출고지시
	public String updateSelectedDataIvt(Map<String,String>  formData, List<Object> gridData);
	
	// DOOSAN IF
	public String saveMasterWmGrTrGrCreDoosanIF(Map<String,String>  formData);

	// 지연사유저장
	public void saveMasterWmCoDelayPop(Map<String,String>  pMap);

}
