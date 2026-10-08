package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.koreab2b.mro.master.cmcl.dao.MasterCmClLogisRateMngDao;

@Service("masterCmClLogisRateMngService")
public class MasterCmClLogisRateMngServiceImpl implements MasterCmClLogisRateMngService {
	
	@Autowired
	private MasterCmClLogisRateMngDao masterCmClLogisRateMngDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClLogisRateMngDao.selectList(param);
	}

	// 저장
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData) {
		return masterCmClLogisRateMngDao.updateSelectedData(formData, gridData);
	}

	// 삭제
	public String deleteSelectedData(Map<String, String> formData, List<Object> gridData) {
		return masterCmClLogisRateMngDao.deleteSelectedData(formData, gridData);
	}

	// 예외기준 조회
	public List<Map<String, String>> getFeeList(Map<String, Object> param) {
		return masterCmClLogisRateMngDao.selectFeeList(param);
	}	
}
