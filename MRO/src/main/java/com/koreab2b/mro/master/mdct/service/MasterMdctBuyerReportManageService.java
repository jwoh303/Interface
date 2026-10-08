package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

public interface MasterMdctBuyerReportManageService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 개별처리
	public String updateSelectedProc(Map<String,String>  formData, List<Object> gridData);
	
	// 재생성
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 품의상신
	public String approvalMasterMdctBuyerReportManageList(Map<String,String>  formData, List<Object> gridData);
}
