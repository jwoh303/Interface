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

@Repository("buyerMdCmExcelCartPunchoutSearchDao")
@Transactional
public class BuyerMdCmExcelCartPunchoutSearchDaoImpl implements BuyerMdCmExcelCartPunchoutSearchDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmExcelCartPunchoutSearch", formData);
	} 

	// 장바구니 업로드 (TMP)
	public String saveExcelUp(Map<String,String>  formData) {
		
		try{
		 String buyer_item_no = "";
		 
			String st_query = formData.get("result").toString(); 
			Map<String,String> _data = null;
			
			String  _EXCELDATA[] = st_query.split("\\|"); 
			 if (_EXCELDATA == null){
			 }else{
				 
				 for( int i=0 ; i < _EXCELDATA.length; i++){ 					 
					 
					 if (i>0){
						 String str[] =  _EXCELDATA[i].split("@@",-1);  					 
						 _data = new HashMap<String,String>() ;
						 _data.put("st_user_id", formData.get("st_user_id"));
						 _data.put("st_buyer", formData.get("st_buyer"));
						 
						 buyer_item_no = CommonUtil.nvl(str[0],"");
						 
						 if (!"".equals(buyer_item_no)){
						 _data.put("BUYER_ITEM_NO", buyer_item_no);
						 _data.put("CART_QTY", CommonUtil.nvl(str[1],""));
						 
						  sqlSessionTemplate.update("buyer.mdcm.insertMdCmExcelCart", _data);		  
						 }
					 }
				 }
			 } 
		}catch(Exception e){
			throw new RuntimeException("장바구니 엑셀 업로드를 실패하였습니다.");
		}
			  
		  return "OK";
	}
}

