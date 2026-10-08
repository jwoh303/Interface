package com.koreab2b.mro.common.mprq.dao;

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

@Repository("MasterMpRqBulkQuotationItemRegPopDao")
@Transactional
public class MasterMpRqBulkQuotationItemRegPopDaoImpl implements MasterMpRqBulkQuotationItemRegPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationItemRegPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 엑셀 업로드
	@SuppressWarnings("unchecked")
	public String batchdata(Map<String, String> param, List<Object> gridData) {
		
		_rtnMsg = "저장완료 되었습니다.";
	
		String type = param.get("st_project_unit");
		try{
			for(int i=0; i < gridData.size(); i++){
				param.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("batchMasterMpRqBulkQuotationItemReg param : {} ", param);
				
				// 업로드 전 초기화
				if(i == 0){
					sqlSessionTemplate.update("master.mprq.initBntTrxlBuRqItemUplolad", param);
				}
//				if(!param.get("BUYER_CODE").equals("") && !param.get("BYIT_COMORG_CODE").equals("") &&!param.get("BUYER_ITEM_NO").equals("") 
//						&&!param.get("CONTRACT_NO").equals("") &&!param.get("CONTRACT_SEQ").equals("") && !param.get("AGENT_CODE").equals("") &&
//						!param.get("PO_CNT").equals("")  &&!param.get("QTY").equals("")  &&!param.get("RE_LIST_PRICE").equals("") &&!param.get("MAIN_BUYER").equals("")) {
//					continue;
//				}
				if (type.equals("B")) { //고객사인 경우
					sqlSessionTemplate.update("master.mprq.setBntTrxlUploadRegBuyer", param);
				}else { // 그룹사인 경우
					sqlSessionTemplate.update("master.mprq.setBntTrxlUploadRegGroup", param);
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg; 
	}
	
	@Override
	public List<Map<String, String>> selectdata(Map<String, String> param) {
		String type = param.get("st_project_unit");
		List<Map<String, String>> _rtn = new ArrayList<Map<String, String>>();
		try{
			if (type.equals("B")) { //고객사인 경우
				_rtn = sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationItemRegBuyer", param);
			}else {
				_rtn = sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationItemRegGroup", param);
			}
		
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtn;
	}

	@Override
	public String savedata(Map<String, String> param) {
		_rtnMsg = "저장완료 되었습니다.";
		try{
			LOGGER.debug("saveMasterMpRqBulkQuotationItemReg.savedata param : {} ", param);
			
			// KEP_BURQ_ITEM 에 insert
			int cnt = sqlSessionTemplate.update("master.mprq.insertMasterMpRqBulkQuotationItem", param);
			
			// 제대로 insert 되면 update
			if(cnt > 0) {
				// 아직 SG 소싱개시 상태인 경우에만 업데이트
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqBulkQuotationProjectStatus_1", param);
				
				// 기존협력사로 RFQ 테이블에한줄 쌓음 (이후 KeP품목정보 등록을 위해)
				String type = param.get("st_project_unit");
				if (type.equals("B")) { //고객사인 경우
					sqlSessionTemplate.update("master.mprq.insertMasterMpRqBulkQuotationRfqBuyerInit", param);
				}  else {
					sqlSessionTemplate.update("master.mprq.insertMasterMpRqBulkQuotationRfqGroupInit", param);
				}
			}
		
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg;
	}	



}
