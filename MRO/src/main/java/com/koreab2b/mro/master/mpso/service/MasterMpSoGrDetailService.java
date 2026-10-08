package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoGrDetailService {
	
	// 리스트조회
	public List<Map<String,String>> searchMasterMpSoGrDetailList(Map<String,Object>  param);
	public List<Map<String,String>> searchMasterMpSoGrDetailList_v2(Map<String,Object>  param);

	// 입고취소
	public String setNewGrDelChange_Item(Map<String,String>  formData, List<Object> gridData);
	public String setNewGrDelChange_Item_v2(Map<String,String>  formData, List<Object> gridData);
	// 저장
	public String saveMasterMpSoGrDetailList(Map<String,String>  formData, List<Object> gridData);
	public String saveMasterMpSoGrDetailList_v2(Map<String,String>  formData, List<Object> gridData);
}
