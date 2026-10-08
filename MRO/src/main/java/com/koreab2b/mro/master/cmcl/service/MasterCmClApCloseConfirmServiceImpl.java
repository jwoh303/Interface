package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClApCloseConfirmDao;



@Service("masterCmClApCloseConfirmService")
public class MasterCmClApCloseConfirmServiceImpl implements MasterCmClApCloseConfirmService {
	
	@Autowired
	private MasterCmClApCloseConfirmDao masterCmClApCloseConfirmDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClApCloseConfirmDao.selectList(param);
	}

	// 제출취소, 회계전송
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData) {
		return masterCmClApCloseConfirmDao.updateSelectedData(formData, gridData);
	}
	public String updateSelectedData_v2(Map<String, String> formData, List<Object> gridData) {
		return masterCmClApCloseConfirmDao.updateSelectedData_v2(formData, gridData);
	}
	
}
