package com.koreab2b.mro.buyer.mpso.dao;

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

@Repository("buyerMpSoCartUploadDao")
@Transactional
public class BuyerMpSoCartUploadDaoImpl implements BuyerMpSoCartUploadDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoCartUploadDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData){
		String st_cart_type = formData.get("st_cart_type");
		
		// 고객사에 따른 조회쿼리 분기(P06-0000080)
		if("TYPE1".equals(st_cart_type)){
			return sqlSessionTemplate.selectList("buyer.mpso.getCartAddType1List", formData);			
		}else if("TYPE2".equals(st_cart_type)){
			return sqlSessionTemplate.selectList("buyer.mpso.getCartAddType2List", formData);
		}else{
			return sqlSessionTemplate.selectList("buyer.mpso.getCartAddList", formData);			
		}
	}	
	
	// 장바구니 업로드 (TMP)
	public String saveExcelUp(Map<String,String>  formData) {
		
		try{
		 sqlSessionTemplate.update("buyer.mpso.setCartAddDel", formData);

		 String remark = "";
		 String item_qty = "";
		 String buyer_item_no = "";
		 String ref_pr_no_1 =""; // 업체구분
		 String ref_pr_no_2 =""; // 현장
		 String item_len = "";
		 String budget_dept = ""; // 예산부서(P06-0000080-TYPE2)
		 String account_type = ""; // 계정(P06-0000080-TYPE2)
		 
		 	String st_query = formData.get("result").toString(); 
			Map<String,String> _data = null;
			
			String  _ICOMCART[] = st_query.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 for( int i=0 ; i < _ICOMCART.length; i++){ 					 
					 if (i>0){
						 if(formData.get("cart_type").equals("TYPE1")){ // 길이수량 사용 고객사(P06-0000080)
							 String str[] =  _ICOMCART[i].split("@@",-1);  					 
							 _data = new HashMap<String,String>() ;
							 _data.put("userid", formData.get("userid"));
							 _data.put("buyer", formData.get("buyer"));
							 _data.put("SEQ",String.valueOf(i));
							 ref_pr_no_1 = CommonUtil.nvl(str[0],"");
							 ref_pr_no_2 = CommonUtil.nvl(str[1],"");
							 buyer_item_no = CommonUtil.nvl(str[2],"");
							 
							 if(!"".equals(buyer_item_no)){
								 _data.put("BUYER_ITEM_NO",buyer_item_no);
								 _data.put("REF_PR_NO",ref_pr_no_1+"^"+ref_pr_no_2);
								 item_qty = CommonUtil.nvl(str[4],"0");
								 item_qty = item_qty.replaceAll(",", "");
								 _data.put("QTY",item_qty);
								 
								 item_len = CommonUtil.nvl(str[3],"");
								 item_len = item_len.replaceAll(",", "");
								 _data.put("LEN",item_len);
								 
								 // 엑셀양식에 길이 입력 안 할 시 총수량 산출용 길이 1로 셋팅, 입력 있으면 입력길이 셋팅
								 if(!"".equals(item_len)){
									 _data.put("TEMP_LEN",item_len);
								 }else{
									 _data.put("TEMP_LEN","1");
								 }
								 
								 if(!CommonUtil.NumberChk(item_qty)){
									 remark = "유효하지않은 수량표현";
									 _data.put("QTY","0");
								 }else{
									 remark = "";
								 }
								 
								 _data.put("REMARK",remark);
								 sqlSessionTemplate.update("buyer.mpso.insertIcomcartTmpType1", _data);
							 }
						 }else if(formData.get("cart_type").equals("TYPE2")){ // 예산부서/계정 사용 고객사(P06-0000080)
							 String str[] =  _ICOMCART[i].split("@@",-1);  					 
							 _data = new HashMap<String,String>() ;
							 _data.put("userid", formData.get("userid"));
							 _data.put("buyer", formData.get("buyer"));
							 _data.put("SEQ",String.valueOf(i));
							 buyer_item_no = CommonUtil.nvl(str[0],"");
							 
							 if(!"".equals(buyer_item_no)){
								 _data.put("BUYER_ITEM_NO",buyer_item_no);
								 item_qty = CommonUtil.nvl(str[1],"0");
								 item_qty = item_qty.replaceAll(",", "");
								 _data.put("QTY",item_qty);
								 
								 budget_dept = CommonUtil.nvl(str[2],"");
								 _data.put("BUDGET_DEPT", budget_dept);
								 account_type = CommonUtil.nvl(str[3],"");
								 _data.put("ACCOUNT_TYPE", account_type);
								 ref_pr_no_1 = CommonUtil.nvl(str[4],"");
								 _data.put("REF_PR_NO", ref_pr_no_1);
								 
								 if(!CommonUtil.NumberChk(item_qty)){
									 remark = "유효하지않은 수량표현";
									 _data.put("QTY","0");
								 }else{
									 remark = "";
								 }
								 
								 _data.put("REMARK",remark);
								 sqlSessionTemplate.update("buyer.mpso.insertIcomcartTmpType2", _data);
							 }
						 }else{
							 String str[] =  _ICOMCART[i].split("@@",-1);  					 
							 _data = new HashMap<String,String>() ;
							 _data.put("userid", formData.get("userid"));
							 _data.put("buyer", formData.get("buyer"));
							 _data.put("SEQ",String.valueOf(i));
							 buyer_item_no = CommonUtil.nvl(str[0],"");
							 
							 if(!"".equals(buyer_item_no)){
								 _data.put("BUYER_ITEM_NO",buyer_item_no);
								 item_qty = CommonUtil.nvl(str[1],"0");
								 item_qty = item_qty.replaceAll(",", "");
								 _data.put("QTY",item_qty);
								 
								 if(!CommonUtil.NumberChk(item_qty)){
									 remark = "유효하지않은 수량표현";
									 _data.put("QTY","0");
								 }else{
									 remark = "";
								 }
								 
								 _data.put("REMARK",remark);
								 sqlSessionTemplate.update("buyer.mpso.insertIcomcartTmp", _data);
							 }
						 }
					 }
				 }
			 } 
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("장바구니 업로드 실패하였습니다.");
		}
			  
		  return "OK";
	}
	
	// 장바구니 저장
	public String saveSetCartAddReg(Map<String,String>  formData) {		
		
		String st_query = formData.get("st_query").toString(); 
		Map<String,String> _data = null;
		
		String  _ICOMCART[] = st_query.split("@@"); 
		 if (_ICOMCART == null){
			 LOGGER.debug("_ICOMCART 미존재 ");
		 }else{
			 
			 for( int i=0 ; i < _ICOMCART.length; i++){ 
				 _data = new HashMap<String,String>() ;
				 _data.put("userid", formData.get("userid"));
				 _data.put("buyer", formData.get("buyer"));
				 _data.put("cart_type", formData.get("st_cart_type"));
				 _data.put("SEQ", _ICOMCART[i]);
				 
				  sqlSessionTemplate.update("buyer.mpso.setCartAddReg", _data);		  
				  sqlSessionTemplate.update("buyer.mpso.setCartAddDelAll", _data);		  
			 }
		 }
		  
		  return "OK";
	}
	
	//삭제
	public String removeSetCartAddDel(Map<String,String>  formData) {
		
		String st_query = formData.get("st_query").toString(); 
		Map<String,String> _data = null;
		
		String  _ICOMCART[] = st_query.split("@@"); 
		 if (_ICOMCART == null){
			 LOGGER.debug("_ICOMCART 미존재 ");
		 }else{
			 
			 for( int i=0 ; i < _ICOMCART.length; i++){ 
				 _data = new HashMap<String,String>() ;
				 _data.put("userid", formData.get("userid"));
				 _data.put("buyer", formData.get("buyer"));
				 _data.put("SEQ", _ICOMCART[i]);
				   
				  sqlSessionTemplate.update("buyer.mpso.setCartAddDelAll", _data);		  
			 }
		 } 
		  
		  return "OK";
	}
 
	
}
