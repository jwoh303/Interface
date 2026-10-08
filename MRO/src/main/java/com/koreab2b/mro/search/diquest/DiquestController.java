package com.koreab2b.mro.search.diquest;

import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.diquest.ir.client.command.CommandSearchRequest;
import com.diquest.ir.client.util.RequestHandler;
import com.diquest.ir.common.msg.ext.body.common.ErrorMessage;
import com.diquest.ir.common.msg.protocol.Protocol;
import com.diquest.ir.common.msg.protocol.query.FilterSet;
import com.diquest.ir.common.msg.protocol.query.Query;
import com.diquest.ir.common.msg.protocol.query.QueryParser;
import com.diquest.ir.common.msg.protocol.query.QuerySet;
import com.diquest.ir.common.msg.protocol.result.Result;
import com.diquest.ir.common.msg.protocol.result.ResultSet;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.search.diquest.catalog.AutoOrderByPhrase;
import com.koreab2b.mro.search.diquest.catalog.AutoSelectPhrase;
import com.koreab2b.mro.search.diquest.catalog.AutoWherePhrase;
import com.koreab2b.mro.search.diquest.catalog.GroupByPhrase;
import com.koreab2b.mro.search.diquest.catalog.OrderByPhrase;
import com.koreab2b.mro.search.diquest.catalog.ResultData;
import com.koreab2b.mro.search.diquest.catalog.ResultGroup;
import com.koreab2b.mro.search.diquest.catalog.SelectPhrase;
import com.koreab2b.mro.search.diquest.catalog.WherePhrase;
import com.koreab2b.mro.search.diquest.combine.CombineWherePhrase;


@Controller("diquestController")
public class DiquestController {

	private static final Logger LOGGER = LoggerFactory.getLogger(DiquestController.class);

	@Value("#{diquestProps['diquest.admin.ip']}")
	private String adminIp;
	
	@Value("#{diquestProps['diquest.dqcat.ip']}")
	private String adminIp2;
	
	@Value("#{diquestProps['diquest.admin.port']}")
	private String adminPort;

	@Value("#{diquestProps['diquest.collection.dev.name']}")
	private String collentionDevName; 
	
	@Value("#{diquestProps['diquest.collection.real.name']}")
	private String collentionRealName; 
	
	@Value("#{diquestProps['diquest.collection.dev.smartmake.name']}")
	private String smartmakeCollentionDevName; 
	
	@Value("#{diquestProps['diquest.collection.real.smartmake.name']}")
	private String smartmakeCollentionRealName; 
	 
	public String getCollentionName(HttpServletRequest pRequest) {
		String flag = CommonUtil.getDevRealLocalFlag(pRequest); // 0 로컬 1 개발 2 운영
		
		LOGGER.debug(" getCollentionName 0 로컬 1 개발 2 운영 : {}", flag);
		
		if ("2".equals(flag)){
			return collentionRealName;
		}else{
			//return collentionDevName;
			return collentionRealName;
		}
	}
	
	public String getSmartmakeCollentionName(HttpServletRequest pRequest) {
		String flag = CommonUtil.getDevRealLocalFlag(pRequest); // 0 로컬 1 개발 2 운영
		
		LOGGER.debug(" getCollentionName 0 로컬 1 개발 2 운영 : {}", flag);
		
		if ("2".equals(flag)){
			return smartmakeCollentionRealName;
		}else{
			return smartmakeCollentionDevName;		
		}
	}
 

