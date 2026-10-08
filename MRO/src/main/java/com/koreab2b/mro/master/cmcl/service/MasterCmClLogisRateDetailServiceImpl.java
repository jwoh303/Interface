package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClLogisRateDetailDao;

@Service("masterCmClLogisRateDetailService")
public class MasterCmClLogisRateDetailServiceImpl implements MasterCmClLogisRateDetailService {
	
	@Autowired
	private MasterCmClLogisRateDetailDao masterCmClLogisRateDetailDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClLogisRateDetailDao.selectList(param);
	}
	public List<Map<String,String>> getList_v2(Map<String,Object> param) {
		return masterCmClLogisRateDetailDao.selectList_v2(param);
	}
	
}
