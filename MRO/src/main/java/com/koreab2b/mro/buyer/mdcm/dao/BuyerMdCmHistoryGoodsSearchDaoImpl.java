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

@Repository("buyerMdCmHistoryGoodsSearchDao")
@Transactional
public class BuyerMdCmHistoryGoodsSearchDaoImpl implements BuyerMdCmHistoryGoodsSearchDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMdCmGoodsLisDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmHistoryGoodsSearchList", formData);
	}
	public List<Map<String,String>> selectBuyerMdCmHistoryGoodsSearchList_v2(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmHistoryGoodsSearchList_v2", formData);
	}
	// 이력상품검색에서 삭제
	@Override
	public String deleteItem(Map<String, String> formData) {
		
		StringBuffer _rtnMsg = new StringBuffer();
		String _msg = "";

		String _query = formData.get("st_query2").toString();
		String _user_id = formData.get("st_user_id_session").toString();
		String _buyer = formData.get("st_com_code").toString();

		try{
			 String  _itemList[] = _query.split("&&"); 
			 if (_itemList== null){
				 LOGGER.debug("_queryList 미존재 ");
			 }else{
				 LOGGER.debug(" _queryList.length  " + _itemList.length );
				 if (_itemList.length > 0){
					 for( int i=0 ; i < _itemList.length; i++){
						 String str= _itemList[i];
				        if (str != null ){
				        	
				        	 Map<String,String> _data = new HashMap<String,String>() ;
					        _data.put("BUYER", _buyer);
					        _data.put("USER_ID", _user_id);
					        _data.put("BUYER_ITEM_NO", str);
					        
					        LOGGER.debug(" _data  " + _data);
							// 기존에 등록한 이력상품 삭제 후 다시 등록
							sqlSessionTemplate.update("buyer.mdcm.deleteBuyerMdCmhistoryGoodsItem", _data);
							
							sqlSessionTemplate.update("buyer.mdcm.insertBuyerMdCmhistoryGoodsItem", _data);
				        }
					 }
				 }
			 }		 
			 LOGGER.debug("_rtnMsg.toString() " +_rtnMsg.toString());
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException(_msg + "이력상품검색 삭제에 실패하였습니다.");
		}
		return _rtnMsg.toString();
	}
}
