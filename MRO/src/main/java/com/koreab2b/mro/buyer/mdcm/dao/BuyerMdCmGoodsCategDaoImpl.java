package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;


@Repository("buyerMdCmGoodsCategDao")
@Transactional
public class BuyerMdCmGoodsCategDaoImpl implements BuyerMdCmGoodsCategDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMdCmGoodsCategDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 코드 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		resultList = sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmGoodsCategList", param);

		return resultList;
	}

	// 코드 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {

		int _count = 0;
		
		_rtnMsg = "분류 생성 및 수정이 정상적으로 완료되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				
				formData.putAll((Map<String, String>)gridData.get(i));
				if ( "U".equals(formData.get("sStatus")) ) {
					_count = sqlSessionTemplate.insert("buyer.mdcm.updateBuyerMdCmGoodsCateg", formData);
					if ( _count != 1 ) {
						throw new RuntimeException("분류수정 실패 했습니다.\n\n다시 확인하여 주십시요.");
					}
				}else if ( "I".equals(formData.get("sStatus")) ) {
					_count = sqlSessionTemplate.insert("buyer.mdcm.insertBuyerMdCmGoodsCateg", formData);
					if ( _count != 1 ) {
						throw new RuntimeException("분류추가 실패 했습니다.\n\n다시 확인하여 주십시요.");
					}					
				}
			}
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			throw new RuntimeException("분류추가 실패 했습니다.\n\n다시 확인하여 주십시요.");
		}
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public int updateBuyerMdAmGoodsCategLis_v2(Map<String,String>  formData) {
		
		StringBuffer _rtnMsg = new StringBuffer(); 

		int result = 0;
		try{
			 
			result = sqlSessionTemplate.insert("buyer.mdcm.updateBuyerMdCmGoodsCateg", formData);
			if ( result != 1 ) {
				throw new RuntimeException("폴더 수정 실패 했습니다.다시 확인하여 주십시요.");
			}
			 
			 LOGGER.debug("_rtnMsg.toString() " +_rtnMsg.toString());
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("폴더 수정 실패하였습니다.");
		} 

		return result;
	}
	
	// 코드 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		int _count = 0;
		
		_rtnMsg = "분류 삭제가 정상적으로 완료되었습니다";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));	
				_count = sqlSessionTemplate.update("buyer.mdcm.deleteBuyerMdCmGoodsCateg", formData);
				if ( _count != 1 ) {
					throw new RuntimeException("분류삭제 실패 했습니다.\n\n다시 확인하여 주십시요.");
				}
			}
		} catch(Exception e ) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("분류삭제 실패 했습니다.\n\n다시 확인하여 주십시요.");
		}

		return _rtnMsg;		
	}
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public int delBuyerMdAmGoodsCategLis_v2(Map<String,String>  formData) {
		
		StringBuffer _rtnMsg = new StringBuffer(); 

		int result = 0;
		try{
			 
			result = sqlSessionTemplate.update("buyer.mdcm.deleteBuyerMdCmGoodsCateg", formData);
			//폴더 안에 상품 삭제
			sqlSessionTemplate.update("buyer.mdcm.deleteBuyerMdCmGoodsCategItem", formData);
			if ( result != 1) {
				throw new RuntimeException("폴더 삭제 실패 했습니다.다시 확인하여 주십시요.");
			}
			 
			 LOGGER.debug("_rtnMsg.toString() " +_rtnMsg.toString());
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("폴더 삭제 실패하였습니다.");
		} 

		return result;
	}
	
	// 코드 저장
	@SuppressWarnings("unchecked")
	public int saveBuyerMdAmGoodsCategLis_v2(Map<String,String>  formData) {
		
		StringBuffer _rtnMsg = new StringBuffer(); 

		int result = 0;
		try{
			 
			result = sqlSessionTemplate.insert("buyer.mdcm.insertBuyerMdCmGoodsCateg", formData);
			if ( result != 1 ) {
				throw new RuntimeException("폴더 추가 실패 했습니다.다시 확인하여 주십시요.");
			}
			 
			 LOGGER.debug("_rtnMsg.toString() " +_rtnMsg.toString());
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("폴더 추가 실패하였습니다.");
		} 

		return result;
	}
}
