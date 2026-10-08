package com.koreab2b.mro.common.wmco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmco.dao.MasterWmCoTranBuyerPopDao;

@Service("masterWmCoTranBuyerPopService")
public class MasterWmCoTranBuyerPopServiceImpl implements MasterWmCoTranBuyerPopService {
	
	@Autowired
	private MasterWmCoTranBuyerPopDao masterWmCoTranBuyerPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmCoTranBuyerPopDao.selectList(formData);
	}	
	

}
