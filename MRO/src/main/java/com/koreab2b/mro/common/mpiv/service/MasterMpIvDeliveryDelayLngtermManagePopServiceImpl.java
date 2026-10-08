package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.MasterMpIvDeliveryDelayLngtermManagePopDao;

@Service("masterMpIvDeliveryDelayLngtermManagePopService")
public class MasterMpIvDeliveryDelayLngtermManagePopServiceImpl implements MasterMpIvDeliveryDelayLngtermManagePopService {
	
	@Autowired
	private MasterMpIvDeliveryDelayLngtermManagePopDao masterMpIvDeliveryDelayLngtermManagePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIvDeliveryDelayLngtermManagePopDao.selectList(formData);
	}	
	

}
