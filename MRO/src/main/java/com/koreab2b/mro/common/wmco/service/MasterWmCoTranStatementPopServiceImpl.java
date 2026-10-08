package com.koreab2b.mro.common.wmco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmco.dao.MasterWmCoTranStatementPopDao;

@Service("masterWmCoTranStatementPopService")
public class MasterWmCoTranStatementPopServiceImpl implements MasterWmCoTranStatementPopService {
	
	@Autowired
	private MasterWmCoTranStatementPopDao masterWmCoTranStatementPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmCoTranStatementPopDao.selectList(formData);
	}	
	

}
