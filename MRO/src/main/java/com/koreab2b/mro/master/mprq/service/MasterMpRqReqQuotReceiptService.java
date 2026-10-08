package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqReqQuotReceiptService {
	
	/*리스트조회*/
	public List<Map<String,String>> getList(Map<String,Object>  param);

	/*저장*/
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	/*품목재정비 요청*/
	public String updateItemChgReqData(Map<String,String>  formData, List<Object> gridData);
	
	/*견적요청*/	
	public String orderSelectedData(Map<String,String>  formData, List<Object> gridData);

	/*삭제*/	
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	/*전략소싱팀 추가라운드*/	
	public String updateSoMasterMpRqReqNegoReceipt(Map<String,String>  formData, List<Object> gridData);
	/**
	 * 표준카탈로그 매핑
	 * 
	 * @param formData
	 * @return
	 */
	public String saveMasterMpRqStndCatalgListPop(Map<String, String> formData);
	/* MSDS여부 확인.*/
	public List<Map<String,String>> getMsdsInfo(Map<String,String>  formData);
	/*견적이관*/
	public String updateMasterMpRqReqQuotTrans(Map<String,String>  formData, List<Object> gridData);
	//고객사 납품가능지역 저장
	public String saveMasterMpRqDelyArea(Map<String,String> formData);
	/*SG 지정*/
	public String updateMasterMpRqSGInfo(Map<String,String>  formData, List<Object> gridData);
	/*SG 지정 취소*/
	public String updateMasterMpRqSGCancle(Map<String,String>  formData, List<Object> gridData);
	/*SG 품목정비 제출*/
	public String updateMasterMpRqItmCheSend(Map<String,String>  formData, List<Object> gridData);
	/* 견적특이사항 메일 발송 */
	public String insertAddNoteSendMail(Map<String,String>  formData, List<Object> gridData);
	/*운영비고 일괄 입력*/	
	public String saveMasterMpRqReqQuotAdminRemark(Map<String,String>  formData, List<Object> gridData);
	/*SG지정 재요청 사유*/
	public String updateMasterMpRqSgDReq(Map<String,String>  formData, List<Object> gridData);
	/*DB클린징 등록 상품이미지 복사*/
	public String updateMasterMpRqDbCleansingImageCopy(Map<String,String>  formData, List<Object> gridData);
	/*DB클린징(이미지포함) 복사*/
	public String updateMasterMpRqDbCleansingCopy(Map<String,String>  formData, List<Object> gridData);
}
