package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonInfoDao;
import com.koreab2b.mro.common.mpiv.dao.SellerMpIvTranStatementWritePopDao;
import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvTranStatementDivsnWriteDao;
import com.koreab2b.mro.util.CommonUtil;

@Service("sellerMpIvTranStatementDivsnWriteService")
public class SellerMpIvTranStatementDivsnWriteServiceImpl implements SellerMpIvTranStatementDivsnWriteService {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvTranStatementDivsnWriteServiceImpl.class);
	
	@Autowired
	private SellerMpIvTranStatementDivsnWriteDao sellerMpIvTranStatementDivsnWriteDao;

	@Autowired
	private SellerMpIvTranStatementWritePopDao sellerMpIvTranStatementWritePopDao;
	
	@Autowired
	private CommonInfoDao commonInfoDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> pMap) {
		
		List<Map<String, String>> list = sellerMpIvTranStatementDivsnWriteDao.selectList(pMap);
		
		String pop_key = CommonUtil.nvl(pMap.get("pop_key"));
		
		if(list.size() > 0 && !pop_key.equals("")){
			Map<String,String> map = (Map<String,String>)CommonUtil.getListNvl(list).get(0);
			
			String rpt_url = "";
	        
	        map.put("USER_ID", pMap.get("st_user_id"));
	        map.put("BUYER", pMap.get("st_buyer_code"));
	        map.put("GBN", ""); // 거래명세서 작성여부 ( 작성일경우 : WR, 아닐경우 : "")
	        
	        // 특수로직데이터를 이용해서 레포트 url 조회
	        rpt_url = commonInfoDao.selectRptUrl(map);
	        	
	        logger.debug("rpt_url==============>> " + rpt_url);
	        
//	        map.put("RPT_URL", rpt_url);
	        
	        list.get(0).put("RPT_URL", rpt_url);
		}
        
		return list;
	}	
	
	// 저장
	public Map<String, String> saveSellerMpIvTranStatementDivsnWrite(Map<String,String> pMap) {
		
		String doc_type 		= "IV";
		
		pMap.put("doc_type", doc_type);
		
		String inv_no = sellerMpIvTranStatementWritePopDao.getOrderNo(pMap);
		
		pMap.put("st_inv_no", inv_no);
		
		return sellerMpIvTranStatementDivsnWriteDao.saveSellerMpIvTranStatementDivsnWrite(pMap);
	}	

}
