package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqBulkQuotationDetailPopDao;

@Service("MasterMpRqBulkQuotationDetailPopService")
public class MasterMpRqBulkQuotationDetailPopServiceImpl implements MasterMpRqBulkQuotationDetailPopService {
	
	@Autowired
	private MasterMpRqBulkQuotationDetailPopDao MasterMpRqBulkQuotationDetailDao;

	@Override
	public String updateData(Map<String,String>  formData) {
		return MasterMpRqBulkQuotationDetailDao.updateData(formData);
	}

	@Override
	public String updateNoticeData(List<Object> gridData, Map<String, String> formData) {
		return MasterMpRqBulkQuotationDetailDao.updateNoticeData(gridData, formData);
	}

	@Override
	public Map<String, String> getProject(Map<String, Object> formData) {
		return MasterMpRqBulkQuotationDetailDao.getProject(formData);
	}

	@Override
	public List<Map<String, String>> getSheet(Map<String, Object> formData) {
		return MasterMpRqBulkQuotationDetailDao.getSheet(formData);
	}

	@Override
	public String updateBuyerData(List<Object> gridData, Map<String, String> formData) {
		return MasterMpRqBulkQuotationDetailDao.updateBuyerData(gridData, formData);
	}	
}
