package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcm.dao.MasterMdCmImageViewPopDao;

@Service("masterMdCmImageViewPopService")
public class MasterMdCmImageViewPopServiceImpl implements MasterMdCmImageViewPopService {
	
	@Autowired
	private MasterMdCmImageViewPopDao masterMdCmImageViewPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCmImageViewPopDao.selectList(formData);
	}	

}
