package com.koreab2b.mro.common.cmcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClSalesTaxsheetIssueRegDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterCmClCmmntPopDao")
@Transactional
public class MasterCmClCmmntPopDaoImpl implements MasterCmClCmmntPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesTaxsheetIssueRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.cmcl.selectMasterCmClCmmntPopList", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "적요 수정이 완료 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if ( "".equals(formData.get("ITEM_SEQ")) ) {
					// 외상매출_세금계산서 insert
					int upCount = sqlSessionTemplate.update("common.cmcl.insertMasterCmClCmmntPopList", formData);
					
					if ( upCount == 0 ) {
						throw new RuntimeException("\n\n[ 적요 변경 실패 ]");
					}
					
				}
				else {
					// 외상매출_세금계산서 update
					int upCount = sqlSessionTemplate.update("common.cmcl.updateMasterCmClCmmntPopList", formData);
					
					if ( upCount == 0 ) {
						throw new RuntimeException("\n\n[ 적요 변경 실패 ]");
					}
				}
				
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 적요 수정 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	// 담당자조회
	public List<Map<String,String>> selectMasterCmClStndSettingPop(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.cmcl.selectMasterCmClStndSettingPop", formData);
	}

	// 미매핑 세금계산서 조회 팝업
	public List<Map<String,String>> selectMasterCmClIssueIdInfoPop(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.cmcl.selectMasterCmClIssueIdInfoPop", formData);
	}
	
	// 미매핑 세금계산서 조회 팝업 (상단 그리드 조회)
	public List<Map<String,String>> selectMasterCmClIssueIdInfoPop1(Map<String,Object> formData) {
		List<String> list = CommonUtil.getStringArrary((String) formData.get("st_group_key"), "@");
		formData.put("st_group_key", list);

		String st_mapping_type = (String) formData.get("st_mapping_type");
		String st_issueId_yn = (String) formData.get("st_issueId_yn");
		
		if(st_issueId_yn.equals("Y") && (st_mapping_type.equals("N1") || st_mapping_type.equals("NN"))){
			return sqlSessionTemplate.selectList("common.cmcl.selectMasterCmClIssueIdInfoPopY", formData);	
		}else{
			return sqlSessionTemplate.selectList("common.cmcl.selectMasterCmClIssueIdInfoPopN", formData);
		}
	}
	
	// 담당자저장
	@SuppressWarnings("unchecked")
	public String saveMasterCmClStndSettingPop(Map<String,String>  formData, List<Object> gridData) {

		int _count = 0;
		
		_rtnMsg = "정상적으로 완료되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				
				formData.putAll((Map<String, String>)gridData.get(i));
				if ( "U".equals(formData.get("sStatus")) ) {
					_count = sqlSessionTemplate.insert("common.cmcl.updateMasterCmClStndSettingPop", formData);
					if ( _count != 1 ) {
						throw new RuntimeException("담당자수정 실패 했습니다.\n\n다시 확인하여 주십시요.");
					}
				}else if ( "I".equals(formData.get("sStatus")) ) {
					_count = sqlSessionTemplate.insert("common.cmcl.insertMasterCmClStndSettingPop", formData);
					if ( _count != 1 ) {
						throw new RuntimeException("담다자추가 실패 했습니다.\n\n다시 확인하여 주십시요.");
					}					
				}
			}
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			throw new RuntimeException("담당자저장 실패 했습니다.\n\n다시 확인하여 주십시요.");
		}
		return _rtnMsg;
	}
	
	
	// 담당자삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String delMasterCmClStndSettingPop(Map<String,String>  formData, List<Object> gridData) {
		
		int _count = 0;
		
		_rtnMsg = "삭제가 정상적으로 완료되었습니다";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));	
				_count = sqlSessionTemplate.update("common.cmcl.delMasterCmClStndSettingPop", formData);
				if ( _count != 1 ) {
					throw new RuntimeException("담당자삭제 실패 했습니다.\n\n다시 확인하여 주십시요.");
				}
			}
		} catch(Exception e ) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("담당자삭제 실패 했습니다.\n\n다시 확인하여 주십시요.");
		}

		return _rtnMsg;		
	}
	// 수정사유
	public List<Map<String,String>> selectMasterCmClStndSettingModifyPop(Map<String,Object> formData) {
		String st_gbn = (String) formData.get("st_gbn");
		if(st_gbn.equals("AP")){
			return sqlSessionTemplate.selectList("common.cmcl.selectMasterCmClStndSettingApModifyPop", formData);
		}else{
			return sqlSessionTemplate.selectList("common.cmcl.selectMasterCmClStndSettingModifyPop", formData);	
		}
		
	}
}
