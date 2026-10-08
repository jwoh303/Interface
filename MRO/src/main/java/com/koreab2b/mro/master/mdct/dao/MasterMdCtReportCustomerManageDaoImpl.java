package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;

@Repository("masterMdCtReportCustomerManageDao")
@Transactional
public class MasterMdCtReportCustomerManageDaoImpl implements MasterMdCtReportCustomerManageDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtReportCustomerManageDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	private String _rtnMsg = "";
	
	//  리포트 등록 조회
	public List<Map<String,String>> selectReportList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtBuyerReportList", formData);
	}
	// 리포트관리 매핑
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtBuyerReportMapList", param);
	}
	// 등록
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "등록 되었습니다.";
		String st_rp_cd = "";
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				
				formData.putAll((Map<String, String>)gridData.get(i));
				//고객사 코드 유효성 체크
				List<Map<String,String>> list = null;
				list = sqlSessionTemplate.selectList("master.mdct.selecMasterMdCtBuyerCheck", formData);
				if(list.size() == 0){
					_rtnMsg = "고객사코드 확인 바랍니다.";
					throw new RuntimeException(_rtnMsg);
				}
				//리포트 관리 등록 체크
				List<Map<String,String>> list2 = null;
				list2 = sqlSessionTemplate.selectList("master.mdct.selecMasterMdCtBuyerCheck2", formData);
				if(list2.size() > 0){
					_rtnMsg = formData.get("COM_NAME_LOC")+"("+formData.get("COM_CODE")+ ") 은(는) 리포트 등록 되어있어 등록 불가능 합니다.";
					throw new RuntimeException(_rtnMsg);
				}
				//고객사 매핑여부 체크
				if(i==0) {
					st_rp_cd =  masterMpRqBuyerReqDao.nextVal("KRKORE0001", "RP");
					formData.put("GROUP_CODE", st_rp_cd);
					sqlSessionTemplate.update("master.mdct.insertMasterMdCtReportCustomerList", formData);
				}
				sqlSessionTemplate.update("master.mdct.insertMasterMdCtReportCustomerMng", formData);
			}
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			if("등록 되었습니다.".equals(_rtnMsg)) {
				_rtnMsg = "등록에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	// 저장
	@SuppressWarnings("unchecked")
	public String saveMasterMdCtReportCustomerList(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "저장 되었습니다.";
		try {
			//리포트 정보 저장
			sqlSessionTemplate.update("master.mdct.updateMasterMdCtReportCustomerList", formData);
			sqlSessionTemplate.update("master.mdct.deleteMasterMdCtReportCustomerMng", formData);
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				//고객사 코드 유효성 체크
				List<Map<String,String>> list = null;
				list = sqlSessionTemplate.selectList("master.mdct.selecMasterMdCtBuyerCheck", formData);
				if(list.size() == 0){
					_rtnMsg = "고객사코드 확인 바랍니다.";
					throw new RuntimeException(_rtnMsg);
				}
				//리포트 관리 등록 체크
				List<Map<String,String>> list2 = null;
				list2 = sqlSessionTemplate.selectList("master.mdct.selecMasterMdCtBuyerCheck2", formData);
				if(list2.size() > 0){
					_rtnMsg = formData.get("COM_NAME_LOC")+"("+formData.get("COM_CODE")+ ") 은(는) 리포트 등록 되어있어 등록 불가능 합니다.";
					throw new RuntimeException(_rtnMsg);
				}
				sqlSessionTemplate.update("master.mdct.insertMasterMdCtReportCustomerMng", formData);
			}
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			if("저장 되었습니다.".equals(_rtnMsg)) {
				_rtnMsg = "등록에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	// 리포트매핑 삭제
	@SuppressWarnings("unchecked")
	public String delMasterMdCtReportCustomerList(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "삭제 되었습니다.";
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				//리포트 정보 저장
				sqlSessionTemplate.update("master.mdct.delMasterMdCtReportCustomerList", formData);
			}
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			_rtnMsg = "삭제에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
}
