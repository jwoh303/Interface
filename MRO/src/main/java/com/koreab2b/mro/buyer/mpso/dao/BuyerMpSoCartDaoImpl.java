package com.koreab2b.mro.buyer.mpso.dao;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.StringWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.w3c.dom.Document;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.CxmlUtil;

@Repository("buyerMpSoCartDao")
@Transactional
public class BuyerMpSoCartDaoImpl implements BuyerMpSoCartDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoCartDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회 
	public List<Map<String,String>> getShoppintCartSelectSql(Map<String,String>  formData){
		return sqlSessionTemplate.selectList("buyer.mpso.getShoppintCartSelectSql"+formData.get("st_listQuery"), formData);
	}
	public List<Map<String,String>> getShoppintCartSelectSql_v2(Map<String,String>  formData){
		return sqlSessionTemplate.selectList("buyer.mpso.getShoppintCartSelectSql"+formData.get("st_listQuery")+"_v2", formData);
	}
	public List<Map<String,String>> getBuyerShoppingCartOrderListConfirm(Map<String,String>  formData){
		
		
		
		Map<String,Object>  data = new HashMap<String,Object>();
		data.putAll(formData);
		  
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"),"@@");
		if(_list.size() > 0){
			data.put("st_query_cart_array", _list);
		} 
	  
		/* SEQ를 필요로 하는 st_query_cart 부분 추가 시작 */	

		String st_query_cart_tmp = formData.get("st_query_cart");
		String st_query_cart_tmp_list[] = st_query_cart_tmp.split("@@");		
		String st_query_cart_seq = "";
		data.put("st_seqYn", "N");

		if (st_query_cart_tmp_list != null) {
			
			// ICOMCART.SEQ 구분자 : &&
			for (int i = 0; i < st_query_cart_tmp_list.length; i++) {
				String str[] =  st_query_cart_tmp_list[i].split("&&",-1);  
				
				for( int k=0; k < str.length; k++){
					LOGGER.debug("str["+k+"] ==>" + str[k]);
		} 
			
				LOGGER.debug("str.length ==>" + str.length);
				
				// SEQ 존재하면 st_seqYn(xml의 조건에서 사용)
			if (str != null && str.length == 2){
				data.put("st_cart_seq", str[1]);
					data.put("st_seqYn", "Y");
					st_query_cart_seq += str[0] + str[1] + "@@";
			}else{ // 없으면 원문 그대로
				st_query_cart_seq = st_query_cart_tmp;
			}
			}
			
			_list = CommonUtil.getStringArrary(st_query_cart_seq,"@@");
			
			LOGGER.debug("_list ==>" + _list );
			
			data.put("st_query_cart_array", _list);
		}

		/* SEQ를 필요로 하는 st_query_cart 부분 추가 종료 */
		
		
		
		return sqlSessionTemplate.selectList("buyer.mpso.getBuyerShoppingCartOrderListConfirm"+formData.get("st_listQuery"), data);
	}
	public List<Map<String,String>> getHongIkType(Map<String,String>  formData){
		return sqlSessionTemplate.selectList("buyer.mpso.getHongIkType", formData);
	}
	public List<Map<String,String>> getHongIkSheetType(Map<String,String>  formData) {
		return sqlSessionTemplate.selectList("buyer.mpso.getHongIkSheetType", formData);
	}
	// 바로주문 - 유한용
	// 유한은 ICOMTRXL 집어 넣고 ICOMCART 삭제한다.
	public String saveBuyerYuhanCartUpdate(Map<String,String>  formData){
		  
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString(); 
		Map<String,String> _data = null;
		
		try{
			 
			 String  _ICOMCART[] = _st_update.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
				        
				        
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    } 
				        
				       
				        if (str != null && str.length == 6){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id); 
					         
					        
					        _data.put("st_ref_pr_no", str[0]);
					        _data.put("mg_note", str[1]);   
					        _data.put("st_item_no", str[2]);
					        _data.put("st_order_price", str[3]); 
					        _data.put("st_order_qty", str[4]);
					        _data.put("st_cart_seq", str[5]);
					        
					        sqlSessionTemplate.update("buyer.mpso.createIcomtrxl", _data);  
					        sqlSessionTemplate.delete("buyer.mpso.removeIcomcart", _data);  
					        
						 }				         
					 }					  
				 }				  
			 } 
			  
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("바로주문 실패하였습니다.");
		}
		return null;
		 
	}
	// 바로주문 , 저장
	public String saveBuyerShoppingcartQtyUpdate(Map<String,String>  formData){
		 
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString(); 
		String cart_type = formData.get("st_cart_type").toString(); 
		List<Map<String,String>> list = null;
		Map<String,String> _data = null;
		Map<String,String> _ldata = null;
		
		try{
			 
			 String  _ICOMCART[] = _st_update.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
				        
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    } 
				        
						
				        if (str != null && str.length >= 13){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id); 
						        
					        _data.put("st_item_no", str[0]);
					        _data.put("st_order_qty", str[1]);  
					        _data.put("st_ref_pr_no", str[2]);
					        _data.put("st_contract_no", str[3]);
					        _data.put("st_contract_seq", str[4]);
					        _data.put("st_fixed_price_flag", str[5]); 
					        _data.put("st_order_price", str[6]);
					        _data.put("st_account_type", str[7]); 
					        _data.put("st_budget_dept", str[8]); 
					        _data.put("remark", str[9]); 
					        _data.put("ref_pr_dept", str[10]); 
					        _data.put("mg_code", str[11]);
					        _data.put("mg_note", str[12]); 
					        
					        if(str.length == 14){
					        	_data.put("st_cart_seq", str[13]);
					        }else{
					        	_data.put("st_cart_seq", "");
					        }
					        
					        sqlSessionTemplate.update("buyer.mpso.updateIcomcart", _data);  
					        
					        if(cart_type.equals("HONG-CART")){
					        	
					        	//홍익 대학교 확인번호
					        	list = sqlSessionTemplate.selectList("buyer.mpso.setShoppingCartHongIk", _data);
					        	
					        	_data.put("text","" ); 
					        	
				 
					        		
						        	if (list != null){
						        		if (list.size()>0){
	
						        			StringBuilder sb = new StringBuilder();
						        			
						        			for  (int j=0; j<list.size(); j++){					        				
						        			
						        				_ldata = new HashMap<String,String>() ;
							        			_ldata = list.get(j);
							        			
							        			sb.append(" 						WHEN NVL(HI_DEPT_CODE, 'NO-GRADUATE') = '");
							        			sb.append(_ldata.get("HI_DEPT"));
							        			sb.append("' THEN '");
							        			sb.append(String.valueOf(_ldata.get("RN")));
							        			sb.append("'	\n"); 
	
						        			}
						        			
						        			
						        			 _data.put("text",sb.toString() ); 
						        			
						        		}else{
						        			_data.put("text","" ); 
						        		}
						        		
						        	}else{
						        		 _data.put("text","" ); 
						        	}
						        	
					     
					        	
					        	if ("".equals(_data.get("text").toString())){
					        		LOGGER.debug("홍익 대학교 확인번호 setShoppingCartHongIk 미존재 ");
					        	}else{
					        		sqlSessionTemplate.update("buyer.mpso.updateIcomcartHONG-CART", _data);   
					        	}
					        	 
					        } 
					        
					        
						 }				         
					 }					  
				 }				  
			 } 
			  
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("장바구니 저장 실패하였습니다.");
		}
		return null;
	}
	// 바로주문 , 저장
	public String saveBuyerShoppingcartQtyCowayUpdate(Map<String,String>  formData){
		 
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString(); 
		String cart_type = formData.get("st_cart_type").toString(); 
		List<Map<String,String>> list = null;
		Map<String,String> _data = null;
		Map<String,String> _ldata = null;
		
		try{
			 
			 String  _ICOMCART[] = _st_update.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
				        
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    } 
				        
						
				        if (str != null && str.length >= 14){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id); 
						        
					        _data.put("st_item_no", str[0]);
					        _data.put("st_order_qty", str[1]);  
					        _data.put("st_ref_pr_no", str[2]);
					        _data.put("st_contract_no", str[3]);
					        _data.put("st_contract_seq", str[4]);
					        _data.put("st_fixed_price_flag", str[5]); 
					        _data.put("st_order_price", str[6]);
					        _data.put("st_account_type", str[7]); 
					        _data.put("st_budget_dept", str[8]); 
					        _data.put("remark", str[9]); 
					        _data.put("ref_pr_dept", str[10]); 
					        _data.put("mg_code", str[11]);
					        _data.put("mg_note", str[12]);
					        _data.put("st_cart_seq", str[13]); 
					        
					        sqlSessionTemplate.update("buyer.mpso.updateCowaycart", _data);  
					        
						 }				         
					 }					  
				 }				  
			 } 
			  
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("장바구니 저장 실패하였습니다.");
		}
		return null;
	}
	
	// 삭제
	public String removeBuyerShoppingcartMycartDelReg(Map<String,String>  formData){
 
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString(); 
		 Map<String,String> _data = null;
		
		try{
			 
			 String  _ICOMCART[] = _st_update.split("&&",-1); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
				        
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    } 
				        
						
				        if (str != null && str.length >= 6){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id); 
					        
					        _data.put("st_item_no", str[0]);
					        _data.put("st_agent_code", str[1]);   
					        _data.put("st_contract_no", str[2]);
					        _data.put("st_contract_seq", str[3]);
					        _data.put("st_byit_comorg_code", str[4]);  
					        _data.put("st_user_flag", str[5]);
					        
					        if(str.length == 7){
					        	_data.put("st_cart_seq", str[6]);
					        }else{
					        	_data.put("st_cart_seq", "");
					        }
					        
					        sqlSessionTemplate.delete("buyer.mpso.setShoppingCartListDelete", _data);  
					        
						 }				         
					 }					  
				 }				  
			 } 
			  
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("장바구니 삭제 실패하였습니다.");
		}
		return null;
	} 
	
	// 삭제
	public String removeBuyerShoppingcartMycartClcsDelReg(Map<String,String>  formData){
		
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString(); 
		Map<String,String> _data = null;
		
		try{
			
			String  _ICOMCART[] = _st_update.split("&&",-1); 
			if (_ICOMCART == null){
				LOGGER.debug("_ICOMCART 미존재 ");
			}else{
				
				
				LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				if (_ICOMCART.length >0){
					for( int i=0 ; i < _ICOMCART.length; i++){ 
						String str[] =  _ICOMCART[i].split("@@",-1);  
						
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
						} 
						
						
						if (str != null && str.length == 7){
							
							_data = new HashMap<String,String>() ;
							_data.put("buyer", _buyer);
							_data.put("user_id", _user_id); 
							
							_data.put("st_item_no", str[0]);
							_data.put("st_agent_code", str[1]);   
							_data.put("st_contract_no", str[2]);
							_data.put("st_contract_seq", str[3]);
							_data.put("st_byit_comorg_code", str[4]);  
							_data.put("st_user_flag", str[5]);
							_data.put("st_cart_seq", str[6]);
							
							
							sqlSessionTemplate.delete("buyer.mpso.setShoppingCartClcsListDelete", _data);  
							
						}				         
					}					  
				}				  
			} 
			
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("장바구니 삭제 실패하였습니다.");
		}
		return null;
	} 
	// 바로주문 , 길이 저장
	public String saveBuyerShoppingcartSizeQtyUpdate(Map<String,String>  formData){
		
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString();
		String _department = "";		
		String cart_type = formData.get("st_cart_type").toString();
		boolean isAmore = false;
		// 품목별 도착지 지정
		String p060000100 = formData.get("p060000100").toString();		
		List<Map<String,String>> list = null;
		Map<String,String> _data = null;
		Map<String,String> _ldata = null;
		Map<String,String> _aTmp = null;
		Map<String,ArrayList<String>> _adata = new LinkedHashMap<String,ArrayList<String>>() ;		
		List<Map<String,String>> amoreList = new ArrayList<Map<String,String>>();
		LocalDate localDate = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		String curDate = localDate.format(formatter);
		List<Map<String,String>> chkAmoreCmp = null;
		Map<String,String> amoreCmp = null;
		List<Map<String,String>> amoreDeptList = null;
		String wbs = "";
		String glAccount = "";
		String plant = "";		
		List<Map<String,String>> chkNoIfAmoreCmp = null;
		Map<String,String> chkNoIfMap = null;
		
		try{
			 String  _ICOMCART[] = _st_update.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 
					 chkAmoreCmp = sqlSessionTemplate.selectList("buyer.mpso.selectAmoreCompany", formData);
					 if(chkAmoreCmp.size() > 0) {
						 amoreCmp = chkAmoreCmp.get(0);
					 }					 
					 String [] amoreKeys = {"BUKRS","ORDDT","AMT01","DEPT2","KOSTL","FISTL","HKONT"};
					 for(String key : amoreKeys) {
						 _adata.put(key, new ArrayList<String>()); 
					 }
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    }
						
				        if (str != null && str.length >= 16){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id); 
						        
					        _data.put("st_item_no", str[0]);
					        _data.put("st_order_qty", str[1]);  
					        _data.put("st_ref_pr_no", str[2]);
					        _data.put("st_contract_no", str[3]);
					        _data.put("st_contract_seq", str[4]);
					        _data.put("st_fixed_price_flag", str[5]); 
					        _data.put("st_order_price", str[6]);
					        _data.put("st_account_type", str[7]); 
					        _data.put("st_budget_dept", str[8]); 
					        _data.put("remark", str[9]); 
					        _data.put("ref_pr_dept", str[10]); 
					        _data.put("mg_code", str[11]);
					        _data.put("mg_note", str[12]);
					        _data.put("st_size_qty", str[13]); 
					        _data.put("st_size_len", str[14]);
					        _data.put("st_pr_reason", str[15]);
					        if(str.length == 18){
					        	_data.put("st_cart_seq", str[16]);
					        	_data.put("st_dely_bundle_flag", str[17]);
					        }else if(p060000100 != null){
					        	_data.put("st_cart_seq", str[16]);
					        	_data.put("st_dely_bundle_flag", str[17]);
					        	_data.put("item_dely_to_location_code", str[18]);
					        	_data.put("item_dely_to_location_text", str[19]);
					        	_data.put("item_recv_user", str[20]);
					        	_data.put("item_recv_user_phone", str[21]);
					        }else{
					        	_data.put("st_cart_seq", "");
					        	_data.put("st_dely_bundle_flag", "N");
					        }
					        sqlSessionTemplate.update("buyer.mpso.updateSizeIcomcart", _data);  
					        if(cart_type.equals("HONG-CART")){
					        	//홍익 대학교 확인번호
					        	list = sqlSessionTemplate.selectList("buyer.mpso.setShoppingCartHongIk", _data);
					        	_data.put("text","" ); 
						        	if (list != null){
						        		if (list.size()>0){
	
						        			StringBuilder sb = new StringBuilder();
						        			
						        			for  (int j=0; j<list.size(); j++){					        				
						        			
						        				_ldata = new HashMap<String,String>() ;
							        			_ldata = list.get(j);
							        			
							        			sb.append(" 						WHEN NVL(HI_DEPT_CODE, 'NO-GRADUATE') = '");
							        			sb.append(_ldata.get("HI_DEPT"));
							        			sb.append("' THEN '");
							        			sb.append(String.valueOf(_ldata.get("RN")));
							        			sb.append("'	\n"); 
	
						        			}
						        			 _data.put("text",sb.toString() ); 
						        			
						        		}else{
						        			_data.put("text","" ); 
						        		}
						        		
						        	}else{
						        		 _data.put("text","" ); 
						        	}
						        	
					        	if ("".equals(_data.get("text").toString())){
					        		LOGGER.debug("홍익 대학교 확인번호 setShoppingCartHongIk 미존재 ");
					        	}else{
					        		sqlSessionTemplate.update("buyer.mpso.updateIcomcartHONG-CART", _data);   
					        	}
					        }
					        if(amoreCmp != null && amoreCmp.get("COMPANY_CODE").equals("KRAMORG001")) {
					        	chkNoIfMap = new HashMap<String,String>(); 
					        	chkNoIfAmoreCmp = new ArrayList<Map<String,String>>();
					        	if(_buyer.equals("KRAMOR0005")) {
					        		wbs = "";
					        		glAccount = _data.get("st_ref_pr_no");					        		
					        	}else {
					        		wbs = _data.get("st_ref_pr_no");
					        		glAccount = _data.get("st_account_type");
					        	}
					        	
					        	chkNoIfMap.put("COM_CODE", formData.get("buyer"));
					        	chkNoIfMap.put("KOSTL", _data.get("st_budget_dept"));
					        	chkNoIfMap.put("HKONT", _data.get("st_account_type"));
								chkNoIfAmoreCmp = sqlSessionTemplate.selectList("buyer.mpso.selectNoIfAmoreCompany", chkNoIfMap);
								
								if(chkNoIfAmoreCmp.size() > 0) {
									LOGGER.info("###### 아모레 예산체크 제외 계정 : "+ chkNoIfAmoreCmp.toString());
									continue;									
								}
								
					        	LOGGER.info("###### _data : "+ _data.toString());
					        	
					        	Double amtTmp = 0.0;
					        	Integer amt = 0;
					        	amtTmp = Double.valueOf(_data.get("st_order_price")) * Double.valueOf(_data.get("st_order_qty"));
					        	amt = (int)Math.round(amtTmp);
					        	amoreDeptList = sqlSessionTemplate.selectList("buyer.mpso.selectAmoreDept", _data);
					        	if(amoreDeptList.size() > 0) {
					        		_department = amoreDeptList.get(0).get("FISTL");
					        	}
					        	plant = amoreCmp.get("CODE");
					        	_aTmp = new HashMap<String,String>() ;					        	
					        	_aTmp.put("BUKRS",plant); //PLANT
					        	_aTmp.put("ORDDT",curDate);
					        	_aTmp.put("AMT01", amt.toString());
					        	_aTmp.put("DEPT2",wbs);
					        	_aTmp.put("KOSTL",_data.get("st_budget_dept"));
					        	_aTmp.put("FISTL",_department);
					        	_aTmp.put("HKONT",glAccount.split("-")[0]);
					        	if(amoreList.size() < 1) {
					        		amoreList.add(_aTmp);
					        	}else {
					        		String newKey = _aTmp.get("FISTL")+_aTmp.get("KOSTL")+_aTmp.get("HKONT")+_aTmp.get("DEPT2");
					        		Boolean isExist = false;
					        		for(Map<String,String> item : amoreList) {
						        		String key = item.get("FISTL")+item.get("KOSTL")+item.get("HKONT")+item.get("DEPT2");
						        		if(newKey.equals(key)) {
						        			Integer tmpPrice = Integer.parseInt(item.get("AMT01"))+Integer.parseInt(_aTmp.get("AMT01"));
						        			item.put("AMT01", tmpPrice.toString());
						        			isExist = true;
						        		}
						        	}
					        		if(!isExist) {
					        			amoreList.add(_aTmp);
					        		}
					        	}
					        }
						 }				         
					 }	
					 if(amoreCmp != null && amoreCmp.get("COMPANY_CODE").equals("KRAMORG001") && chkNoIfAmoreCmp.size() < 1) {
						 isAmore = true;
						 Map<String, String> result = new HashMap<String,String>();
						 for(Map<String,String> item : amoreList) {
							 _adata.get("BUKRS").add(item.get("BUKRS"));
							 _adata.get("ORDDT").add(item.get("ORDDT"));
							 _adata.get("AMT01").add(item.get("AMT01"));
							 _adata.get("DEPT2").add(item.get("DEPT2"));
							 _adata.get("KOSTL").add(item.get("KOSTL"));
							 _adata.get("FISTL").add(item.get("FISTL"));
							 _adata.get("HKONT").add(item.get("HKONT"));
						 }
						 LOGGER.info("###### paramMap : "+ _adata.toString());
						 //예산체크 전송
						 result = amorepacificFiCheck(_adata);
						 LOGGER.info("###### 예산체크 결과 : "+ result.toString());
						 String resultMsg = result.get("PE_CHKYN");
						 //예산체크 결과 확인
						 if(resultMsg.equals("Y - 성공")) {
							 
						 }else if(resultMsg.indexOf("N - 가용예산") > -1) {
							 throw new RuntimeException("SAP 예산이 부족하여 전체품목 주문이 불가합니다. 부서예산관리자에게 잔여액을 확인하고 재진행해주시기 바랍니다.");
						 }else if(resultMsg.indexOf("N - 계정") > -1) {
							 throw new RuntimeException("SAP 계정이 유효하지 않습니다. 부서예산관리자에게 해당 내용 확인하고 재진행해주시기 바랍니다.");
						 }else if(resultMsg.indexOf("N - 펀드센터") > -1) {
							 throw new RuntimeException("SAP 코스트센터가 유효하지 않습니다. 부서예산관리자에게 해당 내용 확인하고 재진행해주시기 바랍니다.");
						 }else {
							 throw new RuntimeException("SAP 내 오류값이 있습니다. 부서예산관리자에게 해당 내용 확인하고 재진행해주시기 바랍니다.");
						 }
					 }
				 }				  
			 } 
			  
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if(isAmore) {
				throw new RuntimeException(e.getMessage());
			} else {
				throw new RuntimeException("장바구니 저장 실패하였습니다.");
			}
			
		}
		return null;
	}
	public String saveBuyerShoppingcartSizeQtyUpdate_v2(Map<String,String>  formData){
		
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString();
		String _department = "";		
		String cart_type = formData.get("st_cart_type").toString();
		boolean isAmore = false;
		// 품목별 도착지 지정
		String p060000100 = formData.get("p060000100").toString();		
		List<Map<String,String>> list = null;
		Map<String,String> _data = null;
		Map<String,String> _ldata = null;
		Map<String,String> _aTmp = null;
		Map<String,ArrayList<String>> _adata = new LinkedHashMap<String,ArrayList<String>>() ;		
		List<Map<String,String>> amoreList = new ArrayList<Map<String,String>>();
		LocalDate localDate = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		String curDate = localDate.format(formatter);
		List<Map<String,String>> chkAmoreCmp = null;
		Map<String,String> amoreCmp = null;
		List<Map<String,String>> amoreDeptList = null;
		String wbs = "";
		String glAccount = "";
		String plant = "";		
		List<Map<String,String>> chkNoIfAmoreCmp = null;
		Map<String,String> chkNoIfMap = null;
		
		try{
			 String  _ICOMCART[] = _st_update.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 
					 chkAmoreCmp = sqlSessionTemplate.selectList("buyer.mpso.selectAmoreCompany", formData);
					 if(chkAmoreCmp.size() > 0) {
						 amoreCmp = chkAmoreCmp.get(0);
					 }					 
					 String [] amoreKeys = {"BUKRS","ORDDT","AMT01","DEPT2","KOSTL","FISTL","HKONT"};
					 for(String key : amoreKeys) {
						 _adata.put(key, new ArrayList<String>()); 
					 }
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    }
						
				        if (str != null && str.length >= 16){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id); 
						        
					        _data.put("st_item_no", str[0]);
					        _data.put("st_order_qty", str[1]);  
					        _data.put("st_ref_pr_no", str[2]);
					        _data.put("st_contract_no", str[3]);
					        _data.put("st_contract_seq", str[4]);
					        _data.put("st_fixed_price_flag", str[5]); 
					        _data.put("st_order_price", str[6]);
					        _data.put("st_account_type", str[7]); 
					        _data.put("st_budget_dept", str[8]); 
					        _data.put("remark", str[9]); 
					        _data.put("ref_pr_dept", str[10]); 
					        _data.put("mg_code", str[11]);
					        _data.put("mg_note", str[12]);
					        _data.put("st_size_qty", str[13]); 
					        _data.put("st_size_len", str[14]);
					        _data.put("st_pr_reason", str[15]);
					        if(str.length == 23){
					        	_data.put("st_cart_seq", str[16]);
					        	_data.put("st_dely_bundle_flag", str[17]);
					        	_data.put("item_dely_to_location_code", str[18]);
					        	_data.put("item_dely_to_location_text", str[19]);
					        	_data.put("item_recv_user", str[20]);
					        	_data.put("item_recv_user_phone", str[21]);
					        	_data.put("item_rd_date",str[22]);
					        }else{
					        	_data.put("st_cart_seq", "");
					        	_data.put("st_dely_bundle_flag", "N");
					        }
//					        if(str.length == 18){
//					        	_data.put("st_cart_seq", str[16]);
//					        	_data.put("st_dely_bundle_flag", str[17]);
//					        }else if(p060000100 != null){
//					        	_data.put("st_cart_seq", str[16]);
//					        	_data.put("st_dely_bundle_flag", str[17]);
//					        	_data.put("item_dely_to_location_code", str[18]);
//					        	_data.put("item_dely_to_location_text", str[19]);
//					        	_data.put("item_recv_user", str[20]);
//					        	_data.put("item_recv_user_phone", str[21]);
//					        }else{
//					        	_data.put("st_cart_seq", "");
//					        	_data.put("st_dely_bundle_flag", "N");
//					        }
					        sqlSessionTemplate.update("buyer.mpso.updateSizeIcomcart_v2", _data);  
					        
					        if(amoreCmp != null && amoreCmp.get("COMPANY_CODE").equals("KRAMORG001")) {
					        	chkNoIfMap = new HashMap<String,String>(); 
					        	chkNoIfAmoreCmp = new ArrayList<Map<String,String>>();
					        	if(_buyer.equals("KRAMOR0005")) {
					        		wbs = "";
					        		glAccount = _data.get("st_ref_pr_no");					        		
					        	}else {
					        		wbs = _data.get("st_ref_pr_no");
					        		glAccount = _data.get("st_account_type");
					        	}
					        	
					        	chkNoIfMap.put("COM_CODE", formData.get("buyer"));
					        	chkNoIfMap.put("KOSTL", _data.get("st_budget_dept"));
					        	chkNoIfMap.put("HKONT", _data.get("st_account_type")); //20261007 KRAMOR0005의 경우도 st_account_type으로 비교하도록 수정
								chkNoIfAmoreCmp = sqlSessionTemplate.selectList("buyer.mpso.selectNoIfAmoreCompany", chkNoIfMap);
								
								if(chkNoIfAmoreCmp.size() > 0) {
									LOGGER.info("###### 아모레 예산체크 제외 계정 : "+ chkNoIfAmoreCmp.toString());
									continue;									
								}
								
					        	LOGGER.info("###### _data : "+ _data.toString());
					        	
					        	Double amtTmp = 0.0;
					        	Integer amt = 0;
					        	amtTmp = Double.valueOf(_data.get("st_order_price")) * Double.valueOf(_data.get("st_order_qty"));
					        	amt = (int)Math.round(amtTmp);
					        	amoreDeptList = sqlSessionTemplate.selectList("buyer.mpso.selectAmoreDept", _data);
					        	if(amoreDeptList.size() > 0) {
					        		_department = amoreDeptList.get(0).get("FISTL");
					        	}
					        	plant = amoreCmp.get("CODE");
					        	_aTmp = new HashMap<String,String>() ;					        	
					        	_aTmp.put("BUKRS",plant); //PLANT
					        	_aTmp.put("ORDDT",curDate);
					        	_aTmp.put("AMT01", amt.toString());
					        	_aTmp.put("DEPT2",wbs);
					        	_aTmp.put("KOSTL",_data.get("st_budget_dept"));
					        	_aTmp.put("FISTL",_department);
					        	_aTmp.put("HKONT",glAccount.split("-")[0]);
					        	if(amoreList.size() < 1) {
					        		amoreList.add(_aTmp);
					        	}else {
					        		String newKey = _aTmp.get("FISTL")+_aTmp.get("KOSTL")+_aTmp.get("HKONT")+_aTmp.get("DEPT2");
					        		Boolean isExist = false;
					        		for(Map<String,String> item : amoreList) {
						        		String key = item.get("FISTL")+item.get("KOSTL")+item.get("HKONT")+item.get("DEPT2");
						        		if(newKey.equals(key)) {
						        			Integer tmpPrice = Integer.parseInt(item.get("AMT01"))+Integer.parseInt(_aTmp.get("AMT01"));
						        			item.put("AMT01", tmpPrice.toString());
						        			isExist = true;
						        		}
						        	}
					        		if(!isExist) {
					        			amoreList.add(_aTmp);
					        		}
					        	}
					        }
						 }				         
					 }	
					 if(amoreCmp != null && amoreCmp.get("COMPANY_CODE").equals("KRAMORG001") && chkNoIfAmoreCmp.size() < 1) {
						 isAmore = true;
						 Map<String, String> result = new HashMap<String,String>();
						 for(Map<String,String> item : amoreList) {
							 _adata.get("BUKRS").add(item.get("BUKRS"));
							 _adata.get("ORDDT").add(item.get("ORDDT"));
							 _adata.get("AMT01").add(item.get("AMT01"));
							 _adata.get("DEPT2").add(item.get("DEPT2"));
							 _adata.get("KOSTL").add(item.get("KOSTL"));
							 _adata.get("FISTL").add(item.get("FISTL"));
							 _adata.get("HKONT").add(item.get("HKONT"));
						 }
						 LOGGER.info("###### paramMap : "+ _adata.toString());
						 //예산체크 전송
						 result = amorepacificFiCheck(_adata);
						 LOGGER.info("###### 예산체크 결과 : "+ result.toString());
						 String resultMsg = result.get("PE_CHKYN");
						 //예산체크 결과 확인
						 if(resultMsg.equals("Y - 성공")) {
							 
						 }else if(resultMsg.indexOf("N - 가용예산") > -1) {
							 throw new RuntimeException("SAP 예산이 부족하여 전체품목 주문이 불가합니다. 부서예산관리자에게 잔여액을 확인하고 재진행해주시기 바랍니다.");
						 }else if(resultMsg.indexOf("N - 계정") > -1) {
							 throw new RuntimeException("SAP 계정이 유효하지 않습니다. 부서예산관리자에게 해당 내용 확인하고 재진행해주시기 바랍니다.");
						 }else if(resultMsg.indexOf("N - 펀드센터") > -1) {
							 throw new RuntimeException("SAP 코스트센터가 유효하지 않습니다. 부서예산관리자에게 해당 내용 확인하고 재진행해주시기 바랍니다.");
						 }else {
							 throw new RuntimeException("SAP 내 오류값이 있습니다. 부서예산관리자에게 해당 내용 확인하고 재진행해주시기 바랍니다.");
						 }
					 }
				 }				  
			 } 
			  
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if(isAmore) {
				throw new RuntimeException(e.getMessage());
			} else {
				throw new RuntimeException("장바구니 저장 실패하였습니다.");
			}
			
		}
		return null;
	}
	
	// 인터페이스 전송
	public String transferBuyerShoppingcartUpdate(Map<String,String>  formData){
		 
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString(); 
		Map<String,String> _data = null;
		
		try{
			 
			 String  _ICOMCART[] = _st_update.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
				        
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    } 
				        
						
				        if (str != null && str.length >= 13){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id); 
						        
					        _data.put("st_item_no", str[0]);
					        _data.put("st_order_qty", str[1]);  
					        _data.put("st_ref_pr_no", str[2]);
					        _data.put("st_contract_no", str[3]);
					        _data.put("st_contract_seq", str[4]);
					        _data.put("st_fixed_price_flag", str[5]); 
					        _data.put("st_order_price", str[6]);
					        _data.put("st_account_type", str[7]); 
					        _data.put("st_budget_dept", str[8]); 
					        _data.put("remark", str[9]); 
					        _data.put("ref_pr_dept", str[10]); 
					        _data.put("mg_code", str[11]);
					        _data.put("mg_note", str[12]); 
					        
					        if(str.length == 14){
					        	_data.put("st_cart_seq", str[13]);
					        }else{
					        	_data.put("st_cart_seq", str[15]);
					        }
					        
					        sqlSessionTemplate.update("buyer.mpso.updateInterfaceIcomcart", _data);  
					        
						 }
					 }
				 }
			 }
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("인터페이스 전송에 실패하였습니다.");
		}
		return null;
	}
	
	public Map<String,String> getPunchoutOrderMessage(Map<String, String> formData) {
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString();
		String _langType = "ko-KR";
		
		Document doc = null;
		
		Map<String,String> _data = null;
		Map<String,String> _pMap = new HashMap<String, String>();
		
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		List<Map<String,String>> connectionData = null;
		List<Map<String,String>> fromInfo = null;
		List<Map<String,String>> toInfo = null;
		
		Map<String,String> _ret = new HashMap<String, String>();
		
		CxmlUtil cxml = new CxmlUtil();

		/*변경로직*/
		try {
			String  _ICOMCART[] = _st_update.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
				        
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
		                   } 
						
				        if (str != null && str.length >= 13){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id); 
						        
					        _data.put("st_item_no", str[0]);
					        _data.put("st_order_qty", str[1]);  
					        _data.put("st_ref_pr_no", str[2]);
					        _data.put("st_contract_no", str[3]);
					        _data.put("st_contract_seq", str[4]);
					        _data.put("st_fixed_price_flag", str[5]); 
					        _data.put("st_order_price", str[6]);
					        _data.put("st_account_type", str[7]); 
					        _data.put("st_budget_dept", str[8]); 
					        _data.put("remark", str[9]); 
					        _data.put("ref_pr_dept", str[10]); 
					        _data.put("mg_code", str[11]);
					        _data.put("mg_note", str[12]); 
					        
					        if(str.length == 14){
					        	_data.put("st_cart_seq", str[13]);
					        }else{
					        	_data.put("st_cart_seq", str[15]);
					        }
					        
					        sqlSessionTemplate.update("buyer.mpso.updateIcomcart", _data);  
					        _pMap = sqlSessionTemplate.selectOne("buyer.mpso.selectTransferCartList", _data);
					        list.add(_pMap);
					        
						 }
					 }
				 }
				 
				 connectionData = sqlSessionTemplate.selectList("buyer.mpso.selectConnectionInfo", _data);
				 toInfo = sqlSessionTemplate.selectList("buyer.mpso.selectPunchoutInfo", _data);
				 _data.put("buyer", "KRKORE0001");
				 fromInfo = sqlSessionTemplate.selectList("buyer.mpso.selectPunchoutInfo",_data);
				 
				 if(list != null && connectionData != null){
					 
					 for(int i=0;i<list.size();i++){
						 list.get(i).put("URL", connectionData.get(0).get("URL"));
						 list.get(i).put("BUYERCOOKIE", connectionData.get(0).get("BUYERCOOKIE"));
						 list.get(i).put("FROM_DOMAIN", fromInfo.get(0).get("DOMAIN"));
						 list.get(i).put("FROM_IDENTITY", fromInfo.get(0).get("IDENTITY"));
						 list.get(i).put("TO_DOMAIN", toInfo.get(0).get("DOMAIN"));
						 list.get(i).put("TO_IDENTITY", toInfo.get(0).get("IDENTITY"));
						 list.get(i).put("LANG_TYPE", _langType);
					 }
					 
					 doc = cxml.createPunchoutOrderMessage(list);					 
					 
					 Transformer tf = TransformerFactory.newInstance().newTransformer();
					 tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
					 tf.setOutputProperty(OutputKeys.INDENT,"yes");
					 Writer out = new StringWriter();
					 tf.transform(new DOMSource(doc), new StreamResult(out));
					     
					 Map<String, String> logMap = new HashMap<String, String>();
					 logMap.put("INTERFACE_ID", "PUNCHOUT");
					 logMap.put("CONTENTS", "OrderRequest_"+out.toString());
					 logMap.put("FLAG", "Y");
					 logMap.put("ERROR_MSG", "");
					 
					 sqlSessionTemplate.insert("insertWebServiceLog",logMap);
					 
					 _ret.put("XML", out.toString() );
					 _ret.put("URL", connectionData.get(0).get("URL") );
					 _ret.put("OAFUNC", connectionData.get(0).get("OAFUNC") );
					 _ret.put("OAHP", connectionData.get(0).get("OAHP") );
					 _ret.put("OASF", connectionData.get(0).get("OASF") );
					 _ret.put("TRANSACTIONID", connectionData.get(0).get("TRANSACTIONID") );
					 _ret.put("OPERATIONKEY", connectionData.get(0).get("OPERATIONKEY") );
					 
				 }else{
					 throw new RuntimeException("인터페이스 전송에 실패하였습니다._2");
				 }
				 
			 }
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("인터페이스 전송에 실패하였습니다.");
		}
		
		/*변경 로직 끝*/
		return _ret;
	}
	
	public Map<String,String> getPunchoutOrderMessageFagb(Map<String, String> formData) {
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString();
		String _langType = "ko-KR";
		
		Document doc = null;
		
		Map<String,String> _data = null;
		Map<String,String> _pMap = new HashMap<String, String>();
		
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		List<Map<String,String>> connectionData = null;
		List<Map<String,String>> fromInfo = null;
		List<Map<String,String>> toInfo = null;
		
		Map<String,String> _ret = new HashMap<String, String>();
		
		CxmlUtil cxml = new CxmlUtil();

		/*변경로직*/
		try {
			String  _ICOMCART[] = _st_update.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
				        
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
		                   } 
						
				        if (str != null && str.length >= 13){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id); 
						        
					        _data.put("st_item_no", str[0]);
					        _data.put("st_order_qty", str[1]);  
					        _data.put("st_ref_pr_no", str[2]);
					        _data.put("st_contract_no", str[3]);
					        _data.put("st_contract_seq", str[4]);
					        _data.put("st_fixed_price_flag", str[5]); 
					        _data.put("st_order_price", str[6]);
					        _data.put("st_account_type", str[7]); 
					        _data.put("st_budget_dept", str[8]); 
					        _data.put("remark", str[9]); 
					        _data.put("ref_pr_dept", str[10]); 
					        _data.put("mg_code", str[11]);
					        _data.put("mg_note", str[12]); 
					        
					        if(str.length == 14){
					        	_data.put("st_cart_seq", str[13]);
					        }else{
					        	_data.put("st_cart_seq", str[15]);
					        }
					        
					        sqlSessionTemplate.update("buyer.mpso.updateIcomcart", _data);  
					        _pMap = sqlSessionTemplate.selectOne("buyer.mpso.selectTransferCartList", _data);
					        list.add(_pMap);
					        
						 }
					 }
				 }
				 
				 connectionData = sqlSessionTemplate.selectList("buyer.mpso.selectConnectionInfo", _data);
				 toInfo = sqlSessionTemplate.selectList("buyer.mpso.selectPunchoutInfo", _data);
				 _data.put("buyer", "KRKORE0001");
				 fromInfo = sqlSessionTemplate.selectList("buyer.mpso.selectPunchoutInfo",_data);
				 
				 if(list != null && connectionData != null){
					 
					 for(int i=0;i<list.size();i++){
						 list.get(i).put("URL", connectionData.get(0).get("URL"));
						 list.get(i).put("BUYERCOOKIE", connectionData.get(0).get("BUYERCOOKIE"));
						 list.get(i).put("FROM_DOMAIN", fromInfo.get(0).get("DOMAIN"));
						 list.get(i).put("FROM_IDENTITY", fromInfo.get(0).get("IDENTITY"));
						 list.get(i).put("TO_DOMAIN", toInfo.get(0).get("DOMAIN"));
						 list.get(i).put("TO_IDENTITY", toInfo.get(0).get("IDENTITY"));
						 list.get(i).put("LANG_TYPE", _langType);
					 }
					 
					 doc = cxml.createPunchoutOrderMessage(list);					 
					 
					 Transformer tf = TransformerFactory.newInstance().newTransformer();
					 tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
					 tf.setOutputProperty(OutputKeys.INDENT,"yes");
					 Writer out = new StringWriter();
					 tf.transform(new DOMSource(doc), new StreamResult(out));
					     
					 Map<String, String> logMap = new HashMap<String, String>();
					 logMap.put("INTERFACE_ID", "PUNCHOUT");
					 logMap.put("CONTENTS", "OrderRequest_FAGB"+out.toString());
					 logMap.put("FLAG", "Y");
					 logMap.put("ERROR_MSG", "");
					 
					 sqlSessionTemplate.insert("insertWebServiceLog",logMap);
					 
					 _ret.put("XML", out.toString() );
					 _ret.put("URL", connectionData.get(0).get("URL") );					 
					 _ret.put("id", connectionData.get(0).get("TRANSACTIONID") );					 
					 
				 }else{
					 throw new RuntimeException("인터페이스 전송에 실패하였습니다._2");
				 }				 
			 }
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("인터페이스 전송에 실패하였습니다.");
		}
		
		/*변경 로직 끝*/
		return _ret;
	}
	
	
	@Override
	public Map<String, String> getPunchoutOrderMessagePMK(Map<String, String> formData) {
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString();
		String _langType = "ko-KR";
		
		Document doc = null;
		
		Map<String,String> _data = null;
		Map<String,String> _pMap = new HashMap<String, String>();
		
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		List<Map<String,String>> connectionData = null;
		List<Map<String,String>> fromInfo = null;
		List<Map<String,String>> toInfo = null;
		
		Map<String,String> _ret = new HashMap<String, String>();
		
		CxmlUtil cxml = new CxmlUtil();

		/*변경로직*/
		try {
			String  _ICOMCART[] = _st_update.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
				        
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
		                   } 
						
				        if (str != null && str.length >= 13){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id); 
						        
					        _data.put("st_item_no", str[0]);
					        _data.put("st_order_qty", str[1]);  
					        _data.put("st_ref_pr_no", str[2]);
					        _data.put("st_contract_no", str[3]);
					        _data.put("st_contract_seq", str[4]);
					        _data.put("st_fixed_price_flag", str[5]); 
					        _data.put("st_order_price", str[6]);
					        _data.put("st_account_type", str[7]); 
					        _data.put("st_budget_dept", str[8]); 
					        _data.put("remark", str[9]); 
					        _data.put("ref_pr_dept", str[10]); 
					        _data.put("mg_code", str[11]);
					        _data.put("mg_note", str[12]); 
					        
					        if(str.length == 14){
					        	_data.put("st_cart_seq", str[13]);
					        }else{
					        	_data.put("st_cart_seq", str[15]);
					        }
					        
					        sqlSessionTemplate.update("buyer.mpso.updateIcomcart", _data);  
					        _pMap = sqlSessionTemplate.selectOne("buyer.mpso.selectTransferCartList", _data);
					        list.add(_pMap);
					        
						 }
					 }
				 }
				 
				 connectionData = sqlSessionTemplate.selectList("buyer.mpso.selectConnectionInfo", _data);
				 toInfo = sqlSessionTemplate.selectList("buyer.mpso.selectPunchoutInfo", _data);
				 _data.put("buyer", "KRKORE0001");
				 fromInfo = sqlSessionTemplate.selectList("buyer.mpso.selectPunchoutInfo",_data);
				 
				 if(list != null && connectionData != null){
					 
					 for(int i=0;i<list.size();i++){
						 list.get(i).put("URL", connectionData.get(0).get("URL"));
						 list.get(i).put("BUYERCOOKIE", connectionData.get(0).get("BUYERCOOKIE"));
						 list.get(i).put("FROM_DOMAIN", fromInfo.get(0).get("DOMAIN"));
						 list.get(i).put("FROM_IDENTITY", fromInfo.get(0).get("IDENTITY"));
						 list.get(i).put("TO_DOMAIN", toInfo.get(0).get("DOMAIN"));
						 list.get(i).put("TO_IDENTITY", toInfo.get(0).get("IDENTITY"));
						 list.get(i).put("LANG_TYPE", _langType);
					 }
					 
					 doc = cxml.createPunchoutOrderMessage(list);					 
					 
					 Transformer tf = TransformerFactory.newInstance().newTransformer();
					 tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
					 tf.setOutputProperty(OutputKeys.INDENT,"yes");
					 Writer out = new StringWriter();
					 tf.transform(new DOMSource(doc), new StreamResult(out));
					     
					 Map<String, String> logMap = new HashMap<String, String>();
					 logMap.put("INTERFACE_ID", "PUNCHOUT");
					 logMap.put("CONTENTS", "OrderRequest_PMK"+out.toString());
					 logMap.put("FLAG", "Y");
					 logMap.put("ERROR_MSG", "");
					 
					 sqlSessionTemplate.insert("insertWebServiceLog",logMap);
					 
					 _ret.put("XML", out.toString() );
					 _ret.put("URL", connectionData.get(0).get("URL") );					 
					 _ret.put("id", connectionData.get(0).get("TRANSACTIONID") );					 
					 
				 }else{
					 throw new RuntimeException("인터페이스 전송에 실패하였습니다._2");
				 }				 
			 }
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("인터페이스 전송에 실패하였습니다.");
		}
		
		/*변경 로직 끝*/
		return _ret;
	}
	
	@Override
	public Map<String, String> getPunchoutOrderMessageYHKB(Map<String, String> formData) {
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString();
		String _langType = "ko-KR";
		
		Document doc = null;
		
		Map<String,String> _data = null;
		Map<String,String> _pMap = new HashMap<String, String>();
		
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		List<Map<String,String>> connectionData = null;
		List<Map<String,String>> fromInfo = null;
		List<Map<String,String>> toInfo = null;
		
		Map<String,String> _ret = new HashMap<String, String>();
		
		CxmlUtil cxml = new CxmlUtil();

		/*변경로직*/
		try {
			String  _ICOMCART[] = _st_update.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
				        
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
		                   } 
						
				        if (str != null && str.length >= 13){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id); 
						        
					        _data.put("st_item_no", str[0]);
					        _data.put("st_order_qty", str[1]);  
					        _data.put("st_ref_pr_no", str[2]);
					        _data.put("st_contract_no", str[3]);
					        _data.put("st_contract_seq", str[4]);
					        _data.put("st_fixed_price_flag", str[5]); 
					        _data.put("st_order_price", str[6]);
					        _data.put("st_account_type", str[7]); 
					        _data.put("st_budget_dept", str[8]); 
					        _data.put("remark", str[9]); 
					        _data.put("ref_pr_dept", str[10]); 
					        _data.put("mg_code", str[11]);
					        _data.put("mg_note", str[12]); 
					        
					        if(str.length == 14){
					        	_data.put("st_cart_seq", str[13]);
					        }else{
					        	_data.put("st_cart_seq", str[15]);
					        }
					        
					        sqlSessionTemplate.update("buyer.mpso.updateIcomcart", _data);  
					        _pMap = sqlSessionTemplate.selectOne("buyer.mpso.selectTransferCartList", _data);
					        list.add(_pMap);
					        
						 }
					 }
				 }
				 
				 connectionData = sqlSessionTemplate.selectList("buyer.mpso.selectConnectionInfo", _data);
				 toInfo = sqlSessionTemplate.selectList("buyer.mpso.selectPunchoutInfo", _data);
				 _data.put("buyer", "KRKORE0001");
				 fromInfo = sqlSessionTemplate.selectList("buyer.mpso.selectPunchoutInfo",_data);
				 
				 if(list != null && connectionData != null){
					 
					 for(int i=0;i<list.size();i++){
						 list.get(i).put("URL", connectionData.get(0).get("URL"));
						 list.get(i).put("BUYERCOOKIE", connectionData.get(0).get("BUYERCOOKIE"));
						 list.get(i).put("FROM_DOMAIN", fromInfo.get(0).get("DOMAIN"));
						 list.get(i).put("FROM_IDENTITY", fromInfo.get(0).get("IDENTITY"));
						 list.get(i).put("TO_DOMAIN", toInfo.get(0).get("DOMAIN"));
						 list.get(i).put("TO_IDENTITY", toInfo.get(0).get("IDENTITY"));
						 list.get(i).put("LANG_TYPE", _langType);
					 }
					 
					 doc = cxml.createPunchoutOrderMessage(list);					 
					 
					 Transformer tf = TransformerFactory.newInstance().newTransformer();
					 tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
					 tf.setOutputProperty(OutputKeys.INDENT,"yes");
					 Writer out = new StringWriter();
					 tf.transform(new DOMSource(doc), new StreamResult(out));
					     
					 Map<String, String> logMap = new HashMap<String, String>();
					 logMap.put("INTERFACE_ID", "PUNCHOUT");
					 logMap.put("CONTENTS", "OrderRequest_YHKB"+out.toString());
					 logMap.put("FLAG", "Y");
					 logMap.put("ERROR_MSG", "");
					 
					 sqlSessionTemplate.insert("insertWebServiceLog",logMap);
					 
					 _ret.put("XML", out.toString() );
					 _ret.put("URL", connectionData.get(0).get("URL") );					 
					 _ret.put("id", connectionData.get(0).get("TRANSACTIONID") );					 
					 
				 }else{
					 throw new RuntimeException("인터페이스 전송에 실패하였습니다._2");
				 }				 
			 }
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("인터페이스 전송에 실패하였습니다.");
		}
		
		/*변경 로직 끝*/
		return _ret;
	}
	
	public Map<String,String> getPunchoutOrderMessageTEST(Map<String, String> formData) {
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString();
		
		String _st_langtype = formData.get("st_langtype").toString();
		String _st_encoding = formData.get("st_encoding").toString();
		String _st_indent = formData.get("st_indent").toString();
		String _st_fake = formData.get("st_fake").toString();
		
		System.out.println("_st_langtype : "+_st_langtype);
		System.out.println("_st_encoding : "+_st_encoding);
		System.out.println("_st_indent : "+_st_indent);
		System.out.println("_st_fake : "+_st_fake);
		
		LOGGER.debug("_st_langtype : "+_st_langtype);
		LOGGER.debug("_st_encoding : "+_st_encoding);
		LOGGER.debug("_st_indent : "+_st_indent);
		LOGGER.debug("_st_fake : "+_st_fake);
		Document doc = null;
		
		Map<String,String> _data = null;
		Map<String,String> _pMap = new HashMap<String, String>();
		
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		List<Map<String,String>> connectionData = null;
		List<Map<String,String>> fromInfo = null;
		List<Map<String,String>> toInfo = null;
		
		Map<String,String> _ret = new HashMap<String, String>();
		
		CxmlUtil cxml = new CxmlUtil();

		/*변경로직*/
		try {
			String  _ICOMCART[] = _st_update.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
				        
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
		                   } 
						
				        if (str != null && str.length >= 13){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id); 
						        
					        _data.put("st_item_no", str[0]);
					        _data.put("st_order_qty", str[1]);  
					        _data.put("st_ref_pr_no", str[2]);
					        _data.put("st_contract_no", str[3]);
					        _data.put("st_contract_seq", str[4]);
					        _data.put("st_fixed_price_flag", str[5]); 
					        _data.put("st_order_price", str[6]);
					        _data.put("st_account_type", str[7]); 
					        _data.put("st_budget_dept", str[8]); 
					        _data.put("remark", str[9]); 
					        _data.put("ref_pr_dept", str[10]); 
					        _data.put("mg_code", str[11]);
					        _data.put("mg_note", str[12]); 
					        
					        if(str.length == 14){
					        	_data.put("st_cart_seq", str[13]);
					        }else{
					        	_data.put("st_cart_seq", str[15]);
					        }
					        
					        sqlSessionTemplate.update("buyer.mpso.updateIcomcart", _data);  
					        _pMap = sqlSessionTemplate.selectOne("buyer.mpso.selectTransferCartList", _data);
					        list.add(_pMap);
					        
						 }
					 }
				 }
				 
				 connectionData = sqlSessionTemplate.selectList("buyer.mpso.selectConnectionInfo", _data);
				 toInfo = sqlSessionTemplate.selectList("buyer.mpso.selectPunchoutInfo", _data);
				 _data.put("buyer", "KRKORE0001");
				 fromInfo = sqlSessionTemplate.selectList("buyer.mpso.selectPunchoutInfo",_data);
				 
				 if(list != null && connectionData != null){
					 
					 for(int i=0;i<list.size();i++){
						 list.get(i).put("URL", connectionData.get(0).get("URL"));
						 list.get(i).put("BUYERCOOKIE", connectionData.get(0).get("BUYERCOOKIE"));
						 list.get(i).put("FROM_DOMAIN", fromInfo.get(0).get("DOMAIN"));
						 list.get(i).put("FROM_IDENTITY", fromInfo.get(0).get("IDENTITY"));
						 list.get(i).put("TO_DOMAIN", toInfo.get(0).get("DOMAIN"));
						 list.get(i).put("TO_IDENTITY", toInfo.get(0).get("IDENTITY"));
						 list.get(i).put("LANG_TYPE", _st_langtype);
					 }
					 if(_st_fake.equals("Y")){
						doc = cxml.createFakePunchoutOrderMessage(list); 
					 }else{
						 doc = cxml.createPunchoutOrderMessage(list); 
					 }					 
					 
					 Transformer tf = TransformerFactory.newInstance().newTransformer();
					 if(_st_encoding.equals("Y")){
						 tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
					 }
					 
					 if(_st_indent.equals("Y")){
						 tf.setOutputProperty(OutputKeys.INDENT,"yes");
					 }else{
						 tf.setOutputProperty(OutputKeys.INDENT,"no");
					 }
					 
					 Writer out = new StringWriter();
					 tf.transform(new DOMSource(doc), new StreamResult(out));
					     
					 Map<String, String> logMap = new HashMap<String, String>();
					 logMap.put("INTERFACE_ID", "PUNCHOUT");
					 logMap.put("CONTENTS", "OrderRequest_"+out.toString());
					 logMap.put("FLAG", "Y");
					 logMap.put("ERROR_MSG", "");
					 
					 sqlSessionTemplate.insert("insertWebServiceLog",logMap);
					 
					 _ret.put("XML", out.toString() );
					 _ret.put("URL", connectionData.get(0).get("URL") );
					 
				 }else{
					 throw new RuntimeException("인터페이스 전송에 실패하였습니다._2");
				 }
				 
			 }
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("인터페이스 전송에 실패하였습니다.");
		}
		
		/*변경 로직 끝*/
		return _ret;
	}
	
	public String removePunchoutOrderMessageShoppingcart(Map<String, String> formData) {
		
		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString(); 
		 Map<String,String> _data = null;
		
		try{
			 
			 String  _ICOMCART[] = _st_update.split("\\|");  
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
				        
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    } 
				        
						
				        if (str != null && str.length >= 6){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id); 
					        
					        _data.put("st_item_no", str[0]);
					        _data.put("st_agent_code", str[1]);   
					        _data.put("st_contract_no", str[3]);
					        _data.put("st_contract_seq", str[4]);
					        _data.put("st_user_flag", "C");
					        _data.put("st_cart_seq", str[15]);
					        
					        sqlSessionTemplate.delete("buyer.mpso.setShoppingCartListDeleteForPunchout", _data);  
					        
						 }				         
					 }					  
				 }				  
			 } 
			  
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("장바구니 삭제 실패하였습니다.");
		}
		return null;
	}
	public String getPunchoutURL(Map<String, String> formData) {
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString(); 
		Map<String,String> _data = new HashMap<String,String>() ;;
		Map<String,String> _ret = new HashMap<String,String>() ;;
		
		String ret = "";
		_data.put("user_id", _user_id);
		_data.put("buyer", _buyer);
		
		try{
			_ret = sqlSessionTemplate.selectOne("buyer.mpso.selectConnectionInfo", _data);  
			ret = _ret.get("URL");
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("인터페이스 전송에 실패하였습니다.");
		}
		return ret;
	}
	
	public List<Map<String, String>> getNexeAccountList(Map<String, String> formData) {	
		return sqlSessionTemplate.selectList("buyer.mpso.getNexeAccountList", formData);
	}
	
	public Map<String, String> amorepacificFiCheck(Map<String,ArrayList<String>> paramMap){
		Map<String, String> result = new HashMap<String,String>();		
		ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
			
		try {
			Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap("KRAMOR0003", "P11-0000004");
			String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));			
			URL url = new URL(st_url);
			
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();
			conn.setRequestMethod("POST");
	        conn.setRequestProperty("Content-Type", "application/json");
	        conn.setRequestProperty("Accept", "application/json");
	        conn.setDoOutput(true);	        
	        
	        // JSON 데이터 전송
			OutputStream outputStream = conn.getOutputStream();
	        outputStream.write(mapper.writeValueAsString(paramMap).getBytes());
	        outputStream.flush();
	        outputStream.close();
	        
	        // 응답 코드 확인
	        int responseCode = conn.getResponseCode();
	        LOGGER.info("##### 응답 코드 : " + responseCode);	        
	        
	        // 응답 데이터 읽기
	        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        String line;
	        StringBuilder response = new StringBuilder();	
	
	        while ((line = reader.readLine()) != null) {
	            response.append(line);
	        }
	
	        reader.close();
	        
	        // 응답 데이터 출력
	        LOGGER.info("##### 응답 데이터 : " + response.toString());

	        // 연결 해제
	        conn.disconnect();	
	        
	        result = mapper.readValue(response.toString(), Map.class);
	        
		} catch (IOException e) {
			e.printStackTrace();
		}	        
		
		return result;
	}
	
}
