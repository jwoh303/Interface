package com.koreab2b.mro.common.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpif.dao.MasterMpIfOrderTypePopDao;

@Service("masterMpIfOrderTypePopService")
public class MasterMpIfOrderTypePopServiceImpl implements MasterMpIfOrderTypePopService {
	
	@Autowired
	private MasterMpIfOrderTypePopDao masterMpIfOrderTypePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIfOrderTypePopDao.selectList(formData);
	}	
	

}
