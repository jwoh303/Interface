package com.koreab2b.mro.common.coco.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;



@Repository("CommonWmReApprovalDao")
@Transactional
public class CommonWmReApprovalDaoImpl implements CommonWmReApprovalDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonWmReApprovalDao.class);
		@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	//반품 상신취소
	public String wmreCancle(Map<String,String> formData){
		
        sqlSessionTemplate.update("commonWmReApproval.updateWmreKEPMGPHD", formData);
        sqlSessionTemplate.update("commonWmReApproval.updateWmreKEPMGPDT", formData);

		return "OK";
	}
	//반품조회
	public List<Map<String,String>>   approvalWmReListPop(Map<String,String>  _pMap) {
		return sqlSessionTemplate.selectList("commonWmReApproval.selectapprovalWmReListPop",_pMap); 
	}
	//반품 결재
	public String wmreApprovalA(Map<String,String> formData){
        sqlSessionTemplate.update("commonWmReApproval.updateWmreKEPMGPHD", formData);
        sqlSessionTemplate.update("commonWmReApproval.updateWmreKEPMGPDT", formData);
        //결재후처리
        sqlSessionTemplate.update("commonWmReApproval.call_PKG_KEP_RETURN_PO_APPROVAL_FETCH", formData);

		return "OK";
	}
	//반품 반려
	public String wmreApprovalB(Map<String,String> formData){
        sqlSessionTemplate.update("commonWmReApproval.updateWmreKEPMGPHD", formData);
        sqlSessionTemplate.update("commonWmReApproval.updateWmreKEPMGPDT", formData);
		return "OK";
	}

	// 삭제
	public String runlWmReListPop(Map<String,String>  formData){
 
		String _st_update = formData.get("st_update").toString(); 
		 Map<String,String> _data = null;
		
		try{
			 
			 String  _WMRE[] = _st_update.split("&&",-1); 
			 if (_WMRE == null){
			 }else{
				 if (_WMRE.length >0){
					 for( int i=0 ; i < _WMRE.length; i++){ 
				        String str[] =  _WMRE[i].split("@@",-1);  
					
				        if (str != null){
				        	_data = new HashMap<String,String>() ;
					        _data.put("DOCU_NO", str[0]);
					        sqlSessionTemplate.update("commonWmReApproval.call_PKG_KEP_RETURN_PO_APPROVAL_FETCH", _data);
					        
						 }				         
					 }					  
				 }				  
			 } 
			  
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("재실행에 실패하였습니다.");
		}
		return null;
	} 
}
