package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmSellerMbrcmpyRegDao;

@Service("masterMdAmSellerMbrcmpyRegService")
public class MasterMdAmSellerMbrcmpyRegServiceImpl implements MasterMdAmSellerMbrcmpyRegService {
	
	@Autowired
	private MasterMdAmSellerMbrcmpyRegDao masterMdAmSellerMbrcmpyRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmSellerMbrcmpyRegDao.selectList(param);
	}	
	
	// 아이디 중복체크
	public String getIDCheck(Map<String,String> formData) {
		return masterMdAmSellerMbrcmpyRegDao.selectIDCheck(formData);
	}
	
	// 비밀번호 룰 조회
	public String getPwdValidCheck(Map<String,String> formData) {
		return masterMdAmSellerMbrcmpyRegDao.selectPwdValidCheck(formData);
	}
		
	// 저장
	@Transactional
	public Map<String, Object> updateSelectedData(Map<String,String>  formData) {
		return masterMdAmSellerMbrcmpyRegDao.updateSelectedData(formData);
	}

	// 가입여부 확인
	public Map<String,String> getIrsCheck(Map<String,String> formData) {
		return masterMdAmSellerMbrcmpyRegDao.selectIrsCheck(formData);
	}
}
