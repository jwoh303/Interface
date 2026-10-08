package com.koreab2b.mro.master.mpvo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpvo.dao.MasterMpVoVocLeadTimeDao;

@Service("masterMpVoVocLeadTimeService")
public class MasterMpVoVocLeadTimeServiceImpl implements MasterMpVoVocLeadTimeService {
	
	@Autowired
	private MasterMpVoVocLeadTimeDao masterMpVoVocLeadTimeDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpVoVocLeadTimeDao.selectList(param);
	}	

}
