package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmBuyerMbrcmpyRegDao;

@Service("masterMdAmBuyerMbrcmpyRegService")
public class MasterMdAmBuyerMbrcmpyRegServiceImpl implements MasterMdAmBuyerMbrcmpyRegService {
	
	@Autowired
	private MasterMdAmBuyerMbrcmpyRegDao masterMdAmBuyerMbrcmpyRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmBuyerMbrcmpyRegDao.selectList(param);
	}
	
	// 아이디 중복체크
	public String getIDCheck(Map<String,String> formData) {
		return masterMdAmBuyerMbrcmpyRegDao.selectIDCheck(formData);
	}
	
	// 비밀번호 룰 조회
	public String getPwdValidCheck(Map<String,String> formData) {
		return masterMdAmBuyerMbrcmpyRegDao.selectPwdValidCheck(formData);
	}
		
	// 저장
	@Transactional
	public Map<String, Object> updateSelectedData(Map<String,String>  formData) {
		return masterMdAmBuyerMbrcmpyRegDao.updateSelectedData(formData);
	}	
}
