package com.koreab2b.mro.master.mdam.service;

import java.util.List;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmMsdsDao;

@Service("MasterMdAmMsdsService")
public class MasterMdAmMsdsServiceImpl implements MasterMdAmMsdsService {
	
	@Autowired
	private MasterMdAmMsdsDao masterMdAmMsdsDao;
	
	// 리스트 조회,엑셀다운로드
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdAmMsdsDao.selectList(param);
	}	
}
