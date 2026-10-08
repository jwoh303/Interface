package com.koreab2b.mro.common.mprq.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoCartUploadDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("buyerMpRqExcelUploadPopDao")
@Transactional
public class BuyerMpRqExcelUploadPopDaoImpl implements BuyerMpRqExcelUploadPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoCartUploadDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mprq.selectBuyerMpRqExcelUploadPopList", formData);
	}
	public List<Map<String,String>> selectList_v2(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mprq.selectBuyerMpRqExcelUploadPopList_v2", formData);
	}
	
	// 견적의뢰 업로드 (TMP)
	public String saveExcelUp(Map<String,String>  formData) {
		
		try{
		 sqlSessionTemplate.update("buyer.mprq.setMpRqAddDel", formData);

		 String buyer_item_no = "";
		 String item_qty = "";  
		 String buyer_tager_price = "";  
		 String description = "";  
		 
			String st_query = formData.get("result").toString(); 
			Map<String,String> _data = null;
			
			String  _EXCELDATA[] = st_query.split("\\|"); 
			 if (_EXCELDATA == null){
				 LOGGER.debug("_EXCELDATA 미존재 ");
			 }else{
				 
				 for( int i=0 ; i < _EXCELDATA.length; i++){ 					 
					 
					 if (i>0){
						 String str[] =  _EXCELDATA[i].split("@@",-1);  					 
						 _data = new HashMap<String,String>() ;
						 _data.put("st_user_id", formData.get("st_user_id"));
						 _data.put("st_buyer", formData.get("st_buyer"));
						 
						 buyer_item_no = CommonUtil.nvl(str[0],"");
						 description = CommonUtil.nvl(str[1],"");
						 
						 if (!"".equals(description)){
						 _data.put("BUYER_ITEM_NO", buyer_item_no);
						 _data.put("DESCRIPTION", description);
						 _data.put("SPECIFICATION", CommonUtil.nvl(str[2],""));
						 _data.put("UNIT_MEASURE", CommonUtil.nvl(str[3],""));
						 _data.put("MAKER_NAME", CommonUtil.nvl(str[4],""));
						 _data.put("ORIGIN_NAME", CommonUtil.nvl(str[5],""));
						 _data.put("REQ_PRICE_TYPE", CommonUtil.nvl(str[6],"R"));
						 
						 buyer_tager_price = CommonUtil.nvl(str[7],"0");
						 buyer_tager_price = buyer_tager_price.replaceAll(",", "");
						 item_qty = CommonUtil.nvl(str[8],"0");
						 item_qty = item_qty.replaceAll(",", "");
						 
						 _data.put("BUYER_TARGET_PRICE", CommonUtil.nvl(buyer_tager_price,""));
						 _data.put("ITEM_QTY", CommonUtil.nvl(item_qty,""));
						 _data.put("BUYER_ASSIGN_AGENT_CODE", CommonUtil.nvl(str[9],""));
						 _data.put("AGENT", CommonUtil.nvl(str[10],""));
						 _data.put("TMP_REMARK", CommonUtil.nvl(str[11],""));
						 
						  sqlSessionTemplate.update("buyer.mprq.insertMpRqAddTemp", _data);		  
						 }
					 }
				 }
			 } 
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 상품 견적의뢰 엑셀 업로드를 실패하였습니다.");
		}
			  
		  return "OK";
	}
	
	// 견적의뢰 업로드 (TMP)
	public String saveExcelUp_v2(Map<String,String>  formData) {
		
		try{
		 sqlSessionTemplate.update("buyer.mprq.setMpRqAddDel", formData);

		 String buyer_item_no = "";
		 String item_qty = "";  
		 String buyer_tager_price = "";  
		 String description = "";  
		 
			String st_query = formData.get("result").toString(); 
			Map<String,String> _data = null;
			
			String  _EXCELDATA[] = st_query.split("\\|"); 
			 if (_EXCELDATA == null){
				 LOGGER.debug("_EXCELDATA 미존재 ");
			 }else{
				 for( int i=0 ; i < _EXCELDATA.length; i++){ 					 
					 if (i>0){
						 String str[] =  _EXCELDATA[i].split("@@",-1);  					 
						 _data = new HashMap<String,String>() ;
						 _data.put("st_user_id", formData.get("st_user_id"));
						 _data.put("st_buyer", formData.get("st_buyer"));
						 buyer_item_no = CommonUtil.nvl(str[0],"");
						 description = CommonUtil.nvl(str[1],"");
						 if (!"".equals(description)){
						 _data.put("BUYER_ITEM_NO", buyer_item_no);
						 _data.put("DESCRIPTION", description);
						 _data.put("SPECIFICATION", CommonUtil.nvl(str[2],""));
						 _data.put("UNIT_MEASURE", CommonUtil.nvl(str[3],""));
						 _data.put("MAKER_NAME", CommonUtil.nvl(str[4],""));
						 _data.put("MAKER_PART_NO", CommonUtil.nvl(str[5],""));
						 _data.put("ORIGIN_NAME", CommonUtil.nvl(str[6],""));
						 _data.put("REQ_PRICE_TYPE", CommonUtil.nvl(str[7],"R"));
						 
						 buyer_tager_price = CommonUtil.nvl(str[8],"0");
						 buyer_tager_price = buyer_tager_price.replaceAll(",", "");
						 item_qty = CommonUtil.nvl(str[9],"0");
						 item_qty = item_qty.replaceAll(",", "");
						 
						 _data.put("BUYER_TARGET_PRICE", CommonUtil.nvl(buyer_tager_price,""));
						 _data.put("ITEM_QTY", CommonUtil.nvl(item_qty,""));
						 _data.put("BUYER_ASSIGN_AGENT_CODE", CommonUtil.nvl(str[10],""));
						 _data.put("AGENT", CommonUtil.nvl(str[11],""));
						 _data.put("TMP_REMARK", CommonUtil.nvl(str[12],""));
						 
						  sqlSessionTemplate.update("buyer.mprq.insertMpRqAddTemp_v2", _data);		  
						 }else{
							return "error";
						 }
					 }
				 }
			 } 
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 상품 견적의뢰 엑셀 업로드를 실패하였습니다.");
		}
			  
		  return "OK";
	}
}
