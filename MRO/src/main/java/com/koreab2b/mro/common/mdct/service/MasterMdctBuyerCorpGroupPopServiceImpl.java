package com.koreab2b.mro.common.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdct.dao.MasterMdctBuyerCorpGroupPopDao;

@Service("masterMdctBuyerCorpGroupPopService")
public class MasterMdctBuyerCorpGroupPopServiceImpl implements MasterMdctBuyerCorpGroupPopService {
	
	@Autowired
	private MasterMdctBuyerCorpGroupPopDao masterMdctBuyerCorpGroupPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdctBuyerCorpGroupPopDao.selectList(formData);
	}	
}
