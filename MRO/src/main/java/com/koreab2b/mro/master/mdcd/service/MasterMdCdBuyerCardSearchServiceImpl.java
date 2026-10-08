package com.koreab2b.mro.master.mdcd.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdcd.dao.MasterMdCdBuyerCardSearchDao;

@Service("masterMdCdBuyerCardSearchService")
public class MasterMdCdBuyerCardSearchServiceImpl implements MasterMdCdBuyerCardSearchService {
	@Autowired
	private MasterMdCdBuyerCardSearchDao masterMdCdBuyerCardSearchDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCdBuyerCardSearchDao.selectList(param);
	}	
}
