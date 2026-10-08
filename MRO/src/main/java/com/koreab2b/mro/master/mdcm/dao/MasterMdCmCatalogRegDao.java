package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatalogRegDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 등록
	public String regSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 품의상신
	public Map<String,String> consSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 일괄업로드
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 복사
	public String copySelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// CMS등록
	public String confirmSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	//매출원가 적용 여부 조회
	public String getBuyerRateAdaptFlag(Map<String,String>  pMap);
	
	public String getBuyerRateInfo(Map<String,String>  pMap);
	
	public String getProcessTypeRateInfo(Map<String,String>  pMap);
	
	public String getBuyerStandardRate(Map<String,String>  pMap);
	
	public Map<String,String> getTotProcessTypeRateInfo(Map<String,String>  pMap);
	
	public String ncaRequest(Map<String,String>  formData);
	public String ncaCancel(Map<String,String>  formData);
	public String ncaApproval(Map<String,String>  formData);
	public String ncaReject(Map<String,String>  formData);
	public List<Map<String,String>> ncaResultList(Map<String,String>  formData);
	public List<Map<String,String>> scaResultList(Map<String,String>  formData);
	
	public String getCatalogRegBottomOrgCodeMultiPop(Map<String,String>  pMap);
	//재계약 취소
	public String rctCancel(Map<String,String>  formData);	
	

}
