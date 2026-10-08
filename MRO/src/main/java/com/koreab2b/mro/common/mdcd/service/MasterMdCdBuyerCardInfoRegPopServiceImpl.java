package com.koreab2b.mro.common.mdcd.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcd.dao.MasterMdCdBuyerCardInfoRegPopDao;

@Service("masterMdCdBuyerCardInfoRegPopService")
public class MasterMdCdBuyerCardInfoRegPopServiceImpl implements MasterMdCdBuyerCardInfoRegPopService {
	
	@Autowired
	private MasterMdCdBuyerCardInfoRegPopDao masterMdCdBuyerCardInfoRegPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCdBuyerCardInfoRegPopDao.selectList(formData);
	}	
	

}
