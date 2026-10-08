package com.koreab2b.mro.common.none.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.none.dao.CommonNoNeMyMenuPopDao;

@Service("commonNoNeMyMenuPopService")
public class CommonNoNeMyMenuPopServiceImpl implements CommonNoNeMyMenuPopService {
	@Autowired
	private CommonNoNeMyMenuPopDao commonNoNeMyMenuPopDao;

	// 조회
	public List<Map<String,String>> getCommonNoNeMyMenuAllList(Map<String,Object> formData) {
		return commonNoNeMyMenuPopDao.getCommonNoNeMyMenuAllList(formData);
	}
	
	// 나의 메뉴 목록 조회
	public List<Map<String,String>> getCommonNoNeMyMenuList(Map<String,Object>  formData) {
		return commonNoNeMyMenuPopDao.getCommonNoNeMyMenuList(formData);
	}
	
	// 저장
	public String saveCommonNoNeMyMenu(Map<String,String>  formData, List<Object> gridData) {
		return commonNoNeMyMenuPopDao.saveCommonNoNeMyMenu(formData,gridData);
	}
	public String saveCommonNoNeMyMenuAjax(Map<String,String>  formData) {
		return commonNoNeMyMenuPopDao.saveCommonNoNeMyMenuAjax(formData);
	}
	
	// 저장
	public Map<String, Object> addCommonNoNeMyMenu(Map<String,String>  formData) {
		return commonNoNeMyMenuPopDao.addCommonNoNeMyMenu(formData);
	}
	

}
