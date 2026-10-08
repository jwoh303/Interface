package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqReqQuotReceiptDao;

@Service("masterMpRqReqQuotReceiptService")
public class MasterMpRqReqQuotReceiptServiceImpl implements MasterMpRqReqQuotReceiptService {
	
	@Autowired
	private MasterMpRqReqQuotReceiptDao masterMpRqReqQuotReceiptDao;

	/*리스트 조회*/
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpRqReqQuotReceiptDao.selectList(param);
	}	

	/*저장*/
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.updateSelectedData(formData, gridData);
	}
	
	/*품목재정비 요청*/
	@Transactional
	public String updateItemChgReqData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.updateItemChgReqData(formData, gridData);
	}	

	/*견적요청*/
	@Transactional
	public String orderSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.orderSelectedData(formData, gridData);
	}

	/*삭제*/
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.deleteSelectedData(formData, gridData);
	}
	/*전략소싱팀 추가라운드*/
	@Transactional
	public String updateSoMasterMpRqReqNegoReceipt(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.updateSoMasterMpRqReqNegoReceipt(formData, gridData);
	}
	/*표준카탈로그매핑*/
	public String saveMasterMpRqStndCatalgListPop(Map<String,String>  formData){
		return masterMpRqReqQuotReceiptDao.saveMasterMpRqStndCatalgListPop(formData);
	}
	// 조회
	public List<Map<String,String>> getMsdsInfo(Map<String,String> formData) {
		return masterMpRqReqQuotReceiptDao.getMsdsInfo(formData);
	}
	/*견적이관*/
	@Transactional
	public String updateMasterMpRqReqQuotTrans(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.updateMasterMpRqReqQuotTrans(formData, gridData);
	}
	//고객사납품가능지역 저장
	@Transactional
	public String saveMasterMpRqDelyArea(Map<String,String>  formData) {
		return masterMpRqReqQuotReceiptDao.saveMasterMpRqDelyArea(formData);
	}
	/*SG 지정*/
	@Transactional
	public String updateMasterMpRqSGInfo(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.updateMasterMpRqSGInfo(formData, gridData);
	}
	/*SG 지정취소*/
	@Transactional
	public String updateMasterMpRqSGCancle(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.updateMasterMpRqSGCancle(formData, gridData);
	}
	/*품목정비 제출*/
	@Transactional
	public String updateMasterMpRqItmCheSend(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.updateMasterMpRqItmCheSend(formData, gridData);
	}
	/* 견적특이사항 메일 발송 */
	@Transactional
	public String insertAddNoteSendMail(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.insertAddNoteSendMail(formData, gridData);
	}
	/*운영비고일괄 입력*/
	@Transactional
	public String saveMasterMpRqReqQuotAdminRemark(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.saveMasterMpRqReqQuotAdminRemark(formData, gridData);
	}
	/*SG지정 재요청 사유*/
	@Transactional
	public String updateMasterMpRqSgDReq(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.updateMasterMpRqSgDReq(formData, gridData);
	}
	/*DB클린징 등록 상품이미지 복사*/
	@Transactional
	public String updateMasterMpRqDbCleansingImageCopy(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.updateMasterMpRqDbCleansingImageCopy(formData, gridData);
	}
	/*DB클린징(이미지포함) 복사*/
	@Transactional
	public String updateMasterMpRqDbCleansingCopy(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqQuotReceiptDao.updateMasterMpRqDbCleansingCopy(formData, gridData);
	}
}
