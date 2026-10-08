package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoClosingDetailDao {
	
	// 리스트 조회
	public List<Map<String,String>> searchMasterMpSoClosingDetailList(Map<String,Object> param);

	// 취소
	public String setNewGrDelChange_Item(Map<String,String>  formData, List<Object> gridData);

	// 삭제
	public String setNewPODelete_Item(Map<String,String>  formData, List<Object> gridData);

}
