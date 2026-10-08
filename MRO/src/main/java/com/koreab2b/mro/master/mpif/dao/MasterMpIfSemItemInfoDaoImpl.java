package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@SuppressWarnings("unchecked")
@Repository("masterMpIfSemItemInfoDao")
@Transactional
public class MasterMpIfSemItemInfoDaoImpl implements MasterMpIfSemItemInfoDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpIfSemItemInfoDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.mpif.selectMasterMpIfSemItemInfoList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}
	
	@Override
	// 수정/저장
	public String updateItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		String _rtnMsg = "";
		
		try {
			/**
			 * update icombyit
			 * udpate keprqdt
			 */
			for(int i = 0 ; i < pGridData.size() ; i++ ){
				pFormData.putAll((Map<String, String>)pGridData.get(i));
				
				if(sqlSessionTemplate.update("updateIcombyitInfoForSem", pFormData)==0) throw new Exception();
				if(sqlSessionTemplate.update("updateKeprqdtInfoForSem", pFormData)==0) throw new Exception();
				pFormData.put("P_MSG", "[수정]");
				sqlSessionTemplate.update("master.mpif.deleteSemItemMasterInfo", pFormData);
				sqlSessionTemplate.update("master.mpif.deleteSemItemDetailInfo", pFormData);
				sqlSessionTemplate.update("master.mpif.deleteSemItemPriceInfo", pFormData);
			}

			_rtnMsg	= "수정되었습니다.";
		} catch (Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("품목정보 수정중 오류가 발생했습니다.");
		}
		return _rtnMsg;
	}
	
	@Override
	// 재견적
	public String requotItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		String _rtnMsg = "";
		
		try {
			/**
			 * update keprqdt
			 * update kepqtdt
			 */
			for(int i = 0 ; i < pGridData.size() ; i++ ){
				pFormData.putAll((Map<String, String>)pGridData.get(i));
				
				if(sqlSessionTemplate.update("requotSemKepqtdtInfo", pFormData)==0) throw new Exception();
				if(sqlSessionTemplate.update("requotSemKeprqdtInfo", pFormData)==0) throw new Exception();
				pFormData.put("P_MSG", "[재견적]");
				if(sqlSessionTemplate.update("master.mpif.deleteSemItemMasterInfo", pFormData)==0) throw new Exception();
				if(sqlSessionTemplate.update("master.mpif.deleteSemItemDetailInfo", pFormData)==0) throw new Exception();
				if(sqlSessionTemplate.update("master.mpif.deleteSemItemPriceInfo", pFormData)==0) throw new Exception();
			}

			_rtnMsg	= "재견적되었습니다.";
		} catch (Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("재견적 처리중 오류가 발생했습니다.");
		}
		return _rtnMsg;
	}
	
	@Override
	// 견적취소
	public String cancelItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		// TODO Auto-generated method stub
		String _rtnMsg = "견적을 취소 하였습니다.";
  		
  		try{
  			for(int i=0; i < pGridData.size(); i++){
  				pFormData.putAll((Map<String, String>)pGridData.get(i));		
  				sqlSessionTemplate.update("master.mpif.deleteSemQuotReceipt", pFormData);
  				logger.error("deleteMasterMpRqReqQuotReceipt_1 실행 완료");
  				
  				/*프로시저 실행*/
  				sqlSessionTemplate.selectList("master.mprq.procQtItemCatalogDelete", pFormData);
  							
  				if("SUCCESS".equals(pFormData.get("RESULT"))){
  					pFormData.put("P_MSG", "[견적취소]"+pFormData.get("CANCEL_REMARK")+" / ");
  					sqlSessionTemplate.update("master.mpif.deleteSemItemMasterInfo", pFormData);
  					sqlSessionTemplate.update("master.mpif.deleteSemItemDetailInfo", pFormData);
  					sqlSessionTemplate.update("master.mpif.deleteSemItemPriceInfo", pFormData);
  				}
  				else if(!"SUCCESS".equals(pFormData.get("RESULT"))){
  					_rtnMsg = "프로시저[PROC_QT_ITEM_CATALOG_DELETE]가 실행되지 못했습니다..";
  					throw new RuntimeException(_rtnMsg);
  				}  				
  			}
  		}catch(Exception e){
  			logger.error("SQL ERROR : ", e);
  			throw new RuntimeException("견적 취소에 실패하였습니다.");
  		}

  		return _rtnMsg;		
	}
}
