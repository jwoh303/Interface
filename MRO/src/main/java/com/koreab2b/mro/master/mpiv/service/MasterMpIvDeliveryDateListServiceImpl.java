package com.koreab2b.mro.master.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpiv.dao.MasterMpIvDeliveryDateListDao;

@Service("masterMpIvDeliveryDateListService")
public class MasterMpIvDeliveryDateListServiceImpl implements MasterMpIvDeliveryDateListService {
	
	@Autowired
	private MasterMpIvDeliveryDateListDao masterMpIvDeliveryDateListDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIvDeliveryDateListDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIvDeliveryDateListDao.updateSelectedData(formData, gridData);
	}	

}
