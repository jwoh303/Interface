package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatalogRecharterService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	// 재계약 저장
	public String saveMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData);
	// 재계약 취소
	public String cancleMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData);
	// 재계약 재요청
	public String reqMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData);
	// 재계약 단가반영 요청
	public String approvalMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData);
	
}
