package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqDailySourcingDupSearchPopDao;

@Service("masterMpRqDailySourcingDupSearchPopService")
public class MasterMpRqDailySourcingDupSearchPopServiceImpl implements MasterMpRqDailySourcingDupSearchPopService {

	@Autowired
	private MasterMpRqDailySourcingDupSearchPopDao masterMpRqDailySourcingDupSearchPopDao;

	public List<Map<String,String>> getCatList(Map<String,Object> formData) {
		return masterMpRqDailySourcingDupSearchPopDao.selectCatList(formData);
	}

	public List<Map<String,String>> getStdList(Map<String,Object> formData) {
		return masterMpRqDailySourcingDupSearchPopDao.selectStdList(formData);
	}

}
