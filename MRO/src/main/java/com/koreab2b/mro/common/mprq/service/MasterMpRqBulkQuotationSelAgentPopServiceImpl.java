package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqBulkQuotationSelAgentPopDao;


@Service("MasterMpRqBulkQuotationSelAgentPopService")
public class MasterMpRqBulkQuotationSelAgentPopServiceImpl implements MasterMpRqBulkQuotationSelAgentPopService {
	
	@Autowired
	private MasterMpRqBulkQuotationSelAgentPopDao MasterMpRqBulkQuotationSelAgentDao;

	// 협력사 조회
	@Override
	public List<Map<String, String>> getMasterMpRqBulkQuotationSelAgent(Map<String, String> param) {
		return MasterMpRqBulkQuotationSelAgentDao.selectdata(param);
	}

	// 우선 협력사 조회
	@Override
	public List<Map<String, String>> getMasterMpRqBulkQuotationSelAgent2(Map<String, String> param) {
		return MasterMpRqBulkQuotationSelAgentDao.selectdata2(param);
	}
	
	// 우선협력사 저장
	@Override
	public String saveMasterMpRqBulkQuotationSelAgent(Map<String, String> formData, List<Object> gridData) {
		return MasterMpRqBulkQuotationSelAgentDao.insertdata(formData, gridData);
	}
	// 협력사 삭제
	@Override
	public String delMasterMpRqBulkQuotationSelAgent(Map<String, String> formData,  List<Object> gridData) {
		return MasterMpRqBulkQuotationSelAgentDao.deletedata(formData, gridData);
	}

	// 견적에 선택 협력사 추가
	@Override
	public String saveMasterMpRqBulkQuotationSelAgentPopRFQ(Map<String, String> formData, List<Object> gridData) {
		return MasterMpRqBulkQuotationSelAgentDao.insertRfqdata(formData, gridData);
	}


}
