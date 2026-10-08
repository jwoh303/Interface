package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterCmClDeptClosingDao")
@Transactional
public class MasterCmClDeptClosingDaoImpl implements MasterCmClDeptClosingDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClDeptClosingDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;
//	    String _checkYn = "";
	    int upCount = 0;
	    
//		sqlSessionTemplate.select("master.cmcl.selectMasterCmClDeptClosingList", param, _resultHander);
//		resultList = (List<Map<String, String>>)_resultHander.getList();
	    
		// 생성 트랜잭션 체크
//		_checkYn = (String) sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClDeptClosingList_Check", param);
		
		sqlSessionTemplate.select("master.cmcl.selectMasterCmClDeptClosingList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		
		if ( resultList.size() == 0 ) {
			try {
				// 부서별마감설정 생성
				upCount = sqlSessionTemplate.insert("master.cmcl.insertMasterCmClDeptClosingList", param);
				
				if ( upCount == 0 ) {
					throw new RuntimeException("\n\n[ 부서별마감설정 기초 데이타 일괄생성 실패 ]");
				}
				
				sqlSessionTemplate.select("master.cmcl.selectMasterCmClDeptClosingList", param, _resultHander);
				resultList = (List<Map<String, String>>)_resultHander.getList();
				
			} catch (Exception e) {
				LOGGER.error("SQL ERROR : ", e);
				
				if ( e instanceof RuntimeException ) {
					throw new RuntimeException("\n\n[ 조회 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
				}
				
				throw new RuntimeException("\n\n[ 일괄생성 오류 발생 ]\n\n관리자에게 문의하시기 바랍니다.");
			}
		}
		
		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
//		String _jobKind = formData.get("job_kind");
//		String _checkYn = "";
		int upCount = 0;
		
		try {
			// 저장 처리
//			if ( "save".equals(_jobKind) ) {
				_rtnMsg = "정상적으로 저장 되었습니다.";
				
				for ( int i = 0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					
					// 부서별마감설정 저장
					upCount = sqlSessionTemplate.update("master.cmcl.updateMasterCmClDeptClosingList", formData);
					
					if ( upCount != 1 ) {
						throw new RuntimeException("\n\n[ 부서별마감설정 저장 실패 ]");
					}
					
				}
//			}
			// 생성 처리
//			else if ( "create".equals(_jobKind) ) {
//				_rtnMsg = "정상적으로 일괄생성 되었습니다.";
//				
//				// 생성 트랜잭션 체크
//				_checkYn = (String) sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClDeptClosingList_Check", formData);
//				
//				if ( "N".equals(_checkYn) ) {
//					throw new RuntimeException("\n\n[ 이미 마감설정 데이타가 존재합니다. ]\n\n다시 확인하여 주십시요.");
//				}
//				
//				// 부서별마감설정 생성
//				upCount = sqlSessionTemplate.insert("master.cmcl.insertMasterCmClDeptClosingList", formData);
//				
//				if ( upCount != 1 ) {
//					throw new RuntimeException("\n\n[ 부서별마감설정 일괄생성 실패 ]");
//				}
//			}
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException("\n\n[ 저장 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
			
			throw new RuntimeException("\n\n[ 저장 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}

}
