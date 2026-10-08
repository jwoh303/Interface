package com.koreab2b.mro.master.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.wmgr.dao.MasterWmGrBarcodeDao;

@Service("masterWmGrBarcodeService")
public class MasterWmGrBarcodeServiceImpl implements MasterWmGrBarcodeService {
	
	@Autowired
	private MasterWmGrBarcodeDao masterWmGrBarcodeDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmGrBarcodeDao.selectList(param);
	}	

	
}
