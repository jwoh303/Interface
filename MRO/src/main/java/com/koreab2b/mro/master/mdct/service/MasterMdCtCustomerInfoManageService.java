package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCtCustomerInfoManageService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	//엑셀 업로드
	public String uploadMasterMdCtCustomerInfoManage(Map<String, String> param,List<Object> gridData);
	// 잠재고객등록 팝업
	public List<Map<String,String>> getCustomerInfo(Map<String,String>  param);	
	
}
