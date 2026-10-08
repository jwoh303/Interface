package com.koreab2b.mro.buyer.wmgr.dao;

import java.util.List;
import java.util.Map;

public interface BuyerWmGrWarehousingRegDao {

	// init
	public Map<String,String> getBuyerWmGrWarehousingRegInit(Map<String,String> formData);
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public List<Map<String,String>> getBuyerWmGrWarehousingRegList_v2(Map<String,Object> formData);
	public List<Map<String,String>> getBuyerWmGrWarehousingRegList_v3(Map<String,Object> formData);
	
	// 조회조건 - userList 조회
	public List<Map<String,String>> selectUserList(Map<String,String> formData);
	
	// 입고번호 생성
	public String getOrderNo(Map<String,String> pMap);
	
	// 저장
	public String updateSelectedData(Map<String,String> formData);
	
	// 롯데칠성 입고 결재 상신
	public Map<String,String> selectGrAppSendList(Map<String,String> formData);

	//롯데칠성 입고 결재 상신 초기화
	public String updateResetGrWarehousingReg(Map<String,String>  formData, List<Object> gridData);
}
