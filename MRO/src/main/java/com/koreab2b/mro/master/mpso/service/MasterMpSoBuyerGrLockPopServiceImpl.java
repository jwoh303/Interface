package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoBuyerGrLockPopDao;

@Service("masterMpSoBuyerGrLockPopService")
public class MasterMpSoBuyerGrLockPopServiceImpl implements MasterMpSoBuyerGrLockPopService {
	
	@Autowired
	private MasterMpSoBuyerGrLockPopDao masterMpSoBuyerGrLockPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoBuyerGrLockPopDao.selectList(formData);
	}
	
	// 입고잠금
	public String saveGrLock(Map<String,String>  formData){
		return masterMpSoBuyerGrLockPopDao.updateGrLock(formData);
	}
}