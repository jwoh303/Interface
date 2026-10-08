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

@Repository("buyerMpSoDlvryInfoDao")
@Transactional
public class BuyerMpSoDlvryInfoDaoImpl implements BuyerMpSoDlvryInfoDao { 

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public List<Map<String, String>>  getList(Map<String,String>  formData)  {
		return sqlSessionTemplate.selectList("buyer.mpso.getListICOMLUSR", formData);
	}  

	// 우편번호검증
	public String checkZipCode(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("buyer.mpso.checkZipCode", formData);
	} 
	
	// 기본 배송정보 입력 
	public String setUserInfoUpdate(Map<String,String>  formData){
		 sqlSessionTemplate.update("buyer.mpso.setUserInfoUpdate", formData);
		 return "UPDATE_OK";
	} 
	
	

	// 수령희망일 입력
	public List<Map<String, String>>  getBuyerMpSoRecvDateRegisterPop(Map<String,String>  formData)  {
		
		Map<String,Object>  data = new HashMap<String,Object>();
		data.putAll(formData);
		  
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"),"@@");
		if(_list.size() > 0){
			data.put("st_query_cart_array", _list);
		} 
	  
		
		
		
		return sqlSessionTemplate.selectList("buyer.mpso.getBuyerMpSoRecvDateRegisterPop", data);
	}  
	
	
	// 배송조회
	public List<Map<String, String>>  getBuyerMpSoDlvryInfoStatusList(Map<String,String>  formData) { 
		return sqlSessionTemplate.selectList("buyer.mpso.getBuyerMpSoDlvryInfoStatusList",  formData);
	}  
	public List<Map<String, String>>  getBuyerMpSoDlvryInfoDtlList(Map<String,String>  formData)  { 
		return sqlSessionTemplate.selectList("buyer.mpso.getBuyerMpSoDlvryInfoDtlList",  formData);
	}
	public List<Map<String, String>>  getBuyerMpSoDlvryInfoDtlList_v2(Map<String,String>  formData)  { 
		return sqlSessionTemplate.selectList("buyer.mpso.getBuyerMpSoDlvryInfoDtlList_v2",  formData);
	}
	

	// 부서조회(ICOMCOD2 C001)
	public String getdeptYn(Map<String, String> formData) {
		String msg = "";
		int cnt = (Integer) sqlSessionTemplate.selectOne("buyer.mpso.getdeptYn",  formData);
		if(cnt > 0) {
			msg = "Y";
		} else {
			msg = "N";
		}
		return msg;
	}  
	

	
	
}
