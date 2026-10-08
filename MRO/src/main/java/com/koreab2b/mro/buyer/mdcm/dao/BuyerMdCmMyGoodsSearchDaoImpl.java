package com.koreab2b.mro.buyer.mdcm.dao;

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

@Repository("buyerMdCmMyGoodsSearchDao")
@Transactional
public class BuyerMdCmMyGoodsSearchDaoImpl implements BuyerMdCmMyGoodsSearchDao {
	private static final Logger LOGGER  = LoggerFactory.getLogger(BuyerMdCmMyGoodsSearchDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmMyGoodsSearchList", formData);
	}
	public List<Map<String,String>> selectBuyerMdCmMyGoodsSearchList_v2(Map<String,String> formData) {
		String total_flag = CommonUtil.nvl(formData.get("total_flag"),"N");
		if(total_flag.equals("Y")){
			return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmMyGoodsSearchListAllNoPaging_v2", formData);
		}else{
			String paging_flag = CommonUtil.nvl(formData.get("paging_flag"),"Y");
			if(paging_flag.equals("N")){
				return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmMyGoodsSearchListNoPaging_v2", formData);
			}else{
				return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmMyGoodsSearchList_v2", formData);
			}
			
		}
	}
	
	//신규견적 조회
	public List<Map<String,String>> selectRqdtList(Map<String,String> formData) {

		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);
		List<String> _list = new ArrayList<String>();
		_list = CommonUtil.getStringArrary((String) formData.get("st_query"), "@@");
		if (_list.size() > 0) {
			data.put("st_query", _list);
		}
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmMyRqdtSearchList", data);
	}
	// 나의상품삭제
	public int removeBuyerMdCmMyGoodsLisList(Map<String,String>  formData) {
		
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
				        
				       
				        if (str != null && str.length == 7){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("BUYER", _buyer);
					        _data.put("USER_ID", _user_id);
					        _data.put("USE_FLAG", _use_flag);
					         
					        
					        _data.put("BUYER_ITEM_NO", str[0]);
					        _data.put("CART_QTY", str[1]);  
					        _data.put("AGENT", str[2]);
					        _data.put("CONTRACT_NO", str[3]);
					        _data.put("CONTRACT_SEQ", str[4]);
					        _data.put("BYIT_COMORG_CODE", str[5]);
					        _data.put("SEQ", str[6]); 
					          
		 
					        result = sqlSessionTemplate.delete("buyer.mdcm.removeBuyerMdCmMyGoodsLisList", _data);  
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
	// 분류저장
	public int saveBuyerMdCmMyGroupLisList(Map<String,String>  formData) {
		
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
				        
				       
				        if (str != null && str.length == 7){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("BUYER", _buyer);
					        _data.put("USER_ID", _user_id);
					        _data.put("USE_FLAG", _use_flag);
					         
					        
					        _data.put("BUYER_ITEM_NO", str[0]);
					        _data.put("CART_QTY", str[1]);  
					        _data.put("MY_GROUP", str[2]);
					        _data.put("CONTRACT_NO", str[3]);
					        _data.put("CONTRACT_SEQ", str[4]);
					        _data.put("BYIT_COMORG_CODE", str[5]); 
					        _data.put("SEQ", str[6]); 
					          
		 
					        result = sqlSessionTemplate.delete("buyer.mdcm.saveBuyerMdCmMyGroupLisList", _data);  
						 }				         
					 }					  
				 }				  
			 } 
			  
			 
			 LOGGER.debug("_rtnMsg.toString() " +_rtnMsg.toString());
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("나의상품 분류 저장에 실패하였습니다.");
		} 

		return result;
	}	
	
	public List<Map<String,String>> getMyCatalgList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.getMyCatalgList", formData);
	}
	
}
