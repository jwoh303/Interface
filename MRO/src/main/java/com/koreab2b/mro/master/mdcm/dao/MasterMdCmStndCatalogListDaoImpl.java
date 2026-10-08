package com.koreab2b.mro.master.mdcm.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmStndCatalogListDao")
@Transactional
public class MasterMdCmStndCatalogListDaoImpl implements MasterMdCmStndCatalogListDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmStndCatalogListDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 승인
	public String saveMasterMpRqConfirmStndCatlg(Map<String,String>  formData){
		String _st_update = formData.get("st_query").toString();
		Map<String,String> _data = null;
		try{
			 String  _CONFIRM[] = _st_update.split("\\|"); 
			 if (_CONFIRM == null){
				 LOGGER.debug("_CONFIRM 미존재 ");
			 }else{
				 LOGGER.debug(" _CONFIRM.length  " + _CONFIRM.length );
				 if (_CONFIRM.length >0){
					 for( int i=0 ; i < _CONFIRM.length; i++){ 
				        String str[] =  _CONFIRM[i].split("@@",-1);  
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    } 
				        if (str != null){
				        	_data = new HashMap<String,String>() ;
					        _data.put("st_cms_catlg_id", str[0]);
					        sqlSessionTemplate.delete("master.mdcm.updateMasterMpRqConfirmStndCatlg", _data);  
					        
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

	
}
