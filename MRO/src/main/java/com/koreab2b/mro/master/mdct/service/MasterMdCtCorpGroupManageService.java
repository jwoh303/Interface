package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCtCorpGroupManageService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 법인코드 중복 체크
	public String getCorpCheck(Map<String,Object>  param);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String deleteSelectedData(Map<String,String>  formData);
}
