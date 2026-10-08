package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdctBuyerReportManageDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 개별처리
	public String updateSelectedProc(Map<String,String>  formData, List<Object> gridData);
	
	// 재생성
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 품의상신
	public String approvalMasterMdctBuyerReportManageList(Map<String,String>  formData, List<Object> gridData);
}
