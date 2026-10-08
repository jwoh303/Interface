package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfErrMngDao;

@Service("masterMpIfErrMngService")
public class MasterMpIfErrMngServiceImpl implements MasterMpIfErrMngService {
	
	@Autowired
	private MasterMpIfErrMngDao masterMpIfErrMngDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIfErrMngDao.selectList(param);
	}
	
	@Transactional
	public String insertTotal(Map<String, Object> param) {
		return masterMpIfErrMngDao.insertTotal(param);
	}

	@Transactional
	public String insertSubTotal(Map<String, String> formData, List<Object> gridData) {
		return masterMpIfErrMngDao.insertSubTotal(formData, gridData);
	}

	public List<Map<String, String>> getNewList(Map<String, Object> param) {
		return masterMpIfErrMngDao.selectNewList(param);
	}

	public List<Map<String, String>> getMpifNewErrMngPop(Map<String, Object> pMap) {
		return masterMpIfErrMngDao.selectMpifNewErrMngPop(pMap);
	}

	@Transactional
	public String saveMpifNewErrMngPop(Map<String, String> pMap) {
		return masterMpIfErrMngDao.saveMpifNewErrMngPop(pMap);
	}

}
