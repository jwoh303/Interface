package com.koreab2b.mro.master.clmg.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.clmg.dao.MasterClMgCreditListDao;

@Service("masterClMgCreditListService")
public class MasterClMgCreditListServiceImpl implements MasterClMgCreditListService {
	@Autowired
	private MasterClMgCreditListDao masterClMgCreditListDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterClMgCreditListDao.selectList(param);
	}
	// 리스트 조회
	public List<Map<String,String>> getDetailList(Map<String,Object> param) {
		return masterClMgCreditListDao.selectDetailList(param);
	}
}
