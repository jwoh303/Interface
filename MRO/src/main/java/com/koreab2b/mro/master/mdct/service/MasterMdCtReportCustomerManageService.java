package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCtReportCustomerManageService {
	// 리포트 등록 리스트
	public List<Map<String,String>> getReportList(Map<String,String>  formData);
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	// 등록
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	// 저장
	public String saveMasterMdCtReportCustomerList(Map<String,String>  formData, List<Object> gridData);
	// 고객사 매핑 삭제
	public String delMasterMdCtReportCustomerList(Map<String,String>  formData, List<Object> gridData);
	
}
