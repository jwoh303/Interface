package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoClosingDetailService {
	
	// 리스트조회
	public List<Map<String,String>> searchMasterMpSoClosingDetailList(Map<String,Object>  param);

	// 입고취소
	public String setNewGrDelChange_Item(Map<String,String>  formData, List<Object> gridData);
	
	// 발주삭제
	public String setNewPODelete_Item(Map<String,String>  formData, List<Object> gridData);

}
