package com.koreab2b.mro.master.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcp.dao.MasterMdCpAgntcmpyDao;

@Service("masterMdCpAgntcmpyService")
public class MasterMdCpAgntcmpyServiceImpl implements MasterMdCpAgntcmpyService {
	
	@Autowired
	private MasterMdCpAgntcmpyDao masterMdCpAgntcmpyDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCpAgntcmpyDao.selectList(param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> getExcelList(Map<String,Object> param) {
		return masterMdCpAgntcmpyDao.selectExcelList(param);
	}
	
	// 신용평가여부 조회
	public String getCreaditCnt(Map<String,Object> param) {
		return masterMdCpAgntcmpyDao.selectCreaditCnt(param);
	}

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCpAgntcmpyDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCpAgntcmpyDao.deleteSelectedData(formData, gridData);
	}
}
