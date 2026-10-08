package com.koreab2b.mro.master.mprq.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqDailySourcingBusinessDetailDao;

@Service("masterMpRqDailySourcingBusinessDetailService")
public class MasterMpRqDailySourcingBusinessDetailServiceImpl implements MasterMpRqDailySourcingBusinessDetailService {

	@Autowired
	private MasterMpRqDailySourcingBusinessDetailDao masterMpRqDailySourcingBusinessDetailDao;

	public Map<String,Object> getDetail(Map<String,Object> formData) {
		return masterMpRqDailySourcingBusinessDetailDao.selectDetail(formData);
	}

}
