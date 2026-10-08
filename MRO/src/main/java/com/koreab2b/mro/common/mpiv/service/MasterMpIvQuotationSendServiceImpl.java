package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.MasterMpIvQuotationSendDao;

@Service("masterMpIvQuotationSendService")
public class MasterMpIvQuotationSendServiceImpl implements MasterMpIvQuotationSendService {
	
	@Autowired
	private MasterMpIvQuotationSendDao masterMpIvQuotationSendDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIvQuotationSendDao.selectList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getLngtermDelayPopList(Map<String,Object> formData) {
		return masterMpIvQuotationSendDao.selectLngtermDelayPopList(formData);
	}
	
	public String setMasterMpIvQuotationSendDelayReasonPop(Map<String,String> pMap) {
		return masterMpIvQuotationSendDao.insertMasterMpIvQuotationSendDelayReasonPop(pMap);
	}
	// 지연사유
	public List<Map<String,String>> getRqdtDelayReasonPop(Map<String,String>  pMap){
		return masterMpIvQuotationSendDao.getRqdtDelayReasonPop(pMap);
	}
	// 견적 세부진행상태
	public List<Map<String,String>> getRqdtDelayDetailPop(Map<String,String>  pMap){
		return masterMpIvQuotationSendDao.getRqdtDelayDetailPop(pMap);
	}
}
