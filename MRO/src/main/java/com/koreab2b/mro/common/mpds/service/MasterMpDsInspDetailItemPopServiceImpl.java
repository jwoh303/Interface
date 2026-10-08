package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.MasterMpDsInspDetailItemPopDao;

@Service("masterMpDsInspDetailItemPopService")
public class MasterMpDsInspDetailItemPopServiceImpl implements MasterMpDsInspDetailItemPopService {
	
	@Autowired
	private MasterMpDsInspDetailItemPopDao masterMpDsInspDetailItemPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMpDsInspDetailItemPopDao.selectList(formData);
	}	
	

}
