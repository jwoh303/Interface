package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqCmpySelQuotationSendDao;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqQuotationReceiptSendDao;

@Service("masterMpRqCmpySelQuotationSendService")
public class MasterMpRqCmpySelQuotationSendServiceImpl implements MasterMpRqCmpySelQuotationSendService {
	
	@Autowired
	private MasterMpRqCmpySelQuotationSendDao masterMpRqCmpySelQuotationSendDao;

	@Autowired
	private MasterMpRqQuotationReceiptSendDao masterMpRqQuotationReceiptSendDao;
	
	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpRqCmpySelQuotationSendDao.selectList(param);
	}	
	
	// 팝업
	public List<Map<String,String>> getMasterMpRqReqUserSelPop(Map<String,Object> param) {
		return masterMpRqCmpySelQuotationSendDao.getMasterMpRqReqUserSelPop(param);
	}	

	// 견적취소
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqCmpySelQuotationSendDao.deleteSelectedData(formData, gridData);
	}
	
	// 견적저장
	@Transactional
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqCmpySelQuotationSendDao.saveSelectedData(formData, gridData);
	}
	
	// 견적초기화
	@Transactional
	public Map<String,String> initSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqCmpySelQuotationSendDao.initSelectedData(formData, gridData);
	}
	
	// 추가정비 요청
	@Transactional
	public String updateAfterItemChgReqData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqCmpySelQuotationSendDao.updateAfterItemChgReqData(formData, gridData);
	}
	
	// 추가정비 제출
	@Transactional
	public String updateMasterMpRqAfterItmCheSend(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqCmpySelQuotationSendDao.updateMasterMpRqAfterItmCheSend(formData, gridData);
	}
	
	// 견적초기화(결재 X)
	@Transactional
	public Map<String,String> initNewSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqCmpySelQuotationSendDao.initNewSelectedData(formData, gridData);
	}
}
