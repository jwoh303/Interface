package com.koreab2b.mro.common.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpif.dao.MasterMpIfBefrPopDao;

@Service("masterMpIfBefrPopService")
public class MasterMpIfBefrPopServiceImpl implements MasterMpIfBefrPopService {
	
	@Autowired
	private MasterMpIfBefrPopDao masterMpIfBefrPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIfBefrPopDao.selectList(formData);
	}	
	

}
