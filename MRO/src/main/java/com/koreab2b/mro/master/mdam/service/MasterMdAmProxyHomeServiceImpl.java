package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmProxyHomeDao;

@Service("masterMdAmProxyHomeService")
public class MasterMdAmProxyHomeServiceImpl implements MasterMdAmProxyHomeService {
	
	@Autowired
	private MasterMdAmProxyHomeDao masterMdAmProxyHomeDao;

	// 구매대행 홈 담당자별 실적현황 리스트조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmProxyHomeDao.selectList(param);
	}
	
	// 나의주요업무 권한 조회
	public String getMasterMdAmProxyMainWorkProcessAuthGbn(Map<String,Object>  param){
		return masterMdAmProxyHomeDao.selectMasterMdAmProxyMainWorkProcessAuthGbn(param);
	}
	
	// 나의 주요업무처리 리스트 조회
	public List<Map<String,String>> getMasterMdAmProxyMainWorkProcessList(Map<String,Object>  param){
		return masterMdAmProxyHomeDao.selectMasterMdAmProxyMainWorkProcessList(param);
	}
	
	// 담당자별 처리현황
	public List<Map<String,String>> getWorkProcessListByUser(Map<String,Object>  param){
		return masterMdAmProxyHomeDao.selectWorkProcessListByUser(param);
	}
		
	// 나의 주요업무처리 합계 조회
	public Map<String,String> getMasterMdAmProxyMainWorkProcessSumList(Map<String,Object>  param){
		return masterMdAmProxyHomeDao.selectMasterMdAmProxyMainWorkProcessSumList(param);
	}
	
	// 긴급납기/선입고 리스트
	public List<Map<String,String>> getMasterMdAmProxyDocTypeFPoList(Map<String,Object>  param){
		return masterMdAmProxyHomeDao.selectMasterMdAmProxyDocTypeFPoList(param);
	}
	
	// 고객사별 의뢰 재집계
	public String getMasterMdAmProxyBuyerRecount(Map<String,Object> param) {
		return masterMdAmProxyHomeDao.execMasterMdAmProxyBuyerRecount(param);
	}
	
}
