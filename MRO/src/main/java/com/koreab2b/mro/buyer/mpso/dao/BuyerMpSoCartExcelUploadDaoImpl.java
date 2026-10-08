package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoCartExcelUploadDao")
@Transactional
public class BuyerMpSoCartExcelUploadDaoImpl implements BuyerMpSoCartExcelUploadDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoCartExcelUploadDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		resultList = sqlSessionTemplate.selectList("buyer.mpso.getCartTmpList", param);
		
		return resultList;
	}
	
	// 장바구니 담기
	@SuppressWarnings("unchecked")
	public String setCartAddReg(Map<String,String>  formData, List<Object> gridData) {

		int _count = 0;
		
		_rtnMsg = "정상적으로 등록되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				LOGGER.debug("===>> insert ICOMCART Start <<===");
				formData.putAll((Map<String, String>)gridData.get(i));

				// ICOMCART 삽입
				_count = sqlSessionTemplate.update("buyer.mpso.setExcelIcomcartAdd", formData);
				
				if ( _count != 1 ) {
					throw new RuntimeException("장바구니 담기 중 오류가 발생하였습니다.");
				}else{ // 삽입 후 ICOMCART_TMP 삭제
					sqlSessionTemplate.update("buyer.mpso.delIcomcartTmpExcelUp", formData);
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("장바구니 담기 중 오류가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {

		int _count = 0;
		
		_rtnMsg = "정상적으로 삭제되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				LOGGER.debug("===>> delete ICOMCART_TMP Start <<===");
				formData.putAll((Map<String, String>)gridData.get(i));

				// 업로드 된 ICOMCART_TMP 에서 삭제
				_count = sqlSessionTemplate.update("buyer.mpso.delIcomcartTmpExcelUp", formData);
				
				if ( _count != 1 ) {
					throw new RuntimeException("삭제 중 오류가 발생하였습니다.");
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("삭제 중 오류가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
 
	// 엑셀 업로드
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		sqlSessionTemplate.update("buyer.mpso.delAllIcomcartTmp", formData);
		
		int _count = 0;
		
		_rtnMsg = "정상적으로 업로드 되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				LOGGER.debug("===>> insert ICOMCART_TMP Start <<===");
				formData.putAll((Map<String, String>)gridData.get(i));

				formData.put("SEQ", String.valueOf(i+1));
				
				// 엑셀 업로드 결과 ICOMCART_TMP 삽입
				_count = sqlSessionTemplate.insert("buyer.mpso.insertIcomcartTmpExcelUp", formData);
				
				if ( _count != 1 ) {
					throw new RuntimeException("업로드 중 오류가 발생하였습니다.");
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("업로드 중 오류가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
}
