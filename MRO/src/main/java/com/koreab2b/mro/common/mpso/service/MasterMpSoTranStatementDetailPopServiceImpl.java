package com.koreab2b.mro.common.mpso.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonInfoDao;
import com.koreab2b.mro.common.mpso.dao.MasterMpSoTranStatementDetailPopDao;

@Service("masterMpSoTranStatementDetailPopService")
public class MasterMpSoTranStatementDetailPopServiceImpl implements MasterMpSoTranStatementDetailPopService {
	
	@Autowired
	private MasterMpSoTranStatementDetailPopDao masterMpSoTranStatementDetailPopDao;
	
	@Autowired
	private CommonInfoDao commonInfoDao;

	// 상세정보
	public Map<String,String> getInfo(Map<String,String> formData){
		
		Map<String, String> data = masterMpSoTranStatementDetailPopDao.selectInfo(formData);
		Map<String,String> map = new HashMap<String, String>();
		map.putAll(data);
		map.put("USER_ID", formData.get("USER_ID"));
    	map.put("BUYER", formData.get("st_buyer"));
    	map.put("GBN", ""); // 거래명세서 작성여부 ( 작성일경우 : WR, 아닐경우 : "")
    	
		// 특수로직데이터를 이용해서 레포트 url 조회
    	String rpt_url = commonInfoDao.selectRptUrl(map);
    	
    	data.put("RPT_URL", rpt_url);
		return data;
	}
	public Map<String,String> getInfo_v2(Map<String,String> formData){
		
		Map<String, String> data = masterMpSoTranStatementDetailPopDao.selectInfo_v2(formData);
		Map<String,String> map = new HashMap<String, String>();
		map.putAll(data);
		map.put("USER_ID", formData.get("USER_ID"));
    	map.put("BUYER", formData.get("st_buyer"));
    	map.put("GBN", ""); // 거래명세서 작성여부 ( 작성일경우 : WR, 아닐경우 : "")
    	
		// 특수로직데이터를 이용해서 레포트 url 조회
    	String rpt_url = commonInfoDao.selectRptUrl(map);
    	
    	data.put("RPT_URL", rpt_url);
		return data;
	}
	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMpSoTranStatementDetailPopDao.selectList(formData);
	}
	
	// 물류센터 고객사 체크
	@Override
	public String getW001Flag(Map<String, String> pMap) {
		return masterMpSoTranStatementDetailPopDao.getW001Flag(pMap);
	}	
	

}
