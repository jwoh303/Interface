package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatalogAlterDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 엑셀 리스트 조회
	public List<Map<String,String>> selecExceltList(Map<String,Object> param);
	// MSDS리스트 조회
	public List<Map<String,String>> selectMsdsList(Map<String,Object> param);
	// MSDS상세리스트 조회
	public List<Map<String,String>> selectMsdsDetailList(Map<String,Object> param);
	// MSDS상세리스트 조회
	public List<Map<String,String>> selectMsdsHeadDetailList(Map<String,Object> param);
	public List<Map<String,String>> selectMsdsHeadDetailList_v2(Map<String,Object> param);
	
	public List<Map<String,String>> getMasterMsdsDetailList_v2(Map<String,Object> param);
	// MSDS상세등록리스트 조회
	public List<Map<String,String>> selectMsdsRegList(Map<String,Object> param);
	// MSDS상세 삭제
	public String delMasterMsdsDetailList(Map<String,String>  formData);
	// MSDS상세 수정
	public String updateMasterMsdsDetailList(Map<String,String>  formData);
	// MSDS상세 등록
	public String insertMasterMsdsDetailList(Map<String,String>  formData);
	// MSDS매핑
	public int saveMasterMsdsMapping(Map<String,String> formData, List<Object> gridData);
	// MSDS BYIT매핑
	public int saveMasterMsdsByitMapping(Map<String,String> formData, List<Object> gridData);
	
	public String getBycaComorgSelect(Map<String,Object> param);
	
	
	
	public List<Map<String,String>> getMasterMdCmCatalogMultiAlter(Map<String,Object>  param);
	public List<Map<String,String>> getWarehouseCodeList(Map<String,Object>  param);
	public List<Map<String,String>> getMasterMdCmCatalogSearchPop(Map<String,String>  param);
	
	public String batchMasterMdCmCatalogMultiAlter(Map<String, String> param,List<Object> gridData);
	public String popBatchMasterMdCmCatalogMultiAlter(Map<String, String> param);
	public String delMasterMdCmCatalogMultiAlter(Map<String, String> param,List<Object> gridData);

	
	public String  requestMasterMdCmCatalogSearchPop(Map<String, String> param,List<Object> gridData);
	public String  approvalMasterMdCmCatalogSearchPop(Map<String, String> param);

	// 결재정보 리스트 조회
	public List<Map<String,String>> selectApprInfoList(Map<String,Object> param);
	//카탈로그상태 변경
	public Map<String,String> saveSelectedStatusData(Map<String,String>  formData, List<Object> gridData);

	public List<Map<String, String>> selecCmsExcelList(Map<String, Object> param);
	
	// MSDS 매핑 해제
	public String  saveSelectedMsdsClean(Map<String, String> param,List<Object> gridData);
}
