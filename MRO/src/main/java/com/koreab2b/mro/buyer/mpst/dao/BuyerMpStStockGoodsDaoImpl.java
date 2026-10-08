package com.koreab2b.mro.buyer.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpStStockGoodsDao")
@Transactional
public class BuyerMpStStockGoodsDaoImpl implements BuyerMpStStockGoodsDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpStStockGoodsDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpst.selectBuyerMpStStockGoodsList", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "정상적으로 저장되었습니다.";
		int res_cnt = 0;
//		List<Map<String,String>>_list = null;
		
		try {
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// 회사별 코드관리 merge
				res_cnt = sqlSessionTemplate.insert("buyer.mpst.insertBuyerMpStStockGoodsCreate_ICOMCOD2", formData);
				
				if ( res_cnt != 1 ) {
					throw new RuntimeException("\n\n[ 재고품목 등록중 에러 ]");
				}
				
				// 구매사 재고 관리 테이블 merge
				res_cnt = sqlSessionTemplate.insert("buyer.mpst.insertBuyerMpStStockGoodsCreate_BUYER_STOCK", formData);
	
				if ( res_cnt != 1 ) {
					throw new RuntimeException("\n\n[ 재고 관리 입력중 에러 ]");
				}
				
//				_list = sqlSessionTemplate.selectList("buyer.mpst.getBuyerMpStStockGoodsCheck",formData);
//				String check_flag = CommonUtil.getListKeyValue(_list,"DUP_CNT","0");
//				if(check_flag.equals("0")){	
//					sqlSessionTemplate.insert("buyer.mpst.insertBuyerMpStStockGoodsCreate", formData);
//					sqlSessionTemplate.update("buyer.mpst.updateBuyerMpStStockGoodsRq",formData);
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
			
			throw new RuntimeException("\n\n[ 등록 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
}
