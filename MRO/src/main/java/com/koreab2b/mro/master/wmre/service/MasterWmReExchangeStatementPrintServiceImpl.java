package com.koreab2b.mro.master.wmre.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmre.dao.MasterWmReExchangeStatementPrintDao;

@Service("masterWmReExchangeStatementPrintService")
public class MasterWmReExchangeStatementPrintServiceImpl implements MasterWmReExchangeStatementPrintService {
	
	@Autowired
	private MasterWmReExchangeStatementPrintDao masterWmReExchangeStatementPrintDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmReExchangeStatementPrintDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmReExchangeStatementPrintDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmReExchangeStatementPrintDao.deleteSelectedData(formData, gridData);
	}
}
