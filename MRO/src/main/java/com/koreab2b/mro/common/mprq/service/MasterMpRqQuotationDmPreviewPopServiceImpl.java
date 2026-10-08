package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqQuotationDmPreviewPopDao;

@Service("masterMpRqQuotationDmPreviewPopService")
public class MasterMpRqQuotationDmPreviewPopServiceImpl implements MasterMpRqQuotationDmPreviewPopService {
	
	@Autowired
	private MasterMpRqQuotationDmPreviewPopDao masterMpRqQuotationDmPreviewPopDao;

	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqQuotationDmPreviewPopDao.selectList(formData);
	}
}
