package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogInfoMultiAlterDaoImpl;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("CommonCaImApprovalDao")
@Transactional
public class CommonCaImApprovalDaoImpl implements CommonCaImApprovalDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCatalogInfoMultiAlterDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 품의상신(IM)
	public String imRequest(Map<String,String> formData){
		return "OK";
	}
	
	// 카탈로그변경 결재 상신취소 후 처리(IM)
	public String imCancel(Map<String,String> formData){
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);        
		_pMap.put("STATUS", "D");	// 삭제 처리
		_pMap.put("USER_ID", formData.get("USER_ID"));
		_pMap.put("USER_DEPT", formData.get("USER_DEPT"));
		
		// STEP1
		sqlSessionTemplate.update("commonCaImApproval.updateCancelCaImKEPMGPHD", _pMap);
		// STEP2
		sqlSessionTemplate.update("commonCaImApproval.updateCancelCaImKEPMGPDT", _pMap);
        
		return "OK";
	}
	
	// 카탈로그변경 결재 승인 후 처리(IM)
	public String imApproval(Map<String, String> formData) {
		String _rtnMsg = "결재완료 되었습니다.";
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		if (_pMap != null){
			try{
				_pMap.put("STATUS", "A");
				_pMap.put("USER_ID", formData.get("USER_ID"));
				_pMap.put("USER_DEPT", formData.get("USER_DEPT"));
				        
				// STEP1
				sqlSessionTemplate.update("commonCaImApproval.updateApprovalCaImKEPMGPHD", _pMap);
				sqlSessionTemplate.update("commonCaImApproval.updateApprovalCaImKEPMGPDT", _pMap);
				// STEP2 IF_PROGRESS 추가
				sqlSessionTemplate.update("commonCaImApproval.InsertCaImIF_PROGRESS", _pMap);
			} catch (Exception e){
				LOGGER.error("SQL ERROR : ", e);
					throw new RuntimeException("결재완료에 실패하였습니다.");
			}
		}
		return _rtnMsg; 
	}
	
	// 카탈로그변경 결재 반려 후 처리(IM)
	public String imReject(Map<String,String> formData){
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
		Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		_pMap.put("STATUS", "B");
		_pMap.put("USER_ID", formData.get("USER_ID"));
		_pMap.put("USER_DEPT", formData.get("USER_DEPT"));
		        
		// STEP1
		sqlSessionTemplate.update("commonCaImApproval.updateRejectCaImKEPMGPHD", _pMap);
		// STEP2
		sqlSessionTemplate.update("commonCaImApproval.updateRejectCaImKEPMGPDT", _pMap);
				
		return "OK";
	}

	// 결재정보 조회(페이징)
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> imResultList(Map<String,String> formData) {
		String pageflag = (String) formData.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			sqlSessionTemplate.select("commonCaImApproval.selectImResultList", formData, _resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("commonCaImApproval.selectImResultList", formData);
		}
		return resultList;
	}
}
