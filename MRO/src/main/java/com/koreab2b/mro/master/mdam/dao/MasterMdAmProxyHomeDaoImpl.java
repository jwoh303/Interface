package com.koreab2b.mro.master.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdAmProxyHomeDao")
@Transactional
public class MasterMdAmProxyHomeDaoImpl implements MasterMdAmProxyHomeDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmProxyHomeDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 구매대행 홈 담당자별 실적현황 리스트조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		String authGbn = (String)param.get("auth_gbn");
		
		String userId = CommonUtil.nvl((String)param.get("user_id"));
		String queryId = "";
		
		if(authGbn.equals("DL") || authGbn.equals("BL")){
			queryId = "master.mdam.selectMasterMdAmProxyMainWorkProcessDLList";
			
		} else {
			queryId = "master.mdam.selectMasterMdAmProxyHomeList";
		}
		
		return sqlSessionTemplate.selectList(queryId, param);
	}

	// 나의주요업무 권한 조회
	public String selectMasterMdAmProxyMainWorkProcessAuthGbn(Map<String,Object> param){
		return sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmProxyMainWorkProcessAuthGbn", param);
	}
		
	// 나의 주요업무처리 리스트 조회
	public List<Map<String,String>> selectMasterMdAmProxyMainWorkProcessList(Map<String,Object> param){
		
		//List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		
		String authGbn = CommonUtil.nvl((String)param.get("auth_gbn"));
		String userId = CommonUtil.nvl((String)param.get("user_id"));
		String queryId = "";
		if(authGbn.equals("DL")||authGbn.equals("BL")){
			queryId = "master.mdam.selectMasterMdAmProxyMainWorkProcessDLList";
			
		} else if(authGbn.equals("TL")){
			queryId = "master.mdam.selectMasterMdAmProxyMainWorkProcessTLList";
		}  else if(authGbn.equals("SS")){//소싱지원
			queryId = "master.mdam.selectMasterMdAmProxyMainWorkProcessSSList";
		}  else if(authGbn.equals("SM")){//SM
			queryId = "master.mdam.selectMasterMdAmProxyMainWorkProcessSMList";
		}  else if(authGbn.equals("DSM")){//DSM
			queryId = "master.mdam.selectMasterMdAmProxyMainWorkProcessDSMList";
		} else {
			queryId = "master.mdam.selectMasterMdAmProxyMainWorkProcessList";
		}
		
		return sqlSessionTemplate.selectList(queryId, param);
	}
	
	// 나의 주요업무처리 합계 조회
	public Map<String,String> selectMasterMdAmProxyMainWorkProcessSumList(Map<String,Object> param){
		return sqlSessionTemplate.selectOne("master.mdam.selectMasterMdAmProxyMainWorkProcessSumList", param);
	}
	
	// 긴급납기/선입고 리스트
	public List<Map<String,String>> selectMasterMdAmProxyDocTypeFPoList(Map<String,Object> param){
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmProxyDocTypeFPoList", param);
	}
	
	// 담당자별 처리현황
	public List<Map<String,String>> selectWorkProcessListByUser(Map<String,Object> param){
		return sqlSessionTemplate.selectList("master.mdam.selectWorkProcessListByUser", param);
	}
	
	// 고객사별 의뢰 재집계
	public String execMasterMdAmProxyBuyerRecount(Map<String,Object> param) {
		
		String _rtnMsg = "집계가 정상적으로 완료되었습니다.";
		/*프로시저 실행*/
		try{
			sqlSessionTemplate.update("master.mdam.SP_PROC_KEP_PM_PA_DB", param);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("재집계에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	
}
