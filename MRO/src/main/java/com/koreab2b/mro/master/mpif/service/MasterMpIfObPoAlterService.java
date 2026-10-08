package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIfObPoAlterService {

	// 리스트조회
	public List<Map<String, String>> getList(Map<String, Object> pMap);

	// 엑셀 업로딩검증 저장
	public String updateSelectedDataExcelCheck(Map<String, String> formData, List<Object> gridData);
	
	// 실행
	public String executeDataList(Map<String, String> formData, List<Object> gridData);

	//삭제
	public String delSelectedData(Map<String, String> formData, List<Object> gridData);

}
