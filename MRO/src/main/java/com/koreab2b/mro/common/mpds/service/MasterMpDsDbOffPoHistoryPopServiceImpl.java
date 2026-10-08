package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.MasterMpDsDbOffPoHistoryPopDao;

@Service("masterMpDsDbOffPoHistoryPopService")
public class MasterMpDsDbOffPoHistoryPopServiceImpl implements MasterMpDsDbOffPoHistoryPopService {

	@Autowired
	private MasterMpDsDbOffPoHistoryPopDao masterMpDsDbOffPoHistoryPopDao; 
	
	public List<Map<String,String>> searchList(Map<String,Object>  pMap){
		return masterMpDsDbOffPoHistoryPopDao.selectList(pMap);
	}
}
