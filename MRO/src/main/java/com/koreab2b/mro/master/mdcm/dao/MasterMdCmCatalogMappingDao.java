package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatalogMappingDao {

	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	// 품목매핑
	public String saveMasterMdCmCatalogMapping(Map<String,String>  formData, List<Object> gridData);
	// 매핑반려
	public String rejectMasterMdCmCatalogMapping(Map<String,String>  formData, List<Object> gridData);
	// 매핑완료
	public String saveMasterMdCmCatalogMappingCompl(Map<String,String>  formData, List<Object> gridData);
	// 매핑삭제
	public String saveMasterMdCmCatalogMappingDel(Map<String,String>  formData, List<Object> gridData);
	// 매핑요청
	public String saveMasterMdcmReqMapping(Map<String,String>  formData, List<Object> gridData);
	// 품목보완요청
	public String saveMasterMdCmReqAgentCatalog(Map<String,String>  formData, Map<String,String>  formData2, List<Object> gridData);
	// 저장
	public String saveMasterMdcmReqRemarkAtos(Map<String,String>  formData);
	// 카테고리 속성 조회
	public List<Map<String,String>> getMasterMdCmCategoriAttb(Map<String,String> formData);
	// 품목정비 요청
	public List<Map<String,String>> getCmsComplementHistoryPop(Map<String,Object> formData);
}
