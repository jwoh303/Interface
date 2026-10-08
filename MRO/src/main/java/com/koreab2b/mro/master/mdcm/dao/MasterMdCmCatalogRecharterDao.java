package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatalogRecharterDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	//재계약 저장
	public String saveMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData);
	//재계약 취소
	public String cancleMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData);
	//재계약 재요청
	public String reqMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData);
	//재계약 단가반영요청
	public String approvalMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData);
	
}
