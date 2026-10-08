package com.koreab2b.mro.master.clmg.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.clmg.dao.MasterClMgCreditMngBuyerListDao;

@Service("masterClMgCreditMngBuyerListService")
public class MasterClMgCreditMngBuyerListServiceImpl implements MasterClMgCreditMngBuyerListService {
	@Autowired
	private MasterClMgCreditMngBuyerListDao masterClMgCreditMngBuyerListDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterClMgCreditMngBuyerListDao.selectList(param);
	}

}
