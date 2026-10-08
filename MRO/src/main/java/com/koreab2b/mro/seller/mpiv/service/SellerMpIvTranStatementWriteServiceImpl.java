package com.koreab2b.mro.seller.mpiv.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonInfoDao;
import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvTranStatementWriteDao;
import com.koreab2b.mro.util.CommonUtil;

@Service("sellerMpIvTranStatementWriteService")
public class SellerMpIvTranStatementWriteServiceImpl implements SellerMpIvTranStatementWriteService {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvTranStatementWriteServiceImpl.class);
	
	@Autowired
	private SellerMpIvTranStatementWriteDao sellerMpIvTranStatementWriteDao;
	@Autowired
	private CommonInfoDao commonInfoDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpIvTranStatementWriteDao.selectList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getSellerMpIvTranStatementWriteListPO_v2(Map<String,Object> formData) {
		return sellerMpIvTranStatementWriteDao.getSellerMpIvTranStatementWriteListPO_v2(formData);
	}
	// 조회
	public List<Map<String,String>> getSellerMpIvTranStatementWriteListItem_v2(Map<String,Object> formData) {
		return sellerMpIvTranStatementWriteDao.getSellerMpIvTranStatementWriteListItem_v2(formData);
	}
	public List<Map<String,String>> getSellerMpIvTranStatementWritePrintList_v2(Map<String,Object> formData) {
		List<Map<String,String>> list = sellerMpIvTranStatementWriteDao.getSellerMpIvTranStatementWritePrintList_v2(formData);
		
		return list;
	}
	public Map<String,Object> getSellerMpIvTranStatementWriteRptUrl_v2(Map<String,Object> formData) {
		String returnQuery = "";
		String query = (String) formData.get("st_query_rpt_url");
		Map<String, Object> _response	= new HashMap<String, Object>();
		
		String check_str[]  = CommonUtil.StrToArray(query , "##");
		
		for(int i=0 ; i < check_str.length; i++){
			Map<String,String> map = new HashMap<String, String>();
			String str[] = check_str[i].split("@@",-1);
	    	map.put("GBN", ""); // 거래명세서 작성여부 ( 작성일경우 : WR, 아닐경우 : "")
	    	map.put("BUYER",str[0]);
	    	map.put("PO_NO",str[1]);
	    	map.put("USER_ID", str[3]);
	    	
	    	Map<String,String> tmp = sellerMpIvTranStatementWriteDao.getSellerMpIvTranStatementWriteQryForReport_v2(map);
	    	if(tmp != null) {
	    		map.put("QRY_STR1", CommonUtil.nvl(tmp.get("COL01_DATA")));
	    		map.put("QRY_STR2", CommonUtil.nvl(tmp.get("COL02_DATA")));
	    		map.put("QRY_STR3", CommonUtil.nvl(tmp.get("COL03_DATA")));
	    		map.put("QRY_STR4", CommonUtil.nvl(tmp.get("COL04_DATA")));
	    	}
	    	String rpt_url = commonInfoDao.selectRptUrl(map);
	    	
	    	returnQuery = returnQuery+str[0]+"@@"+str[2]+"@@"+rpt_url+"^||^";//BUYER,INV_NO,RPT_URL
	    	
			
		}
		
		_response.put("rptUrl", returnQuery);
		
		return _response;
	}
	
}
