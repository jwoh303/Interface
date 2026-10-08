package com.koreab2b.mro.common.mpds.service;

import java.util.List;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.MasterMpDsSeedKindPopDao;

@Service("masterMpDsSeedKindPopService")
public class MasterMpDsSeedKindPopServiceImpl implements MasterMpDsSeedKindPopService {
	
	@Autowired
	private MasterMpDsSeedKindPopDao masterMpDsSeedKindPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpDsSeedKindPopDao.selectList(formData);
	}	
	

}
