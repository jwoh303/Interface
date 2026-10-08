package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqDailySourcingDbManageListDao;

@Service("masterMpRqDailySourcingDbManageListService")
public class MasterMpRqDailySourcingDbManageListServiceImpl implements MasterMpRqDailySourcingDbManageListService {

	@Autowired
	private MasterMpRqDailySourcingDbManageListDao masterMpRqDailySourcingDbManageListDao;

	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpRqDailySourcingDbManageListDao.selectList(param);
	}

}
