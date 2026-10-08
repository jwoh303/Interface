package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonInfoDao;
import com.koreab2b.mro.common.mpiv.dao.CommonMpIvInvoiceDetailIVPopDao;

@Service("commonMpIvInvoiceDetailIVPopService")
public class CommonMpIvInvoiceDetailIVPopServiceImpl implements CommonMpIvInvoiceDetailIVPopService {
	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvInvoiceDetailIVPopServiceImpl.class);
	
	@Autowired
	private CommonInfoDao commonInfoDao; 
	
	@Autowired
	private CommonMpIvInvoiceDetailIVPopDao commonMpIvInvoiceDetailIVPopDao;

	public Map<String,String> getInfo(Map<String,String> formData) {
		
		Map<String,String> map = (Map<String,String>)commonMpIvInvoiceDetailIVPopDao.selectInfo(formData);
		
		String rpt_url = "";

    	map.put("USER_ID", formData.get("user_id"));
    	map.put("BUYER", formData.get("buyer"));
    	//map.put("PO_NO", formData.get("po_no"));
    	map.put("GBN", ""); // 거래명세서 작성여부 ( 작성일경우 : WR, 아닐경우 : "")
    	
		// 공통모듈로 옮기고 수정하자!
		// 특수로직데이터를 이용해서 레포트 url 조회
		rpt_url = commonInfoDao.selectRptUrl(map);
		logger.debug("rpt_url==============>> " + rpt_url);
		
		map.put("RPT_URL", rpt_url);
		
		return map;
	}
	public Map<String,String> getInfo_v2(Map<String,String> formData) {
		
		Map<String,String> map = (Map<String,String>)commonMpIvInvoiceDetailIVPopDao.selectInfo_v2(formData);
		
		String rpt_url = "";

    	map.put("USER_ID", formData.get("user_id"));
    	map.put("BUYER", formData.get("buyer"));
    	//map.put("PO_NO", formData.get("po_no"));
    	map.put("GBN", ""); // 거래명세서 작성여부 ( 작성일경우 : WR, 아닐경우 : "")
    	
		// 공통모듈로 옮기고 수정하자!
		// 특수로직데이터를 이용해서 레포트 url 조회
		rpt_url = commonInfoDao.selectRptUrl(map);
		logger.debug("rpt_url==============>> " + rpt_url);
		
		map.put("RPT_URL", rpt_url);
		
		return map;
	}
	
	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonMpIvInvoiceDetailIVPopDao.selectList(formData);
	}	
	public List<Map<String,String>> getList_v2(Map<String,Object> formData) {
		return commonMpIvInvoiceDetailIVPopDao.selectList_v2(formData);
	}	
	

}
