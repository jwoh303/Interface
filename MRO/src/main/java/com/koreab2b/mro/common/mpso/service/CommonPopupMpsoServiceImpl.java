package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.CommonPopupMpsoInfoDao;

@Service("commonPopupMpsoService")
public class CommonPopupMpsoServiceImpl implements CommonPopupMpsoService {

	@Autowired
	private CommonPopupMpsoInfoDao commonPopupMpsoInfoDao; 
	
	public Map<String,String> poDetailPopHd(Map<String,String>  pMap){
		return commonPopupMpsoInfoDao.poDetailPopHd(pMap);
	}
	public List<Map<String,String>> poDetailPopDt(Map<String,String>  pMap){
		return commonPopupMpsoInfoDao.poDetailPopDt(pMap);
	}
	
	// 특수로직 (발주서인쇄) 조회
	public List<Map<String, String>> getSpecialLogicInfo(Map<String,String> formData) {
		return commonPopupMpsoInfoDao.getSpecialLogicInfo(formData);
	}
	
	public Map<String,String> poDetailHistPopHd(Map<String,String>  pMap){
		return commonPopupMpsoInfoDao.poDetailHistPopHd(pMap);
	}
	public List<Map<String,String>> poDetailHistPopDt(Map<String,String>  pMap){
		return commonPopupMpsoInfoDao.poDetailHistPopDt(pMap);
	}	
}
