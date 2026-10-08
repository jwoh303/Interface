package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.MasterMpIvDivsnDeliveryPlanAlterPopDao;

@Service("masterMpIvDivsnDeliveryPlanAlterPopService")
public class MasterMpIvDivsnDeliveryPlanAlterPopServiceImpl implements MasterMpIvDivsnDeliveryPlanAlterPopService {
	
	@Autowired
	private MasterMpIvDivsnDeliveryPlanAlterPopDao masterMpIvDivsnDeliveryPlanAlterPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> _pMap) {
		return masterMpIvDivsnDeliveryPlanAlterPopDao.selectList(_pMap);
	}	

	public String updateMasterMpIvDivsnDeliveryPlanAlterPop(Map<String,String> _pMap){
		return masterMpIvDivsnDeliveryPlanAlterPopDao.updateMasterMpIvDivsnDeliveryPlanAlterPop(_pMap);
	}

}