	@RequestMapping(value = "/search/sample.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String search(HttpServletRequest pRequest, HttpServletResponse pResponse, ModelMap pModel) throws Exception {
		RequestHandler _requestHandler = new RequestHandler(pRequest, pRequest.getSession().getServletContext(),"utf-8");
		String _searchTerm = _requestHandler.getParameter("searchTerm", "");
		
		LOGGER.debug(" 검색어 : {}", _searchTerm);

		if ("".equals(_searchTerm)) {
			LOGGER.debug("검색어가 존재 하지 않습니다!");
			return "sample/searchSample";
		}

		int _rowsperPage = Integer.parseInt(_requestHandler.getParameter("rowsperPage", "10"));
		int _currentPage = Integer.parseInt(_requestHandler.getParameter("currentPage", "1"));

		Query _query = new Query("<b>", "</b>");
		_query.setDebug(true); 
		_query.setFrom(getCollentionName(pRequest));
		_query.setSearchOption(Protocol.SearchOption.CACHE);
		_query.setLoggable(true);
		_query.setResult((_currentPage - 1) * _rowsperPage, ((_currentPage - 1) * _rowsperPage) + (_rowsperPage - 1));
		_query.setFaultless(true);
		_query.setPrintQuery(true);

		SelectPhrase _selectColumn = new SelectPhrase();
		_query.setSelect(_selectColumn.get());

		WherePhrase _conditions = new WherePhrase();
		_query.setWhere(_conditions.get(_requestHandler,false));

		OrderByPhrase _orderBy = new OrderByPhrase();
		_query.setOrderby(_orderBy.get(_requestHandler));

		GroupByPhrase _groupBy = new GroupByPhrase();
		_query.setGroupBy(_groupBy.get(_requestHandler));

		QuerySet querySet = new QuerySet(1);
		querySet.addQuery(_query);
		//검색엔진 이중화 작업
		String realAdminIp = "";
		if( isConnectAble( adminIp, Integer.parseInt(adminPort), 1000 ) ) {
			realAdminIp = adminIp;
		} else if( isConnectAble( adminIp2, Integer.parseInt(adminPort), 1000 ) ) {
			realAdminIp = adminIp2;
		}
		LOGGER.debug("realAdminIp: {}", realAdminIp);
		CommandSearchRequest _command = new CommandSearchRequest(realAdminIp, Integer.parseInt(adminPort));
		int _returnCode = _command.request(querySet);

		if (_returnCode >= 0) {
			ResultSet _resultSet = _command.getResultSet();
			Result[] _resultList = _resultSet.getResultList();

			ResultData _searchResult = new ResultData();
			pModel.addAttribute("totalList", _searchResult.getTotalList(_query.getSelectFields(), _resultList));

			ResultGroup _resultGroup = new ResultGroup(_resultList[_resultList.length - 1]);
			pModel.addAttribute("groupAList", _resultGroup.getGroupAList());
			pModel.addAttribute("groupBList", _resultGroup.getGroupBList());

		} else {
			ErrorMessage _errorMessage = _command.getException();
			String _errorMsg = _errorMessage.getErrorMessage();
			LOGGER.error("search Error Code : {} ", _returnCode);
			LOGGER.error("search Error Msg  : {}", _errorMsg);
		}

		return "sample/searchSample";
	}

	/**
	 * 상품검색
	 * 
	 * @param request
	 * @param response
	 * @param pModel
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mdcm/getBuyerMdCmGoodsDiLisList.do", method = { RequestMethod.POST })
	public String getBuyerMdCmGoodsDiLisList(HttpServletRequest pRequest, HttpServletResponse response, ModelMap pModel) throws Exception { 
		RequestHandler _requestHandler = new RequestHandler(pRequest, pRequest.getSession().getServletContext(),"utf-8");
	 /*
		if ("".equals(_requestHandler.getParameter("searchTerm", ""))) {
		//	return "buyer/mdcm/buyerMdCmGoodsDiLisList";
		}
	  */
		
