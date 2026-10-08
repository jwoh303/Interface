package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqDailySourcingBusinessListDao;

@Service("masterMpRqDailySourcingBusinessListService")
public class MasterMpRqDailySourcingBusinessListServiceImpl implements MasterMpRqDailySourcingBusinessListService {

	@Autowired
	private MasterMpRqDailySourcingBusinessListDao masterMpRqDailySourcingBusinessListDao;

	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpRqDailySourcingBusinessListDao.selectList(param);
	}

}
