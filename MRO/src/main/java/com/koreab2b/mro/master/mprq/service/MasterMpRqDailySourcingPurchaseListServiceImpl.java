package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqDailySourcingPurchaseListDao;

@Service("masterMpRqDailySourcingPurchaseListService")
public class MasterMpRqDailySourcingPurchaseListServiceImpl implements MasterMpRqDailySourcingPurchaseListService {

	@Autowired
	private MasterMpRqDailySourcingPurchaseListDao masterMpRqDailySourcingPurchaseListDao;

	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpRqDailySourcingPurchaseListDao.selectList(param);
	}

}
