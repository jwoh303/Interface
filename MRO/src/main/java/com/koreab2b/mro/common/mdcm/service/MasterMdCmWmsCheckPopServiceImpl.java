package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcm.dao.MasterMdCmWmsCheckPopDao;

@Service("masterMdCmWmsCheckPopService")
public class MasterMdCmWmsCheckPopServiceImpl implements MasterMdCmWmsCheckPopService {
	
	@Autowired
	private MasterMdCmWmsCheckPopDao masterMdCmWmsCheckPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCmWmsCheckPopDao.selectList(formData);
	}	
	

}
