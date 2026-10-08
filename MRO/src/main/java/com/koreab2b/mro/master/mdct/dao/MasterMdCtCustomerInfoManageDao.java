package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCtCustomerInfoManageDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	//고객 엑셀 업로드
	public String uploadMasterMdCtCustomerInfoManage(Map<String, String> param,List<Object> gridData);
	//잠재고객등록 팝업
	public List<Map<String,String>> selectCustomerInfo(Map<String,String> param);

}
