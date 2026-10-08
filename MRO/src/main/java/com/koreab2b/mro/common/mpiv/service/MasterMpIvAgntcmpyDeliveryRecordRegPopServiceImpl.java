package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.MasterMpIvAgntcmpyDeliveryRecordRegPopDao;

@Service("masterMpIvAgntcmpyDeliveryRecordRegPopService")
public class MasterMpIvAgntcmpyDeliveryRecordRegPopServiceImpl implements MasterMpIvAgntcmpyDeliveryRecordRegPopService {
	
	@Autowired
	private MasterMpIvAgntcmpyDeliveryRecordRegPopDao masterMpIvAgntcmpyDeliveryRecordRegPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIvAgntcmpyDeliveryRecordRegPopDao.selectList(formData);
	}	
	
	
	// 긴급납기
	public List<Map<String,String>> getMasterMpIvUrgentManagementPop(Map<String,Object>  formData) {
		return masterMpIvAgntcmpyDeliveryRecordRegPopDao.selectMasterMpIvUrgentManagementPop(formData);
	}	
	

}
