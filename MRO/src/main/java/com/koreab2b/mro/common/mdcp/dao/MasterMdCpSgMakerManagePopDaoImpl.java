package com.koreab2b.mro.common.mdcp.dao;

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

@Repository("masterMdCpSgMakerManagePopDao")
@Transactional
public class MasterMdCpSgMakerManagePopDaoImpl implements MasterMdCpSgMakerManagePopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCpSgMakerManagePopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 조회
	public List<Map<String,String>> selectCompyList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpSgMakerManagePopIcomCod3List", formData);
	}
		
	// 리스트 조회
	public List<Map<String,String>> selectKepSgList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpSgMakerManagePopKepSgList", param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> selectKepMkList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpSgMakerManagePopKepMkList", param);
	}
	
	// 저장
	public String updateRemarkData(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		
		try {
			String _remarkChk = sqlSessionTemplate.selectOne("common.mdcp.selectMasterMdCpSgMakerManagePopRemarkCheck", formData);
			
			if ( "OK".equals(_remarkChk) ) {
				sqlSessionTemplate.update("common.mdcp.updateMasterMdCpSgMakerManagePopRemark", formData);
			} else {	
				sqlSessionTemplate.insert("common.mdcp.insertMasterMdCpSgMakerManagePopRemark", formData);

			}
		} catch (Exception e) {
			_rtnMsg = "Err";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("공급사 선정 사유 입력이 실패 하였습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
		
	// 저장
	@SuppressWarnings("unchecked")
	public String updateKepMkData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "제조사 추가 성공 하였습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));

				if ( "I".equals(formData.get("sStatus")) ) {
					sqlSessionTemplate.insert("common.mdcp.insertMasterMdCpSgMakerManagePopKepMkList", formData);
				}
			}
		} catch (Exception e) {
			_rtnMsg = "제조사 추가 실패 하였습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("제조사 추가 실패 하였습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	// MK승인
	@SuppressWarnings("unchecked")
	public String updateConfMkData(Map<String, String>  formData, List<Object> gridData) {
		String _rtnMsg = "제조사 승인에 성공 하였습니다.";
		Map<String, String> _tMap = new HashMap<String, String>();
		Map<String, Object> _pMap = new HashMap<String, Object>();
		
		try {
			List< String > _list = new ArrayList< String >( );
			String _makerCode = "";
			for ( int i=0; i < gridData.size(); i++ ) {
				_tMap.putAll((Map<String, String>)gridData.get(i));
				_makerCode = _tMap.get("MAKER_CODE") + "@@";
			}
			_list = CommonUtil.getStringArrary((String) _makerCode, "@@");
			_pMap.putAll(formData);
			_pMap.put("maker_code_array", _list);
			sqlSessionTemplate.update("common.mdcp.updateMasterMdCpSgMakerManagePopConfMkList", _pMap);

		} catch (Exception e) {
			_rtnMsg = "제조사 승인에 실패 하였습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("제조사 승인에 실패 하였습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
		
	// MK복원
	@SuppressWarnings("unchecked")
	public String updateModMkData(Map<String, String>  formData, List<Object> gridData) {
		String _rtnMsg = "제조사 복원에 성공 하였습니다.";
		Map<String, String> _tMap = new HashMap<String, String>();
		Map<String, Object> _pMap = new HashMap<String, Object>();
		
		try {
			List< String > _list = new ArrayList< String >( );
			String _makerCode = "";
			for ( int i=0; i < gridData.size(); i++ ) {
				_tMap.putAll((Map<String, String>)gridData.get(i));
				_makerCode = _tMap.get("MAKER_CODE") + "@@";
			}
			_list = CommonUtil.getStringArrary((String) _makerCode, "@@");
			_pMap.putAll(formData);
			_pMap.put("maker_code_array", _list);
			sqlSessionTemplate.update("common.mdcp.updateMasterMdCpSgMakerManagePopModMkList", _pMap);

		} catch (Exception e) {
			_rtnMsg = "제조사 복원에 실패 하였습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("제조사 복원에 실패 하였습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	// SG삭제
	@SuppressWarnings("unchecked")
	public String deleteKepSgData(Map<String, String>  formData, List<Object> gridData) {
		String _rtnMsg = "SG 삭제에 성공 하였습니다.";
		Map<String, String> _tMap = new HashMap<String, String>();
		Map<String, Object> _pMap = new HashMap<String, Object>();
		
		try {
			List< String > _list = new ArrayList< String >( );
			String _sgId = "";
			for ( int i=0; i < gridData.size(); i++ ) {
				_tMap.putAll((Map<String, String>)gridData.get(i));
				_sgId = _tMap.get("SG_ID") + "@@";
			}
			_list = CommonUtil.getStringArrary((String) _sgId, "@@");
			_pMap.putAll(formData);
			_pMap.put("sg_id_array", _list);
			sqlSessionTemplate.delete("common.mdcp.deleteMasterMdCpSgMakerManagePopKepSgList", _pMap);
			sqlSessionTemplate.update("common.mdcp.updateMasterMdCpSgMakerManagePopKepSgList", _pMap);

		} catch (Exception e) {
			_rtnMsg = "SG 삭제에 실패 하였습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("SG 삭제에 실패 하였습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	// MK삭제
	@SuppressWarnings("unchecked")
	public String deleteKepMkData(Map<String, String>  formData, List<Object> gridData) {
		String _rtnMsg = "제조사 삭제에 성공 하였습니다.";
		Map<String, String> _tMap = new HashMap<String, String>();
		Map<String, Object> _pMap = new HashMap<String, Object>();
		
		try {
			List< String > _list = new ArrayList< String >( );
			String _makerCode = "";
			for ( int i=0; i < gridData.size(); i++ ) {
				_tMap.putAll((Map<String, String>)gridData.get(i));
				_makerCode = _tMap.get("MAKER_CODE") + "@@";
			}
			_list = CommonUtil.getStringArrary((String) _makerCode, "@@");
			_pMap.putAll(formData);
			_pMap.put("maker_code_array", _list);
			sqlSessionTemplate.delete("common.mdcp.deleteMasterMdCpSgMakerManagePopKepMkList", _pMap);
			sqlSessionTemplate.update("common.mdcp.updateMasterMdCpSgMakerManagePopKepMkList", _pMap);

		} catch (Exception e) {
			_rtnMsg = "제조사 삭제에 실패 하였습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("제조사 삭제에 실패 하였습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}

}
