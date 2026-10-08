package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStBuyerResultDao;

@Service("masterMpStBuyerResultService")
public class MasterMpStBuyerResultServiceImpl implements MasterMpStBuyerResultService {
	
	@Autowired
	private MasterMpStBuyerResultDao masterMpStBuyerResultDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpStBuyerResultDao.selectList(param);
	}
	// 고객사 SG별 실적조회
	public List<Map<String,String>> getBuyerSgList(Map<String,Object> param) {
		return masterMpStBuyerResultDao.selectBuyerSgList(param);
	}
	// 협력사 SG별 실적조회
	public List<Map<String,String>> getAgentSgList(Map<String,Object> param) {
		return masterMpStBuyerResultDao.selectAgentSgList(param);
	}

}
