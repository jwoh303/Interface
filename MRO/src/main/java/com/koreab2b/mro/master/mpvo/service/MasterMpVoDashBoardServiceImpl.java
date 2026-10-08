package com.koreab2b.mro.master.mpvo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpvo.dao.MasterMpVoDashBoardDao;

@Service("masterMpVoDashBoardService")
public class MasterMpVoDashBoardServiceImpl implements MasterMpVoDashBoardService {
	
	@Autowired
	private MasterMpVoDashBoardDao masterMpVoDashBoardDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpVoDashBoardDao.selectList(param);
	}
	
	// 리스트 조회
	public String getCountBuyerOwn(Map<String,Object> param) {
		return masterMpVoDashBoardDao.getCountBuyerOwn(param);
	}

	public List<Map<String,String>> getDashBoardList1(Map<String,Object> param) {
		return masterMpVoDashBoardDao.getDashBoardList1(param);
	}
	
	public List<Map<String,String>> getDashBoardList2(Map<String,Object> param) {
		return masterMpVoDashBoardDao.getDashBoardList2(param);
	}
	
	public List<Map<String,String>> getDashBoardList3(Map<String,Object> param) {
		return masterMpVoDashBoardDao.getDashBoardList3(param);
	}
	
	public List<Map<String,String>> getDashBoardList4(Map<String,Object> param) {
		return masterMpVoDashBoardDao.getDashBoardList4(param);
	}
	
}
