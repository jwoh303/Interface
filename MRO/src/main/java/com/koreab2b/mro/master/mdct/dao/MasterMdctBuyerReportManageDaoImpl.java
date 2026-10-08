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

@Repository("masterMdctBuyerReportManageDao")
@Transactional
public class MasterMdctBuyerReportManageDaoImpl implements MasterMdctBuyerReportManageDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdctBuyerReportManageDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdctBuyerReportManageList", param);
	}
	
	// 개별처리
	@SuppressWarnings("unchecked")
	public String updateSelectedProc(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "개별처리 데이터 집계를 시작합니다.\n약 5분 후 확인해보시기 바랍니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				String _RptCnt ="0";
				
				// 당월 승인 기생성건 체크
				_RptCnt = sqlSessionTemplate.selectOne("master.mdct.selectMasterMdCtBuyerReportProcCheck", formData);
				if (Integer.parseInt(_RptCnt) > 0) {
					throw new RuntimeException("이미 승인으로 생성된 건이 있습니다.");
				}
				
				sqlSessionTemplate.update("master.mdct.PKG_REPORT_STATISTICS_CREATE_RG", formData);
			}
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			_rtnMsg = "이미 승인으로 생성된 건이 있습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	
	// 재생성
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "처리 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				//기존데이터 삭제
				sqlSessionTemplate.update("master.mdct.deleteMasterMdctBuyerReportReportDt", formData);
				//리포트 번호 채번
				String st_report_no =  masterMpRqBuyerReqDao.nextVal("KRKORE0001", "RN");
				formData.put("REPORT_NO", st_report_no);
				//데이터 생성
				sqlSessionTemplate.update("master.mdct.insertMasterMdctBuyerReportReportDt", formData);
			}
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
		
	// 품의상신
	@SuppressWarnings("unchecked")
	public String approvalMasterMdctBuyerReportManageList(Map<String,String>  formData, List<Object> gridData) {
		String st_pm_no =  "";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				//리포트 번호 채번
				if(i == 0) {
					st_pm_no =  masterMpRqBuyerReqDao.nextVal("KRKORE0001", "PM");
				}
				String st_pm_seq = String.valueOf(i+1);
				formData.put("PM_NO", st_pm_no);
				formData.put("PM_SEQ", st_pm_seq);
				//KEPMGPDT 생성
				sqlSessionTemplate.update("master.mdct.insertMasterMdctBuyerReportKepmgpDt", formData);
				//KEPMGPHD 생성
				if(i == 0) {
					sqlSessionTemplate.update("master.mdct.insertMasterMdctBuyerReportKepmgpHd", formData);
				}
			}
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return st_pm_no;
	}
}
