package com.koreab2b.mro.common.mpiv.service;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonInfoDao;
import com.koreab2b.mro.common.mpiv.dao.SellerMpIvTranStatementAlterPrintPopDao;
import com.koreab2b.mro.util.CommonUtil;

@Service("sellerMpIvTranStatementAlterPrintPopService")
public class SellerMpIvTranStatementAlterPrintPopServiceImpl implements SellerMpIvTranStatementAlterPrintPopService {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvTranStatementAlterPrintPopServiceImpl.class);
	
	@Autowired
	private CommonInfoDao commonInfoDao; 
	
	@Autowired
	private SellerMpIvTranStatementAlterPrintPopDao sellerMpIvTranStatementAlterPrintPopDao;

	// 기본정보 조회
	public Map<String,String> getInfo(Map<String,String>  pMap){
		List<Map<String, String>> detailInfo = sellerMpIvTranStatementAlterPrintPopDao.selectInfo(pMap);
		
		Map<String,String> map = (Map<String,String>)CommonUtil.getListNvl(detailInfo).get(0);
		
        String qry_str1 = CommonUtil.nvl(map.get("QRY_STR1"));
        String qry_str2 = CommonUtil.nvl(map.get("QRY_STR2"));
        String qry_str3 = CommonUtil.nvl(map.get("QRY_STR3"));
        String qry_str4 = CommonUtil.nvl(map.get("QRY_STR4"));
                

        logger.debug("SellerMpIvTranStatementAlterPrintPopServiceImpl 거래명세서 수정 및 출력 기본정보조회 출력 start ====================");
        
        Set<String> keySet = map.keySet();
        Iterator<String> iterator = keySet.iterator();
        
        while(iterator.hasNext()){
        	String key = iterator.next();
        	String value = map.get(key);
        	logger.debug("key : "+key+", value : "+value);
        }
        
        logger.debug("SellerMpIvTranStatementAlterPrintPopServiceImpl 거래명세서 수정 및 출력 기본정보조회 출력 end ====================");
        
        String rpt_url = "";

    	map.put("USER_ID", pMap.get("st_user_id"));
    	map.put("BUYER", pMap.get("st_buyer"));
    	map.put("PO_NO", pMap.get("st_po_no"));
    	map.put("GBN", ""); // 거래명세서 작성여부 ( 작성일경우 : WR, 아닐경우 : "")

		// 공통모듈로 옮기고 수정하자!
		// 특수로직데이터를 이용해서 레포트 url 조회
		rpt_url = commonInfoDao.selectRptUrl(map);
		logger.debug("rpt_url==============>> " + rpt_url);

        map.put("RPT_URL", rpt_url);
		
		return map;
	}
	public Map<String,String> getInfo_v3(Map<String,String>  pMap){
		List<Map<String, String>> detailInfo = sellerMpIvTranStatementAlterPrintPopDao.selectInfo_v3(pMap);
		
		Map<String,String> map = (Map<String,String>)CommonUtil.getListNvl(detailInfo).get(0);
		
        String qry_str1 = CommonUtil.nvl(map.get("QRY_STR1"));
        String qry_str2 = CommonUtil.nvl(map.get("QRY_STR2"));
        String qry_str3 = CommonUtil.nvl(map.get("QRY_STR3"));
        String qry_str4 = CommonUtil.nvl(map.get("QRY_STR4"));
                

        logger.debug("SellerMpIvTranStatementAlterPrintPopServiceImpl 거래명세서 수정 및 출력 기본정보조회 출력 start ====================");
        
        Set<String> keySet = map.keySet();
        Iterator<String> iterator = keySet.iterator();
        
        while(iterator.hasNext()){
        	String key = iterator.next();
        	String value = map.get(key);
        	logger.debug("key : "+key+", value : "+value);
        }
        
        logger.debug("SellerMpIvTranStatementAlterPrintPopServiceImpl 거래명세서 수정 및 출력 기본정보조회 출력 end ====================");
        
        String rpt_url = "";

    	map.put("USER_ID", pMap.get("st_user_id"));
    	map.put("BUYER", pMap.get("st_buyer"));
    	map.put("PO_NO", pMap.get("st_po_no"));
    	map.put("GBN", ""); // 거래명세서 작성여부 ( 작성일경우 : WR, 아닐경우 : "")

		// 공통모듈로 옮기고 수정하자!
		// 특수로직데이터를 이용해서 레포트 url 조회
		rpt_url = commonInfoDao.selectRptUrl(map);
		logger.debug("rpt_url==============>> " + rpt_url);

        map.put("RPT_URL", rpt_url);
		
		return map;
	}
	
	// 조회
	public List<Map<String,String>> getList(Map<String,String> pMap) {
		return sellerMpIvTranStatementAlterPrintPopDao.selectList(pMap);
	}	
	public List<Map<String,String>> getCommonMpIvTranStatementDetailIVPop_v2(Map<String,Object> pMap) {
		return sellerMpIvTranStatementAlterPrintPopDao.getCommonMpIvTranStatementDetailIVPop_v2(pMap);
	}	
	// 납품일 수정
	public String updateInvoiceDate(Map<String,String>  pMap){
		return sellerMpIvTranStatementAlterPrintPopDao.updateInvoiceDate(pMap);
	}
	
	// 거래명세서 삭제
	public String deleleteTranStatement(Map<String,String>  pMap){
		return sellerMpIvTranStatementAlterPrintPopDao.deleteTranStatement(pMap);
	}
		

}
