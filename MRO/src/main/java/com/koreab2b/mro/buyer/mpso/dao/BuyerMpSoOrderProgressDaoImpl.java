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
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("buyerMpSoOrderProgressDao")
@Transactional
public class BuyerMpSoOrderProgressDaoImpl implements BuyerMpSoOrderProgressDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoOrderProgressDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		//return sqlSessionTemplate.selectList("buyer.mpso.selectBuyerMpSoOrderProgressList", formData);
		
		String pageflag = (String) formData.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("buyer.mpso.selectBuyerMpSoOrderProgressList", formData, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("buyer.mpso.selectBuyerMpSoOrderProgressList", formData);
		}
		
		return resultList;

		
	}
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getBuyerMpSoOrderProgressList_v2(Map<String,Object> formData) {
		List<String> list = CommonUtil.getStringArrary((String)formData.get("st_status"), ",");
		if(list.size() != 0){
			formData.put("st_status", list);
		}
		if(formData.get("st_all_page").equals("N")){
			return sqlSessionTemplate.selectList("buyer.mpso.getBuyerMpSoOrderProgressList_v2", formData);
		}else{
			return sqlSessionTemplate.selectList("buyer.mpso.getBuyerMpSoOrderProgressList_v3", formData);
		}
		
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "";
		List<Map<String,String>>_list = null;
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
	
				_list = sqlSessionTemplate.selectList("buyer.mpso.getBuyerMpSoOrderProgressCheck",formData);
				String check_flag = CommonUtil.getListKeyValue(_list,"DUP_CNT","0");
				if(check_flag.equals("0")){	
					sqlSessionTemplate.insert("buyer.mpso.insertBuyerMpSoOrderProgressCreate", formData);
					sqlSessionTemplate.update("buyer.mpso.updateBuyerMpSoOrderProgressRq",formData);
					
				}else{
					_rtnMsg = "중복된 데이터가 존재합니다.";
					throw new RuntimeException(_rtnMsg);
					
				}	
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("장바구니 담기에 실패하였습니다.");
		}
	return _rtnMsg;
		
	}

	@Override
	public List<Map<String, String>> getBuyerMpSoClcsOrderProgressList(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpso.getBuyerMpSoClcsOrderProgressList", formData);
	}

	@Override
	public List<Map<String, String>> getBuyerMpSoGroupPurchaseOrderProgressList(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpso.getBuyerMpSoGroupPurchaseOrderProgressList2", formData);
	}

	// 삭제
	public String delBuyerMpsoCowayCart(Map<String,String>  formData){
		
		String _st_update = formData.get("st_update").toString();
		String _buyer = formData.get("buyer").toString(); 
		Map<String,String> _data = null;
		
		try{
			
			String  _ICOMCART[] = _st_update.split("&&",-1); 
			if (_ICOMCART == null){
				LOGGER.debug("_COWAYCART 미존재 ");
			}else{
				LOGGER.debug(" _COWAYCART.length  " + _ICOMCART.length );
				if (_ICOMCART.length >0){
					for( int i=0 ; i < _ICOMCART.length; i++){ 
						String str[] =  _ICOMCART[i].split("@@",-1);  
						
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
						} 
						
						if (str != null && str.length == 4){
							_data = new HashMap<String,String>() ;
							_data.put("buyer", _buyer);
							_data.put("st_coway_cart_id", str[0]);
							_data.put("st_contract_no", str[1]);
							_data.put("st_contract_seq", str[2]);
							_data.put("st_seq", str[3]);  
							sqlSessionTemplate.delete("buyer.mpso.setCowayCartClcsListDelete", _data);  
							
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
	@Override
	public List<Map<String, String>> getBuyerMpSoSellerRegProgressList(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpso.getBuyerMpSoSellerRegProgressList", formData);
	}
	@Override
	public List<Map<String, String>> getBuyerMpSoSellerInfoPop(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpso.getBuyerMpSoSellerInfoPop", formData);
	}
	// 삭제
	public String saveBuyerMpSoSellerRegProgressList(Map<String,String>  formData){
		
		String _st_update = formData.get("st_update").toString();
		String _buyer = formData.get("st_com_code").toString(); 
		Map<String,String> _data = null;
		try{
			String  _ICOMCART[] = _st_update.split("&&",-1); 
			if (_ICOMCART == null){
				LOGGER.debug("_COWAYCART 미존재 ");
			}else{
				LOGGER.debug(" _COWAYCART.length  " + _ICOMCART.length );
				if (_ICOMCART.length >0){
					for( int i=0 ; i < _ICOMCART.length; i++){ 
						String str[] =  _ICOMCART[i].split("@@",-1);   
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
						} 
						if (str != null && str.length == 6){
							_data = new HashMap<String,String>() ;
							_data.put("buyer", _buyer);
							_data.put("st_coway_cart_id", str[0]);
							_data.put("st_contract_no", str[1]);
							_data.put("st_contract_seq", str[2]);
							_data.put("st_seq", str[3]);
							_data.put("st_mg_note", str[5]);
							//R:접수, D:삭제
							if(str[4].equals("R")){
								//접수
								sqlSessionTemplate.delete("buyer.mpso.rcptBuyerMpSoSellerRegProgressList", _data);
							}else{
								//삭제
								sqlSessionTemplate.delete("buyer.mpso.delBuyerMpSoSellerRegProgressList", _data);
								//공통코드삭제처리
								sqlSessionTemplate.delete("buyer.mpso.delBuyerMpSoSellerRegCod2", _data);
							}
						}				         
					}					  
				}				  
			} 
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return null;
	}
	
	public String saveBuyerPrCancel(Map<String,String>  formData){
		try{
			sqlSessionTemplate.update("buyer.mpso.setBuyerPrDtCancel", formData);
	        sqlSessionTemplate.update("buyer.mpso.setBuyerPrHdCancel", formData);
	        
	        formData.put("BUYER", formData.get("st_buyer"));
	        sqlSessionTemplate.update("common.mpso.setSysopOrderChangeBeforeDelete5BudgetUpdate2", formData);
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("요청취소 실패하였습니다.");
		}
		return null;
	}
}
