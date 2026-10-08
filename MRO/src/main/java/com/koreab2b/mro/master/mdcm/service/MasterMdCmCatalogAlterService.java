package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatalogAlterService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	public String getBycaComorgSelect(Map<String, Object> param);
	
	// 엑셀 리스트조회
	public List<Map<String,String>> getExcelList(Map<String,Object>  param);
	
	// Msds리스트조회
	public List<Map<String,String>> geMsdstList(Map<String,Object>  param);	
	// Msds상세리스트조회
	public List<Map<String,String>> geMsdsDetailList(Map<String,Object>  param);
	// Msds상세헤드리스트조회
	public List<Map<String,String>> geMsdsHeadDetailList(Map<String,Object>  param);
	public List<Map<String,String>> geMsdsHeadDetailList_v2(Map<String,Object>  param);
	
	public List<Map<String,String>> getMasterMsdsDetailList_v2(Map<String,Object>  param);
	// Msds등록리스트조회
	public List<Map<String,String>> geMsdsRegList(Map<String,Object>  param);	
	// Msds매핑하기
	public int saveMasterMsdsMapping(Map<String,String>  formData, List<Object> gridData);
	// MsdsByit매핑하기
	public int saveMasterMsdsByitMapping(Map<String,String>  formData, List<Object> gridData);
	/**
	 *  Msds상세리스트삭제
	 * 
	 * @param formData
	 * @return
	 */
	public String delMasterMsdsDetailList(Map<String, String> formData);
	/**
	 *  Msds상세리스트수정
	 * 
	 * @param formData
	 * @return
	 */
	public String updateMasterMsdsDetailList(Map<String, String> formData);	
	/**
	 *  Msds상세리스트등록
	 * 
	 * @param formData
	 * @return
	 */
	public String insertMasterMsdsDetailList(Map<String, String> formData);	
	
	public List<Map<String,String>> getMasterMdCmCatalogMultiAlter(Map<String,Object>  param);
	public List<Map<String,String>> getWarehouseCodeList(Map<String,Object>  param);
	public List<Map<String,String>> getMasterMdCmCatalogSearchPop(Map<String,String>  param);
	
	public String batchMasterMdCmCatalogMultiAlter(Map<String, String> param,List<Object> gridData);
	public String popBatchMasterMdCmCatalogMultiAlter(Map<String, String> param);
	public String delMasterMdCmCatalogMultiAlter(Map<String, String> param,List<Object> gridData);

	
	public String  requestMasterMdCmCatalogSearchPop(Map<String, String> param,List<Object> gridData);
	public String  approvalMasterMdCmCatalogSearchPop(Map<String, String> param);
	// 결재정보 리스트 조회
	public List<Map<String,String>> getApprInfoList(Map<String,Object>  param);
	// 카탈로그 상태변경 저장
	public Map<String,String> saveSelectedStatusData(Map<String,String>  formData, List<Object> gridData);
	
	// 표준카테고리 리스트조회
	public List<Map<String, String>> getCmsExcelList(Map<String, Object> pMap);
	
	// MSDS 매핑 해제
	public String saveSelectedMsdsClean(Map<String, String> param,List<Object> gridData);
}
