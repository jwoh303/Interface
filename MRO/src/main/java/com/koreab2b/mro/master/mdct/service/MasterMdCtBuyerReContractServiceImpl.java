package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdct.dao.MasterMdCtBuyerReContractDao;

@Service("masterMdCtBuyerReContractService")
public class MasterMdCtBuyerReContractServiceImpl implements MasterMdCtBuyerReContractService {
	
	@Autowired
	private MasterMdCtBuyerReContractDao masterMdCtBuyerReContractDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCtBuyerReContractDao.selectList(param);
	}	
}
