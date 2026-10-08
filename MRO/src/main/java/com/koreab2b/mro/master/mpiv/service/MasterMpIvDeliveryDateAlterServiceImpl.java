package com.koreab2b.mro.master.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpiv.dao.MasterMpIvDeliveryDateAlterDao;

@Service("masterMpIvDeliveryDateAlterService")
public class MasterMpIvDeliveryDateAlterServiceImpl implements MasterMpIvDeliveryDateAlterService {
	
	@Autowired
	private MasterMpIvDeliveryDateAlterDao masterMpIvDeliveryDateAlterDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIvDeliveryDateAlterDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIvDeliveryDateAlterDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIvDeliveryDateAlterDao.deleteSelectedData(formData, gridData);
	}
}
