package com.koreab2b.mro.master.clmg.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.clmg.dao.MasterClMgCreditCorpListDao;

@Service("masterClMgCreditCorpListService")
public class MasterClMgCreditCorpListServiceImpl implements MasterClMgCreditCorpListService {
	@Autowired
	private MasterClMgCreditCorpListDao masterClMgCreditCorpListDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterClMgCreditCorpListDao.selectList(param);
	}	
}
