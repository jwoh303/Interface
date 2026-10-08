package com.koreab2b.mro.master.mdcd.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdcd.dao.MasterMdCdAgentCardSearchDao;

@Service("masterMdCdAgentCardSearchService")
public class MasterMdCdAgentCardSearchServiceImpl implements MasterMdCdAgentCardSearchService {
	@Autowired
	private MasterMdCdAgentCardSearchDao masterMdCdAgentCardSearchDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCdAgentCardSearchDao.selectList(param);
	}	
}
