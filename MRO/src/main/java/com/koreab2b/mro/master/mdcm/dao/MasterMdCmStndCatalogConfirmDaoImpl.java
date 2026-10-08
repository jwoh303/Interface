package com.koreab2b.mro.master.mdcm.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository("masterMdCmStndCatalogConfirmDao")
@Transactional
public class MasterMdCmStndCatalogConfirmDaoImpl implements MasterMdCmStndCatalogConfirmDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmStndCatalogConfirmDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		resultList =  sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmStndCatalogConfirmList", param);
		
		return resultList;
	}
	/*승인*/
	@SuppressWarnings("unchecked")
	public String saveMasterMpRqConfirmCatlg(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "승인처리가 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//승인처리
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmStndCatalogConfirm", formData);
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	/*반려*/
	@SuppressWarnings("unchecked")
	public String rejectMasterMpRqConfirmCatlg(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "반려처리가 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//반려처리
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmStndCatalogConfirm", formData);
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
}
