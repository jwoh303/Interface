package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvDetailInvoiceCreationPopDao;

@Service("commonMpIvDetailInvoiceCreationPopService")
public class CommonMpIvDetailInvoiceCreationPopServiceImpl implements CommonMpIvDetailInvoiceCreationPopService {
	
	@Autowired
	private CommonMpIvDetailInvoiceCreationPopDao commonMpIvDetailInvoiceCreationPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonMpIvDetailInvoiceCreationPopDao.selectList(formData);
	}
	
	// 송장등록
	public Map<String, String> saveCommonMpIvDetailInvoiceCreationPop(Map<String, String> pMap){
		return commonMpIvDetailInvoiceCreationPopDao.saveCommonMpIvDetailInvoiceCreationPop(pMap);
	}
	

}
