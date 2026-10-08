package com.koreab2b.mro.common.mdct.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.SecurHashAlgorithmUtil;

@Repository("masterMdCtBuyerJoinAlterRequestApprovalPopDao")
@Transactional
public class MasterMdCtBuyerJoinAlterRequestApprovalPopDaoImpl implements MasterMdCtBuyerJoinAlterRequestApprovalPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtBuyerJoinAlterRequestApprovalPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdct.selectMasterMdCtBuyerJoinAlterRequestApprovalPopList", formData);
	}
	
	// 리스트 조회
	public List<Map<String,String>> selectChargeEntryList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("common.mdct.selectMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList", param);
	}
	
	// 고객사 정보 수정
	public String updateSelectedData(Map<String,String> formData) {
		String _rtnMsg = "";
		try {
			
			String _kepBuyerFlag = sqlSessionTemplate.selectOne("common.mdct.selectMdCtBuyerJoinAlterRequestApprovalPopKepBuyerFlagCnt", formData);

			sqlSessionTemplate.update("common.mdct.updateMasterMdCtBuyerJoinAlterRequestApprovalPop", formData);
			sqlSessionTemplate.update("common.mdct.updateMasterMdCtBuyerJoinAlterRequestApprovalPop2", formData);
			formData.put("st_corp_regist_flag", CommonUtil.nvl(formData.get("st_corp_regist_flag"), "N"));
			formData.put("st_seal_certi_regist_flag", CommonUtil.nvl(formData.get("st_seal_certi_regist_flag"), "N"));
			formData.put("st_use_seal_regist_flag", CommonUtil.nvl(formData.get("st_use_seal_regist_flag"), "N"));
			formData.put("st_contract_regist_flag", CommonUtil.nvl(formData.get("st_contract_regist_flag"), "N"));
			
			if (Integer.parseInt(_kepBuyerFlag) > 0) {
				sqlSessionTemplate.update("common.mdct.updateMasterMdCtBuyerJoinAlterRequestApprovalKepBuyerFlag", formData);
			} else {
				sqlSessionTemplate.insert("common.mdct.insertMasterMdCtBuyerJoinAlterRequestApprovalKepBuyerFlag", formData);
			}
			
			String _acntbuyr = sqlSessionTemplate.selectOne("common.mdct.selectMasterMdCtBuyerJoinAlterRequestApprovalAcntbuyr", formData);
			
			if (Integer.parseInt(_acntbuyr) > 0) {
				sqlSessionTemplate.update("common.mdct.updateMasterMdCtBuyerJoinAlterRequestApprovalAcntbuyr", formData);
				
			} else {
				sqlSessionTemplate.insert("common.mdct.insertMasterMdCtBuyerJoinAlterRequestApprovalAcntbuyr", formData);
			}
			
			if (formData.get("st_flag").equals("C")) {
				//김승우팀장 요청사항 2016.03.15 제외처리 insertMasterMdCtBuyerJoinAlterRequestApprovalCompanyMenu
				//sqlSessionTemplate.insert("common.mdct.insertMasterMdCtBuyerJoinAlterRequestApprovalCompanyMenu", formData);
				
				formData.put("st_auth_id",  "ROLE_BADM001");
//				String _authChk =  sqlSessionTemplate.selectOne("common.mdct.getMasterMdCtBuyerJoinAlterRequestApprovalUserAuth",formData);
//				if (Integer.parseInt(_authChk) > 0) {
//					sqlSessionTemplate.update("common.mdct.updateMasterMdCtBuyerJoinAlterRequestApprovalUserAuth",formData);
//				} else {
//					sqlSessionTemplate.insert("common.mdct.insertMasterMdCtBuyerJoinAlterRequestApprovalUserAuth",formData);
//				}
				
				Map<String, String> _pMap = new HashMap<String, String>();
				_pMap.put("COM_CODE", formData.get("com_code"));
				_pMap.put("USER_ID", formData.get("buyer_user_id"));
				
				sqlSessionTemplate.update("master.mdcp.SP_PROC_USERAUTH_GEN", _pMap);
			}
			
			if (!"".equals(formData.get("com_code")) && !"".equals(formData.get("st_from_date"))) { 
				String _kepBuyerRate = sqlSessionTemplate.selectOne("common.mdct.getMasterMdCtBuyerJoinAlterRequestApprovalKepBuyerRate", formData);
				
				if (Integer.parseInt(_kepBuyerRate) > 0) {
					sqlSessionTemplate.update("common.mdct.updateMasterMdCtBuyerJoinAlterRequestApprovalKepBuyerRate", formData);
				} else {
					sqlSessionTemplate.insert("common.mdct.insertMasterMdCtBuyerJoinAlterRequestApprovalKepBuyerRate", formData);
				}
			}
			
			formData.put("DOC_NO", formData.get("st_image_key"));
			sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);

			_rtnMsg = "OK";
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			_rtnMsg = "ERR";
			throw new RuntimeException("고객사 등록정보 저장을에 실패 했습니다.");
		}
		
		return _rtnMsg; 
	}
	
	
		
	// 비밀번호 룰 적용
	public String selectPwdValidCheck(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mdct.pwdValidCheckMdCtBuyerJoinAlterRequestApprovalPop", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateChargeEntryData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "KeP 담당자 저장이 완료 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("updateMasterMdCtBuyerChargeEntryList 요청 파라미터 : formData {}", formData.get("sStatus"));
				
				if ( "I".equals(formData.get("sStatus")) ) {
					sqlSessionTemplate.insert("common.mdct.insertMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList", formData);
				} else if ("U".equals(formData.get("sStatus")) ) {
					sqlSessionTemplate.update("common.mdct.updateMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList", formData);
				}
			}
		} catch (Exception e) {
			_rtnMsg = "KeP 담당자 정보 저장에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("KeP 담당자 정보 저장에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "KeP 담당자 삭제가 완료 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
	
				LOGGER.debug("deletetMasterMdCtBuyerChargeEntryList 요청 파라미터 : formData {}", formData);
				sqlSessionTemplate.delete("common.mdct.deletetMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList", formData);
			}
		} catch (Exception e) {
			_rtnMsg = "KeP 담당자 삭제에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("KeP 담당자 삭제에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	// sg별 매익율 리스트조회
	public List<Map<String,String>> selectSgMarginList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("common.mdct.selectMasterMdCtSgMarginList", param);
	}
	
	// sg별 매익율 저장
	@SuppressWarnings("unchecked")
	public String updateSgMargin(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "처리 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				List<Map<String,String>> list = null;
				list = sqlSessionTemplate.selectList("common.mdct.selectMasterMdCtCod3SgMarginList", formData);
				if(list.size() > 0) {
					sqlSessionTemplate.update("common.mdct.updateMasterMdCtCod3SgMarginList", formData);
				}else {
					sqlSessionTemplate.update("common.mdct.insertMasterMdCtCod3SgMarginList", formData);					
				}
			}
		} catch (Exception e) {
			_rtnMsg = "처리 실패 했습니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 실패 했습니다.");
		}
		
		return _rtnMsg;
	}
	
}
