package com.koreab2b.mro.common.mppo.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;
 

@Repository("buyerMpPoGoodsAddPopDao")
@Transactional
public class BuyerMpPoGoodsAddPopDaoImpl implements BuyerMpPoGoodsAddPopDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpPoGoodsAddPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selecInfotList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mppo.getBuyerCartInfo", formData);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		
		List<Map<String,String>> list = null;
		String byca_comorg_code = formData.get("bycaComorgCode").toString();
		ResultRowHandler _resultHander = new ResultRowHandler();
		if(byca_comorg_code.equals("KRISER0001")) //아이서비스의 경우
		{
			LOGGER.debug("KRISER0001 KRISER0001");
			// asis 쿼리가 이상함
			//list = sqlSessionTemplate.selectList("common.mppo.getCatalogSearchKRISER0001Main", formData);			
		}else{ 
			 sqlSessionTemplate.select("common.mppo.getCatalogSearchMain", formData ,_resultHander);
			 list =   (List<Map<String, String>>)_resultHander.getList(); 
		}
		return list;
	}
	
	
	
	// 상품추가
	public String saveSetItemAdd(Map<String,String>  formData) {
		
		
		String recv_flag = formData.get("st_recv_flag").toString();
		String px_no = formData.get("st_px_no").toString();
		
		
        if(recv_flag.equals("HI")){
             setHongIkItemAdd( formData );
        }else{
            if(px_no.substring(0,2).equals("PX")){  // 발주보류조회
                 setPxOrderItemAdd( formData );
            }else{  // 주문진행현황
                 setPrOrderItemAdd( formData );
            }
        }  
		
		return null;
	}
	
	
	
	
	// 홍익대학교 장바구니 상품추가.
    public String setHongIkItemAdd( Map<String,String>  formData   ) {
    
     String _st_query2 = formData.get("st_query2").toString();
     
   	 String  _ICOMCART[] = _st_query2.split("&&"); 
	 if (_ICOMCART == null){ 
		 LOGGER.debug("_ICOMCART 미존재 ");
		  
	 }else{
		 
		   
		 if (_ICOMCART.length >0){
			 for( int i=0 ; i < _ICOMCART.length; i++){ 
		        String str[] =  _ICOMCART[i].split("@@");    
		        
		       
		        if (str != null ){
		        	
		        	
		        	 Map<String,String> _data = new HashMap<String,String>() ;
			        _data.put("BUYER", formData.get("buyer").toString());
			        _data.put("USER_ID", formData.get("userid").toString());
			        _data.put("BYCA_COMORG_CODE", formData.get("bycaComorgCode").toString());			        
			        _data.put("VERIF_NUM", formData.get("st_px_no").toString());
			        _data.put("RECV_FLAG", formData.get("st_recv_flag").toString());
			        
			        
			        _data.put("BUYER_ITEM_NO", str[0]);
			        _data.put("CART_QTY", str[1]);  
			        _data.put("CONTRACT_NO", str[2]);
			        _data.put("CONTRACT_SEQ", str[3]);
			        
		        	
		        	sqlSessionTemplate.update("common.mppo.setHongIkItemAdd", _data);	
		        	
		        	
		        }
			 }
		 }
	 }
	 
    	
    	return "OK";
    }
    
    
	//구매사 >> 발주 >> 발주보류조회 >> 구매요청(발주) 상세조회 >> 상품추가 <-- 상세구현 필요
    public String setPxOrderItemAdd( Map<String,String>  formData   ) {
    	List<Map<String,String>> list = null;
    	list = sqlSessionTemplate.selectList("common.mppo.getSetPxOrderItemAdd", formData);	 
    	
    	String _st_query2 = formData.get("st_query2").toString();        
      	 String  _ICOMCART[] = _st_query2.split("&&"); 
     	if (list != null){
    		if (list.size() > 0){
    			for (int k=0; k<list.size(); k++){
    				Map<String,String>  data = list.get(k);
							   	 if (_ICOMCART == null){ 
							   		 LOGGER.debug("_ICOMCART 미존재 ");
							   		  
							   	 }else{
							   		 
							   		   
							   		 if (_ICOMCART.length >0){
							   			 for( int i=0 ; i < _ICOMCART.length; i++){ 
							   		        String str[] =  _ICOMCART[i].split("@@");    
							   		        
							   		       
							   		        if (str != null ){
							   		        	
							   		        	
							   		        	 Map<String,String> _data = new HashMap<String,String>() ;
							   		        	 
							   			        _data.put("BUYER", formData.get("buyer").toString());
							   			        _data.put("USER_ID", formData.get("userid").toString());
							   			        _data.put("BYCA_COMORG_CODE", formData.get("bycaComorgCode").toString());			        
							   			        _data.put("VERIF_NUM", formData.get("st_px_no").toString());
							   			        _data.put("RECV_FLAG", formData.get("st_recv_flag").toString());
							   			        
							   			        
							   			     _data.putAll(data);
							   			        
							   			        
							   			        _data.put("BUYER_ITEM_NO", str[0]);
							   			        _data.put("CART_QTY", str[1]);  
							   			        _data.put("CONTRACT_NO", str[2]);
							   			        _data.put("CONTRACT_SEQ", str[3]);
							   			        
							   		        	
							   		        	sqlSessionTemplate.update("common.mppo.setPxOrderItemAdd", _data);	
							   		        	
							   		        	
							   		        }
							   			 }
							   		 }
							   	 }
   	 
    			}
    		}
    	}
   	 
   	 
   	 
    	return "OK";
    }
    
    
	//구매사 >> 주문관리 >> 주문진행현황 >> 구매요청상세정보 >> 상품추가<-- 상세구현 필요
    public String setPrOrderItemAdd( Map<String,String>  formData   ) {
    	List<Map<String,String>> list = null;
    	list = sqlSessionTemplate.selectList("common.mppo.getSetPrOrderItemAdd", formData);	
    	
    	
    	String _st_query2 = formData.get("st_query2").toString();        
     	String  _ICOMCART[] = _st_query2.split("&&"); 
	    	if (list != null){
		   		if (list.size() > 0){
		   			for (int k=0; k<list.size(); k++){
		   				Map<String,String>  data = list.get(k);
									   	 if (_ICOMCART == null){ 
									   		 LOGGER.debug("_ICOMCART 미존재 ");
									   		  
									   	 }else{
									   		 
									   		   
									   		 if (_ICOMCART.length >0){
									   			 for( int i=0 ; i < _ICOMCART.length; i++){ 
									   		        String str[] =  _ICOMCART[i].split("@@");    
									   		        
									   		       
									   		        if (str != null ){
									   		        	
									   		        	
									   		        	 Map<String,String> _data = new HashMap<String,String>() ;
									   		        	 
									   			        _data.put("BUYER", formData.get("buyer").toString());
									   			        _data.put("USER_ID", formData.get("userid").toString());
									   			        _data.put("BYCA_COMORG_CODE", formData.get("bycaComorgCode").toString());			        
									   			        _data.put("VERIF_NUM", formData.get("st_px_no").toString());
									   			        _data.put("RECV_FLAG", formData.get("st_recv_flag").toString());
									   			        
									   			        
									   			     _data.putAll(data);
									   			        
									   			        
									   			        _data.put("BUYER_ITEM_NO", str[0]);
									   			        _data.put("CART_QTY", str[1]);  
									   			        _data.put("CONTRACT_NO", str[2]);
									   			        _data.put("CONTRACT_SEQ", str[3]);
									   			        
									   		        	
									   		        	sqlSessionTemplate.update("common.mppo.setPrOrderItemAdd", _data);	
									   		        	
									   		        	
									   		        }
									   			 }
									   		 }
									   	 }
		  	 
		   			}
		   		}
	   	}
    	 
    	 
    	return "OK";
    }
    
    
    
	
	// 상품 추가 상세 조회
	public List<Map<String,String>> getCatalogDisplayMain(Map<String,String>  formData) {
		return  sqlSessionTemplate.selectList("common.mppo.getCatalogDisplayMain", formData);	
	}
	public List<Map<String,String>> getItemSeries(Map<String,String>  formData){
		return  sqlSessionTemplate.selectList("common.mppo.getItemSeries", formData);	
	}
	public List<Map<String,String>> categoryPathViewer(Map<String,String>  formData){
		return  sqlSessionTemplate.selectList("common.mppo.categoryPathViewer", formData);	
	}
	
	
    
}
