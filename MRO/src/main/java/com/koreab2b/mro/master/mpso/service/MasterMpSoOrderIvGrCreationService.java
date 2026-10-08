package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoOrderIvGrCreationService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 엑셀 업로딩검증 결과 조회
	public List<Map<String,String>> searchMasterMpSoBuyerOrderCreationListExcelResult(Map<String,Object>  param);

	// 엑셀 업로딩검증
	public String updateSelectedDataExcelCheck(Map<String,String>  formData, List<Object> gridData);
	
	// 엑셀 업로딩검증 결과를 저장
	public String updateMasterMpSoBuyerOrderCreationListExcelCheckResult(Map<String,String>  formData, List<Object> gridData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// PM번호 생성 - 결재 전처리
	public String getPmNoMasterMpSoBuyerOrderCreationList(Map<String,String>  formData, List<Object> gridData);


	// 결재 후처리
	public String savePmNoAfterMasterMpSoBuyerOrderCreationList(Map<String,String>  formData, List<Object> gridData);

	// 값 저장
	public String savingSelectedData(Map<String, String> formData, List<Object> pGridData);


}
