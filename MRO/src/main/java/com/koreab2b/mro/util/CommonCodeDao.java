package com.koreab2b.mro.util;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;

import com.googlecode.ehcache.annotations.Cacheable;
import com.googlecode.ehcache.annotations.TriggersRemove;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("CommonCodeDao")
@Transactional
public class CommonCodeDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Cacheable(cacheName = "commonCache")
	public List<Map<String,String>> codeList(String code) {
		return sqlSessionTemplate.selectList("common.codeList", code);
	}
	
	public List<Map<String,String>> codeQueryIdList(String queryId) {
		return sqlSessionTemplate.selectList(queryId, null);
	}
	 
	public List<Map<String,String>> codeQueryIdList(String queryId,Map<String, String> search) {
		
		//System.out.println("queryIdqueryIdqueryIdqueryId " +queryId);
		return sqlSessionTemplate.selectList(queryId, search);
	}
	 
	public List<Map<String,String>> getCombo(Map<String, String> pMap) {
		String queryId = pMap.get("COMMONTABLEGUBUN");
		return sqlSessionTemplate.selectList("common.getCombo"+queryId, pMap);
	} 
	public List<Map<String,String>> getBCombo(Map<String, String> pMap) {
		String queryId = pMap.get("COMMONTABLEGUBUN");
		return sqlSessionTemplate.selectList("common.getBCombo"+queryId, pMap);
	} 
	
	public int insertSmsSend(Map<String, String> pMap) {
		return sqlSessionTemplate.update("common.insertSmsSend", pMap); 
	}
	
	public int insertMailSend(Map<String, String> pMap) {
		return sqlSessionTemplate.update("common.insertMailSend", pMap); 
	}	
	 
	public List<Map<String,String>> getSpecialCheckReturn(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectSpecialCheckReturn", pMap);
	} 
	 
	public List<Map<String,String>> getCodeCheckReturn(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectCodeCheckReturn", pMap);
	} 
	public List<Map<String,String>> getCode2CheckReturn(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectCode2CheckReturn", pMap);
	} 

	public List<Map<String,String>> getCode3CheckReturn(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectCode3CheckReturn", pMap);
	}

	public List<Map<String,String>> getCode3CheckReturnCodeAllParam(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.getCode3CheckReturnCodeAllParam", pMap);
	}

	public List<Map<String,String>> getSpecialCheckReturnSheetMap(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectSpecialCheckReturnSheetMap", pMap);
	} 
	
	public String getSpecialCheckReturnSheetMapByDept(Map<String, String> pMap) { 
		
		String _deptCd = "";
		List<Map<String,String>> _rtnResult= sqlSessionTemplate.selectList("common.selectSpecialCheckReturnSheetMapByDept", pMap);
		if(_rtnResult.size() >0 ){
			_deptCd = _rtnResult.get(0).get("PURCHASER_ID");
		}
		return _deptCd;
	} 
	
