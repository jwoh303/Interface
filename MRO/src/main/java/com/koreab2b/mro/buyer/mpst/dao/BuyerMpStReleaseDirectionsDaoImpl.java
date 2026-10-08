package com.koreab2b.mro.buyer.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpStReleaseDirectionsDao")
@Transactional
public class BuyerMpStReleaseDirectionsDaoImpl implements BuyerMpStReleaseDirectionsDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpStReleaseDirectionsDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpst.selectBuyerMpStReleaseDirectionsList", formData);
	}
	
	// 사용자 조회
	public List<Map<String,String>> selectUserList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpst.selectBuyerMpStReleaseDirectionsList_userList", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "정상적으로 저장되었습니다.";
		int res_cnt = 0;
//		List<Map<String,String>>_list = null;
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));		
	
				// 구매사 수불 상세내역 insert
				res_cnt = sqlSessionTemplate.insert("buyer.mpst.insertBuyerMpStReleaseDirectionsCreate_BUYER_STOCK_LIST", formData);
				
				if ( res_cnt != 1 ) {
					throw new RuntimeException("\n\n[ 출고정보 입력중 에러 ]");
				}
				
				// 구매사 재고 관리 테이블 merge
				res_cnt = sqlSessionTemplate.update("buyer.mpst.insertBuyerMpStReleaseDirectionsCreate_BUYER_STOCK", formData);
				
				if ( res_cnt != 1 ) {
					throw new RuntimeException("\n\n[ 재고 관리 입력중 에러 ]");
				}
				
//				_list = sqlSessionTemplate.selectList("buyer.mpst.getBuyerMpStReleaseDirectionsCheck",formData);
//				String check_flag = CommonUtil.getListKeyValue(_list,"DUP_CNT","0");
//				if(check_flag.equals("0")){	
//					sqlSessionTemplate.insert("buyer.mpst.insertBuyerMpStReleaseDirectionsCreate", formData);
//					sqlSessionTemplate.update("buyer.mpst.updateBuyerMpStReleaseDirectionsRq",formData);
//					
//				}else{
//					_rtnMsg = "중복된 데이터가 존재합니다.";
//					throw new RuntimeException(_rtnMsg);
//				}	
			}
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 출고 처리 중 에러 ]");
		}
		
		return _rtnMsg;
	}
	
}
