package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdct.dao.MasterMdCtBuyerGroupManageDao;

@Service("masterMdCtBuyerGroupManageService")
public class MasterMdCtBuyerGroupManageServiceImpl implements MasterMdCtBuyerGroupManageService {
	@Autowired
	private MasterMdCtBuyerGroupManageDao masterMdCtBuyerGroupManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCtBuyerGroupManageDao.selectList(param);
	}
	
	// 법인코드 중복 체크
	public String getCorpCheck(Map<String,Object> param) {
		return masterMdCtBuyerGroupManageDao.selectCorpCheck(param);
	}
	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtBuyerGroupManageDao.updateSelectedData(formData, gridData);
	}
	
	// 삭제
	@Transactional
	public String deleteSelectedData(Map<String,String>  formData) {
		return masterMdCtBuyerGroupManageDao.deleteSelectedData(formData);
	}
}
