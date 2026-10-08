package com.koreab2b.mro.buyer.mpso.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("buyerMpSoCartMyungWhaDao")
@Transactional
public class BuyerMpSoCartMyungWhaDaoImpl implements BuyerMpSoCartMyungWhaDao { 

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		
		String st_query_cart = formData.get("st_query_cart").toString();
		 
		List<Map<String,String>> list = null;
		 if(st_query_cart.equals("ALL")){
			 list = sqlSessionTemplate.selectList("buyer.mpso.getShoppintCartSelectSql_Kolo0016", formData);
		 }else{
			 
				Map<String,Object>  data = new HashMap<String,Object>();
				data.putAll(formData);
				  
				List< String > _list = new ArrayList< String >( );
				_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"),"@@");
				if(_list.size() > 0){
					data.put("st_query_cart_array", _list);
				} 
			  
				
			 list = sqlSessionTemplate.selectList("buyer.mpso.getBuyerShoppingCartOrderListConfirm_Kolo0016", data);
		 }
		 return list;
	}
	
 
	
}
