package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStAgingGrDao;

@Service("masterMpStAgingGrService")
public class MasterMpStAgingGrServiceImpl implements MasterMpStAgingGrService {
	
	@Autowired
	private MasterMpStAgingGrDao masterMpStAgingGrDao;

	// 재고에이징(입고) 조회
	@Override
	public List<Map<String, String>> getAgingGrList(Map<String, Object> pMap) {
		return masterMpStAgingGrDao.getAgingGrList(pMap);
	}
	
	// 장기재고 증감현황 조회
	@Override
	public List<Map<String, String>> getLongTermStckIncrList(Map<String, Object> pMap) {
		return masterMpStAgingGrDao.getLongTermStckIncrList(pMap);
	}
	
	// 재고에이징(입고) 상세 조회
	@Override
	public List<Map<String, String>> getAgingGrDtList(Map<String, Object> pMap) {
		return masterMpStAgingGrDao.getAgingGrDtList(pMap);
	}
}
