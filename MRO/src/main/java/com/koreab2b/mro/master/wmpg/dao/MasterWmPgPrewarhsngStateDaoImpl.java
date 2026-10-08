package com.koreab2b.mro.master.wmpg.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterWmPgPrewarhsngStateDao")
@Transactional
public class MasterWmPgPrewarhsngStateDaoImpl implements MasterWmPgPrewarhsngStateDao {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterWmPgPrewarhsngStateDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.wmpg.selectMasterWmPgPrewarhsngStateList", param);
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateMasterWmPgPrewarhsngState(Map<String,String>  formData, List<Object> gridData) {
		LOGGER.debug("updateMasterWmPgPrewarhsngState()  ::: ", gridData);
		
		String _rtnMsg = "";
		String _status = "";
		
		try {
			
			if(gridData != null && gridData.size() > 0){
				for(int inx = 0 ; inx < gridData.size() ; inx++){
					formData.putAll((Map<String, String>)gridData.get(inx));
					_status = formData.get("STATUS");
					
					if("03".equals(_status)){
						_rtnMsg = "입고확정 상태 삭제";
						
						// 선입고송장상세 수정(입고확정)
						sqlSessionTemplate.update("master.wmpg.deleteMasterWmPgPrewarhsngWarhsngReg_WMS_GR_QTY", formData);
						
						// 선입고관리 수정(입고확정)
						sqlSessionTemplate.update("master.wmpg.deleteMasterWmPgPrewarhsngWarhsngReg_GR_QTY", formData);
					} else if("04".equals(formData.get("STATUS"))){
						_rtnMsg = "출고지시 확정 상태 삭제";
						
						// 선입고송장상세 수정(출고지시)
						sqlSessionTemplate.update("master.wmpg.deleteMasterWmPgPrewarhsngWarhsngReg_WMS_IVK_QTY", formData);
						
						// 선입고관리 수정(출고지시)
						sqlSessionTemplate.update("master.wmpg.deleteMasterWmPgPrewarhsngWarhsngReg_IV_QTY", formData);
						
						// 선입고 물류센터 송장테이블 저장(출고지시)
						sqlSessionTemplate.insert("master.wmpg.deleteMasterWmPgPrewarhsngReleaseReg", formData);
					} else if("05".equals(formData.get("STATUS"))){
						_rtnMsg = "배송확정 상태 삭제";
						
						// 선입고 물류센터 송장테이블 udpate
						sqlSessionTemplate.update("master.wmpg.deleteMasterWmPgPrewarhsngDlvryReg_KEP_BEFORE_STOCKED_WMSIVDT", formData);
						
						// 선입고송장상세 udpate
						sqlSessionTemplate.update("master.wmpg.deleteMasterWmPgPrewarhsngDlvryReg_KEP_BEFORE_STOCKED_IVDT", formData);
						
						// 선입고관리 udpate
						sqlSessionTemplate.update("master.wmpg.deleteMasterWmPgPrewarhsngDlvryReg_KEP_BEFORE_STOCKED_MNG", formData);
					}
				}
			}
			
			_rtnMsg = _rtnMsg + "처리가 되었습니다.";
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			_rtnMsg = _rtnMsg + "처리를 실패하였습니다.\n\n본사 시스템운영팀으로 연락바랍니다.";
			
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
}
