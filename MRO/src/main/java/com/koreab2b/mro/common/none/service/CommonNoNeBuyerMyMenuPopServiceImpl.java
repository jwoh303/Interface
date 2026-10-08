package com.koreab2b.mro.common.none.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.none.dao.CommonNoNeBuyerMyMenuPopDao;

@Service("commonNoNeBuyerMyMenuPopService")
public class CommonNoNeBuyerMyMenuPopServiceImpl implements CommonNoNeBuyerMyMenuPopService {
	@Autowired
	private CommonNoNeBuyerMyMenuPopDao commonNoNeBuyerMyMenuPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonNoNeBuyerMyMenuPopDao.selectList(formData);
	}
	
	// 나의 메뉴 목록 조회
	public List<Map<String,String>> getMyMenuList(Map<String,String>  formData) {
		return commonNoNeBuyerMyMenuPopDao.selectMyMenuList(formData);
	}
	
	// 저장
	public String saveCommonNoNeBuyerMyMenu(Map<String,String> pMap) {
		return commonNoNeBuyerMyMenuPopDao.insertCommonNoNeBuyerMyMenu(pMap);
	}

}
