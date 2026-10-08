package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqBuyerQuotationReceiptSendCntPopDao;

@Service("masterMpRqBuyerQuotationReceiptSendCntPopService")
public class MasterMpRqBuyerQuotationReceiptSendCntPopServiceImpl implements MasterMpRqBuyerQuotationReceiptSendCntPopService {
	
	@Autowired
	private MasterMpRqBuyerQuotationReceiptSendCntPopDao masterMpRqBuyerQuotationReceiptSendCntPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqBuyerQuotationReceiptSendCntPopDao.selectList(formData);
	}	
	// 품목정비 이력
	public List<Map<String,String>> getQuotationItemMdreqHistList(Map<String,Object> formData) {
		return masterMpRqBuyerQuotationReceiptSendCntPopDao.selectQuotationItemMdreqHistList(formData);
	}
	// 추가정비 이력
	public List<Map<String,String>> getQuotationAfterItemMdreqHistList(Map<String,Object> formData) {
		return masterMpRqBuyerQuotationReceiptSendCntPopDao.selectQuotationAfterItemMdreqHistList(formData);
	}
	// 견적특이사항 조회
	public List<Map<String,String>> getMasterMpRqQuotationRemarkList(Map<String,Object> formData) {
		return masterMpRqBuyerQuotationReceiptSendCntPopDao.selectQuotationRemarkList(formData);
	}
	// 저장
	@Transactional
	public String saveMasterMpRqQuotationRemarkPop(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqBuyerQuotationReceiptSendCntPopDao.saveMasterMpRqQuotationRemarkPop(formData, gridData);
	}
	// 삭제
	@Transactional
	public String delMasterMpRqQuotationRemarkPop(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqBuyerQuotationReceiptSendCntPopDao.delMasterMpRqQuotationRemarkPop(formData, gridData);
	}
	// 네고정비 이력
	public List<Map<String,String>> getQuotationNegoItemMdreqHistList(Map<String,Object> formData) {
		return masterMpRqBuyerQuotationReceiptSendCntPopDao.selectQuotationNegoItemMdreqHistList(formData);
	}
	// SG지정 이력
	public List<Map<String,String>> getQuotationSgDHistList(Map<String,Object> formData) {
		return masterMpRqBuyerQuotationReceiptSendCntPopDao.selectQuotationSgDHistList(formData);
	}
}
