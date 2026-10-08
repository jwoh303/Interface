package com.koreab2b.mro.buyer.mpso.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.koreab2b.mro.rfc.coway.dao.BuyerCowayRfcDao;

@Repository("buyerMpSoDelyReturnCowayDao")
@Transactional
public class BuyerMpSoDelyReturnCowayDaoImpl implements BuyerMpSoDelyReturnCowayDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Autowired
	private BuyerCowayRfcDao buyerCowayRfcDao;

	@Override
	public List<Map<String, String>> selectList(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpso.getBuyerDelyReturnList", formData);
	}

	/**
	 * setReturnPrIns
	 * 코웨이 반납지급요청건 생성 및 전송 처리
	 */
	@Override
	public Map<String, String> setReturnPrIns(List<Map<String, String>> pList) {
		Map<String, String> rtn = new HashMap<String, String>();
		List<Map<String, String>> _pList = new ArrayList<Map<String, String>>();
		String docNo = null;
		int prhdCnt = 0;
		int prdtCnt = 0;
		int eaiCnt	= 0;
		Map<String, String> param = null;
		int seq = 1;
		String returnInfo	= "";
		String[] arrReturnInfo	= null;
		
		try {
			/**
			 * Process Flow
			 * 1. SELECT MBLNR
			 * 1. INSERT INTO ICOMPRDT
			 * 2. INSERT INTO ICOMPRHD
			 * 3. INSERT INTO EAI.IF_COWAY_PR_SEND
			 * 4. SELECT IF DATA
			 */
			String mblnrNo = sqlSessionTemplate.selectOne("buyer.mpso.getMblnrNo");

			for (Map<String, String> map : pList) {
				
				

				param = new HashMap<String, String>();
				param.putAll(map);
				param.put("I_REMBLNR", mblnrNo);
				docNo = map.get("PR_NO");
				
				param.put("DOC_NO", docNo);
				param.put("SEQ", String.valueOf(seq++));

				prdtCnt = sqlSessionTemplate.insert("buyer.mpso.delyReturnPrdtInsert", param);
				if (prdtCnt < 1) {
					throw new Exception("Error : Insert ICOMPRDT Count is 0.");
				}
			}

			param = new HashMap<String, String>();
			param.putAll(pList.get(0));
			param.put("DOC_NO", docNo);
			prhdCnt = sqlSessionTemplate.insert("buyer.mpso.delyReturnPrhdInsert", param);
			if (prhdCnt < 1) 
				throw new Exception("Error : Insert ICOMPRHD Count is 0.");

			eaiCnt = sqlSessionTemplate.insert("buyer.mpso.delyReturnTrxlInsert", param);
			
			param = new HashMap<String, String>();
			param.put("BUYER",		pList.get(0).get("st_buyer"));
			param.put("I_MBNLR",	mblnrNo);
			
			_pList	= sqlSessionTemplate.selectList("buyer.mpso.delyReturnTrxlSelect", param);

			param = new HashMap<String, String>();
			
			param.put("functionName",	pList.get(0).get("functionName"));
			param.put("inTableName",	pList.get(0).get("inTableName"));
			param.put("I_REMBLNR",		mblnrNo);
			param.put("BUYER",		pList.get(0).get("st_buyer"));
			param.put("PR_NO",		docNo);
			
			rtn.putAll(buyerCowayRfcDao.execZmmGsysRerequestCheck(param, _pList));
			
			if ("E".equals(rtn.get("MSGTYPE"))){
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			} else {
				param.put("MSGTYPE", rtn.get("MSGTYPE"));
				param.put("MESSAGE", rtn.get("MESSAGE"));
				sqlSessionTemplate.update("buyer.mpso.delyReturnTrxlUpdate", param);
			}
		} catch (Exception e) {
			rtn.put("MSGTYPE", "E");
			rtn.put("MESSAGE", "오류 확인.");
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		return rtn;
	}

	/**
	 * 문서번호 채번
	 * 
	 * @param comCode
	 * @param docType
	 * @return
	 */
	public String getOrderNo(String comCode, String docType) {
		String orderNo = "";
		Map<String, String> param = new HashMap<String, String>();
		param.put("COM_CODE", comCode);
		param.put("DOC_TYPE", docType);
		List<Map<String, String>> ordrNoList = sqlSessionTemplate.selectList("buyer.mpso.getOrderNo", param);
		for (Map<String, String> ordrNoMap : ordrNoList)
			orderNo = ordrNoMap.get("DOC_NO");
		String statement = "";
		if (ordrNoList.size() == 0) {
			statement = "buyer.mpso.insertSqmt";
			int year_num = Calendar.getInstance().get(Calendar.YEAR);
			String yearStr = String.valueOf(year_num);
			orderNo = docType + yearStr.substring(2, 4) + "000001";
		} else
			statement = "buyer.mpso.updateSqmt";
		sqlSessionTemplate.update(statement, param);
		return orderNo;
	}
}
