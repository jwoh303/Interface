package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.wmgr.dao.MasterWmGrWarehousingPopDao;

@Service("masterWmGrWarehousingPopService")
public class MasterWmGrWarehousingPopServiceImpl implements MasterWmGrWarehousingPopService {
	
	@Autowired
	private MasterWmGrWarehousingPopDao masterWmGrWarehousingPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmGrWarehousingPopDao.selectList(formData);
	}	
	
	// 조회 상단
	public List<Map<String,String>> getPop(Map<String,Object> formData) {
		return masterWmGrWarehousingPopDao.selectPop(formData);
	}	
	public List<Map<String,String>> getPop_v2(Map<String,Object> formData) {
		return masterWmGrWarehousingPopDao.selectPop_v2(formData);
	}	
	
	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGrWarehousingPopDao.delSelectedData(formData, gridData);
	}	
	@Transactional
	public String delSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGrWarehousingPopDao.delSelectedData_v2(formData, gridData);
	}
}
