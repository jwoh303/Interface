package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmStndCatalogRegService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 생성
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 등록품의팝업
	public Map<String,String> saveMasterMdCmStndCatalogApprPop(Map<String,String>  formData, List<Object> gridData);
	// 등록품의
	public Map<String,String> saveMasterMdCmStndCatalogApprList(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 엑셀업로드
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 임시저장
	public String saveTempMasterMdCmStndCatalogRegList(Map<String,String>  formData, List<Object> gridData);
	
	// 생성
	public String saveMasterMdCmStndCatalogRegPop(Map<String,String>  formData, List<Object> gridData);
}
