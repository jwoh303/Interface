package com.koreab2b.mro.master.wmdl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmdl.dao.MasterWmDlDlvryConfirmDao;

@Service("masterWmDlDlvryConfirmService")
public class MasterWmDlDlvryConfirmServiceImpl implements MasterWmDlDlvryConfirmService {
	
	@Autowired
	private MasterWmDlDlvryConfirmDao masterWmDlDlvryConfirmDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmDlDlvryConfirmDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmDlDlvryConfirmDao.updateSelectedData(formData, gridData);
	}	

	// 택배사저장
	@Transactional
	public String updateSelectedDataCenter(Map<String,String>  formData, List<Object> gridData) {
		return masterWmDlDlvryConfirmDao.updateSelectedDataCenter(formData, gridData);
	}
	
	public List<Map<String,String>> getPop(Map<String, String> pMap) {
		return masterWmDlDlvryConfirmDao.selectPopList(pMap);
	}	
}
