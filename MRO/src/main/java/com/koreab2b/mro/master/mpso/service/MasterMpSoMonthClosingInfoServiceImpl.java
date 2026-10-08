package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoMonthClosingInfoDao;

@Service("masterMpSoMonthClosingInfoService")
public class MasterMpSoMonthClosingInfoServiceImpl implements MasterMpSoMonthClosingInfoService {
	
	@Autowired
	private MasterMpSoMonthClosingInfoDao masterMpSoMonthClosingInfoDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpSoMonthClosingInfoDao.selectList(param);
	}	

}
