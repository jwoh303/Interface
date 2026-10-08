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

@Repository("masterCmClClArApMappingDao")
@Transactional
public class MasterCmClClArApMappingDaoImpl implements MasterCmClClArApMappingDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClClArApMappingDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;
	    
	    String pageflag = (String) param.get("pageflag");
		resultList = (List<Map<String, String>>)_resultHander.getList();
		if("0".equals(pageflag)){
			sqlSessionTemplate.select("master.cmcl.selectMasterCmClClArApMappingList", param,_resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClClArApMappingList", param);
		}
		return resultList;
	}
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectTaxList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;
	    
	    String pageflag = (String) param.get("pageflag");
		resultList = (List<Map<String, String>>)_resultHander.getList();
		if("0".equals(pageflag)){
			sqlSessionTemplate.select("master.cmcl.selectMasterCmClTaxMappingList", param,_resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClTaxMappingList", param);
		}
		return resultList;
	}
	
	// 세금계산서 상계처리 매핑
	@SuppressWarnings("unchecked")
	public String callProcTaxSkip(Map<String,String>  formData) {
		
		_rtnMsg = "정상적으로 매핑 되었습니다.";
		try {
			sqlSessionTemplate.update("master.cmcl.call_PROC_TAX_SKIP", formData);
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 매핑 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		return null;
	}

	// 세금계산서 수동 상계처리
	@SuppressWarnings("unchecked")
	public String updateProcTaxSkip(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 매핑 되었습니다.";
		String NTS_GROUP_KEY = "";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if(i == 0){
					NTS_GROUP_KEY = CommonUtil.nvl(formData.get("ISSUE_ID"), "");	
				}
				
				formData.put("NTS_GROUP_KEY", NTS_GROUP_KEY);
				
				sqlSessionTemplate.update("master.cmcl.manual_PROC_TAX_SKIP", formData);
			}
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 매핑 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
		
	// 매출 자동매핑
	@SuppressWarnings("unchecked")
	public String callProcTaxMappingAr(Map<String,String>  formData) {
		
		_rtnMsg = "정상적으로 매핑 되었습니다.";
		try {
			sqlSessionTemplate.update("master.cmcl.call_PROC_TAX_MAPPING_AR", formData);
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 매핑 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		return null;
	}
	
	// 매입 자동매핑
	@SuppressWarnings("unchecked")
	public String callProcTaxMappingAp(Map<String,String>  formData) {
		
		_rtnMsg = "정상적으로 매핑 되었습니다.";
		try {
			sqlSessionTemplate.update("master.cmcl.call_PROC_TAX_MAPPING_AP", formData);
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 매핑 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		return null;
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String savetMasterCmClArApMappingList(Map<String,String>  formData) {
		
		_rtnMsg = "정상적으로 저장 되었습니다.";
		try {
			List<String> acc_no_list = CommonUtil.getStringArrary((String) formData.get("st_acc_no"), "@");
			List<String> acc_seq_list = CommonUtil.getStringArrary((String) formData.get("st_acc_seq"), "@");
			List<String> issue_id_list = CommonUtil.getStringArrary((String) formData.get("st_issue_id"), "@");

			// acc_no_list 와 acc_seq_list 길이가 같을 때(정상 작동)
			if(acc_no_list.size() == acc_seq_list.size()){
				for (int i=0; i<acc_no_list.size(); i++ ) {
					for(int j=0; j<issue_id_list.size(); j++){
						formData.put("st_acc_no", acc_no_list.get(i));
						formData.put("st_acc_seq", acc_seq_list.get(i));
						formData.put("ISSUE_ID", issue_id_list.get(j));
						
						sqlSessionTemplate.insert("master.cmcl.inserMasterCmClArApMapping", formData);
					}
				}	
			}
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 저장 오류 발생 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		return null;
	}
	// 저장
	@SuppressWarnings("unchecked")
	public String saveExceptionMasterCmClArApMappingList(Map<String,String>  formData, List<Object> gridData) {
			
		_rtnMsg = "정상적으로 저장 되었습니다.";
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.insert("master.cmcl.inserExcepMasterCmClArApMapping", formData);
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
	// 확정
	@SuppressWarnings("unchecked")
	public String confirmtMasterCmClArApMappingList(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 확정 되었습니다.";
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.insert("master.cmcl.confirmtMasterCmClArApMappingList", formData);
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
	// 매핑취소
	@SuppressWarnings("unchecked")
	public String cancleMappingMasterCmClArApMappingList(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 매핑취소 되었습니다.";
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.insert("master.cmcl.cancleMappingMasterCmClArApMappingList", formData);
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
	// 취소
	@SuppressWarnings("unchecked")
	public String cancleMasterCmClArApMappingList(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 취소 되었습니다.";
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.insert("master.cmcl.cancleMasterCmClArApMappingList", formData);
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
}
