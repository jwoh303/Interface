package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqBulkQuotationAddAgentPopDao;


@Service("MasterMpRqBulkQuotationAddAgentPopService")
public class MasterMpRqBulkQuotationAddAgentPopServiceImpl implements MasterMpRqBulkQuotationAddAgentPopService {
	
	@Autowired
	private MasterMpRqBulkQuotationAddAgentPopDao MasterMpRqBulkQuotationAddAgentDao;

	// 품목정보 조회
	@Override
	public Map<String, String> getItem(Map<String, String> param) {
		return MasterMpRqBulkQuotationAddAgentDao.selectItem(param);
	}
	
	// 협력사 조회
	@Override
	public List<Map<String, String>> getMasterMpRqBulkQuotationAddAgent(Map<String, String> param) {
		return MasterMpRqBulkQuotationAddAgentDao.selectdata(param);
	}
	
	// 협력사 삭제
	@Override
	public String delMasterMpRqBulkQuotationAddAgent(Map<String, String> formData,  List<Object> gridData) {
		return MasterMpRqBulkQuotationAddAgentDao.deletedata(formData, gridData);
	}

	// 진행현황
	@Override
	public List<Map<String, String>> getMasterMpRqBulkQuotationAddAgentListPop(Map<String, String> param) {
		return MasterMpRqBulkQuotationAddAgentDao.selectListdata(param);
	}


}
