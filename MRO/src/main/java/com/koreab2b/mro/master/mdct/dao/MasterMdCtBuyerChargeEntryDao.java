package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCtBuyerChargeEntryDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 담당자 중복 체크
	public String selectKepUserIdCheck(Map<String,String>  formData, List<Object> gridData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
}
