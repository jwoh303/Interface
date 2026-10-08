package com.koreab2b.mro.master.wmpg.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterWmPgPrewarhsngWarhsngRegDao")
@Transactional
public class MasterWmPgPrewarhsngWarhsngRegDaoImpl implements MasterWmPgPrewarhsngWarhsngRegDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterWmPgPrewarhsngWarhsngRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.wmpg.selectMasterWmPgPrewarhsngWarhsngRegList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		// 출고일 셋팅
		String _st_ivk_yn= (String) formData.get("st_ivk_yn");
		String _st_ivk_date = ((String) formData.get("st_ivk_date")).replace("/", "");
		String _checkYn = "";
		
		formData.put("st_ivk_date",_st_ivk_date);
		
		try {
			
			if ( "Y".equals(_st_ivk_yn) ) {
				_rtnMsg = "정상적으로 센터 입고 및 출고지시가 되었습니다.";
			} else {
				_rtnMsg = "정상적으로 센타 입고가 되었습니다.";
			}
			
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// 저장 트랜잭션 체크
				_checkYn = (String)sqlSessionTemplate.selectOne("master.wmpg.selectMasterWmPgPrewarhsngWarhsngReg_Check_Yn", formData);
				
				if ( "N".equals(_checkYn) ) {
					throw new RuntimeException("\n\n[ 이미 센타 입고된 데이터입니다. ]\n\n다시 확인하여 주십시요.");
				}
				
				// 선입고송장상세 수정(입고확정)
				sqlSessionTemplate.update("master.wmpg.updateMasterWmPgPrewarhsngWarhsngReg_WMS_GR_QTY", formData);
				
				// 선입고관리 수정(입고확정)
				sqlSessionTemplate.update("master.wmpg.updateMasterWmPgPrewarhsngWarhsngReg_GR_QTY", formData);
				
				if ( "Y".equals(_st_ivk_yn) ) {
					// 선입고송장상세 수정(출고지시)
					sqlSessionTemplate.update("master.wmpg.updateMasterWmPgPrewarhsngWarhsngReg_WMS_IVK_QTY", formData);
					
					// 선입고관리 수정(출고지시)
					sqlSessionTemplate.update("master.wmpg.updateMasterWmPgPrewarhsngWarhsngReg_IV_QTY", formData);
					
					// 선입고 물류센터 송장테이블 저장(출고지시)
					sqlSessionTemplate.insert("master.wmpg.insertMasterWmPgPrewarhsngWarhsngReg_KEP_BEFORE_STOCKED_WMSIVDT", formData);
				}
			}
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			if ( "Y".equals(_st_ivk_yn) ) {
				_rtnMsg = "\n\n[ 센타 입고 및 출고지시 실패 ]\n\n본사 시스템운영팀으로 연락바랍니다.";
			} else {
				_rtnMsg = "\n\n[ 센타 입고 실패 ]\n\n본사 시스템운영팀으로 연락바랍니다.";
			}
			
			throw new RuntimeException(_rtnMsg);
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
//				sqlSessionTemplate.update("master.wmpg.deleteMasterWmPgPrewarhsngWarhsngReg", formData);
//				LOGGER.error("deleteMasterWmPgPrewarhsngWarhsngReg 실행 완료");
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
