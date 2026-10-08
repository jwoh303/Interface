package com.koreab2b.mro.common.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdct.dao.MasterMdCtBuyerReContractPopDao;

@Service("masterMdCtBuyerReContractPopService")
public class MasterMdCtBuyerReContractPopServiceImpl implements MasterMdCtBuyerReContractPopService {
	
	@Autowired
	private MasterMdCtBuyerReContractPopDao masterMdCtBuyerReContractPopDao;

	// 팝업 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCtBuyerReContractPopDao.selectList(formData);
	}
	
	// 저장
	public String saveSelectedData (Map<String,String> formData) {
		return masterMdCtBuyerReContractPopDao.saveSelectedData(formData);
	}
}
