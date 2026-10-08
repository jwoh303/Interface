package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStLongTermStckListDao;

@Service("masterMpStLongTermStckListService")
public class MasterMpStLongTermStckListServiceImpl implements MasterMpStLongTermStckListService {
	@Autowired
	private MasterMpStLongTermStckListDao masterMpStLongTermStckListDao;

	// 장기재고 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpStLongTermStckListDao.selectList(param);
	}
	
	// 장기재고 상세 팝업 조회
	public List<Map<String,String>> getPopList(Map<String,Object> param) {
		return masterMpStLongTermStckListDao.selectPopList(param);
	}
		
	// 장기재고 상세 리스트 조회
	public List<Map<String,String>> getDtList(Map<String,Object> param) {
		return masterMpStLongTermStckListDao.selectDtList(param);
	}
	
	// 재고현황 추이 리스트 조회
	public List<Map<String,String>> getFlowList(Map<String,Object> param) {
		return masterMpStLongTermStckListDao.selectFlowList(param);
	}	
}
