package com.koreab2b.mro.master.mpiv.service;

import java.util.List;


import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpiv.dao.MasterMpIvDeliveryDelayListDao;

@Service("masterMpIvDeliveryDelayListService")
public class MasterMpIvDeliveryDelayListServiceImpl implements MasterMpIvDeliveryDelayListService {
	
	@Autowired
	private MasterMpIvDeliveryDelayListDao masterMpIvDeliveryDelayListDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIvDeliveryDelayListDao.selectList(param);
	}
	
}
