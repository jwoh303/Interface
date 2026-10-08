package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;


@Repository("masterMdCmCatalogRecharterDao")
@Transactional
public class MasterMdCmCatalogRecharterDaoImpl implements MasterMdCmCatalogRecharterDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCatalogRecharterDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCatalogRecharterList", param);
	}
	
	// 재계약 저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장 되었습니다.";
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("master.mdcm.saveMasterMdCmCatalogRecharter", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장 실패하였습니다.");
		}
		return _rtnMsg;		
	}
	
	// 재계약 취소
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String cancleMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "취소처리 되었습니다.";
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("master.mdcm.cancleMasterMdCmCatalogRecharter", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("취소 실패하였습니다.");
		}
		return _rtnMsg;		
	}

	// 재계약 재요청
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String reqMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "재요청 처리 하였습니다.";
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//기존 차수 종결처리 
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogRecharterRevision", formData);
				//신규차수 Insert
				sqlSessionTemplate.update("master.mdcm.insertMasterMdCmCatalogRecharterRevision", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("재요청 실패하였습니다.");
		}
		return _rtnMsg;		
	}
	
	// 재계약 단가반영 요청
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String approvalMasterMdCmCatalogRecharter(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "단가반영 요청 하였습니다.";
		String pm_no = "";
		try{
			//결재번호 채번
			pm_no = buyerMpSoOrderInfoDao.getOrderNo("KRKORE0001","PM");
			formData.put("PM_NO", pm_no);
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				// 그리드 내용 저장
				sqlSessionTemplate.update("master.mdcm.saveMasterMdCmCatalogRecharter", formData);
				
				formData.put("PM_SEQ", String.valueOf(i+1));
				//KEPMGPDT 결재임시 상태건 삭제(데이터 정리용)
				sqlSessionTemplate.update("master.mdcm.deleteMasterMdCmKepmgpdtRecharter", formData);
				//KEPMGPHD 결재임시 상태건 삭제(데이터 정리용)
				sqlSessionTemplate.update("master.mdcm.deleteMasterMdCmKepmghhdRecharter", formData);
				//KEPMGPDT INSERT
				sqlSessionTemplate.update("master.mdcm.insertMasterMdCmKepmgpdtRecharter", formData);
				if (i == 0){
					//KEPMGPHD INSERT
					sqlSessionTemplate.update("master.mdcm.insertMasterMdCmKepmgphdRecharter", formData); 
				}
				
				// 결재 상신 상태로 변경
				sqlSessionTemplate.update("master.mdcm.approvalMasterMdCmCatalogRecharter", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("단가반영 요청에 실패하였습니다.");
		}
		return pm_no;		
	}
}
