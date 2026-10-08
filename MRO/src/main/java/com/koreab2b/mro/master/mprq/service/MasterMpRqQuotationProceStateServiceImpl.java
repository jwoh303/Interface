package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqQuotationProceStateDao;

@Service("masterMpRqQuotationProceStateService")
public class MasterMpRqQuotationProceStateServiceImpl implements MasterMpRqQuotationProceStateService {
	
	@Autowired
	private MasterMpRqQuotationProceStateDao masterMpRqQuotationProceStateDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpRqQuotationProceStateDao.selectList(param);
	}
	//MSDS반려리스트 조회
	public List<Map<String,String>> getReturnMsdsList(Map<String,Object> param) {
		return masterMpRqQuotationProceStateDao.selectReturnMsdsList(param);
	}	
	@Transactional
	public String saveMasterMpRqQuotationReturnMsds(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqQuotationProceStateDao.saveMasterMpRqQuotationReturnMsds(formData, gridData);
	}	
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqQuotationProceStateDao.updateSelectedData(formData, gridData);
	}	
	
	public String updateSelectedData2(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqQuotationProceStateDao.updateSelectedData2(formData, gridData);
	}	
	// 운영사 비고저장
	@Transactional
	public String saveMasterMprqQuotationAtoA(Map<String,String>  formData) {
		return masterMpRqQuotationProceStateDao.saveMasterMprqQuotationAtoA(formData);
	}
	//협력사 견적마감시간 저장.
	@Transactional
	public String saveMasterMpRqQuotationAtoSDate(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqQuotationProceStateDao.saveMasterMpRqQuotationAtoSDate(formData, gridData);
	}
	//일괄 추가라운드 요청
	@Transactional
	public String saveMasterMpRqQuotationSelectedRound(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqQuotationProceStateDao.saveMasterMpRqQuotationSelectedRound(formData, gridData);
	}
	//협력사견적요청 메일 전송
	@Transactional
	public String saveMasterMpRqQuotationMailList(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqQuotationProceStateDao.saveMasterMpRqQuotationMailList(formData, gridData);
	}
	// 고객사 제출 비고 저장
	@Transactional
	public String saveMasterMprqQuotationAtoB(Map<String,String>  formData) {
		return masterMpRqQuotationProceStateDao.saveMasterMprqQuotationAtoB(formData);
	}
	// ANY 정비 제출
	@Transactional
	public String updateMasterMpRqAnyItmCheSend(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqQuotationProceStateDao.updateMasterMpRqAnyItmCheSend(formData, gridData);
	}
	// DM발송 이력
	public List<Map<String,String>> getQuotationDmRemindHistList(Map<String,Object> formData) {
		return masterMpRqQuotationProceStateDao.selectQuotationDmRemindHistList(formData);
	}
	// 견적 비고
	public Map<String, String> getRemarkPop(Map<String, String> formData) {
		return masterMpRqQuotationProceStateDao.selectRemarkPop(formData);
	}
	@Override
	public String saveRemarkPop(Map<String, String> formData) {
		return masterMpRqQuotationProceStateDao.saveRemarkPop(formData);
	}
}
