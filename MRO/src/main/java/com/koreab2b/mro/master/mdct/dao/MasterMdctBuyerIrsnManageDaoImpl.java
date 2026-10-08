package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdctBuyerIrsnManageDao")
@Transactional
public class MasterMdctBuyerIrsnManageDaoImpl implements MasterMdctBuyerIrsnManageDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdctBuyerIrsnManageDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 담당자 중복체크
	public String selectKepUserIdCheck(Map<String,String>  formData, List<Object> gridData) {
		return sqlSessionTemplate.selectOne("master.mdct.selectMasterMdctBuyerIrsnManageUserIdCheck", formData);
	}
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdctBuyerIrsnManageList", param);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "고객사 사업자번호 저장이 완료 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				String _irsNoChk = "0";
				
				LOGGER.debug("updateMasterMdctBuyerIrsnManageList 요청 파라미터 : formData {}", formData.get("sStatus"));
				
				_irsNoChk = sqlSessionTemplate.selectOne("master.mdct.getMasterMdctBuyerIrsnManageIrsNoCheck", formData);
				if ("0".equals(_irsNoChk)) {
					sqlSessionTemplate.insert("master.mdct.insertMasterMdctBuyerIrsnManageList", formData);
				}else {
					sqlSessionTemplate.update("master.mdct.updateMasterMdctBuyerIrsnManageList", formData);	
				}
			}
		} catch (Exception e) {
			_rtnMsg = "고객사 사업자번호 저장에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("고객사 사업자번호 저장에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "고객사 사업자번호 삭제가 완료 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
	
				LOGGER.debug("deletetMasterMdctBuyerIrsnManageList 요청 파라미터 : formData {}", formData);
				sqlSessionTemplate.delete("master.mdct.deletetMasterMdctBuyerIrsnManageList", formData);
			}
		} catch (Exception e) {
			_rtnMsg = "고객사 사업자번호 삭제에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("고객사 사업자번호 삭제에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
}
