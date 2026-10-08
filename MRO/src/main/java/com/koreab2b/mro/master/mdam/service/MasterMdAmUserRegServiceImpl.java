package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmUserRegDao;

@Service("masterMdAmUserRegService")
public class MasterMdAmUserRegServiceImpl implements MasterMdAmUserRegService {
	
	@Autowired
	private MasterMdAmUserRegDao masterMdAmUserRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmUserRegDao.selectList(param);
	}
	
	// 아이디 중복체크
	public String getIDCheck(Map<String,String> formData) {
		return masterMdAmUserRegDao.selectIDCheck(formData);
	}
	
	// 비밀번호 룰 조회
	public String getPwdValidCheck(Map<String,String> formData) {
		return masterMdAmUserRegDao.selectPwdValidCheck(formData);
	}

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData) {
		return masterMdAmUserRegDao.updateSelectedData(formData);
	}
	// hash 저장
	@Transactional
	public String updateSelectedHashData(Map<String,String>  formData) {
		return masterMdAmUserRegDao.updateSelectedHashData(formData);
	}	
}
