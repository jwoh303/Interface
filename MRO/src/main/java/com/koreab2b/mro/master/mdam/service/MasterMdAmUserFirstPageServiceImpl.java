package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmUserFirstPageDao;

@Service("masterMdAmUserFirstPageService")
public class MasterMdAmUserFirstPageServiceImpl implements MasterMdAmUserFirstPageService {
	
	@Autowired
	private MasterMdAmUserFirstPageDao masterMdAmUserFirstPageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmUserFirstPageDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmUserFirstPageDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmUserFirstPageDao.deleteSelectedData(formData, gridData);
	}	
}
