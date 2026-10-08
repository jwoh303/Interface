package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoPrewarhsngRequestAllRegPopDao {

	// 저장
	public String saveExcelUp(Map<String,String>  formData);
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	// 선입고 요청 등록
	public String updateMasterMpSoPrewarhsngRequestAllRegPop(Map<String,String>  formData, List<Object> gridData);

}
