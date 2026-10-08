package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdct.dao.MasterMdCtBuyerProfileDao;

@Service("masterMdCtBuyerProfileService")
public class MasterMdCtBuyerProfileServiceImpl implements MasterMdCtBuyerProfileService {
	
	@Autowired
	private MasterMdCtBuyerProfileDao masterMdCtBuyerProfileDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCtBuyerProfileDao.selectList(param);
	}	
	
	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCtBuyerProfileDao.deleteSelectedData(formData, gridData);
	}
}
