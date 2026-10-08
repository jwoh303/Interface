package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

public interface MasterMpStHeadTeamResultService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 차트조회
	public List<Map<String,String>> getList1(Map<String,Object>  param);
		
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);

}
