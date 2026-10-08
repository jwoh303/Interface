package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmMbrcmpyRegDao;

@Service("masterMdAmMbrcmpyRegService")
public class MasterMdAmMbrcmpyRegServiceImpl implements MasterMdAmMbrcmpyRegService {
	
	@Autowired
	private MasterMdAmMbrcmpyRegDao masterMdAmMbrcmpyRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmMbrcmpyRegDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmMbrcmpyRegDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmMbrcmpyRegDao.deleteSelectedData(formData, gridData);
	}

	// 담당자명 확인
	public Map<String,String> getStaffNameCheck(Map<String,String> param) {
		return masterMdAmMbrcmpyRegDao.selectStaffNameCheck(param);
	}
}
