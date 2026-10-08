package com.koreab2b.mro.master.mprq.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqDailySourcingPurchaseDetailDao;

@Service("masterMpRqDailySourcingPurchaseDetailService")
public class MasterMpRqDailySourcingPurchaseDetailServiceImpl implements MasterMpRqDailySourcingPurchaseDetailService {

	@Autowired
	private MasterMpRqDailySourcingPurchaseDetailDao masterMpRqDailySourcingPurchaseDetailDao;

	public Map<String,Object> getDetail(Map<String,Object> formData) {
		return masterMpRqDailySourcingPurchaseDetailDao.selectDetail(formData);
	}

}
