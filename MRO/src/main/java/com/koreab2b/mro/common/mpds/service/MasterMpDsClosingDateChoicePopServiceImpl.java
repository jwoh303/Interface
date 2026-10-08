package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.MasterMpDsClosingDateChoicePopDao;

@Service("masterMpDsClosingDateChoicePopService")
public class MasterMpDsClosingDateChoicePopServiceImpl implements MasterMpDsClosingDateChoicePopService {
	
	@Autowired
	private MasterMpDsClosingDateChoicePopDao masterMpDsClosingDateChoicePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpDsClosingDateChoicePopDao.selectList(formData);
	}	
	

}
