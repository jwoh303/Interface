package com.koreab2b.mro.common.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpif.dao.MasterMpIfSourcingPopDao;

@Service("masterMpIfSourcingPopService")
public class MasterMpIfSourcingPopServiceImpl implements MasterMpIfSourcingPopService {
	
	@Autowired
	private MasterMpIfSourcingPopDao masterMpIfSourcingPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIfSourcingPopDao.selectList(formData);
	}	
	

}
