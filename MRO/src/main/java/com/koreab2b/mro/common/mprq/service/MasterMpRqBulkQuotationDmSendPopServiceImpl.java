package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqBulkQuotationDmSendPopDao;


@Service("masterDmSendPopService")
public class MasterMpRqBulkQuotationDmSendPopServiceImpl implements MasterMpRqBulkQuotationDmSendPopService {
	
	@Autowired
	private MasterMpRqBulkQuotationDmSendPopDao masterMdCmAgentDmSendPopDao;

	// 메일 전송
	@Transactional
	public String saveMasterDmSend(Map<String,String> formData, List<Object> gridData) {
		return masterMdCmAgentDmSendPopDao.saveMasterMpRqAgentDmSend(formData, gridData);
	}


}
