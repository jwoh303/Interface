package com.koreab2b.mro.common.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpif.dao.MasterMpIfOrderNoSearchPopDao;

@Service("masterMpIfOrderNoSearchPopService")
public class MasterMpIfOrderNoSearchPopServiceImpl implements MasterMpIfOrderNoSearchPopService {
	
	@Autowired
	private MasterMpIfOrderNoSearchPopDao masterMpIfOrderNoSearchPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIfOrderNoSearchPopDao.selectList(formData);
	}	
	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfOrderNoSearchPopDao.updateSelectedData(formData, gridData);
	}	
	
}
