package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIfErrMngService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 전체집계
	public String insertTotal(Map<String,Object>  param);
	
	// 부분집계
	public String insertSubTotal(Map<String,String>  formData, List<Object> gridData);

	//인터페이스 모니터링 관리 리스트 조회
	public List<Map<String, String>> getNewList(Map<String, Object> pMap);

	//인터페이스 모니터링 상세 팝업
	public List<Map<String, String>> getMpifNewErrMngPop(Map<String, Object> pMap);

	//인터페이스 모니터링 팝업 저장
	public String saveMpifNewErrMngPop(Map<String, String> pMap);
}
