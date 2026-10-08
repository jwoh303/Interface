package com.koreab2b.mro.master.wmre.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmre.dao.MasterWmReReturnProgressStateDao;

@Service("masterWmReReturnProgressStateService")
public class MasterWmReReturnProgressStateServiceImpl implements MasterWmReReturnProgressStateService {
	
	@Autowired
	private MasterWmReReturnProgressStateDao masterWmReReturnProgressStateDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,String> param) {
		return masterWmReReturnProgressStateDao.selectList(param);
	}
	public List<Map<String,String>> getMasterWmReReturnProgressStateList_v2(Map<String,Object> param) {
		return masterWmReReturnProgressStateDao.getMasterWmReReturnProgressStateList_v2(param);
	}
	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmReReturnProgressStateDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmReReturnProgressStateDao.deleteSelectedData(formData, gridData);
	}
}
