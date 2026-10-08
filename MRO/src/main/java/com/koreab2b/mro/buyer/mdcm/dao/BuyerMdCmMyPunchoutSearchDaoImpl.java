package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMdCmMyPunchoutSearchDao")
@Transactional
public class BuyerMdCmMyPunchoutSearchDaoImpl implements BuyerMdCmMyPunchoutSearchDao { 
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMdCmGoodsLisDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmMyPunchoutSearch", formData);
	} 
	// 나의상품삭제
	public int removeBuyerMdCmMyPunchOutLisList(Map<String,String>  formData) {
		
		StringBuffer _rtnMsg = new StringBuffer(); 

		String _query = formData.get("st_query2").toString();
		String _use_flag = formData.get("st_use_flag").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString();
		int result = 0;
		Map<String,String> _data = null;
		try{
			 
			 String  _ICOMCART[] = _query.split("&&"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@");    
				        
				       
				        if (str != null){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("BUYER", _buyer);
					        _data.put("USER_ID", _user_id);
					        _data.put("USE_FLAG", _use_flag);
					        
					        _data.put("BUYER_ITEM_NO", str[0]);
					        _data.put("AGENT", str[1]);  
					        _data.put("CONTRACT_NO", str[2]);
					        _data.put("CONTRACT_SEQ", str[3]);
					        _data.put("BYIT_COMORG_CODE", str[4]);
					        _data.put("DESCRIPTION", str[5]);
					        _data.put("SPECIFICATION", str[6]);
					        _data.put("UNIT_PRICE", str[7]);
					        _data.put("CART_QTY", str[8]);
					         
		 
					        result = sqlSessionTemplate.delete("buyer.mdcm.removeBuyerMdCmMyPunchOutLisList", _data);  
						 }				         
					 }					  
				 }				  
			 } 
			  
			 
			 LOGGER.debug("_rtnMsg.toString() " +_rtnMsg.toString());
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("나의상품 삭제 실패하였습니다.");
		} 

		return result;
	}	
	
	// 엑셀다운로드
	public List<Map<String,String>> getExcelList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.excelBuyerMdCmMyPunchoutSearch", formData);
	} 
}

