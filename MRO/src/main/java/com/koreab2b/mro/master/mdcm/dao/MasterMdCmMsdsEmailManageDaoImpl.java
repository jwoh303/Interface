package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCmMsdsEmailManageDao")
@Transactional
public class MasterMdCmMsdsEmailManageDaoImpl implements MasterMdCmMsdsEmailManageDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmMsdsEmailManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		resultList = sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmMsdsEmailManageList", param);
		
		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		String _checkVal = "";
		String _seqVal = "";
		int _count = 0;
		
		_rtnMsg = "추가 및 수정이 정상적으로 완료되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				LOGGER.debug("===>> Start <<===");
				formData.putAll((Map<String, String>)gridData.get(i));

				if ( "U".equals(formData.get("sStatus")) ) {
					LOGGER.debug("===>> U <<===");
					_checkVal = (String)sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmMsdsEmailManageCheck", formData);
					
					if ( !"".equals(CommonUtil.nvl(_checkVal)) ) {
						throw new RuntimeException("\n\n[ 같은 내용의 수신자가 이미 등록되어 있습니다. ]\n\n다시 확인하여 주십시요.");
					}
					
					_count = sqlSessionTemplate.update("master.mdcm.updateMasterMdCmMsdsEmailManage", formData);
					
					if ( _count != 1 ) {
						throw new RuntimeException("\n\n[ 수정 실패 ]\n\n다시 확인하여 주십시요.");
					}
				}
				else if ( "I".equals(formData.get("sStatus")) ) {
					LOGGER.debug("===>> I <<===");
					_checkVal = (String)sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmMsdsEmailManageCheck", formData);
					
					if ( !"".equals(CommonUtil.nvl(_checkVal)) ) {
						throw new RuntimeException("\n\n[ 같은 내용의 수신자가 이미 등록되어 있습니다. ]\n\n다시 확인하여 주십시요.");
					}
					
					_seqVal = (String)sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmMsdsEmailManageSeq", formData);
					LOGGER.debug("===>> 채번 : {} <<===", _seqVal);
					formData.put("SEQ", _seqVal);
					
					_count = sqlSessionTemplate.update("master.mdcm.insertMasterMdCmMsdsEmailManage", formData);
					
					if ( _count != 1 ) {
						throw new RuntimeException("\n\n[ 추가 실패 ]\n\n다시 확인하여 주십시요.");
					}
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 추가 및 수정 에러 발생 ]\n\n시스템운영팀으로 연락바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		int _count = 0;

		_rtnMsg = " 삭제가 정상적으로 완료되었습니다";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));	
				
				_count = sqlSessionTemplate.update("master.mdcm.deleteMasterMdCmMsdsEmailManage", formData);
				
				if ( _count != 1 ) {
					throw new RuntimeException("\n\n[ 삭제 실패 ]\n\n다시 확인하여 주십시요.");
				}
			}
		} catch(Exception e ) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 삭제 에러 발생 ]\n\n본사 시스템운영팀으로 연락바랍니다.");
		}

		return _rtnMsg;		
	}
	
}
