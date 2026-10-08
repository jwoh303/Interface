package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdct.dao.MasterMdctNewReBuyerDao;

@Service("masterMdctNewReBuyerService")
public class MasterMdctNewReBuyerServiceImpl implements MasterMdctNewReBuyerService {
	
	@Autowired
	private MasterMdctNewReBuyerDao masterMdctNewReBuyerDao;

	// 전체 조회
	public List<Map<String,String>> getAllList(Map<String,Object> param) {
		return masterMdctNewReBuyerDao.selectAllList(param);
	}
	
	// 개인 조회
	public List<Map<String,String>> getIndvList(Map<String,Object> param) {
		return masterMdctNewReBuyerDao.selectIndvList(param);
	}
}
