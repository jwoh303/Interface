package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvTranBuyerChoicePopDao;

@Service("commonMpIvTranBuyerChoicePopService")
public class CommonMpIvTranBuyerChoicePopServiceImpl implements CommonMpIvTranBuyerChoicePopService {
	
	@Autowired
	private CommonMpIvTranBuyerChoicePopDao commonMpIvTranBuyerChoicePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> pMap) {
		return commonMpIvTranBuyerChoicePopDao.selectList(pMap);
	}
	public List<Map<String,String>> getCommonMpIvTranBuyerChoicePopList(Map<String,Object> pMap) {
		return commonMpIvTranBuyerChoicePopDao.getCommonMpIvTranBuyerChoicePopList(pMap);
	}	
	
	//물류 조회
	public List<Map<String,String>> getBpList(Map<String,String> pMap) {
		return commonMpIvTranBuyerChoicePopDao.selecBptList(pMap);
	}	
}
