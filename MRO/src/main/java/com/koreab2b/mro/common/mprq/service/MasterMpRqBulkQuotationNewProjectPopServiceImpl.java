package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqBulkQuotationNewProjectPopDao;

@Service("MasterMpRqBulkQuotationNewProjectPopService")
public class MasterMpRqBulkQuotationNewProjectPopServiceImpl implements MasterMpRqBulkQuotationNewProjectPopService {
	
	@Autowired
	private MasterMpRqBulkQuotationNewProjectPopDao MasterMpRqBulkQuotationNewProjectDao;

	@Transactional
	public Map<String, Object> insertData(Map<String,String>  formData) {
		return MasterMpRqBulkQuotationNewProjectDao.insertData(formData);
	}

	@Override
	public String insertNoticeData(List<Object> gridData, Map<String, String> formData) {
		return MasterMpRqBulkQuotationNewProjectDao.insertNoticeData(gridData, formData);
	}

	@Override
	public String insertBuyerData(List<Object> gridData, Map<String, String> formData) {
		return MasterMpRqBulkQuotationNewProjectDao.insertBuyerData(gridData, formData);
	}	
}
