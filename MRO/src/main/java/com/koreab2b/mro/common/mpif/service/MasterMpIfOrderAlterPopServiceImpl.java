package com.koreab2b.mro.common.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpif.dao.MasterMpIfOrderAlterPopDao;

@Service("masterMpIfOrderAlterPopService")
public class MasterMpIfOrderAlterPopServiceImpl implements MasterMpIfOrderAlterPopService {
	
	@Autowired
	private MasterMpIfOrderAlterPopDao masterMpIfOrderAlterPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIfOrderAlterPopDao.selectList(formData);
	}	
	

}
