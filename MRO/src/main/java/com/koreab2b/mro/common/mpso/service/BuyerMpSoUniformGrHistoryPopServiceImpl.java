package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoUniformGrHistoryPopDao;

@Service("buyerMpSoUniformGrHistoryPopService")
public class BuyerMpSoUniformGrHistoryPopServiceImpl implements BuyerMpSoUniformGrHistoryPopService {
	
	@Autowired
	private BuyerMpSoUniformGrHistoryPopDao buyerMpSoUniformGrHistoryPopDao;

	// 조회
	public List<Map<String,String>> getHdList(Map<String,String> formData) {
		return buyerMpSoUniformGrHistoryPopDao.selectHdList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getDtList(Map<String,String> formData) {
		return buyerMpSoUniformGrHistoryPopDao.selectDtList(formData);
	}
}
