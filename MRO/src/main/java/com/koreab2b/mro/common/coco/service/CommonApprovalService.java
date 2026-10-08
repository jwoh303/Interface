package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;


public interface CommonApprovalService {	 
	
	
	public List<Map<String,String>> buyerNewPassRecvList(Map<String,String>  _pMap);
	public List<Map<String,String>> buyerNewPassCompleteList(Map<String,String>  _pMap);
	public List<Map<String,String>>  buyerNewPassSendList(Map<String,String>  _pMap);
	
	public List<Map<String,String>> buyerNewPassList_v2(Map<String,Object>  _pMap);
 
	public List<Map<String,String>>  getCommonApprovalListPop(Map<String,String>  _pMap);
	public List<Map<String,String>>  getCommonApprovalListPop_v2(Map<String,Object>  _pMap);
	
	public Map<String,Object>  getBuyerCommonMyPagePop(Map<String,String>  _pMap);
	public Map<String,Object>  getBuyerCommonPrPxData(Map<String,String>  _pMap);
	public Map<String,Object>  getBuyerCommonNgNsData(Map<String,String>  _pMap);
	
	
	public List<Map<String,String>>   getApprovalLine(Map<String,String>  _pMap);
	public List<Map<String,String>>   getApprovalLine_v2(Map<String,String>  _pMap);
	public Map<String,Object>  getApprovalInfo(Map<String,String>  _pMap);
	
	public List<Map<String,String>>   getCateApprovalLine(Map<String,String>  _pMap);

	public List<Map<String,String>>   getMultiPassLine(Map<String,String>  _pMap);
	public List<Map<String,String>>   getMultiPassLine_v2(Map<String,Object>  _pMap);
	
	public List<Map<String,String>>   getCurrentPassLine_v2(Map<String,Object>  _pMap);
	
	public String approval(Map<String, String> _pMap);
	//결재 메일 재발송 
	public String commonApprovalMailSend(Map<String, String> _pMap);
	public String updateContent(Map<String, String> _pMap); 
	public String updateContent_v2(Map<String, String> _pMap); 
	public String cancel(Map<String, String> _pMap); 
	
	public String reject(Map<String, String> _pMap); 
	public String request(Map<String, String> _pMap); 
	public String request_temp(Map<String, String> _pMap); 
	
	public void test(Map<String, String> _pMap);
	public void test1(Map<String, String> _pMap);
	
	public  List<Map<String,String>>    getIcomTrgwList(Map<String,String>  _pMap);
	
	public List<Map<String,String>>   approvalPrListPop(Map<String,String>  _pMap);
	public List<Map<String,String>>   approvalPxListPop(Map<String,String>  _pMap);
	public List<Map<String,String>>   approvalPxListPop2(Map<String,String>  _pMap);
	
	public List<Map<String,String>>   approvalPrListPop_v2(Map<String,Object>  _pMap);
	public List<Map<String,String>>   approvalPxListPop_v2(Map<String,Object>  _pMap);
	
	public List<Map<String,String>>   approvalOeListPop(Map<String,String>  _pMap);
	public List<Map<String,String>>   approvalOfListPop(Map<String,String>  _pMap);
	public String rejectPrListPop(Map<String, String> formData);
	public String rejectPrListPop_v2(Map<String, String> formData);
	public String rejectNgNsListPop_v2(Map<String, String> formData);
	
	public List<Map<String,String>> buyerCauNewPassRecvList(Map<String,String>  _pMap);
	public List<Map<String,String>> buyerCauNewPassRecvExcelList(Map<String,String>  _pMap);
	public List<Map<String,String>> getBuyerCauCommonMyPagePopPrList(Map<String,Object>  param);
	public Map<String,Object>  getBuyerCauCommonMyPagePop(Map<String,String>  _pMap);
	//고객사 주문 결재 일괄 반려처리 
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 고객사 별 결재 필수 포함
	public List<Map<String, String>> getBuyerApprovalLine(Map<String, String> pMap);
	
	// 카탈로그 계약변경 일괄수정(엑셀다운로드)
	public List<Map<String, String>> getExcelDownCamList(Map<String, String> pMap);
	
	public String updatePassLine_v2(Map<String,String>  formData, List<Object> gridData);
	public String updatePassLine_v3(Map<String,String>  formData, List<Object> gridData);
	public String insertAppPath_v2(Map<String,String>  formData, List<Object> gridData);
	public String deleteMyPassLine_v2(Map<String, String> _pMap); 
	
}