//	@Cacheable(cacheName = "commonCache")
	@TriggersRemove(cacheName = "commonCache", removeAll=true)
	public List<Map<String,String>> getActionId(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.getActionId", pMap);
	}
	
	@TriggersRemove(cacheName = "commonCache", removeAll=true)
	public List<Map<String,String>> getCartCnt(Map<String, String> pMap) { 
		boolean p060000052 = CommonUtil.getSpecialCheckReturn(pMap.get("BUYER"),"P06-0000052");
		
		// 고객사 견적 예외사항 체크
		String buyer_exception_type	= "";
		boolean buyer_exception_yn = CommonUtil.getSpecialCheckReturn(pMap.get("BUYER"), "P04-4027-10"); // 권한특수로직
		if (buyer_exception_yn) {
			buyer_exception_type = CommonUtil.getSpecialCheckReturn(pMap.get("BUYER"), "P04-4027-10", "COL01_DATA");
		}
		
		pMap.put("RQDT_TYPE", buyer_exception_type);
		
		// 일반적인 단가합의 기능을 사용하지 않는 사용자(ex 깨끗한나라 화학물질 담당자)
		String msds_search_flag = "N";
		boolean msds_user_flag = CommonUtil.getCode2CheckReturn("MSDSBUSR", pMap.get("USER_ID"), pMap.get("BUYER"));
		if(msds_user_flag == true){
			msds_search_flag = "Y";
		}
		
		pMap.put("MSDS_USER", msds_search_flag);
		
		if(p060000052 == true){
			return sqlSessionTemplate.selectList("buyerMain.getBuyerStatusCountPCOMainSql", pMap);
		}else{
			return sqlSessionTemplate.selectList("buyerMain.getBuyerStatusCountMainSql", pMap);
		}
		
	}
	@TriggersRemove(cacheName = "commonCache", removeAll=true)
	public List<Map<String,String>> getCartCnt_v2(Map<String, String> pMap) { 
		boolean p060000052 = CommonUtil.getSpecialCheckReturn(pMap.get("BUYER"),"P06-0000052");
		
		// 고객사 견적 예외사항 체크
		String buyer_exception_type	= "";
		boolean buyer_exception_yn = CommonUtil.getSpecialCheckReturn(pMap.get("BUYER"), "P04-4027-10"); // 권한특수로직
		if (buyer_exception_yn) {
			buyer_exception_type = CommonUtil.getSpecialCheckReturn(pMap.get("BUYER"), "P04-4027-10", "COL01_DATA");
		}
		
		pMap.put("RQDT_TYPE", buyer_exception_type);
		
		// 일반적인 단가합의 기능을 사용하지 않는 사용자(ex 깨끗한나라 화학물질 담당자)
		String msds_search_flag = "N";
		boolean msds_user_flag = CommonUtil.getCode2CheckReturn("MSDSBUSR", pMap.get("USER_ID"), pMap.get("BUYER"));
		if(msds_user_flag == true){
			msds_search_flag = "Y";
		}
		
		pMap.put("MSDS_USER", msds_search_flag);
		
		if(p060000052 == true){
			return sqlSessionTemplate.selectList("buyerMain.getBuyerStatusCountPCOMainSql", pMap);
		}else{
			return sqlSessionTemplate.selectList("buyerMain.getBuyerStatusCountMainSql_v2", pMap);
		}
		
	}
	
	public List<Map<String,String>> getKepBuyerFlagColumnReturn(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.getKepBuyerFlagColumnReturn", pMap);
	}
	public List<Map<String,String>> getCode3RoleReturn(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectCode3RoleReturn", pMap);
	}
	public List<Map<String,String>> getSpecialCategUserBoolean(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectSpecialCategUserBoolean", pMap);
	} 
	public List<Map<String,String>> getSpecialCategUserList(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectSpecialCategUserList", pMap);
	} 
	public List<Map<String,String>> getSpecialCategComcodeList(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectSpecialCategComcodeList", pMap);
	} 
	public List<Map<String,String>> getInfoAgreeReturn(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectInfoAgreeReturn", pMap);
	}
	public List<Map<String,String>> getIcomcod3Boolean(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectIcomcod3Boolean", pMap);
	} 
	public List<Map<String,String>> getIcomCode2ReturnMap(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectIcomCode2ReturnMapReturn", pMap);
	} 
	//결재타입여부
	public List<Map<String,String>> getDocuTypeCheckReturn(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectDocuTypeCheckReturn", pMap);
	} 
	public List<Map<String,String>> getInfoUpdateReturn(Map<String, String> pMap) {
		
		return sqlSessionTemplate.selectList("common.selectInfoUpdateReturn", pMap);
	}
	//공통코드 ICOMCOD1 TEXT
	public List<Map<String,String>> getCodeTextReturn(Map<String, String> pMap) { 
		
		return sqlSessionTemplate.selectList("common.selectCodeTextReturn", pMap);
	}
	
	public String getMyItemYn_v2(Map<String, String> pMap) { 
		return sqlSessionTemplate.selectOne("common.selectMyItemYn_v2", pMap);
	}
	
	public List<Map<String,String>> getMenuTabInfo_v2(Map<String, String> pMap) { 
		return sqlSessionTemplate.selectList("common.selectMenuTabInfo_v2", pMap);
	}
} 


    
