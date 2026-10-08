package com.koreab2b.mro.master.mdcd.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcd.dao.MasterMdCdBuyerCardManageDao;

@Service("masterMdCdBuyerCardManageService")
public class MasterMdCdBuyerCardManageServiceImpl implements MasterMdCdBuyerCardManageService {
	
	@Autowired
	private MasterMdCdBuyerCardManageDao masterMdCdBuyerCardManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCdBuyerCardManageDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData) {
		return masterMdCdBuyerCardManageDao.updateSelectedData(formData);
	}	

}
