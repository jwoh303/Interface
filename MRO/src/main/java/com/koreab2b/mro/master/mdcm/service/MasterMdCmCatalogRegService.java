package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatalogRegService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 등록
	public String regSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 품의상신
	public Map<String,String> consSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 일괄 업로드
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 복사
	public String copySelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// CMS등록
	public String confirmSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 매출원가 적용 여부
	public String getBuyerRateAdaptFlag(Map<String,String>  pMap);
	
	public String getBuyerRateInfo(Map<String,String>  pMap);
	
	public String getProcessTypeRateInfo(Map<String,String>  pMap);
	
	public String getBuyerStandardRate(Map<String,String>  pMap);
	
	public Map<String,String> getTotProcessTypeRateInfo(Map<String,String>  pMap);	
	
	public String getCatalogRegBottomOrgCodeMultiPop(Map<String,String>  pMap);
}
