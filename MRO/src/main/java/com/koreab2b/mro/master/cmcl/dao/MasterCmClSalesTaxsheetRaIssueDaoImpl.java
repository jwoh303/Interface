package com.koreab2b.mro.master.cmcl.dao;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.io.Writer;
import java.sql.Clob;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.koreab2b.mro.util.AesCryptoAlgorithmUtil;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@SuppressWarnings("unchecked")
@Repository("masterCmClSalesTaxRaReqSumDao")
@Transactional
public class MasterCmClSalesTaxsheetRaIssueDaoImpl implements MasterCmClSalesTaxsheetRaIssueDao {
	private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<Map<String, String>> selectList(Map<String, Object> pParam) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.cmcl.selectMasterCmClSalesTaxsheetRaIssueList", pParam, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	@Override
	public List<Map<String, String>> getRaIssueFormat(Map<String, Object> pParam) {
		
		List<Map<String, String>> rtnMap = new ArrayList<Map<String, String>>();
		String certPassword = "";
		String bizIrsNo = "";
		Map<String, String> map =  new HashMap<String, String>();
		String _xml_content = "";
		String _conversation_id = "";
		String _issue_date	= "";
		
		/**
		 * My_list 정보를 조회. Conversation_id 로 확인.
		 */
		
		List<Map<String, Object>> data = sqlSessionTemplate.selectList("selectRaIssueXmlData", pParam);
		
		if (data != null && data.size() > 0) {
			
			Clob _xmlData = (Clob)data.get(0).get("DATAXML");
			

			try {
				_xml_content = _xmlData.getSubString(1, (int)_xmlData.length());
			} catch (SQLException e) {
				e.printStackTrace();
			}
			_conversation_id = (String)pParam.get("param1");
			_issue_date = sqlSessionTemplate.selectOne("master.cmcl.getYyyymmdd", "");
		}
		
		try {
			if(bizIrsNo.equals("1358551796")){//경기MRO
				certPassword = AesCryptoAlgorithmUtil.Encrypt("koreab2b!!", "sBcertNonStd");
			}else{
				certPassword = AesCryptoAlgorithmUtil.Encrypt("koreab2b", "sBcertNonStd");
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		try {
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = dbf.newDocumentBuilder();   		    		
    		
    		Document _xml = builder.parse(new ByteArrayInputStream(_xml_content.getBytes("UTF-8")));
			XPath xpath = XPathFactory.newInstance().newXPath();
    		
			NodeList items = (NodeList)xpath.evaluate("//TaxInvoice/ExchangedDocument/IssueDateTime", _xml, XPathConstants.NODESET);
    		Node issueDateTime = items.item(0);
    		issueDateTime.setTextContent(_issue_date);
    		
    		Transformer tf = TransformerFactory.newInstance().newTransformer();
    		tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
    		tf.setOutputProperty(OutputKeys.INDENT,"yes");
    		Writer out = new StringWriter();
    		tf.transform(new DOMSource(_xml), new StreamResult(out));

    		_xml_content	= out.toString();
    		
    		//System.out.println("_xml_content : " + _xml_content);
    		
		} catch (Exception e) {
			LOGGER.error("Xml Parsing Error" + CommonUtil.printStackTraceToString(e));
		}
		
		map.put("SEND_FORMAT"	,_xml_content);
		map.put("SERT_PASSWORD"	,certPassword);
		map.put("CON_ID"		,_conversation_id);
		map.put("REQUEST_TIME"	,_issue_date);
		map.put("SMARTBILL_URL"	,(String)pParam.get("smartBillUrl"));
		
		rtnMap.add(map);
		
		return rtnMap;
	}

	@Override
	public String delSelectedData(Map<String, String> pFormData, List<Object> pGridData) {
		/**
		 * 삭제 기능
		 * 1. 체크로직
		 *  - 삭제가능 조건 : 발행취소 상태만 가능함.
		 * 2. 삭제처리
		 *  - keptardt.status = 'D'
		 *  - icomgrdt rollback
		 *  - buyer_ar_comp.if_flag = 'D'
		 */
		String _rtnMsg = "삭제 처리 완료 되었습니다.";
		
		try {
			for ( int i = 0 ; i < pGridData.size() ; i++ ) {
				
				pFormData.putAll((Map<String, String>)pGridData.get(i));
				
				List<Map<String,String>> chkCnt = sqlSessionTemplate.selectList("master.cmcl.selectRaIssueCheckCnt", pFormData);
				
				if (chkCnt.size() == 0) {
					_rtnMsg = "발행취소건만 삭제 가능합니다.";
					throw new RuntimeException("발행취소건만 삭제 가능합니다.");
				}
				
				sqlSessionTemplate.update("master.cmcl.updateRaIssueDelete_KEPTARDT"		, pFormData);	// 매출삭제
				sqlSessionTemplate.update("master.cmcl.updateRaIssueDelete_ICOMGRDT"		, pFormData);	// 입고초기화
				sqlSessionTemplate.update("master.cmcl.updateRaIssueDelete_BUYER_AR_COMP"	, pFormData);	// 마감정산내역 삭제처리.
				sqlSessionTemplate.update("master.cmcl.deleteRaIssueDelete_MY_LIST"			, pFormData);	// 마감정산내역 삭제처리.
			}
		} catch (Exception e) {
			
			LOGGER.error("Error : " + CommonUtil.printStackTraceToString(e));
			
			if(!"삭제 처리 완료 되었습니다.".equals(_rtnMsg)){
				throw new RuntimeException(_rtnMsg);
			}else{
				LOGGER.error("MasterCmClSalesTaxsheetRaIssueDao delSelectedData Error : ", CommonUtil.printStackTraceToString(e));
				throw new RuntimeException("\n\n[ 삭제 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
		}
		return _rtnMsg;
	}
}
