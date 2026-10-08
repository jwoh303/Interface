package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoNexePopDao;


@Service("buyerMpSoNexePopService")
public class BuyerMpSoNexePopServiceImpl implements BuyerMpSoNexePopService {
	
	@Autowired
	private BuyerMpSoNexePopDao buyerMpSoNexePopDao;

	@Override
	public List<Map<String, String>> getList(Map<String, String> formData) {
		return buyerMpSoNexePopDao.selectList(formData);
	}

	@Override
	public List<Map<String, String>> getRefNoList(Map<String, String> formData) {
		return buyerMpSoNexePopDao.getRefNoList(formData);
	}

		
	

}
