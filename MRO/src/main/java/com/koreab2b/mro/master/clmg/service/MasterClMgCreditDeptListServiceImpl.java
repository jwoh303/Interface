package com.koreab2b.mro.master.clmg.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.clmg.dao.MasterClMgCreditDeptListDao;

@Service("masterClMgCreditDeptListService")
public class MasterClMgCreditDeptListServiceImpl implements MasterClMgCreditDeptListService {
	@Autowired
	private MasterClMgCreditDeptListDao masterClMgCreditDeptListDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterClMgCreditDeptListDao.selectList(param);
	}
	// 리스트 조회
	public List<Map<String,String>> getDetailList(Map<String,Object> param) {
		return masterClMgCreditDeptListDao.selectDetailList(param);
	}
}
