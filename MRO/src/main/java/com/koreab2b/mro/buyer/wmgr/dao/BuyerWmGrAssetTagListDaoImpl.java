package com.koreab2b.mro.buyer.wmgr.dao;

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

import com.koreab2b.mro.master.mdam.dao.MasterMdAmMasterCodeManageDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("buyerWmGrAssetTagListDao")
@Transactional
public class BuyerWmGrAssetTagListDaoImpl implements BuyerWmGrAssetTagListDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdAmMasterCodeManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";


	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		// 부서코드 조회
		resultList = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrAssetTagList", param);
		
		return resultList;
	}
	/*저장*/
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "저장했습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrAssetTagList", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
}