package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdct.dao.MasterMdCtCorpGroupManageDao;

@Service("masterMdCtCorpGroupManageService")
public class MasterMdCtCorpGroupManageServiceImpl implements MasterMdCtCorpGroupManageService {
	
	@Autowired
	private MasterMdCtCorpGroupManageDao masterMdCtCorpGroupManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCtCorpGroupManageDao.selectList(param);
	}
	
	// 법인코드 중복 체크
	public String getCorpCheck(Map<String,Object> param) {
		return masterMdCtCorpGroupManageDao.selectCorpCheck(param);
	}
	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtCorpGroupManageDao.updateSelectedData(formData, gridData);
	}
	
	// 저장
	@Transactional
	public String deleteSelectedData(Map<String,String>  formData) {
		return masterMdCtCorpGroupManageDao.deleteSelectedData(formData);
	}
	
	
}