		//LOGGER.error("getBuyerMdCmGoodsDiLisList start: {} ", _requestHandler);  

		
		int _rowsperPage = 0;
		SessionInfo _sessionInfo = (SessionInfo) _requestHandler.getSession().getAttribute("sessionInfo");
		String uiVersion = (String) pRequest.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) { //리뉴얼에선 해당 값 없으면 디폴트 30
			String rowCnt = _requestHandler.getParameter("onepagerow", _sessionInfo.getRowCnt());
			String pageString = "30,50,100,200,500,1000";
			if(!Arrays.asList(pageString.split(",")).contains(rowCnt)){
				rowCnt = "30";
			}
			_rowsperPage = Integer.parseInt(rowCnt);
		}else{
			_rowsperPage = Integer.parseInt(_requestHandler.getParameter("onepagerow", "10"));
		}
		
		int _currentPage = Integer.parseInt(_requestHandler.getParameter("curPage", "1"));
		int _totalSize = 0;
		
		List<Map<String,String>> tmpData = new ArrayList<Map<String,String>>();
		Query _query = new Query("<b>", "</b>");
		_query.setDebug(true);
		_query.setFrom(getCollentionName(pRequest));

		_query.setThesaurusOption((byte)(Protocol.ThesaurusOption.EQUIV_SYNONYM | Protocol.ThesaurusOption.QUASI_SYNONYM));
		_query.setSearchOption(Protocol.SearchOption.CACHE);
		_query.setLoggable(true);
		_query.setResult((_currentPage - 1) * _rowsperPage, ((_currentPage - 1) * _rowsperPage) + (_rowsperPage - 1));
		_query.setFaultless(true);
		_query.setPrintQuery(true);

		SelectPhrase _selectColumn = new SelectPhrase();
		_query.setSelect(_selectColumn.get());

		WherePhrase _conditions = new WherePhrase();
		_query.setWhere(_conditions.get(_requestHandler,false));

		OrderByPhrase _orderBy = new OrderByPhrase();
		_query.setOrderby(_orderBy.get(_requestHandler));

		GroupByPhrase _groupBy = new GroupByPhrase();
		_query.setGroupBy(_groupBy.get(_requestHandler));

		QuerySet querySet = new QuerySet(1);
		querySet.addQuery(_query);
		 QueryParser parser = new QueryParser();
		 pModel.addAttribute("searchWhereStr", parser.whereSetToString(_conditions.get(_requestHandler,false)));
		LOGGER.debug("searchWhereStr2: {}", parser.whereSetToString(_conditions.get(_requestHandler,false)));
		//검색엔진 이중화 작업
		String realAdminIp = "";
		if( isConnectAble( adminIp, Integer.parseInt(adminPort), 1000 ) ) {
			realAdminIp = adminIp;
		} else if( isConnectAble( adminIp2, Integer.parseInt(adminPort), 1000 ) ) {
			realAdminIp = adminIp2;
		}
		LOGGER.debug("realAdminIp: {}", realAdminIp);
		CommandSearchRequest _command = new CommandSearchRequest(realAdminIp, Integer.parseInt(adminPort));
		int _returnCode = _command.request(querySet);

		if (_returnCode >= 0) {
			ResultSet _resultSet = _command.getResultSet();
			Result[] _resultList = _resultSet.getResultList();

			ResultData _searchResult = new ResultData();
			pModel.addAttribute("data", _searchResult.getTotalList(_query.getSelectFields(), _resultList));
			tmpData = _searchResult.getTotalList(_query.getSelectFields(), _resultList);

			ResultGroup _resultGroup = new ResultGroup(_resultList[_resultList.length - 1]);
			pModel.addAttribute("data_MAKER", _resultGroup.getGroupAList());
			pModel.addAttribute("data_CATEGORY", _resultGroup.getGroupBList());

			Result _result = null;
			for (int m = 0; _resultList != null && m < _resultList.length; m++) {
				_result = _resultList[m];
				_totalSize = _result.getTotalSize();
			}
			pModel.addAttribute("totalCnt", String.valueOf(_totalSize));

		} else {
			ErrorMessage _errorMessage = _command.getException();
			String _errorMsg = _errorMessage.getErrorMessage();
			LOGGER.error("getBuyerMdCmGoodsDiLisList Error Code : {} ", _returnCode);
			LOGGER.error("getBuyerMdCmGoodsDiLisList Error Msg  : {}", _errorMsg);
		}
		String stResearchFlag = _requestHandler.getParameter("st_research_flag", "N");
		String stSearchTern = _requestHandler.getParameter("searchTerm", "");
		//XSS 취얌점 대응 nvl 처리.
		String stsearchResultKeyword = CommonUtil.nvl(_requestHandler.getParameter("resultKeyword", ""));
		String stSearchKeyWord = CommonUtil.nvl(_requestHandler.getParameter("searchKeyWord", ""));
		LOGGER.debug("stResearchFlag : {} ", stResearchFlag);
		LOGGER.debug("stSearchTern  : {}", stSearchTern);
		LOGGER.debug("stSearchKeyWord  : {}", stSearchKeyWord);

		pModel.addAttribute("searchKeyWord", stSearchTern);
		pModel.addAttribute("searchResultKeyword", stsearchResultKeyword);
		pModel.addAttribute("searchTargetIDX_CATEGORY_NO",_requestHandler.getParameter("searchTargetIDX_CATEGORY_NO"));
		
		//검색화면내 카테고리,제조사 선택하는 경우(필터링 효과 내야됨)
		if((_requestHandler.getParameter("st_sub_flag").equals("Y") && !_requestHandler.getParameter("st_maker").equals("")) || (_requestHandler.getParameter("st_sub_flag").equals("Y") && !_requestHandler.getParameter("st_categoty_name").equals(""))){
			int _totalSize2 = 0;
			Query _query2 = new Query("<b>", "</b>");
			_query2.setDebug(true);
			_query2.setFrom(getCollentionName(pRequest));

			_query2.setThesaurusOption((byte)(Protocol.ThesaurusOption.EQUIV_SYNONYM | Protocol.ThesaurusOption.QUASI_SYNONYM));
			_query2.setSearchOption(Protocol.SearchOption.CACHE);
			_query2.setLoggable(true);
			_query2.setResult((_currentPage - 1) * _rowsperPage, ((_currentPage - 1) * _rowsperPage) + (_rowsperPage - 1));
			_query2.setFaultless(true);
			_query2.setPrintQuery(true);

			_query2.setSelect(_selectColumn.get());

			_query2.setWhere(_conditions.get(_requestHandler,true));

			_query2.setOrderby(_orderBy.get(_requestHandler));

			_query.setGroupBy(_groupBy.get(_requestHandler));

			QuerySet querySet2 = new QuerySet(1);
			querySet2.addQuery(_query2);
			int _returnCode2 = _command.request(querySet2);

			if (_returnCode2 >= 0) {
				ResultSet _resultSet2 = _command.getResultSet();
				Result[] _resultList2 = _resultSet2.getResultList();

				ResultData _searchResult2 = new ResultData();
				pModel.addAttribute("data", _searchResult2.getTotalList(_query2.getSelectFields(), _resultList2));
				tmpData = _searchResult2.getTotalList(_query2.getSelectFields(), _resultList2);
				
				Result _result2 = null;
				for (int m = 0; _resultList2 != null && m < _resultList2.length; m++) {
					_result2 = _resultList2[m];
					_totalSize2 = _result2.getTotalSize();
				}
				pModel.addAttribute("totalCnt", String.valueOf(_totalSize2));
				
				pModel.addAttribute("st_maker",_requestHandler.getParameter("st_maker"));
				pModel.addAttribute("st_categoty_name",_requestHandler.getParameter("st_categoty_name"));
				pModel.addAttribute("st_sub_flag",_requestHandler.getParameter("st_sub_flag"));
				
			} else {
				ErrorMessage _errorMessage = _command.getException();
				String _errorMsg = _errorMessage.getErrorMessage();
				LOGGER.error("getBuyerMdCmGoodsDiLisList Error Code : {} ", _returnCode);
				LOGGER.error("getBuyerMdCmGoodsDiLisList Error Msg  : {}", _errorMsg);
			}
			
		}
		
		if ("renewal".equals(uiVersion)) {
			for(int i = 0 ; i<tmpData.size(); i++){
				//결과데이터로 등록상품에 있는지 YN 컬럼 추가 - 단순 고객사,상품코드만 비교
				String myItemYn = CommonUtil.getMyItemYn_v2(tmpData.get(i));
				tmpData.get(i).put("MY_ITEM_YN", myItemYn);
			}
			pModel.addAttribute("data",tmpData);
			return "buyer/mdcm/buyerMdCmGoodsDiLisList_v2";
		} else {
			return "buyer/mdcm/buyerMdCmGoodsDiLisList";
		}
		
	}
	/**
	 * 상품검색
	 * 
	 * @param request
	 * @param response
	 * @param pModel
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mdcm/getBuyerMdCmPCODiLisList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getBuyerMdCmPCODiLisList(HttpServletRequest pRequest, HttpServletResponse response, ModelMap pModel) throws Exception { 
		RequestHandler _requestHandler = new RequestHandler(pRequest, pRequest.getSession().getServletContext(),"utf-8");
		
		int _rowsperPage = Integer.parseInt(_requestHandler.getParameter("onepagerow", "10"));
		int _currentPage = Integer.parseInt(_requestHandler.getParameter("curPage", "1"));
		int _totalSize = 0;

		Query _query = new Query("<b>", "</b>");
		_query.setDebug(true);
		_query.setFrom(getCollentionName(pRequest));
		_query.setSearchOption(Protocol.SearchOption.CACHE);
		_query.setLoggable(true);
		_query.setResult((_currentPage - 1) * _rowsperPage, ((_currentPage - 1) * _rowsperPage) + (_rowsperPage - 1));
		_query.setFaultless(true);
		_query.setPrintQuery(true);

		SelectPhrase _selectColumn = new SelectPhrase();
		_query.setSelect(_selectColumn.get());

		WherePhrase _conditions = new WherePhrase();
		_query.setWhere(_conditions.get(_requestHandler,false));

		OrderByPhrase _orderBy = new OrderByPhrase();
		_query.setOrderby(_orderBy.get(_requestHandler));

		GroupByPhrase _groupBy = new GroupByPhrase();
		_query.setGroupBy(_groupBy.get(_requestHandler));

		QuerySet querySet = new QuerySet(1);
		querySet.addQuery(_query);
		//검색엔진 이중화 작업
		String realAdminIp = "";
		if( isConnectAble( adminIp, Integer.parseInt(adminPort), 1000 ) ) {
			realAdminIp = adminIp;
		} else if( isConnectAble( adminIp2, Integer.parseInt(adminPort), 1000 ) ) {
			realAdminIp = adminIp2;
		}
		LOGGER.debug("realAdminIp: {}", realAdminIp);
		CommandSearchRequest _command = new CommandSearchRequest(realAdminIp, Integer.parseInt(adminPort));
		int _returnCode = _command.request(querySet);

		if (_returnCode >= 0) {
			ResultSet _resultSet = _command.getResultSet();
			Result[] _resultList = _resultSet.getResultList();

			ResultData _searchResult = new ResultData();
			pModel.addAttribute("data", _searchResult.getTotalList(_query.getSelectFields(), _resultList));

			ResultGroup _resultGroup = new ResultGroup(_resultList[_resultList.length - 1]);
			pModel.addAttribute("data_MAKER", _resultGroup.getGroupAList());
			pModel.addAttribute("data_CATEGORY", _resultGroup.getGroupBList());

			Result _result = null;
			for (int m = 0; _resultList != null && m < _resultList.length; m++) {
				_result = _resultList[m];
				_totalSize = _result.getTotalSize();
			}
			pModel.addAttribute("totalCnt", String.valueOf(_totalSize));

		} else {
			ErrorMessage _errorMessage = _command.getException();
			String _errorMsg = _errorMessage.getErrorMessage();
			LOGGER.error("getBuyerMdCmPCODiLisList Error Code : {} ", _returnCode);
			LOGGER.error("getBuyerMdCmPCODiLisList Error Msg  : {}", _errorMsg);
		}
		return "buyer/mdcm/buyerMdCmPCODiLisList";
	}
	/**
	 * 카탈로그조회및수정(검색엔진) 상품검색
	 * 
	 * @param request
	 * @param response
	 * @param pModel
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogSearchList.do", method = { RequestMethod.GET, RequestMethod.POST })
		public String getMasterMdCmCatalogAlterEngineList(HttpServletRequest pRequest, HttpServletResponse response, ModelMap pModel) throws Exception {
		RequestHandler _requestHandler = new RequestHandler(pRequest, pRequest.getSession().getServletContext(),"utf-8");
		
		//LOGGER.error("getMasterMdCmCatalogAlterEngineList start: {} ", _requestHandler);  

		int _rowsperPage = Integer.parseInt(_requestHandler.getParameter("onepagerow", "10"));
		int _currentPage = Integer.parseInt(_requestHandler.getParameter("curPage", "1"));
		int _totalSize = 0;
		
		Query _query = new Query("<b>", "</b>");
		_query.setDebug(true);
		_query.setFrom(getCollentionName(pRequest));
		_query.setThesaurusOption((byte)(Protocol.ThesaurusOption.EQUIV_SYNONYM | Protocol.ThesaurusOption.QUASI_SYNONYM));
		_query.setSearchOption(Protocol.SearchOption.CACHE);
		_query.setLoggable(true);
		_query.setResult((_currentPage - 1) * _rowsperPage, ((_currentPage - 1) * _rowsperPage) + (_rowsperPage - 1));
		_query.setFaultless(true);
		_query.setPrintQuery(true);

		SelectPhrase _selectColumn = new SelectPhrase();
		_query.setSelect(_selectColumn.get());
		
		CombineWherePhrase _conditions = new CombineWherePhrase();
		_query.setWhere(_conditions.get(_requestHandler));

		OrderByPhrase _orderBy = new OrderByPhrase();
		_query.setOrderby(_orderBy.get(_requestHandler));

		QuerySet querySet = new QuerySet(1);
		querySet.addQuery(_query);

		//검색엔진 이중화 작업
		String realAdminIp = "";
		if( isConnectAble( adminIp, Integer.parseInt(adminPort), 90000 ) ) {
			realAdminIp = adminIp;
		} else if( isConnectAble( adminIp2, Integer.parseInt(adminPort), 90000 ) ) {
			realAdminIp = adminIp2;
		}
		LOGGER.debug("realAdminIp: {}", realAdminIp);
		CommandSearchRequest _command = new CommandSearchRequest(realAdminIp, Integer.parseInt(adminPort));
		int _returnCode = _command.request(querySet);
		
		if (_returnCode >= 0) {
			ResultSet _resultSet = _command.getResultSet();
			Result[] _resultList = _resultSet.getResultList();

			ResultData _searchResult = new ResultData();
			pModel.addAttribute("data", _searchResult.getTotalList(_query.getSelectFields(), _resultList));
			
			Result _result = null;
			for (int m = 0; _resultList != null && m < _resultList.length; m++) {
				_result = _resultList[m];
				_totalSize = _result.getTotalSize();
			}
			
			pModel.addAttribute("totalCnt", String.valueOf(_totalSize));

		} else {
			ErrorMessage _errorMessage = _command.getException();
			String _errorMsg = _errorMessage.getErrorMessage();
			LOGGER.error("getMasterMdCmCatalogAlterEngineList Error Code : {} ", _returnCode);
			LOGGER.error("getMasterMdCmCatalogAlterEngineList Error Msg  : {}", _errorMsg);
		}

		return "master/mdcm/masterMdCmCatalogSearchList";
	}
	
	
	
	
	
	
	
	/**
	 * 상품검색 - 자동완성
	 * 
	 * @param request
	 * @param response
	 * @param pModel
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mdcm/getBuyerMdCmGoodsDiAitoLisList.do", method = { RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public Map<String, Object>  getBuyerMdCmGoodsDiAitoLisList(HttpServletRequest pRequest, HttpServletResponse response, ModelMap pModel) throws Exception { 
		RequestHandler _requestHandler = new RequestHandler(pRequest, pRequest.getSession().getServletContext(),"utf-8");
 
		//LOGGER.error("getBuyerMdCmGoodsDiAitoLisList utf-8 start: {} ", _requestHandler);  
		   
		   StringBuffer cateSb = new StringBuffer();
		   StringBuffer cateSbA = new StringBuffer();
		   StringBuffer cateSbB = new StringBuffer();
		   StringBuffer cateSbC = new StringBuffer();
		   StringBuffer cateSbD = new StringBuffer(); 
		   StringBuffer cateSbE = new StringBuffer(); 
		   
		String[] cate = {"DESCRIPTION_LOC", "SPECIFICATION", "MAKER_NAME", "CATEGORY_TEXT", "AGENT"};	 
		FilterSet[] filterSet = null;
		Query _query = new Query("<b>", "</b>");
		_query.setDebug(true);
		_query.setFrom(getSmartmakeCollentionName(pRequest));

		_query.setThesaurusOption((byte)(Protocol.ThesaurusOption.EQUIV_SYNONYM | Protocol.ThesaurusOption.QUASI_SYNONYM));
		_query.setResult(0,4);
		_query.setSearch(true);
		_query.setDebug(true);
		_query.setFaultless(true);
		_query.setPrintQuery(true);
		_query.setLoggable(true);
		_query.setSearchOption(Protocol.SearchOption.CACHE | Protocol.SearchOption.BANNED | Protocol.SearchOption.STOPWORD);
		_query.setPrintQuery(true);

		AutoSelectPhrase _selectColumn = new AutoSelectPhrase();
		_query.setSelect(_selectColumn.get());

		AutoWherePhrase _conditions = new AutoWherePhrase();
		_query.setWhere(_conditions.get(_requestHandler));

		AutoOrderByPhrase _orderBy = new AutoOrderByPhrase();
		_query.setOrderby(_orderBy.get(_requestHandler));
 

		QuerySet querySet = new QuerySet(6);
		querySet.addQuery(_query);
		
		for(int i = 0 ; i < cate.length ; i ++ ) {
			filterSet = new FilterSet[]{ 
				new FilterSet(Protocol.FilterSet.OP_MATCH, "FILTER_CATE", cate[i])
				//new FilterSet(Protocol.FilterSet.OP_MATCH, "FILTER_BUYER", SessionComCode)
			};

			_query = new Query();
			_query.setFrom(getSmartmakeCollentionName(pRequest));
			_query.setSelect(_selectColumn.get());
			_query.setWhere(_conditions.get(_requestHandler));
			_query.setFilter(filterSet);
			_query.setOrderby(_orderBy.get(_requestHandler));
			_query.setResult(0,4);
			_query.setSearch(true);
			_query.setDebug(true);
			_query.setFaultless(true);
			_query.setPrintQuery(true);
			_query.setLoggable(true);
			_query.setSearchOption(Protocol.SearchOption.CACHE | Protocol.SearchOption.BANNED | Protocol.SearchOption.STOPWORD);
			//query.setResultModifier("typo");
			//query.setValue("typo-parameters", searchTerm);
			_query.setPrintQuery(true);
			querySet.addQuery(_query);
		}

		//검색엔진 이중화 작업
		String realAdminIp = "";
		if( isConnectAble( adminIp, Integer.parseInt(adminPort), 1000 ) ) {
			realAdminIp = adminIp;
		} else if( isConnectAble( adminIp2, Integer.parseInt(adminPort), 1000 ) ) {
			realAdminIp = adminIp2;
		}
		LOGGER.debug("realAdminIp: {}", realAdminIp);
		CommandSearchRequest _command = new CommandSearchRequest(realAdminIp, Integer.parseInt(adminPort));
		int _returnCode = _command.request(querySet);

		if (_returnCode >= 0) {
			
			ResultSet _resultSet = _command.getResultSet();
			Result[] _resultList = _resultSet.getResultList();
 
		//cate total
			Result result = _resultList[0];
		   int realSize = result.getRealSize();
		//changeQuery = result.getValue("typo-result");

		   
 
		if(realSize > 0)
		{
	        for(int i=0;i<realSize;i++)
	        { 
				cateSb.append(new String(result.getResult(i,0)));
				cateSb.append("@@");
			}
		}
		else 
		{ 
		} 
			
			
			
		//cateA
		result = _resultList[1];
		realSize = result.getRealSize(); 
		if(realSize > 0)
		{ 
			for(int i=0;i<realSize;i++)
	        {
				cateSbA.append(new String(result.getResult(i,0)));
				cateSbA.append("@@");
			}
		}
		else 
		{
		}
			
		//cateB
		result = _resultList[2];
		realSize = result.getRealSize(); 
		if(realSize > 0)
		{ 
			for(int i=0;i<realSize;i++)
	        {
				cateSbB.append(new String(result.getResult(i,0)));
				cateSbB.append("@@");
			}
		}
		else 
		{
		}
			

		//cateC
		result = _resultList[3];
		realSize = result.getRealSize(); 
		if(realSize > 0)
		{ 
			for(int i=0;i<realSize;i++)
	        {
				cateSbC.append(new String(result.getResult(i,0)));
				cateSbC.append("@@");
			}
		}
		else 
		{
		}
		
		
		//cateD
		result = _resultList[4];
		realSize = result.getRealSize(); 
		if(realSize > 0)
		{ 
			for(int i=0;i<realSize;i++)
	        {
				cateSbD.append(new String(result.getResult(i,0)));
				cateSbD.append("@@");
			}
		}
		else 
		{
		}
		
		
		//cateE
		result = _resultList[5];
		realSize = result.getRealSize(); 
		if(realSize > 0)
		{ 
			for(int i=0;i<realSize;i++)
	        {
				cateSbE.append(new String(result.getResult(i,0)));
				cateSbE.append("@@");
			}
		}
		else 
		{
		}


		} else {
			ErrorMessage _errorMessage = _command.getException();
			String _errorMsg = _errorMessage.getErrorMessage();
			LOGGER.error("getBuyerMdCmGoodsDiAitoLisList Error Code : {} ", _returnCode);
			LOGGER.error("getBuyerMdCmGoodsDiAitoLisList Error Msg  : {}", _errorMsg);
		}
		
		
		LOGGER.debug("getBuyerMdCmGoodsDiAitoLisList  cateSb : {} ", cateSb.toString());
		LOGGER.debug("getBuyerMdCmGoodsDiAitoLisList  cateSbA : {} ", cateSbA.toString());
		LOGGER.debug("getBuyerMdCmGoodsDiAitoLisList  cateSbB : {} ", cateSbB.toString());
		LOGGER.debug("getBuyerMdCmGoodsDiAitoLisList  cateSbC : {} ", cateSbC.toString());
		LOGGER.debug("getBuyerMdCmGoodsDiAitoLisList  cateSbD : {} ", cateSbD.toString());
		LOGGER.debug("getBuyerMdCmGoodsDiAitoLisList  cateSbE : {} ", cateSbE.toString()); 
		
		
		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("cateSb", cateSb.toString()); 
		_response.put("cateSbA", cateSbA.toString()); 
		_response.put("cateSbB", cateSbB.toString()); 
		_response.put("cateSbC", cateSbC.toString()); 
		_response.put("cateSbD", cateSbD.toString()); 
		_response.put("cateSbE", cateSbE.toString()); 
		return _response;
 
	} 
	
	/**
	 * 접속 가능 여부 확인
	 * @param host
	 * @param port			
	 * @param _timeout		타임아웃
	 * @return	boolean		true - 접속, false - 접속실패
	 * @throws Exception
	 */
    public boolean isConnectAble(String host, int port, double _timeout) throws Exception {
        boolean flag = false;
        try {
            InetAddress inetAddress = InetAddress.getByName(host);
            double timeout_sec_default = 2000;

            if(_timeout <=0) _timeout = (int) timeout_sec_default;
            {
                int timeout = (int) _timeout ;
                SocketAddress socketAddress = new InetSocketAddress(inetAddress, port);
                Socket socket = new Socket();

                socket.connect(socketAddress, timeout);
                flag= socket.isConnected();
                if(socket.isConnected()) socket.close();
            }
        }catch( Exception e ){
        	e.printStackTrace();
        }
        
        return flag;
    }
	
}
