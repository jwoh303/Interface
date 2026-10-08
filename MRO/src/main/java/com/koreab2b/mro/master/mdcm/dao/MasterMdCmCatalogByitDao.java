package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatalogByitDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	// 견적카탈로그 품목코드 매핑하기
	public int saveMasterItemNoMapping(Map<String,String> formData, List<Object> gridData);
	
}
