package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmgr.dao.MasterWmGrWarehousingNoPopDao;

@Service("masterWmGrWarehousingNoPopService")
public class MasterWmGrWarehousingNoPopServiceImpl implements MasterWmGrWarehousingNoPopService {
	
	@Autowired
	private MasterWmGrWarehousingNoPopDao masterWmGrWarehousingNoPopDao;

	// 조회
	public Map<String,String> getList1(Map<String,String> formData) {
		return masterWmGrWarehousingNoPopDao.selectList1(formData);
	}	
	public List<Map<String,String>> getList2(Map<String,String> formData) {
		return masterWmGrWarehousingNoPopDao.selectList2(formData);
	}	
	
}
