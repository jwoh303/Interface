package com.koreab2b.mro.master.mprq.dao;

import java.util.ArrayList;
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

@Repository("MasterMpRqQuotationBulkItemProjectListDao")
@Transactional
public class MasterMpRqBulkQuotationProjectListDaoImpl implements MasterMpRqBulkQuotationProjectListDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationProjectListDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {

		//진행상태코드
		param.put("st_project_status_all", CommonUtil.getStringArrary((String) param.get("st_project_status"), ","));
		//부서코드
		param.put("st_kep_dept_all", CommonUtil.getStringArrary((String) param.get("st_kep_dept"), ","));
	
		// update 할게 1개 이상이면 update
		int cnt = sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqBulkQuotationProjectCnt", param);
		
		if(cnt != 0) {
			sqlSessionTemplate.update("master.mprq.updateMasterMpRqBulkQuotationProjectStatus", param);
		}
		
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationProjectList", param);
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateData(Map<String,Object> param) {
		
		try{
			// STEP1 KEP_BURQ_MNG 상태 업데이트
			int cnt = sqlSessionTemplate.update("master.mprq.abortBulkQuotation", param);
			if(cnt < 0) {
				_rtnMsg = "프로젝트 중단에 실패하였습니다. "+param.get("st_burq_no") +" 프로젝트 상태를 확인해보세요";
			}
			
			// STEP2 KEP_BURQ_RFQ 진행중인 요청 건 취소처리 
			sqlSessionTemplate.update("master.mprq.abortBulkQuotationRFQ", param);
			
		} catch (Exception e){
			_rtnMsg = "Error";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장 하던중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}
		
		return _rtnMsg;
	}

}
