package com.koreab2b.mro.common.mppo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mppo.dao.BuyerMpPoDvlyAgrmntHistoryPopDao;

@Service("buyerMpPoDvlyAgrmntHistoryPopService")
public class BuyerMpPoDvlyAgrmntHistoryPopServiceImpl implements BuyerMpPoDvlyAgrmntHistoryPopService {
	
	@Autowired
	private BuyerMpPoDvlyAgrmntHistoryPopDao buyerMpPoDvlyAgrmntHistoryPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpPoDvlyAgrmntHistoryPopDao.selectList(formData);
	}	
	

}
