package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCmsPriceValidDao;

@Service("masterMdCmCmsPriceValidService")
public class MasterMdCmCmsPriceValidServiceImpl implements MasterMdCmCmsPriceValidService {

	@Autowired
	private MasterMdCmCmsPriceValidDao masterMdCmCmsPriceValidDao;

	// 목록 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCmsPriceValidDao.selectList(param);
	}
}
