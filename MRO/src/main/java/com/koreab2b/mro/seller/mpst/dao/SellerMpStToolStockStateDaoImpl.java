package com.koreab2b.mro.seller.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("sellerMpStToolStockStateDao")
@Transactional
public class SellerMpStToolStockStateDaoImpl implements SellerMpStToolStockStateDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(SellerMpStToolStockStateDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> formData) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("seller.mpst.selectSellerMpStToolStockStateList", formData, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "정상적으로 저장되었습니다.";
		int res_cnt = 0;
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));		
	
				// 구매대행재고수불 update
				res_cnt = sqlSessionTemplate.update("seller.mpst.updateSellerMpStToolStockState_KEP_S_STOCK", formData);
				
                if ( res_cnt != 1 ) {
                    throw new RuntimeException("\n\n[ 재고수량 등록 중 에러 ]");
                }
			}
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 재고수량 저장 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		String _rtnMsg = "정상적으로 삭제되었습니다.";
		int res_cnt = 0;
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				// 구매사별 계약서 가격정보 update
				res_cnt = sqlSessionTemplate.update("seller.mpst.updateSellerMpStToolStockState_ICOMCQDT", formData);
				
                if ( res_cnt != 1 ) {
                    throw new RuntimeException("\n\n[ 카탈로그 재고 표기 삭제 중 에러 ]");
                }
				
				// 구매대행재고수불 delete
                res_cnt = sqlSessionTemplate.delete("seller.mpst.deleteSellerMpStToolStockState", formData);
				
                if ( res_cnt != 1 ) {
                	throw new RuntimeException("\n\n[ 재고테이블 삭제 중 에러 ]");
                }
			}
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 재고품목 삭제 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}

		return _rtnMsg;		
	}	
	
}
