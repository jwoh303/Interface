package com.koreab2b.mro.master.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpiv.dao.MasterMpIvDeliveryRecordManageDao;

@Service("masterMpIvDeliveryRecordManageService")
public class MasterMpIvDeliveryRecordManageServiceImpl implements MasterMpIvDeliveryRecordManageService {
	
	@Autowired
	private MasterMpIvDeliveryRecordManageDao masterMpIvDeliveryRecordManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIvDeliveryRecordManageDao.selectList(param);
	}
}
