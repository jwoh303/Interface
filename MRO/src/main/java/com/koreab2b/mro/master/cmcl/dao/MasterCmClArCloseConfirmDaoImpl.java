package com.koreab2b.mro.master.cmcl.dao;

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

@Repository("masterCmClArCloseConfirmDao")
@Transactional
public class MasterCmClArCloseConfirmDaoImpl implements MasterCmClArCloseConfirmDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterCmClArCloseConfirmDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		param.put("st_user_dept_cd_all", CommonUtil.getStringArrary((String) param.get("st_user_dept_cd"), ","));
		return sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClArCloseConfirmList", param);
	}

	// 마감 미제출자 리스트 조회
	public List<Map<String, String>> selectPopList(Map<String, Object> param) {
		if(param.get("st_type").equals("AR")) { // 매출, 물류비
			return sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClArCloseConfirmPopList", param);			
		} else {
			return sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClApCloseConfirmPopList", param);
		}
		
	}
	public List<Map<String, String>> selectPopList_v2(Map<String, Object> param) {
		if(param.get("st_type").equals("AR")) { // 매출, 물류비
			return sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClArCloseConfirmPopList_v2", param);			
		} else {
			return sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClApCloseConfirmPopList_v2", param);
		}
		
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		String _jobKind = formData.get("job_kind");
		
		try {
			
			// 마감완료
			if ( "confirm".equals(_jobKind) ) {
				_rtnMsg = "마감완료 처리 완료 되었습니다.";
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClArCloseConfirm_confirm", formData);			
				}
			}
			// 제출취소
			else if ( "cancle".equals(_jobKind) ) {
				_rtnMsg = "제출취소 처리 완료 되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					String siteName = CommonUtil.nvl(formData.get("SITE"), "");
					// 기존 데이터 삭제
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClArCloseConfirm_delete", formData);
					// BILL_CLOSE_USER_LIST 업데이트
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClArCloseConfirm_cancle", formData);
					// 마감제출 FLAG 변경(MRO, 건설, 유통 분리)
					if(siteName.equals("KOREAB2B")) {
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClArCloseConfirmFlag_mro", formData);
					} else if(siteName.equals("KWAY")) {
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClArCloseConfirmFlag_kway", formData);
					} else if(siteName.equals("건설MRO")) {
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClArCloseConfirmFlag_sa", formData);
					}
				}
			}
			
			// 회계전송
			else if ( "send".equals(_jobKind) ) {
				_rtnMsg = "세금계산서 전송이 완료 되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					String siteName = CommonUtil.nvl(formData.get("SITE"), "");
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClArCloseConfirm_send", formData);
					
					// ERP 전송(MRO, 건설, 유통 분리)
					if(siteName.equals("KOREAB2B")) {
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClArCloseErpSendFlag_mro", formData);
					} else if(siteName.equals("KWAY")) {
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClArCloseErpSendFlag_kway", formData);
					} else if(siteName.equals("건설MRO")) {
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClArCloseErpSendFlag_sa", formData);
					}
				}
			}
			
			// 추가제출
			else if ( "submit".equals(_jobKind) ) {
				_rtnMsg = "추가제출 처리 완료 되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));					
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClArCloseConfirm_submit", formData);					
				}
			}
			
		} catch (Exception e){
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			if ( "confirm".equals(_jobKind) ) {
				throw new RuntimeException("\n\n[ 마감완료 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
			else if ( "cancle".equals(_jobKind) ) {
				throw new RuntimeException("\n\n[ 제출취소 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
			else if ( "send".equals(_jobKind) ) {
				throw new RuntimeException("\n\n[ 회계전송 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
			else if ( "submit".equals(_jobKind) ) {
				throw new RuntimeException("\n\n[ 추가제출 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
		}
		
		return _rtnMsg;
	}
	

}
