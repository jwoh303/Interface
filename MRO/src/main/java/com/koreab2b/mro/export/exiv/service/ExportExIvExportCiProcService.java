package com.koreab2b.mro.export.exiv.service;

import java.util.List;
import java.util.Map;

public interface ExportExIvExportCiProcService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// CI Item 추가등록 대상 조회
	public List<Map<String,String>> getItemList(Map<String,Object>  param);

	// 상세입고등록
	public String updateSelectedHdData(Map<String,String>  formData, List<Object> gridData);
	
	// 리스트 상세 조회
	public List<Map<String,String>> getDetailData(Map<String,Object>  param);
	
	// icomcod2 조회팝업
	public List<Map<String,String>> getExportExIvIcomCodPop(Map<String,Object>  param);	
	
	// C/L, P/L 등록
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 입고취소
	public String cancleExportExIvExportReceipt(Map<String,String>  formData, List<Object> gridData);
	
	// CI 체크
	public String getCICheck(Map<String,String>  formData);
}
