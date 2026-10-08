package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCtReportCustomerManageDao {
	
	// 리포트 등록 조회
	public List<Map<String,String>> selectReportList(Map<String,String> formData);
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	// 등록
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	// 저장
	public String saveMasterMdCtReportCustomerList(Map<String,String>  formData, List<Object> gridData);
	// 리포트매핑 삭제
	public String delMasterMdCtReportCustomerList(Map<String,String>  formData, List<Object> gridData);
}
