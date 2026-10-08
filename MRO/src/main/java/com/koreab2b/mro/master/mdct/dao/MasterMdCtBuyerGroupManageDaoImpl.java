package com.koreab2b.mro.master.mdct.dao;

import java.util.ArrayList;
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

@Repository("masterMdCtBuyerGroupManageDao")
@Transactional
public class MasterMdCtBuyerGroupManageDaoImpl implements MasterMdCtBuyerGroupManageDao {
private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtBuyerGroupManageDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 법인코드 중복 체크
	public String selectCorpCheck(Map<String,Object> param) {
		return sqlSessionTemplate.selectOne("master.mdct.selectMasterMdCtBuyerGroupManageGroupCheck", param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtBuyerGroupManageList", param);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "고객사 그룹 정보 저장이 완료 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("updateMasterMdCtBuyerGroupManageList 요청 파라미터 : formData {}", formData.get("sStatus"));
				
				if ( "I".equals(formData.get("sStatus")) ) {
					sqlSessionTemplate.insert("master.mdct.insertMasterMdCtBuyerGroupManageList", formData);
				} else {
					sqlSessionTemplate.update("master.mdct.updateMasterMdCtBuyerGroupManageList", formData);
				}
			}
		} catch (Exception e) {
			_rtnMsg = "고객사 그룹 정보 저장에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("고객사 그룹 정보 저장에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	// 삭제
	public String deleteSelectedData(Map<String,String>  formData) {
		_rtnMsg = "고객사 그룹 삭제가 완료 되었습니다.";
		Map<String,Object>  data = new HashMap<String,Object>();
		
		try {
			List< String > _list = new ArrayList< String >( );
			_list = CommonUtil.getStringArrary((String) formData.get("st_group_code"),"@@");
			if (_list.size() > 0) {
				data.put("group_code_in_array", _list);
				
				LOGGER.debug("updateMasterMdCtBuyerGroupManageList 요청 파라미터 : formData {}", data);
				sqlSessionTemplate.delete("master.mdct.deletetMasterMdCtBuyerGroupManageList", data);
			}
		} catch (Exception e) {
			_rtnMsg = "고객사 그룹 삭제에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("고객사 그룹 삭제에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
}
