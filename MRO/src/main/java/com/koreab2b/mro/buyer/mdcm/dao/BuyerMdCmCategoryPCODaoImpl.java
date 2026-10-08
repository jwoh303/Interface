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

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;

@Repository("buyerMdCmCategoryPCODao")
@Transactional
public class BuyerMdCmCategoryPCODaoImpl implements BuyerMdCmCategoryPCODao { 
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMdCmGoodsLisDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmCategoryPCO", formData);
	} 
	// 조회
	public List<Map<String,String>> getCategoryPathPCO(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmCategoryPathPCO", formData);
	}
	// 조회
	public List<Map<String,String>> getRqUserInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdcm.selectBuyerMdCmRqUserInfo", formData);
	} 
	/**
	 * 저장
	 *  desc 견적임시저장
	 * 
	 */
	@SuppressWarnings("unchecked")
	public String saveBuyerMdCmRqdtTemp(Map<String,String> formData) {

		StringBuffer _rtnMsg = new StringBuffer();
		String createOk = "CREATE_OK";
		String _msg = "";

		String _query = formData.get("st_query2").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString();
		String _buyerComorg = formData.get("buyerComorg").toString();
		String _qNo = "";
		Integer _qSeq = 1;
		
		try{
			
			 String  _KEPRQDT[] = _query.split("&&"); 
			 if (_KEPRQDT == null){
				 LOGGER.debug("_KEPRQDT 미존재 ");
			 }else{
				  
				 if (_KEPRQDT.length >0){
					 for( int i=0 ; i < _KEPRQDT.length; i++){ 
				        String str[] =  _KEPRQDT[i].split("@@");   

				        if (i == 0){
				        	_qNo = masterMpRqBuyerReqDao.nextVal(_buyer, "TM");
				        }
				        if (str != null ){
				        	
				        	 Map<String,String> _data = new HashMap<String,String>() ;
				        	 _data.put("QUOTATION_NO", _qNo);
				        	 _data.put("QUOTATION_SEQ", _qSeq.toString());
					        _data.put("BUYER", _buyerComorg);
					        _data.put("BUYER_ITEM_NO", str[0]);
					        _data.put("USER_ID", str[2]);
					        _data.put("USER_NAME",str[3]);
					        _data.put("USER_DEPT", str[4]);
					        _data.put("USER_MAIL", str[6]);
					        _data.put("USER_TEL", str[7]);
					         
							sqlSessionTemplate.insert("buyer.mdcm.insertQuotationReqTemp", _data);
							_qSeq++;
			              } 
					 }				         
				 }					  
			 }				  
			 _rtnMsg.delete(0, _rtnMsg.length());
			 _rtnMsg.append(createOk);
		}catch(Exception e){
			throw new RuntimeException(_msg + "실패하였습니다.");
		}
	return _rtnMsg.toString();
		
	}
}

