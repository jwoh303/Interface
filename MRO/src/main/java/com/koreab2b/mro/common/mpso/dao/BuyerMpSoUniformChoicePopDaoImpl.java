package com.koreab2b.mro.common.mpso.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoUniformChoicePopDao")
@Transactional
public class BuyerMpSoUniformChoicePopDaoImpl implements BuyerMpSoUniformChoicePopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoUniformChoicePopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectBuyerMpSoUniformChoicePopList", formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData){
		
		String _st_item_list = formData.get("st_item_list").toString();
		String _user_id = formData.get("userid").toString();
		String _com_code = formData.get("com_code").toString();
		Map<String,String> _data = null;
		
		LOGGER.debug(_st_item_list);
		LOGGER.debug(_user_id);
		LOGGER.debug(_com_code);
		
		try{
			String _item_list[] = _st_item_list.split("&&");
			if (_item_list == null){
				LOGGER.debug("_item_list 미존재 ");
			}else{
				LOGGER.debug(" _item_list.length  " + _item_list.length );
				
				if (_item_list.length >0){
					for( int i=0 ; i < _item_list.length; i++){
						String str[] =  _item_list[i].split("@",-1);
						
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    }
						
				        if (str != null && str.length == 3){
				        	_data = new HashMap<String,String>();
					        _data.put("com_code", _com_code);
					        _data.put("user_id", _user_id); 

					        _data.put("st_buyer_item_no", str[0]);
					        _data.put("st_contract_no", str[1]);  
					        _data.put("st_contract_seq", str[2]);

					        sqlSessionTemplate.update("common.mpso.updateBuyerMpSoUniformChoicePop", _data);  
						 }				         
					 }					  
				 }				  
			 } 
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("등록 실패하였습니다.");
		}
		return null;
	}
}
