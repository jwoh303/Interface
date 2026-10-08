package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqQuotationProceStateDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	// MSDS반려리스트 조회
	public List<Map<String,String>> selectReturnMsdsList(Map<String,Object> param);
	// MSDS견적제출
	public String saveMasterMpRqQuotationReturnMsds(Map<String,String>  formData, List<Object> gridData);
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	public String updateSelectedData2(Map<String,String>  formData, List<Object> gridData);

	// 운영사비고 저장
	public String saveMasterMprqQuotationAtoA(Map<String,String>  formData);
	//협력사 견적마감시간
	public String saveMasterMpRqQuotationAtoSDate(Map<String,String>  formData, List<Object> gridData);
	//일괄 추가라운드 요청
	public String saveMasterMpRqQuotationSelectedRound(Map<String,String>  formData, List<Object> gridData);
	//협력사견적요청 메일 전송
	public String saveMasterMpRqQuotationMailList(Map<String,String>  formData, List<Object> gridData);
	// 고객사 제출 비고 저장
	public String saveMasterMprqQuotationAtoB(Map<String,String>  formData);
	
	// ANY 정비 제출
	public String updateMasterMpRqAnyItmCheSend(Map<String,String>  formData, List<Object> gridData);
	
	// DM발송 이력
	public List<Map<String,String>> selectQuotationDmRemindHistList(Map<String,Object> formData);
	
	// 견적 비고
	public Map<String, String> selectRemarkPop(Map<String, String> formData);
	// 견적 비고 저장
	public String saveRemarkPop(Map<String, String> formData);
}
