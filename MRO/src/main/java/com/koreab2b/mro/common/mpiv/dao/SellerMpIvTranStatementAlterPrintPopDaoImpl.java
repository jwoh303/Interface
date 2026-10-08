package com.koreab2b.mro.common.mpiv.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("sellerMpIvTranStatementAlterPrintPopDao")
@Transactional
public class SellerMpIvTranStatementAlterPrintPopDaoImpl implements SellerMpIvTranStatementAlterPrintPopDao {
	
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvTranStatementAlterPrintPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 기본정보 조회
	public List<Map<String, String>> selectInfo(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvTranStatementAlterPrintPopInfo", pMap);
	}
	public List<Map<String, String>> selectInfo_v3(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvTranStatementAlterPrintPopInfo_v3", pMap);
	}
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvTranStatementAlterPrintPopList", pMap);
	}
	public List<Map<String,String>> getCommonMpIvTranStatementDetailIVPop_v2(Map<String,Object> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.getCommonMpIvTranStatementDetailIVPop_v2", pMap);
	}
	
	// 납품일 수정
	public String updateInvoiceDate(Map<String,String>  pMap){
		String _rtnMsg = "";
		
		try{
			
			sqlSessionTemplate.update("common.mpiv.updateInvoiceDateIvdt", pMap);
			
			sqlSessionTemplate.update("common.mpiv.updateInvoiceDateIvhd", pMap);
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("납품일 변경이 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
		}
		
		return _rtnMsg;	
	}
	
	// 거래명세서 삭제
	public String deleteTranStatement(Map<String,String>  pMap){
		
		String _rtnMsg = "";
		Map<String, String> map;
		Map<String, String> map_hd;
		List<Map<String, String>> list	= new ArrayList<Map<String, String>>();
		
		int res_cnt = 0;
		
		try{
			
			String seller		= CommonUtil.nvl(pMap.get("st_seller"),"");
			String user_id		= CommonUtil.nvl(pMap.get("st_user_id"),"");
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				map = new HashMap<String, String>();
				
				map.put("buyer", 	str[0]);
				map.put("po_no", 	str[1]);
				map.put("po_seq", 	str[2]);
				map.put("inv_no", 	str[3]);
				map.put("inv_seq", 	str[4]);
				map.put("ds_date", 	str[5]);
				
				map.put("seller", 	seller);
				map.put("user_id", 	user_id);
						
				list.add(map);
			}
			
			map_hd = list.get(0);
			
			// 거래명세서 삭제 전 입고여부 확인 후 삭제처리
			String del_chk = sqlSessionTemplate.selectOne("common.mpiv.selectMpIvTranStatementDeleteCheck", map_hd);
			
			if(del_chk.equals("00")){
				_rtnMsg = "납품실적이나 입고수량이 등록된 건입니다. 거래명세서 삭제를 할 수 없습니다.";
				
			} else {
			
				// 1. ICOMIVDT
				res_cnt = sqlSessionTemplate.update("common.mpiv.deleteTranStatementIvdt", map_hd);
				
				// 2. ICOMIVHD
				res_cnt = sqlSessionTemplate.update("common.mpiv.deleteTranStatementIvhd", map_hd);
				
				for(int i=0; i < list.size(); i++){
					map = (Map<String, String>)list.get(i);
	
					// 3. ICOMPORS
					res_cnt = sqlSessionTemplate.update("common.mpiv.deleteTranStatementPors", map);
					
					// 4. ICOMPODT
					res_cnt = sqlSessionTemplate.update("common.mpiv.deleteTranStatementPodt", map);
				
					// 5. ICOMPOHD
					res_cnt = sqlSessionTemplate.update("common.mpiv.deleteTranStatementPohd", map);
				}
			}
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("거래명세서 삭제가 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
		}
		
		return _rtnMsg;	
	}
}
