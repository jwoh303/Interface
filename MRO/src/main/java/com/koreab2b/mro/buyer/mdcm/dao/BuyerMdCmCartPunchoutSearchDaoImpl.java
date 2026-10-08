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

@Repository("buyerMdCmCartPunchoutSearchDao")
@Transactional
public class BuyerMdCmCartPunchoutSearchDaoImpl implements BuyerMdCmCartPunchoutSearchDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmCartPunchoutSearch", formData);
	} 
	/**
	 * 저장
	 *  desc ICOMCART
 		 USE_FLAG	NOT NULL	CHAR(1)	용도구분(C:장바구니,D:,R:나의상품)
	 * 
	 */
	@SuppressWarnings("unchecked")
	public String saveBuyerMdCmCartQtyPunchOut(Map<String,String> formData) {

		StringBuffer _rtnMsg = new StringBuffer();
		String createOk = "CREATE_OK";
		String _msg = "";

		String _query = formData.get("st_query2").toString();
		String _use_flag = formData.get("st_use_flag").toString();
		String _user_id = formData.get("st_user_id_session").toString();
		String _buyer = formData.get("st_com_code").toString();


		
		try{
			
			int duplicateCnt = 0;  
			 String  _ICOMCART[] = _query.split("&&"); 
			 if (_ICOMCART == null){
			 }else{
				  
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@"); 
				       
				        if (str != null ){				        	
				        	 Map<String,String> _data = new HashMap<String,String>() ;
					        _data.put("BUYER", _buyer);
					        _data.put("USER_ID", _user_id);
					        _data.put("USE_FLAG", _use_flag);			         
					        
					        _data.put("BUYER_ITEM_NO", str[0]);
					        _data.put("AGENT", str[1]);  
					        _data.put("CONTRACT_NO", str[2]);
					        _data.put("CONTRACT_SEQ", str[3]);
					        _data.put("BYIT_COMORG_CODE", str[4]);
					        _data.put("ITEM_SEQ", str[5]);
					        _data.put("CART_QTY", str[6]);	
					        
					        int result = sqlSessionTemplate.update("buyer.mdcm.saveBuyerMdCmCartQtyPunchOut", _data);
						 }				         
					 }					  
				 }				  
			 } 
			 
			 if (duplicateCnt == 0){
				 _rtnMsg.delete(0, _rtnMsg.length());
				 _rtnMsg.append(createOk);
			 }
			 
		}catch(Exception e){
			throw new RuntimeException(_msg + "담기 실패하였습니다.");
		}
	return _rtnMsg.toString();
		
	}
	/**
	 * 저장
	 *  desc ICOMCART
 		 USE_FLAG	NOT NULL	CHAR(1)	용도구분(C:장바구니,D:,R:나의상품)
	 * 
	 */
	@SuppressWarnings("unchecked")
	public String deleteBuyerMdCmCartListPunchOut(Map<String,String> formData) {

		StringBuffer _rtnMsg = new StringBuffer();
		String createOk = "CREATE_OK";
		String _msg = "";

		String _query = formData.get("st_query").toString();
		String _user_id = formData.get("st_user_id_session").toString();
		String _buyer = formData.get("st_com_code").toString();


		
		try{
			
			int duplicateCnt = 0;  
			 String  _ICOMCART[] = _query.split("&&"); 
			 if (_ICOMCART == null){
			 }else{
				  
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@"); 
				       
				        if (str != null ){				        	
				        	 Map<String,String> _data = new HashMap<String,String>() ;
					        _data.put("BUYER", _buyer);
					        _data.put("USER_ID", _user_id);
					        
					        _data.put("BUYER_ITEM_NO", str[0]);
					        _data.put("AGENT", str[1]);  
					        _data.put("CONTRACT_NO", str[2]);
					        _data.put("CONTRACT_SEQ", str[3]);
					        _data.put("BYIT_COMORG_CODE", str[4]);
					        _data.put("USE_FLAG", str[5]);
					        _data.put("ITEM_SEQ", str[6]);
					        
					        
					        int result = sqlSessionTemplate.update("buyer.mdcm.deleteBuyerMdCmCartListPunchOut", _data);
						 }				         
					 }					  
				 }				  
			 } 
			 
			 if (duplicateCnt == 0){
				 _rtnMsg.delete(0, _rtnMsg.length());
				 _rtnMsg.append(createOk);
			 }
			 
		}catch(Exception e){
			throw new RuntimeException(_msg + "담기 실패하였습니다.");
		}
	return _rtnMsg.toString();
		
	}
}

