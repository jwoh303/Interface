package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatalogRegReqDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 등록 요청
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 신규 업로드
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 기등록 업로드
	public String batchRenewSelectedData(Map<String,String>  formData, List<Object> gridData);
}
