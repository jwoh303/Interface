package com.koreab2b.mro.rfc.coway.dao;

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

import com.koreab2b.mro.rfc.coway.controller.SapManager;
import com.koreab2b.mro.rfc.coway.controller.SapManager.SapRfcFunction;
import com.koreab2b.mro.util.CommonUtil;
import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFieldIterator;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoStructure;
import com.sap.conn.jco.JCoTable;
import com.sap.conn.jco.ext.DestinationDataProvider;

/**
 * 출고확정조회 RFC 인터페이스
 * 
 * @author Swordfish
 * @remark PR번호 Receiver
 */
@Repository("buyerCowayRfcDao")
public class BuyerCowayRfcDaoImpl implements BuyerCowayRfcDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public int numberOfRows;
	public int numberOfCols;

	SapManager sap = null;

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerCowayRfcDaoImpl.class);

	public void getRfcConnection(Map<String, String> propsMap) {

		
		if("2".equals(propsMap.get("devRealLocalFlag"))) {
				// 연결 생성
			try {
				this.sap = new SapManager("COWAY").newSapManagerBinder()
						.set(DestinationDataProvider.JCO_CLIENT,	propsMap.get("client"))
						.set(DestinationDataProvider.JCO_USER,		propsMap.get("user"))
						.set(DestinationDataProvider.JCO_PASSWD,	propsMap.get("passwd"))
						.set(DestinationDataProvider.JCO_LANG,		propsMap.get("lang"))
						.set(DestinationDataProvider.JCO_MSHOST,	propsMap.get("mshost"))
						.set(DestinationDataProvider.JCO_MSSERV,	propsMap.get("msserv"))
						.set(DestinationDataProvider.JCO_SYSNR,		propsMap.get("sysnr"))
						.set(DestinationDataProvider.JCO_GROUP,		propsMap.get("group"))
						.set(DestinationDataProvider.JCO_R3NAME,	propsMap.get("r3name"))
						.bind(true);
				
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			try {
				this.sap = new SapManager("COWAY").newSapManagerBinder()
						.set(DestinationDataProvider.JCO_CLIENT,	propsMap.get("client"))
						.set(DestinationDataProvider.JCO_USER,		propsMap.get("user"))
						.set(DestinationDataProvider.JCO_PASSWD,	propsMap.get("passwd"))
						.set(DestinationDataProvider.JCO_LANG,		propsMap.get("lang"))
						.set(DestinationDataProvider.JCO_MSHOST,	propsMap.get("mshost"))
						.set(DestinationDataProvider.JCO_MSSERV,	propsMap.get("msserv"))
						.set(DestinationDataProvider.JCO_SYSNR,		propsMap.get("sysnr"))
						.set(DestinationDataProvider.JCO_GROUP,		propsMap.get("group"))
						.set(DestinationDataProvider.JCO_R3NAME,	propsMap.get("r3name"))
						.bind(true);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * receiveTable
	 * 
	 * @param tables
	 * @return ArrayList
	 * @remark RFC를 통해서 받은 데이터를 ArrayList로 치환하여 반환한다.
	 */
	public List<Map<String, String>> receiveTable(JCoTable tables) {
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		Map<String, String> rowMap = null;
		this.numberOfRows = tables.getNumRows();
		this.numberOfCols = tables.getFieldCount();
		// String[][] result = new String[this.numberOfRows][this.numberOfCols];

		if (this.numberOfRows > 0) {
			int row = 0;
			do {
				rowMap = new HashMap<String, String>();
				for (JCoFieldIterator e = tables.getFieldIterator(); e.hasNextField();) {
					JCoField field = e.nextField();
					rowMap.put(field.getName(), field.getString());
				}
				result.add(row++, rowMap);
			} while (tables.nextRow());
		} else {
			LOGGER.debug("Return:No results found!");
		}

		LOGGER.debug("  result[rows][cols]=" + this.numberOfRows + ":" + this.numberOfCols);

		return result;
	}

	/**
	 * 재고관리 품목 출고, 반납조회
	 */
	@Override
	public List<Map<String, String>> execZmmGsysDeRerDisplay(Map<String, String> paramMap) {
		paramMap.get("functionName");
		String functionName = paramMap.get("functionName");// ZMM_GSYS_DE_RER_DISPLAY
		String tableName = paramMap.get("tableName");// TE_EXPORT
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		LOGGER.debug("# SAP RFC START....");
		LOGGER.debug("# FUNCTION NAME : " + functionName);
		LOGGER.debug("# TABLE NAME    : " + tableName);
		try {
			SapRfcFunction rfc = this.sap.getRfcFunction(functionName);
			
			JCoParameterList input = rfc.function.getImportParameterList();
			input.setValue("I_KEY", 		paramMap.get("i_key")); // 출고:D. 반납:R
			input.setValue("I_BUKRS", 		"2000"); // 회사코드
			input.setValue("I_STEXT",		paramMap.get("i_stext")); // 조직내역
			input.setValue("I_ORGEH",		paramMap.get("i_orgeh")); // 조직코드
			input.setValue("I_RE_MBLNR",	paramMap.get("i_re_mblnr")); // 요청코드번호
			input.setValue("I_BUDAT_FROM",	paramMap.get("i_budat_from")); // 필수값, 지급/반납 요청일
			input.setValue("I_BUDAT_TO",	paramMap.get("i_budat_to")); // 필수값, 지급/반납 요청일
			input.setValue("I_RESTATUS",	paramMap.get("i_restatus")); // 필수값, 처리상태(Y:완료, N:미처리, A:전체, F:반려)
			input.setValue("I_GUBUN",		paramMap.get("i_gubun")); // 필수값, 조회구분(S:스팀기, N: 일반)
			rfc.execute();
			JCoTable tables = rfc.function.getTableParameterList().getTable(tableName);
			result = receiveTable(tables);
			LOGGER.debug("# DATA COUNT    : " + result.size());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 지급(출고)조회 엑셀다운로드용
	 */
	@Override
	public List<Map<String, String>> execZmmGsysDeliveryDisplaySum(Map<String, String> paramMap) {
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		String I_MBLNRS = CommonUtil.nvl(paramMap.get("I_MBLNRS"));
		String[] V_MBLNR = null;
		if (!I_MBLNRS.equals("")) {
			V_MBLNR = I_MBLNRS.split("@@");
		}
		String functionName = paramMap.get("functionName");
		String inTableName = paramMap.get("inTableName");
		String tableName = paramMap.get("tableName");
		try {
			SapRfcFunction rfc = this.sap.getRfcFunction(functionName);
			
			JCoParameterList input = rfc.function.getImportParameterList();
			input.clear();
			input.setValue("I_BUDAT_FROM",	paramMap.get("I_BUDAT_FROM"));
			input.setValue("I_BUDAT_TO",	paramMap.get("I_BUDAT_TO"));
			JCoTable tables = rfc.function.getTableParameterList().getTable(inTableName);
			String MBLNR = "";
			if (V_MBLNR != null) {
				for (int i = 0; i < V_MBLNR.length; i++) {
					MBLNR = V_MBLNR[i];
					tables.appendRow();
					tables.setValue("MBLNR",	MBLNR);
					rfc.execute();
					tables.clear();
				}
			}
			JCoTable tables2 = rfc.function.getTableParameterList().getTable(tableName);
			result = receiveTable(tables2);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 재고관리 품목의 경우 지급(출고)확정 - 한건 이상의 대량 데이터 처리하는 경우
	 */
	@Override
	public Map<String, String> execZmmGsysDeReCheck(Map<String, String> paramMap) {
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		Map<String, String> rtn = new HashMap<String, String>();
		String functionName = paramMap.get("functionName");
		String inTableName = paramMap.get("inTableName");
		String tableName = paramMap.get("tableName");
		String MBLNR = "";
		String I_AENAM = paramMap.get("I_AENAM");
		String I_MBLNRS = paramMap.get("I_MBLNRS");
		String I_DEL_RE = paramMap.get("I_DEL_RE");
		// String st_MBLNR = "";
		// String st_MESSAGE = "";
		String[] V_MBLNR = null;
		if (!I_MBLNRS.equals(""))
			V_MBLNR = I_MBLNRS.split("@@");
		try {
			SapRfcFunction rfc = this.sap.getRfcFunction(functionName);
			
			JCoParameterList input = rfc.function.getImportParameterList();
			input.clear();
			input.setValue("I_AENAM", I_AENAM);
			JCoTable tables = rfc.function.getTableParameterList().getTable(inTableName);
			for (int i = 0; i < V_MBLNR.length; i++) {
				MBLNR = V_MBLNR[i];
				tables.appendRow();
				tables.setValue("DEL_RE",	I_DEL_RE);
				tables.setValue("MBLNR",	MBLNR);
			}
			rfc.execute();
			
			JCoTable tables2 = rfc.function.getTableParameterList().getTable(tableName);
			result = receiveTable(tables2);
			LOGGER.debug("# DATA COUNT    : " + result.size());
			for (Map<String, String> map : result)
				rtn.putAll(map);
			if(result.size() == 0){
				rtn.put("MESSAGE", "NO RESULT");
				rtn.put("MSGTYPE", "E");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return rtn;
	}

	/**
	 * 지급요청한 문서번호가 기준으로 요청 상태 확인
	 */
	@Override
	public List<Map<String, String>> execZmmGsysReqStatusDisplay(Map<String, String> paramMap, List<Map<String, String>> pList) {
		String functionName = paramMap.get("functionName");// ZMM_GSYS_REQ_STATUS_DISPLAY
		String tableName = paramMap.get("tableName");// TE_EXPORT
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		try {
			SapRfcFunction rfc = this.sap.getRfcFunction(functionName);
			JCoParameterList input = rfc.function.getImportParameterList();
			List<Map<String, String>> rfcResult = new ArrayList<Map<String, String>>();
			for (Map<String, String> map : pList) {
				input.setValue("I_MBLNR",	map.get("st_ref_pr_no"));
				rfc.execute();
				JCoTable tables = rfc.function.getTableParameterList().getTable(tableName);
				rfcResult = receiveTable(tables);
				if(rfcResult.size()>0)
					result = checkedData(rfcResult);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	private List<Map<String, String>> checkedData(List<Map<String, String>> rfcResult) {
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		Map<String, String> rowMap = null;
		String ZSTATUS = "";
		String MBLNR = "";
		String MATNR = "";
		String PR_NO = "";
		String BUYER_ITEM_NO = "";
		for (Map<String, String> map : rfcResult) {
			ZSTATUS = map.get("ZSTATUS");
			if (ZSTATUS.equals("X") || ZSTATUS.equals("F")) {
				MBLNR = map.get("MBLNR");
				MATNR = map.get("MATNR");
				rowMap = new HashMap<String, String>();
//				if ("22".substring(0, 2).equals(MBLNR) || "23".substring(0, 2).equals(MBLNR))
//					PR_NO = "PR" + MBLNR.substring(2);
				BUYER_ITEM_NO = MATNR.substring(11);
				rowMap.put("PR_NO", PR_NO);
				rowMap.put("BUYER_ITEM_NO", BUYER_ITEM_NO);
				rowMap.put("ZSTATUS", ZSTATUS);
				result.add(rowMap);
			}
		}
		return result;
	}

	/**
	 * 반납 요청 체크 및 저장
	 */
	@Override
	public Map<String, String> execZmmGsysRerequestCheck(Map<String, String> paramMap, List<Map<String, String>> pList) {
		Map<String, String> rtn = new HashMap<String, String>();
		
		String functionName = paramMap.get("functionName");
		String inTableName = paramMap.get("inTableName");
		String I_REMBLNR = "";
		String I_SRC = "";

		String MESSAGE = "";
		try {
			I_REMBLNR = paramMap.get("I_REMBLNR");
			
			SapRfcFunction rfc = this.sap.getRfcFunction(functionName);
			
			JCoParameterList input = rfc.function.getImportParameterList();

			input.clear();
			input.setValue("I_REMBLNR",	I_REMBLNR);
			input.setValue("I_AENAM",	pList.get(0).get("I_AFNAM"));
			input.setValue("I_STATUS",	pList.get(0).get("I_STATUS"));
			input.setValue("I_SRC",		I_SRC);
			JCoTable tables = rfc.function.getTableParameterList().getTable(inTableName);
			tables.clear();
			
			for (Map<String, String> map : pList) {
				tables.appendRow();
				tables.setValue("MBLNR",	map.get("MBLNR"));
				tables.setValue("BUKRS",	map.get("BUKRS"));
				tables.setValue("ORGEH",	map.get("ORGEH"));
				tables.setValue("PERNR",	map.get("PERNR"));
				tables.setValue("ZCODE",	map.get("ZCODE"));
				tables.setValue("MATNR",	map.get("MATNR"));
				tables.setValue("REMENGE",	String.valueOf(map.get("REMENGE")));
				tables.setValue("YUMUSANG",	map.get("YUMUSANG"));
				tables.setValue("KONGU_STA","E");
			}
			rfc.execute();
			JCoStructure detail = rfc.function.getExportParameterList().getStructure("E_RETURN");
			rtn.put("MSGTYPE", detail.getString(0));
			rtn.put("MESSAGE", detail.getString(1));
			detail.clear();

		} catch (Exception e) {
			MESSAGE = e.getMessage();
			rtn.put("MSGTYPE", "E");
			rtn.put("MESSAGE", MESSAGE);
			e.printStackTrace();
		}
		return rtn;
	}

	/**
	 * 수수료 대표코드 및 자재 마스터 전송
	 */
	@Override
	public List<Map<String, String>> execZmmClsiteGirequestDisplay(Map<String, String> paramMap) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 지급요청 체크 및 저장
	 * (주문생성 I/F 1. 주문생성 목록에서 신규 이벤트를 조회한다. 2. 조회된 항목을 기준으로 상세 정보를 확인한다. 3. 상세정보를 전송 후 후처리 로직을 통해서 이벤트 이력 및 상태를 관리한다.)
	 */
	@Override
	@Transactional
	public Map<String, String> execZmmGsysGirequestCheck(Map<String, String> paramMap) {
		String buyer = paramMap.get("buyer");
		String prNo = paramMap.get("prNo");
		String functionName = paramMap.get("functionName");// ZMM_GSYS_GIREQUEST_CHECK
		String inTableName = paramMap.get("inTableName");// TI_IMPORT
		String outTableName = paramMap.get("tableName");// TE_EXPORT
		List<Map<String, String>> sendList = new ArrayList<Map<String, String>>();
		List<Map<String, String>> sendData = new ArrayList<Map<String, String>>();
		List<Map<String, String>> rtnData = new ArrayList<Map<String, String>>();
		Map<String, String> rtn = new HashMap<String, String>();
		String I_AFNAM = "";
		String I_BDC = "";
		String I_MBLNR = "";
		String I_STATUS = "";
		LOGGER.debug("********************************************");
		LOGGER.debug("* BUYER : " + buyer);
		LOGGER.debug("* PR_NO : " + prNo);
		LOGGER.debug("############################################");
		LOGGER.debug("# SAP RFC START....");
		LOGGER.debug("# FUNCTION NAME : " + functionName);
		try {
			SapRfcFunction rfc = this.sap.getRfcFunction(functionName);
			JCoParameterList input = rfc.function.getImportParameterList();
//			sendList.addAll(paramList);
			sendList = getPrInterfaceTargetList(paramMap);
			for (Map<String, String> map : sendList) {
				input.clear();
				buyer = map.get("BUYER");
				prNo = map.get("PR_NO");
				I_AFNAM = map.get("I_AFNAM");
				I_MBLNR = map.get("I_MBLNR");
				I_STATUS = map.get("I_STATUS");
				I_BDC = map.get("I_BDC");
				input.clear();
				input.setValue("I_AFNAM",	I_AFNAM);
				input.setValue("I_MBLNR",	I_MBLNR);
				input.setValue("I_STATUS",	I_STATUS);
				input.setValue("I_BDC",		I_BDC);
				sendData = getPrCreateDataList(map);
				JCoTable tables = rfc.function.getTableParameterList().getTable(inTableName);
				tables.clear();
				for (Map<String, String> sendParam : sendData) {
					tables.appendRow();
					tables.setValue("BUKRS",	sendParam.get("BUKRS"));
					tables.setValue("ORGEH",	sendParam.get("ORGEH"));
					tables.setValue("STEXT",	sendParam.get("STEXT"));
					tables.setValue("PERNR",	sendParam.get("PERNR"));
					tables.setValue("ENAME",	sendParam.get("ENAME"));
					tables.setValue("HDATE",	sendParam.get("HDATE"));
					tables.setValue("ZGISU",	sendParam.get("ZGISU"));
					tables.setValue("NEWCK",	sendParam.get("NEWCK"));
					tables.setValue("ZCODE",	sendParam.get("ZCODE"));
					tables.setValue("MATNR",	sendParam.get("MATNR"));
					tables.setValue("MAKTX",	sendParam.get("MAKTX"));
					tables.setValue("GIMENGE",	sendParam.get("GIMENGE"));
					tables.setValue("MEINS",	sendParam.get("MEINS"));
					tables.setValue("GUBUN",	sendParam.get("GUBUN"));
					tables.setValue("ERSDA",	sendParam.get("ERSDA"));
					tables.setValue("ERNAM",	sendParam.get("ERNAM"));
					tables.setValue("LAEDA",	sendParam.get("LAEDA"));
					tables.setValue("AENAM",	sendParam.get("AENAM"));
					tables.setValue("YUMUSANG",	"N");
					tables.setValue("DRSITE",	"Y");
					tables.setValue("DRCP",		"C");
					tables.setValue("DPOINT",	"0");
					tables.setValue("POST_CODE1",	sendParam.get("POST_CODE1"));
					tables.setValue("CITY1",		sendParam.get("CITY1"));
					tables.setValue("STREET",		sendParam.get("STREET"));
					tables.setValue("TEL_NUMBER",	sendParam.get("TEL_NUMBER"));
					tables.setValue("MOB_NUMBER",	sendParam.get("MOB_NUMBER"));
				}
				rfc.execute();
				JCoTable output_table = rfc.function.getTableParameterList().getTable(outTableName);
				rtnData = receiveTable(output_table);
				if(rtnData.size()>0){
					rtn.putAll(rtnData.get(0));
				}
				setResult(buyer, prNo, rtn.get("MSGTYPE"), rtn.get("MESSAGE"));
				output_table.clear();
				LOGGER.debug("--------------------------------------------");
			}
			if(sendList.size() < 1){
				rtn.put("MSGTYPE", "S");
				rtn.put("MESSAGE", "sap 처리대상 아님");
			}
				
		} catch (Exception e) {
			e.printStackTrace();
			rtn.put("MSGTYPE", "E");
			rtn.put("MESSAGE", e.getMessage());
			LOGGER.error(e.getMessage());
		}
		LOGGER.debug("# SAP RFC END....");
		LOGGER.debug("############################################");
		return rtn;
	}

	/**
	 * 조회된 항목을 기준으로 상세 정보를 확인한다.(sap전송용)
	 * 
	 * @param param
	 * @return
	 */
	private List<Map<String, String>> getPrCreateDataList(Map<String, String> param) {
		return sqlSessionTemplate.selectList("rfc.coway.getPrCreateDataList", param);
	}

	/**
	 * 주문생성 목록에서 신규 이벤트를 조회한다.
	 * @param param
	 * @return
	 */
	private List<Map<String, String>> getPrInterfaceTargetList(Map<String, String> param) {
		return sqlSessionTemplate.selectList("rfc.coway.getPrInterfaceTargetList", param);
	}

	/**
	 * 처리결과 저장
	 * 
	 * @param buyer
	 * @param prNo
	 * @param MSGTYPE
	 * @param MESSAGE
	 */
	private void setResult(String buyer, String prNo, String MSGTYPE, String MESSAGE) {
		Map<String, String> param = new HashMap<String, String>();
		param.put("BUYER", buyer);
		param.put("PR_NO", prNo);
		param.put("MESSAGE", MESSAGE);
		String ifFlag = "";
		if ("S".equals(MSGTYPE))
			ifFlag = "Y";
		else
			ifFlag = "A";
		param.put("IF_FLAG", ifFlag);
		sqlSessionTemplate.update("rfc.coway.mergeIfProgress", param);
		sqlSessionTemplate.update("rfc.coway.insertIcomtrxl", param);
	}

	/**
	 * 반납 요청 저장 전 송장처리 체크
	 */
	@Override
	public Map<String, String> execZmmGsysRerequestIvCheck(Map<String, String> paramMap, List<Map<String, String>> pList) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 재고관리 품목의 경우 지급(출고)확정 - 한건씩 처리하는 경우
	 */
	@Override
	public List<Map<String, String>> execZmmGsysDeliveryCheck(Map<String, String> paramMap) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 재고관리 품목 조회
	 */
	@Override
	public List<Map<String, String>> execZmmGsysDeliveryDisplay(Map<String, String> paramMap) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 월별 지급 신청 내역
	 */
	@Override
	public List<Map<String, String>> execZmmGsysReqList(Map<String, String> paramMap) {
		// TODO Auto-generated method stub
		return null;
	}

}