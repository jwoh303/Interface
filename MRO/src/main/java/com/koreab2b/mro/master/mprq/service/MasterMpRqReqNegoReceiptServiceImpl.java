package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqReqNegoReceiptDao;

@Service("masterMpRqReqNegoReceiptService")
public class MasterMpRqReqNegoReceiptServiceImpl implements MasterMpRqReqNegoReceiptService {
	
	@Autowired
	private MasterMpRqReqNegoReceiptDao masterMpRqReqNegoReceiptDao;

	/*리스트 조회*/
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpRqReqNegoReceiptDao.selectList(param);
	}	

	/*저장*/
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqNegoReceiptDao.updateSelectedData(formData, gridData);
	}	

	/*고객사 Nego견적제출*/
	@Transactional
	public String negoSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqNegoReceiptDao.negoSelectedData(formData, gridData);
	}

	/*삭제*/
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqNegoReceiptDao.deleteSelectedData(formData, gridData);
	}
	
	// 네고정비 요청
	@Transactional
	public String updateNegoItemChgReqData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqNegoReceiptDao.updateNegoItemChgReqData(formData, gridData);
	}
	
	// 네고정비 제출
	@Transactional
	public String updateMasterMpRqNegoItmCheSend(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqReqNegoReceiptDao.updateMasterMpRqNegoItmCheSend(formData, gridData);
	}
}
