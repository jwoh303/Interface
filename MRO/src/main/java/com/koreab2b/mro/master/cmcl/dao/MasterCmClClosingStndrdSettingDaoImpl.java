package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterCmClClosingStndrdSettingDao")
@Transactional
public class MasterCmClClosingStndrdSettingDaoImpl implements MasterCmClClosingStndrdSettingDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClClosingStndrdSettingDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;
	    
		sqlSessionTemplate.select("master.cmcl.selectMasterCmClClosingStndrdSettingList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		
		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 저장 되었습니다.";
		int upCount = 0;
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				
				formData.putAll((Map<String, String>)gridData.get(i));
				
				String AC_USER_NAME		= CommonUtil.nvl(formData.get("AC_USER_NAME"), "");
				String AC_USER_PHONE	= CommonUtil.nvl(formData.get("AC_USER_PHONE"), "");
				String AC_USER_FAX		= CommonUtil.nvl(formData.get("AC_USER_FAX"), "");
				String AC_USER_EMAIL		= CommonUtil.nvl(formData.get("AC_USER_EMAIL"), "");
				String AC_USER_ZIP			= CommonUtil.nvl(formData.get("AC_USER_ZIP"), "");
				String AC_CODE 			= CommonUtil.nvl(formData.get("AC_CODE"), "");
				
				if ( AC_CODE.trim().equals("") ) {
					// 회원사경리담당정보(BILL_ACCOUNTING) 등록
					upCount = sqlSessionTemplate.insert("master.cmcl.insertMasterCmClClosingStndrdSetting", formData);
					
					if ( upCount != 1 ) {
						throw new RuntimeException("\n\n[ BILL_ACCOUNTING 등록 실패 ]");
					}
				} 
				else if ( !AC_CODE.equals("") || !AC_USER_NAME.equals("") || !AC_USER_PHONE.equals("") || !AC_USER_FAX.equals("") || !AC_USER_EMAIL.equals("") || !AC_USER_ZIP.equals("") || !AC_USER_ZIP.equals("") ) {
					// 회원사경리담당정보(BILL_ACCOUNTING) 수정
					upCount = sqlSessionTemplate.update("master.cmcl.updateMasterCmClClosingStndrdSetting01", formData);
					
					if ( upCount != 1 ) {
						throw new RuntimeException("\n\n[ BILL_ACCOUNTING 수정 실패 ]");
					}
				}
				
				upCount = 0;
				
				// 회원사정보(ICOMCMPY) 수정
				upCount = sqlSessionTemplate.update("master.cmcl.updateMasterCmClClosingStndrdSetting02", formData);
				
				if ( upCount != 1 ) {
					throw new RuntimeException("\n\n[ ICOMCMPY 수정 실패 ]");
				}
			}
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 저장 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	
	// 삭제
//	@SuppressWarnings("unchecked")
//	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
//	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
//		
//		_rtnMsg = "삭제완료";
//		
//		try{
//			for(int i=0; i < gridData.size(); i++){
//				formData.putAll((Map<String, String>)gridData.get(i));		
//				
//				sqlSessionTemplate.update("master.cmcl.deleteMasterCmClClosingStndrdSetting", formData);
//				LOGGER.error("deleteMasterCmClClosingStndrdSetting 실행 완료");
//
//			}
//		}catch(Exception e){
//			LOGGER.error("SQL ERROR : ", e);
//			throw new RuntimeException("견적 요청에 실패하였습니다.");
//		}
//
//		return _rtnMsg;		
//	}	

}
