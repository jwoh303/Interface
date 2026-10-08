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

@Repository("buyerMdCmGoodsLisDao")
@Transactional
public class BuyerMdCmGoodsLisDaoImpl implements BuyerMdCmGoodsLisDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMdCmGoodsLisDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmGoodsLisList", formData);
	}	
	public List<Map<String,String>> getListCATEGORY_TEXT(Map<String,String>  formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmGoodsLisList_CATEGORY_TEXT", formData);
	};
	public List<Map<String,String>> getListMAKER_NAME(Map<String,String>  formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmGoodsLisList_MAKER_NAME", formData);
	}
	
	// 상세 조회
	public List<Map<String,String>> getCatalogDisplayMain(Map<String,String>  formData){
		return sqlSessionTemplate.selectList("buyer.mdcm.selectbuyerMdCmGoodsLisDetail_CatalogDisplayMain", formData);
	}
	public List<Map<String,String>> getCatalogDisplayMain_v2(Map<String,String>  formData){
		return sqlSessionTemplate.selectList("buyer.mdcm.selectbuyerMdCmGoodsLisDetail_CatalogDisplayMain_v2", formData);
	}
	// 상세 조회
	public List<Map<String,String>> getCatalogDisplayPCOMain(Map<String,String>  formData){
		return sqlSessionTemplate.selectList("buyer.mdcm.selectbuyerMdCmGoodsLisDetail_PCOItemSeries", formData);
	}
	public List<Map<String,String>> getItemSeries(Map<String,String>  formData){
		return sqlSessionTemplate.selectList("buyer.mdcm.selectbuyerMdCmGoodsLisDetail_ItemSeries", formData);
	}
	public List<Map<String,String>> getItemSeries_v2(Map<String,Object>  formData){
		List<String> list = CommonUtil.getStringArrary((String)formData.get("buyer_tem_no"), ",");
		if(list.size() != 0){
			formData.put("buyer_tem_no", list);
		}
		return sqlSessionTemplate.selectList("buyer.mdcm.selectbuyerMdCmGoodsLisDetail_ItemSeries_v2", formData);
	}
	
	public List<Map<String,String>> getItemAttrCheck(Map<String,String>  formData){
		return sqlSessionTemplate.selectList("buyer.mdcm.selectbuyerMdCmGoodsLisDetail_ItemAttrCheck", formData);
	}
	
	
	/**
	 * 저장
	 *  desc ICOMCART
 		 USE_FLAG	NOT NULL	CHAR(1)	용도구분(A:도안관리,C:장바구니,D:,R:나의상품)
	 * 
	 */
	@SuppressWarnings("unchecked")
	public String saveBuyerMdCmGoodsLisList(Map<String,String> formData) {

		StringBuffer _rtnMsg = new StringBuffer();
		String createOk = "CREATE_OK";
		String _msg = "";

		String _query = formData.get("st_query2").toString();
		String _use_flag = formData.get("st_use_flag").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString();
		String _pf_my_group = "";
		String _dup_add_posb_flag = CommonUtil.nvl(formData.get("st_dup_add_flag"), "N").toString();
		String _ref_pr_no = "";
		
		if(formData.get("st_pf_my_group") != null){
			_pf_my_group = formData.get("st_pf_my_group").toString();
		}
		
		if(formData.get("st_ref_pr_no") != null){
			_ref_pr_no = formData.get("st_ref_pr_no").toString();
		}
		
		if ("C".equals(_use_flag)){
			_msg = "장바구니";
		}else if ("R".equals(_use_flag)){
			_msg = "나의상품";
		}else if ("A".equals(_use_flag)){
			_msg = "도안관리";
		}
		
		try{
			
			int duplicateCnt = 0;  
			 String  _ICOMCART[] = _query.split("&&"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@");    
				        
				       
				        if (str != null && str.length == 6){
				        	
				        	 Map<String,String> _data = new HashMap<String,String>() ;
					        _data.put("BUYER", _buyer);
					        _data.put("USER_ID", _user_id);
					        _data.put("USE_FLAG", _use_flag);
					        _data.put("MY_GROUP", _pf_my_group);
					        _data.put("REF_PR_NO", _ref_pr_no);
					        
					        _data.put("BUYER_ITEM_NO", str[0]);
					        _data.put("CART_QTY", str[1]);  
					        _data.put("AGENT", str[2]);
					        _data.put("CONTRACT_NO", str[3]);
					        _data.put("CONTRACT_SEQ", str[4]);
					        _data.put("BYIT_COMORG_CODE", str[5]); 
					         
					        String check_flag = sqlSessionTemplate.selectOne("buyer.mdcm.getItemNoCheck", _data); // 중복체크
					        String check_flag2 = sqlSessionTemplate.selectOne("buyer.mdcm.getItemNoCheck2", _data);  // PK 체크
					        //TODO
					        LOGGER.debug(i + " check_flag  " + check_flag);
					        LOGGER.debug(i + " check_flag2  " + check_flag2);
					        //코웨이CLCS 장바구니 중복상품등록허용
							boolean cartDupItemAllow = false;
							
							// 기존 조건
							if("KRCOWA0002".equals(_buyer) || "KRCOWA0007".equals(_buyer) || "KRCOWA0003".equals(_buyer) || "KRCOWA0008".equals(_buyer)){
								cartDupItemAllow = true;
							}
							// 특수로직도 확인
							if("Y".equals(_dup_add_posb_flag)){
								cartDupItemAllow = true;
							}
							
							if(!cartDupItemAllow){
								if("0".equals(check_flag) && "0".equals(check_flag2)){
									sqlSessionTemplate.update("buyer.mdcm.insertBuyerMdCmGoodsLisCreate", _data); 
								} else {
									duplicateCnt ++;
									if(i+1 == _ICOMCART.length){
										_rtnMsg.append("'").append(str[0]).append("' ");
									}else{
										_rtnMsg.append("'").append(str[0]).append("', ");
									}
								}
							} else {
								sqlSessionTemplate.update("buyer.mdcm.insertBuyerMdCmGoodsLisCreate", _data);
							}
						}
					}
				}
			}
			 
			 if (duplicateCnt == 0){
				 _rtnMsg.delete(0, _rtnMsg.length());
				 _rtnMsg.append(createOk);
			 }
			 
			 LOGGER.debug("_rtnMsg.toString() " +_rtnMsg.toString());
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException(_msg + "담기 실패하였습니다.");
		}
	return _rtnMsg.toString();
		
	}
	@SuppressWarnings("unchecked")
	public String saveBuyerMdCmGoodsLisList_v2(Map<String,String> formData) {

		StringBuffer _rtnMsg = new StringBuffer();
		String createOk = "CREATE_OK";
		String _msg = "";

		String _query = formData.get("st_query2").toString();
		String _use_flag = formData.get("st_use_flag").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString();
		String _pf_my_group = "";
		String _dup_add_posb_flag = CommonUtil.nvl(formData.get("st_dup_add_flag"), "N").toString();
		String _ref_pr_no = "";
		
		if(formData.get("st_pf_my_group") != null){
			_pf_my_group = formData.get("st_pf_my_group").toString();
		}
		
		if(formData.get("st_ref_pr_no") != null){
			_ref_pr_no = formData.get("st_ref_pr_no").toString();
		}
		
		if ("C".equals(_use_flag)){
			_msg = "장바구니";
		}else if ("R".equals(_use_flag)){
			_msg = "나의상품";
		}else if ("A".equals(_use_flag)){
			_msg = "도안관리";
		}
		
		try{
			
			int duplicateCnt = 0;  
			 String  _ICOMCART[] = _query.split("&&"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@");    
				       
				        if (str != null && str.length == 6){
				        	
				        	 Map<String,String> _data = new HashMap<String,String>() ;
					        _data.put("BUYER", _buyer);
					        _data.put("USER_ID", _user_id);
					        _data.put("USE_FLAG", _use_flag);
					        _data.put("MY_GROUP", _pf_my_group);
					        _data.put("REF_PR_NO", _ref_pr_no);
					        
					        _data.put("BUYER_ITEM_NO", str[0]);
					        _data.put("CART_QTY", str[1]);  
					        _data.put("AGENT", str[2]);
					        _data.put("CONTRACT_NO", str[3]);
					        _data.put("CONTRACT_SEQ", str[4]);
					        _data.put("BYIT_COMORG_CODE", str[5]); 
					         
					        String check_flag = "";
					        String check_flag2 = "";
					        if(_use_flag.equals("R")){ //관심상품은 폴더까지 체크
					        	if(_pf_my_group.equals("") || _pf_my_group.equals("MCDEFAULT")){ //폴더 선택 안 한 경우 + 기본폴더 선택한 경우
					        		_data.put("st_type", "ITEM");
						        	_data.put("st_code2", "MCDEFAULT");
						        	_data.put("st_text1", "기본");
						        	
						        	//기본폴더 있는지 체크
						        	String default_yn = sqlSessionTemplate.selectOne("buyer.mdcm.selectBuyerMdCmGoodsDefaultCateg_v2", _data);
						        	if(default_yn.equals("N")){
						        		//기본폴더 생성
						        		sqlSessionTemplate.update("buyer.mdcm.insertBuyerMdCmGoodsDefaultCateg_v2", _data);
						        	}
						        	_data.put("MY_GROUP", "MCDEFAULT");
					        	}
					        	
					        	check_flag = sqlSessionTemplate.selectOne("buyer.mdcm.getItemNoCheck_v2", _data); // 중복체크
					        	check_flag2 = sqlSessionTemplate.selectOne("buyer.mdcm.getItemNoCheck2_v2", _data);  // PK 체크
					        }else{
					        	check_flag = sqlSessionTemplate.selectOne("buyer.mdcm.getItemNoCheck", _data); // 중복체크
					        	check_flag2 = sqlSessionTemplate.selectOne("buyer.mdcm.getItemNoCheck2", _data);  // PK 체크
					        	
					        }
					        //TODO
					        LOGGER.debug(i + " check_flag  " + check_flag);
					        LOGGER.debug(i + " check_flag2  " + check_flag2);
					        //코웨이CLCS 장바구니 중복상품등록허용
							boolean cartDupItemAllow = false;
							
							// 기존 조건
							if("KRCOWA0002".equals(_buyer) || "KRCOWA0007".equals(_buyer) || "KRCOWA0003".equals(_buyer) || "KRCOWA0008".equals(_buyer)){
								cartDupItemAllow = true;
							}
							// 특수로직도 확인
							if("Y".equals(_dup_add_posb_flag)){
								cartDupItemAllow = true;
							}
							
							if(!cartDupItemAllow){
								if("0".equals(check_flag) && "0".equals(check_flag2)){
									sqlSessionTemplate.update("buyer.mdcm.insertBuyerMdCmGoodsLisCreate", _data); 
								} else {
									_rtnMsg.delete(0, _rtnMsg.length());
									duplicateCnt ++;
									if(_use_flag.equals("C")){ //장바구니는 중복담기 특수로직 아니면 수량을 합쳐줌
										sqlSessionTemplate.update("buyer.mdcm.updateBuyerMdCmGoodsLisCreate", _data);
									}
									_rtnMsg.append("이미 장바구니에 담긴 품목입니다.\n선택하신 수량이 추가되었습니다.");
								}
							} else {
								sqlSessionTemplate.update("buyer.mdcm.insertBuyerMdCmGoodsLisCreate", _data);
							}
						}
					}
				}
			}
			 
			 if (duplicateCnt == 0){
				 _rtnMsg.delete(0, _rtnMsg.length());
				 _rtnMsg.append(createOk);
			 }
			 
			 LOGGER.debug("_rtnMsg.toString() " +_rtnMsg.toString());
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException(_msg + "담기 실패하였습니다.");
		}
	return _rtnMsg.toString();
		
	}
}
