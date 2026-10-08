package com.koreab2b.mro.common.mdsr.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdSrSrCmsDetailPopDao {
	// 조회
	public List<Map<String,String>> getMasterMdSrSrCmsDetailPop(Map<String,Object> formData);
	
	// 저장
	public String saveMasterMdSrSrCmsDetailPop(Map<String,String>  formData);
	
	// 형상관리
	public String historyMasterMdSrSrCmsDetailPop(Map<String,String>  formData);
}
