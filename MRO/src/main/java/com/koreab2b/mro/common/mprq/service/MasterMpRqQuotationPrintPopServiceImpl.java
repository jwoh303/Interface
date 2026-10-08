package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqQuotationPrintPopDao;

@Service("masterMpRqQuotationPrintPopService")
public class MasterMpRqQuotationPrintPopServiceImpl implements MasterMpRqQuotationPrintPopService {
	
	@Autowired
	private MasterMpRqQuotationPrintPopDao masterMpRqQuotationPrintPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqQuotationPrintPopDao.selectList(formData);
	}	
	

}
