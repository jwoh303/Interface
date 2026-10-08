package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoPrewarhsngOrderManageDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpSoOrderStandbyOrderReqDetailPopDao")
@Transactional
public class MasterMpSoOrderStandbyOrderReqDetailPopDaoImpl implements MasterMpSoOrderStandbyOrderReqDetailPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoPrewarhsngOrderManageDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	private String _rtnMsg = "";
	
	// 조회(헤더)
	public List<Map<String,String>> selectHeader(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectMasterMpSoOrderStandbyOrderReqHeaderPopList", formData);
	}	
	// 조회(상세)
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectMasterMpSoOrderStandbyOrderReqDetailPopList", formData);
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		LOGGER.debug("요청 파라미터 : {}", gridData);
		
		Map<String, String> lastLoginList = null;
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i< gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("common.mpso.updateMasterMpSoOrderStandbyOrderReqDetailPop_1", formData);
				sqlSessionTemplate.update("common.mpso.updateMasterMpSoOrderStandbyOrderReqDetailPop_2", formData);
				
				// BUYER 셋팅
				formData.put("BUYER", CommonUtil.nvl(formData.get("st_buyer"), ""));
				
				lastLoginList = sqlSessionTemplate.selectOne("master.mpso.selectLastLoginIdWithPrInfo", formData);
	            
	        	// 주문요청자, 발주자 마지막 로그인정보 UPDATE
				formData.put("LAST_LOGIN_ID", CommonUtil.nvl(lastLoginList.get("REQ_USER_ID"), ""));
				formData.put("LAST_LOGIN_ID1",CommonUtil.nvl(lastLoginList.get("PURCHASER_ID"), ""));
				
				// 주문요청자 마지막 로그인 정보 UPDATE
		        sqlSessionTemplate.insert("login.saveLogintime", formData);
		        // 발주자 마지막 로그인 정보 UPDATE
		        sqlSessionTemplate.insert("login.saveLogintime1", formData);
			}
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}	
}
