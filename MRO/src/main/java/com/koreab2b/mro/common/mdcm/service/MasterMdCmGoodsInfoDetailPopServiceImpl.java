package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcm.dao.MasterMdCmGoodsInfoDetailPopDao;

@Service("masterMdCmGoodsInfoDetailPopService")
public class MasterMdCmGoodsInfoDetailPopServiceImpl implements MasterMdCmGoodsInfoDetailPopService {
	
	@Autowired
	private MasterMdCmGoodsInfoDetailPopDao masterMdCmGoodsInfoDetailPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCmGoodsInfoDetailPopDao.selectList(formData);
	}	
	
	// 속성정보 조회
	public List<Map<String,String>> getList2(Map<String,String> formData) {
		return masterMdCmGoodsInfoDetailPopDao.selectList2(formData);
	}	
	
	// 매핑정보 조회
	public List<Map<String,String>> getList3(Map<String,String> formData) {
		return masterMdCmGoodsInfoDetailPopDao.selectList3(formData);
	}	
	

}
