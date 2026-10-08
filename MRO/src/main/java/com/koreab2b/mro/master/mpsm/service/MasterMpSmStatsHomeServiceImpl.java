package com.koreab2b.mro.master.mpsm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpsm.dao.MasterMpSmStatsHomeDao;

@Service("masterMpSmStatsHomeService")
public class MasterMpSmStatsHomeServiceImpl  implements MasterMpSmStatsHomeService {
	
	@Autowired
	private MasterMpSmStatsHomeDao masterMpSmStatsHomeDao;

	// 리스트조회
	public List<Map<String,String>> getWarhsngResultList(Map<String,Object>  param) {
		return masterMpSmStatsHomeDao.selectWarhsngResultList(param);
	}
}
