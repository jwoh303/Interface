package com.koreab2b.mro.common.wmgi.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmgi.dao.MasterWmGiDaehanBarcodeReportPopDao;

@Service("masterWmGiDaehanBarcodeReportPopService")
public class MasterWmGiDaehanBarcodeReportPopServiceImpl implements MasterWmGiDaehanBarcodeReportPopService {
	
	@Autowired
	private MasterWmGiDaehanBarcodeReportPopDao masterWmGiDaehanBarcodeReportPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmGiDaehanBarcodeReportPopDao.selectList(formData);
	}	
	

}
