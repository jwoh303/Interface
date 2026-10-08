package com.koreab2b.mro.master.wmdl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.wmdl.dao.MasterWmDlBuyerWarhsngDao;

@Service("masterWmDlBuyerWarhsngService")
public class MasterWmDlBuyerWarhsngServiceImpl implements MasterWmDlBuyerWarhsngService {
	
	@Autowired
	private MasterWmDlBuyerWarhsngDao masterWmDlBuyerWarhsngDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmDlBuyerWarhsngDao.selectList(param);
	}	

}
