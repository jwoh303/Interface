package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStLogisFeeListDao;

@Service("masterMpStLogisFeeListService")
public class MasterMpStLogisFeeListServiceImpl implements MasterMpStLogisFeeListService {
	@Autowired
	private MasterMpStLogisFeeListDao masterMpStLogisFeeListDao;

	// 물류수수료(부서별)
	public List<Map<String,String>> getDeptList(Map<String,Object> param) {
		return masterMpStLogisFeeListDao.selectDeptList(param);
	}
	
	// 물류수수료(고객사별)
	public List<Map<String,String>> getBuyerList(Map<String,Object> param) {
		return masterMpStLogisFeeListDao.selectBuyerList(param);
	}
	
	// 물류수수료(사유별)
	public List<Map<String,String>> getReasonList(Map<String,Object> param) {
		return masterMpStLogisFeeListDao.selectReasonList(param);
	}
}
