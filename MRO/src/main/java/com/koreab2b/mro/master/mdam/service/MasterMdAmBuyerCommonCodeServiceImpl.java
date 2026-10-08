package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmBuyerCommonCodeDao;

@Service("masterMdAmBuyerCommonCodeService")
public class MasterMdAmBuyerCommonCodeServiceImpl implements MasterMdAmBuyerCommonCodeService {
	
	@Autowired
	private MasterMdAmBuyerCommonCodeDao masterMdAmBuyerCommonCodeDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmBuyerCommonCodeDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmBuyerCommonCodeDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdAmBuyerCommonCodeDao.deleteSelectedData(formData, gridData);
	}
}
