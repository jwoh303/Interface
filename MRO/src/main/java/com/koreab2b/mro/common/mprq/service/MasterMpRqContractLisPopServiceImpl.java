package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqContractLisPopDao;

@Service("masterMpRqContractLisPopService")
public class MasterMpRqContractLisPopServiceImpl implements MasterMpRqContractLisPopService {
	
	@Autowired
	private MasterMpRqContractLisPopDao masterMpRqContractLisPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqContractLisPopDao.selectList(formData);
	}	
	

}
