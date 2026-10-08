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

@Repository("masterWmPgPrewarhsngDlvryRegDao")
@Transactional
public class MasterWmPgPrewarhsngDlvryRegDaoImpl implements MasterWmPgPrewarhsngDlvryRegDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterWmPgPrewarhsngDlvryRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.wmpg.selectMasterWmPgPrewarhsngDlvryRegList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 배송확정 되었습니다.";
		
		// 배송확정일 셋팅
		String _st_ivk_date = ((String) formData.get("st_ivk_date")).replace("/", "");
		String _checkYn = "";
		
		formData.put("st_ivk_date",_st_ivk_date);
		
		try {
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// 저장 트랜잭션 체크
				_checkYn = (String)sqlSessionTemplate.selectOne("master.wmpg.selectMasterWmPgPrewarhsngDlvryRegList_Check_Yn", formData);
				
				if ( "N".equals(_checkYn) ) {
					throw new RuntimeException("\n\n[ 이미 배송 확정된 데이터입니다. ]\n\n다시 확인하여 주십시요.");
				}
				
				// 선입고 물류센터 송장테이블 udpate
				sqlSessionTemplate.update("master.wmpg.updateMasterWmPgPrewarhsngDlvryReg_KEP_BEFORE_STOCKED_WMSIVDT", formData);
				
				// 선입고송장상세 udpate
				sqlSessionTemplate.update("master.wmpg.updateMasterWmPgPrewarhsngDlvryReg_KEP_BEFORE_STOCKED_IVDT", formData);
				
				// 선입고관리 udpate
				sqlSessionTemplate.update("master.wmpg.updateMasterWmPgPrewarhsngDlvryReg_KEP_BEFORE_STOCKED_MNG", formData);
			}
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 배송확정 실패 ]\n\n본사 시스템운영팀으로 연락바랍니다");
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
//				sqlSessionTemplate.update("master.wmpg.deleteMasterWmPgPrewarhsngDlvryReg", formData);
//				LOGGER.error("deleteMasterWmPgPrewarhsngDlvryReg 실행 완료");
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
