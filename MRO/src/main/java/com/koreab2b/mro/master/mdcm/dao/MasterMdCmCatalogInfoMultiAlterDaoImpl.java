package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;
 
@Repository("masterMdCmCatalogInfoMultiAlterDao")
@Transactional
public class MasterMdCmCatalogInfoMultiAlterDaoImpl implements MasterMdCmCatalogInfoMultiAlterDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCatalogInfoMultiAlterDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	
	// 카탈로그 일괄수정 조회
	public List<Map<String,String>> getMasterMdCmCatalogInfoMultiAlter(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.getBnttrxlCaInfoList", param);
	}
	
	// 카탈로그 일괄수정 엑셀 업로드
	@SuppressWarnings("unchecked")
	public String batchMasterMdCmCatalogInfoMultiAlter(Map<String, String> param,List<Object> gridData) {
		
		String _rtnMsg = "저장완료 되었습니다.";
	
		try{
			for(int i=0; i < gridData.size(); i++){
				param.putAll((Map<String, String>)gridData.get(i));
				param.put("SEQ", String.valueOf(i));
				LOGGER.debug("batchMasterMdCmCatalogInfoMultiAlter param : {} ", param);
				
				// 업로드 전 초기화
				if(i == 0){
					sqlSessionTemplate.update("master.mdcm.initBntTrxlCaInfoUplolad", param);
				}
				sqlSessionTemplate.update("master.mdcm.setBntTrxlUploadReg", param);
				
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg; 
	}
	
	// 카탈로그 일괄수정 삭제
	@SuppressWarnings("unchecked")
	public String delMasterMdCmCatalogInfoMultiAlter(Map<String, String> param,List<Object> gridData) {
		String _rtnMsg = "삭제완료 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				param.putAll((Map<String, String>)gridData.get(i));
				LOGGER.debug("delMasterMdCmCatalogInfoMultiAlter param : {} ", param);

				sqlSessionTemplate.update("master.mdcm.deleteBntTrxlCaInfo", param);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("삭제완료에 실패하였습니다.");
		}
		return _rtnMsg; 
	}
	
	// 카탈로그 일괄수정 반영대상 검증
	public List<Map<String,String>> getMasterMdCmCatalogInfoBeforeAfter(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.getMasterMdCmCaInfoBeforeAfter", param);
	}
	
	// 카탈로그 일괄수정 품의 상신
	public String requestMasterMdCmCatalogInfoSearchPop(Map<String, String> param,List<Object> gridData) {
		String pm_no = "";
		try{
			
			String com_code = "KRKORE0001";
			pm_no = buyerMpSoOrderInfoDao.getOrderNo(com_code,"PM");
			param.put("PM_NO", pm_no);
			sqlSessionTemplate.update("master.mdcm.setKepmgpdtCaReg", param);	// KEPMGPDT 생성
			sqlSessionTemplate.update("master.mdcm.setKepmgphdCaReg", param);	// KEPMGPHD 생성
			sqlSessionTemplate.update("master.mdcm.initBntTrxlCaInfoUplolad", param);	// 초기화
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("상신완료에 실패하였습니다.");
		}
		return pm_no; 
	}

}
