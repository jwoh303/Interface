package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqDailySourcingBuyerSelPopDao;

@Service("masterMpRqDailySourcingBuyerSelPopService")
public class MasterMpRqDailySourcingBuyerSelPopServiceImpl implements MasterMpRqDailySourcingBuyerSelPopService {

	@Autowired
	private MasterMpRqDailySourcingBuyerSelPopDao masterMpRqDailySourcingBuyerSelPopDao;

	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqDailySourcingBuyerSelPopDao.selectList(formData);
	}

}
