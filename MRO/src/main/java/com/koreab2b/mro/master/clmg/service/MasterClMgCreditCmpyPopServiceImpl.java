package com.koreab2b.mro.master.clmg.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.clmg.dao.MasterClMgCreditCmpyPopDao;

@Service("masterClMgCreditCmpyPopService")
public class MasterClMgCreditCmpyPopServiceImpl implements MasterClMgCreditCmpyPopService {
	@Autowired
	private MasterClMgCreditCmpyPopDao masterClMgCreditCmpyPopDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterClMgCreditCmpyPopDao.selectList(param);
	}	

}
