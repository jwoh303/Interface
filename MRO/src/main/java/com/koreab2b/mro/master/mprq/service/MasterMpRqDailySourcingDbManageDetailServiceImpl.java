package com.koreab2b.mro.master.mprq.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqDailySourcingDbManageDetailDao;

@Service("masterMpRqDailySourcingDbManageDetailService")
public class MasterMpRqDailySourcingDbManageDetailServiceImpl implements MasterMpRqDailySourcingDbManageDetailService {

	@Autowired
	private MasterMpRqDailySourcingDbManageDetailDao masterMpRqDailySourcingDbManageDetailDao;

	public Map<String,Object> getDetail(Map<String,Object> formData) {
		return masterMpRqDailySourcingDbManageDetailDao.selectDetail(formData);
	}

}
