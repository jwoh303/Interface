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

import com.koreab2b.mro.util.CommonUtil;

@Repository("buyerMdCmPopularGoodsSearchDao")
@Transactional
public class BuyerMdCmPopularGoodsSearchDaoImpl implements BuyerMdCmPopularGoodsSearchDao { 
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMdCmGoodsLisDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmPopularGoodsSearchList", formData);
	} 
	

	/**
	 * 저장
	 *  desc ICOMCART
 		 USE_FLAG	NOT NULL	CHAR(1)	용도구분(C:장바구니,D:,R:나의상품)
	 * 
	 */
	@SuppressWarnings("unchecked")
	public String saveBuyerMdCmPopularGoods(Map<String,String> formData) {

		StringBuffer _rtnMsg = new StringBuffer();
		String createOk = "CREATE_OK";
		String _msg = "";

		String _query = formData.get("st_query2").toString();
		String _use_flag = formData.get("st_use_flag").toString();
		String _user_id = formData.get("st_user_id_session").toString();
		String _buyer = formData.get("st_com_code").toString();

		if ("C".equals(_use_flag)){
			_msg = "장바구니";
		}else if ("R".equals(_use_flag)){
			_msg = "나의상품";
		}
		
		
		
		try{
			
			int duplicateCnt = 0;  
			 String  _ICOMCART[] = _query.split("&&"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
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
					        _data.put("DESCRIPTION", str[5]);
					        _data.put("SPECIFICATION", str[6]);
					        _data.put("UNIT_PRICE", str[7]);
					        _data.put("CART_QTY", str[8]);
					        String check_flag = sqlSessionTemplate.selectOne("buyer.mdcm.getPunchoutItemNoCheck", _data); // 중복체크
							/*
							* 고객사에 따라 카탈로그 검색기준이 다름
							* A: 두산엔진 KRHSDE0003
							*/
							String p060000055 = CommonUtil.getSpecialCheckReturn(_buyer,"P06-0000055","COL02_DATA"); // 검색조건변경
							if(p060000055.equals("A")){
								_data.put("st_s_logic", p060000055);
								_data.put("ITEM_SEQ", "F0");
							}else{
								String cart_seq = sqlSessionTemplate.selectOne("buyer.mdcm.getPunchoutItemSeq", _data);  // Cart Seq가져옴.
								_data.put("st_s_logic", "R");
								_data.put("ITEM_SEQ", cart_seq);
							}
					        LOGGER.debug("중복건 확인 "+check_flag);
					          if("0".equals(check_flag)){
					        	   int result = sqlSessionTemplate.update("buyer.mdcm.insertBuyerMdCmPopularGoodsLisCreate", _data); 
		
				              }else{
				            	  
				            	  duplicateCnt ++;
				                  if(i+1 == _ICOMCART.length){
				                	  _rtnMsg.append("'").append(str[0]).append("' ");
				                  }else{
				                	  _rtnMsg.append("'").append(str[0]).append("', ");
				                  }
				              } 
						 }				         
					 }					  
				 }				  
			 } 
			 
			 if (duplicateCnt == 0){
				 _rtnMsg.delete(0, _rtnMsg.length());
				 _rtnMsg.append(createOk);
			 }
			 
			 LOGGER.debug("_rtnMsg.toString() " +_rtnMsg.toString());
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException(_msg + "담기 실패하였습니다.");
		}
	return _rtnMsg.toString();
		
	}

	/**
	 * 저장
	 *  desc DOOSCART
 		카테고리 업데이트
	 * 
	 */
	@SuppressWarnings("unchecked")
	public String saveBuyerMdCmFolderCode(Map<String,String> formData) {

		StringBuffer _rtnMsg = new StringBuffer();
		String createOk = "CREATE_OK";
		String _msg = "";

		String _query = formData.get("st_query2").toString();
		String _user_id = formData.get("st_user_id_session").toString();
		String _buyer = formData.get("st_com_code").toString();
		String _folder_code = formData.get("st_folder_code").toString();

		try{
			
			 String  _ICOMCART[] = _query.split("&&"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_DOOSCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _DOOSCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@");    
				       
				        if (str != null ){
				        	
				        	 Map<String,String> _data = new HashMap<String,String>() ;
					        _data.put("FOLDER_CODE", _folder_code);
					        _data.put("BUYER", _buyer);
					        _data.put("USER_ID", _user_id);
					        _data.put("USE_FLAG", str[6]);
					        _data.put("BUYER_ITEM_NO", str[0]);
					        _data.put("CONTRACT_NO", str[1]);
					        _data.put("CONTRACT_SEQ", str[2]);
					        _data.put("AGENT", str[3]);  
					        _data.put("BYIT_COMORG_CODE", str[4]);
					        
					        sqlSessionTemplate.update("buyer.mdcm.updateBuyerMdCmFolderCode", _data);					        
						 }				         
					 }					  
				 }				  
			 } 
			 
			 _rtnMsg.delete(0, _rtnMsg.length());
			 _rtnMsg.append(createOk);
			 
			 LOGGER.debug("_rtnMsg.toString() " +_rtnMsg.toString());
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException(_msg + "담기 실패하였습니다.");
		}
	return _rtnMsg.toString();
		
	}
	/**
	 * 저장
	 *  desc ICOMUSCA
 		카테고리 업데이트
	 * 
	 */
	@SuppressWarnings("unchecked")
	public String saveBuyerMdCmFolderName(Map<String,String> formData) {

		StringBuffer _rtnMsg = new StringBuffer();
		String createOk = "CREATE_OK";
		String _msg = "";

		String _query = formData.get("st_query2").toString();
		String _user_id = formData.get("st_user_id_session").toString();
		String _buyer = formData.get("st_com_code").toString();

		try{
			
			 String  _ICOMCART[] = _query.split("&&"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_DOOSCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _DOOSCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@");    
				       
				        if (str != null ){
				        	
				        	 Map<String,String> _data = new HashMap<String,String>() ;
					        _data.put("BUYER", _buyer);
					        _data.put("USER_ID", _user_id);
					        _data.put("FOLDER_2", str[0]);
					        _data.put("FOLDER_3", str[1]);
					        sqlSessionTemplate.update("buyer.mdcm.updateBuyerMdCmFolderName", _data);					        
						 }				         
					 }					  
				 }				  
			 } 
			 
			 _rtnMsg.delete(0, _rtnMsg.length());
			 _rtnMsg.append(createOk);
			 
			 LOGGER.debug("_rtnMsg.toString() " +_rtnMsg.toString());
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException(_msg + "담기 실패하였습니다.");
		}
	return _rtnMsg.toString();
		
	}
	//삭제조회
	public List<Map<String,String>> selectDeleteList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmDeletePunchOutSearchList", formData);
	} 
	
	// 그린상품조회
	public List<Map<String,String>> selectGreenList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmGreenPunchOutSearchList", formData);
	} 
	
	// 프로젝트상품조회
	public List<Map<String,String>> selectProjectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmProjectPunchOutSearchList", formData);
	} 
}

