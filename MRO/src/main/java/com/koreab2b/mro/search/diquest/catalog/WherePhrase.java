package com.koreab2b.mro.search.diquest.catalog;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.diquest.ir.client.util.RequestHandler;
import com.diquest.ir.common.msg.protocol.Protocol;
import com.diquest.ir.common.msg.protocol.query.QueryParser;
import com.diquest.ir.common.msg.protocol.query.WhereSet;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

public class WherePhrase {

	private static final Logger LOGGER = LoggerFactory.getLogger(WherePhrase.class);
		
	public WhereSet[] get(RequestHandler pRequestHandler, boolean flag) throws Exception{	
		String _searchTerm = pRequestHandler.getParameter("searchTerm", "");
		String _searchTarget =pRequestHandler.getParameter("searchTarget", "ALL");
		String _searchTargetIDX_CATEGORY_NO =pRequestHandler.getParameter("searchTargetIDX_CATEGORY_NO", ""); // IDX_CATEGORY_NO  로 바뀌면, 카테고리번호에 해당하는 정보만 가져올 수 있을 듯 합니다.
		String _searchMode = pRequestHandler.getParameter("searchMode", "basics"); // 검색모드
		String _st_description = pRequestHandler.getParameter("st_description", ""); // 상품명-상세
		String _st_specification = pRequestHandler.getParameter("st_specification", ""); // 규격-상세
		String _st_maker = pRequestHandler.getParameter("st_maker", ""); // 제조사-상세
		String _st_categoty_name =pRequestHandler.getParameter("st_categoty_name", ""); // 카테고리-상세
		String _st_research_flag =pRequestHandler.getParameter("st_research_flag", ""); // 결과내재검색
		String _st_searchWhereStr =pRequestHandler.getParameter("st_searchWhereStr", ""); //  결과내재검색조건
		String _st_contract_flag =pRequestHandler.getParameter("st_contract_flag", "N"); //  미계약조회여부
		String _resultKeyword = pRequestHandler.getParameter("resultKeyword", ""); //결과내 재검색 키워드
		String _st_no_contract_hidden_flag =pRequestHandler.getParameter("st_no_contract_hidden_flag", "N"); // 미계약 숨기기
		String _st_sub_flag =pRequestHandler.getParameter("st_sub_flag", "N"); // 화면내 카테고리,제조사 선택인지 여부
		
		LOGGER.debug("searchTarget : {}", _searchTarget);
		LOGGER.debug("_searchTargetIDX_CATEGORY_NO : {}", _searchTargetIDX_CATEGORY_NO);
		LOGGER.debug("searchMode : {}", _searchMode);
		LOGGER.debug("st_description : {}", _st_description);
		LOGGER.debug("st_specification : {}", _st_specification);
		LOGGER.debug("st_maker : {}", _st_maker);
		LOGGER.debug("_st_categoty_name : {}", _st_categoty_name);
		LOGGER.debug("_st_research_flag : {}", _st_research_flag);
		LOGGER.debug("_st_searchWhereStr : {}", _st_searchWhereStr);
		LOGGER.debug("_st_contract_flag : {}", _st_contract_flag);
		
		String _st_SessionComCode = ((SessionInfo) pRequestHandler.getSession().getAttribute("sessionInfo")).getComCode();
		String _using_catal_type = ((SessionInfo) pRequestHandler.getSession().getAttribute("sessionInfo")).getUsingCatalType();
		String _byca_comorg_code = ((SessionInfo) pRequestHandler.getSession().getAttribute("sessionInfo")).getBycaComorgCode();
		String _st_session_user_id = ((SessionInfo) pRequestHandler.getSession().getAttribute("sessionInfo")).getUserId();
		
		LOGGER.debug("sessionComCode : {}", _st_SessionComCode);
		LOGGER.debug("using_catal_type : {}", _using_catal_type);
		LOGGER.debug("byca_comorg_code : {}", _byca_comorg_code);

		String _searchOption = pRequestHandler.getParameter("searchOption", "and");
		byte _whereOption = _searchOption.equals("or") ? Protocol.WhereSet.OP_HASANY : Protocol.WhereSet.OP_HASALL;
		
		LOGGER.debug("searchOption : {}", _searchOption);
		List<WhereSet> _whereList = new ArrayList<WhereSet>();
		//결과내 재검색 기능. 불필요.포함단어 갬식기능으로 변경 
		/*
		if(_st_research_flag.equals("Y")){
			_searchTerm = _resultKeyword;
			QueryParser parser = new QueryParser();
			LOGGER.debug("searchWhereStr1 : {}", _st_searchWhereStr);
			WhereSet[] tempWhereSet = parser.parseWhereSet(_st_searchWhereStr);
			for(int i=0 ; i<tempWhereSet.length; i++){
				_whereList.add(tempWhereSet[i]);
			}
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));	
		}*/
		//포함단어 검색기능
		if(_st_research_flag.equals("Y")){
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_DESCRIPTION_LOC", _whereOption, _resultKeyword, 1000));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_DESCRIPTION_LOC_LIKE", _whereOption, _resultKeyword, 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_SPECIFICATION", _whereOption, _resultKeyword, 900));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_SPECIFICATION_LIKE", _whereOption, _resultKeyword, 90));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_MAKER_NAME", _whereOption, _resultKeyword, 800));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_MAKER_NAME_LIKE", _whereOption, _resultKeyword, 80));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_BUYER_ITEM_NO", _whereOption, _resultKeyword, 700));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_BUYER_ITEM_NO_LIKE", _whereOption, _resultKeyword, 70));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_CATEGORY_TEXT", _whereOption, _resultKeyword, 600));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_CATEGORY_TEXT_LIKE", _whereOption, _resultKeyword, 60));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_AGENT", _whereOption, _resultKeyword, 500));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_AGENT_LIKE", _whereOption, _resultKeyword, 50));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));	
		}		

		LOGGER.debug("searchTerm : {}", _searchTerm);
		if (_searchTarget.equals("DESCRIPTION")) { // 상품명
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_DESCRIPTION_LOC", _whereOption, _searchTerm, 1000));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_DESCRIPTION_LOC_LIKE", _whereOption, _searchTerm, 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		} else if (_searchTarget.equals("SPECIFICATION")) { // 규격
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_SPECIFICATION", _whereOption, _searchTerm, 1000));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_SPECIFICATION_LIKE", _whereOption, _searchTerm, 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		} else if (_searchTarget.equals("BUYER_ITEM_NO")) { // 상품코드
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_BUYER_ITEM_NO", _whereOption, _searchTerm, 1000));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_BUYER_ITEM_NO_LIKE", _whereOption, _searchTerm, 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		} else if (_searchTarget.equals("MAKER_NAME")) { // 제조사
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_MAKER_NAME", _whereOption, _searchTerm, 1000));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_MAKER_NAME_LIKE", _whereOption, _searchTerm, 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		} else if (_searchTarget.equals("CATEG_NAME")) { // 카테고리
			if ("".equals(_searchTargetIDX_CATEGORY_NO)){
				
				LOGGER.debug("IDX_CATEGORY_TEXT : {}", _searchTerm);
				
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				_whereList.add(new WhereSet("IDX_CATEGORY_TEXT", _whereOption, _searchTerm, 1000));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_CATEGORY_TEXT_LIKE", _whereOption, _searchTerm, 100));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}else{ // IDX_CATEGORY_NO  로 바뀌면, 카테고리번호에 해당하는 정보만 가져올 수 있을 듯 합니다.
				
				LOGGER.debug("IDX_CATEGORY_NO : {}", _searchTargetIDX_CATEGORY_NO);
				
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				_whereList.add(new WhereSet("IDX_CATEGORY_NO", _whereOption, _searchTargetIDX_CATEGORY_NO, 1000)); // IDX_CATEGORY_NO  로 바뀌면, 카테고리번호에 해당하는 정보만 가져올 수 있을 듯 합니다.
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
		} else if (_searchTarget.equals("AGENT")) { // 공급사
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_AGENT", _whereOption, _searchTerm, 1000));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_AGENT_LIKE", _whereOption, _searchTerm, 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		} else if (_searchTarget.equals("ITEM_NO")) { // 재고코드
			//_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_ITEM_NO", _whereOption, _searchTerm, 1000));
			//_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			//_whereList.add(new WhereSet("IDX_ITEM_NO_LIKE", _whereOption, _searchTerm, 100));
			//_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		} else { // 전체
			
			if (!_searchTerm.equals("")) { 
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				_whereList.add(new WhereSet("IDX_DESCRIPTION_LOC", _whereOption, _searchTerm, 1000));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_DESCRIPTION_LOC_LIKE", _whereOption, _searchTerm, 100));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_SPECIFICATION", _whereOption, _searchTerm, 900));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_SPECIFICATION_LIKE", _whereOption, _searchTerm, 90));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_MAKER_NAME", _whereOption, _searchTerm, 800));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_MAKER_NAME_LIKE", _whereOption, _searchTerm, 80));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_BUYER_ITEM_NO", _whereOption, _searchTerm, 700));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_BUYER_ITEM_NO_LIKE", _whereOption, _searchTerm, 70));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_CATEGORY_TEXT", _whereOption, _searchTerm, 600));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_CATEGORY_TEXT_LIKE", _whereOption, _searchTerm, 60));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_AGENT", _whereOption, _searchTerm, 500));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_AGENT_LIKE", _whereOption, _searchTerm, 50));				
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_WEIGHTAND));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				_whereList.add(new WhereSet("IDX_PRODUCT_CLOSE_FLAG", _whereOption, "N", 1000000));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}else{ 
			}
			// 상품명 상세
			if (_searchMode.equals("detail") && !_st_description.equals("")) { 
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				_whereList.add(new WhereSet("IDX_DESCRIPTION_LOC", _whereOption, _st_description, 1000));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_DESCRIPTION_LOC_LIKE", _whereOption, _st_description, 100));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}

			// 규격 상세
			if (_searchMode.equals("detail") && !_st_specification.equals("")) { 
				if (!_st_description.equals("")) { 
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				_whereList.add(new WhereSet("IDX_SPECIFICATION", _whereOption, _st_specification, 1000));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_SPECIFICATION_LIKE", _whereOption, _st_specification, 100));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}

			// 제조사 상세
			if (_searchMode.equals("detail") && !_st_maker.equals("")) { 
				if (!_st_description.equals("") || !_st_specification.equals("")  ) { 
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				_whereList.add(new WhereSet("IDX_MAKER_NAME", _whereOption, _st_maker, 1000));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_MAKER_NAME_LIKE", _whereOption, _st_maker, 100));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}

			// 카테고리 상세
			if (_searchMode.equals("detail") && !_st_categoty_name.equals("")) { 
				if (!_st_description.equals("") || !_st_specification.equals("")   || !_st_maker.equals("") ) { 
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				_whereList.add(new WhereSet("IDX_CATEGORY_TEXT", _whereOption, _st_categoty_name, 1000));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet("IDX_CATEGORY_TEXT_LIKE", _whereOption, _st_categoty_name, 100));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
		}
		//검색 화면 내 카테고리,제조사 선택해서 조회하는 경우 - 리뉴얼 화면 기준
		if(_st_sub_flag.equals("Y")){
			if(flag){
				if(!_st_maker.equals("")){
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
					String _st_makerArr[] = _st_maker.split(",");
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
					boolean first = true;
					for(String maker : _st_makerArr){
						if(!first){ //처음만 실행
							_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
						}
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
						_whereList.add(new WhereSet("IDX_MAKER_NAME", _whereOption, maker, 1000));
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
						_whereList.add(new WhereSet("IDX_MAKER_NAME_LIKE", _whereOption, maker, 100));
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
						
						first = false;
					}
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
				}
				if(!_st_categoty_name.equals("")){
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
					String _st_cateArr[] = _st_categoty_name.split(",");
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
					boolean first = true;
					for(String categ : _st_cateArr){
						if(!first){ //처음만 실행
							_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
						}
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
						_whereList.add(new WhereSet("IDX_CATEGORY_TEXT", _whereOption, categ, 1000));
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
						_whereList.add(new WhereSet("IDX_CATEGORY_TEXT_LIKE", _whereOption, categ, 100));
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
						
						first = false;
					}
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
				}
			}
		}
		
		if(_st_contract_flag.equals("N")){
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_STND_FLAG", _whereOption, _st_contract_flag, 1000));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		}
		// 고객사코드
		/*
		 * 공통카탈로그는 사용하지 않기로 했으나 KRHONG0020를 C (ICOMCMPY.USING_CATAL_TYPE이 A:자사, B:공통, C:둘다)로 설정하고 M000109407 를 조회하면 공통카탈로그의 품목도 함께 조회가 된다.
		 */
/*
		if("C".equals(_using_catal_type)){
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));	
			_whereList.add(new WhereSet("IDX_BUYER", Protocol.WhereSet.OP_HASALL, _byca_comorg_code , 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_BUYER", Protocol.WhereSet.OP_HASALL, "KRCOMMG001" , 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));	
		}else{
			_whereList.add(new WhereSet("IDX_BUYER", Protocol.WhereSet.OP_HASALL, _byca_comorg_code , 100));
		}
		_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
		_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));	
	 	if("A".equals(_using_catal_type)){
	 		_whereList.add(new WhereSet("IDX_COM_CODE", Protocol.WhereSet.OP_HASALL, _st_SessionComCode , 100));
		} else if("C".equals(_using_catal_type)){
			_whereList.add(new WhereSet("IDX_COM_CODE", Protocol.WhereSet.OP_HASALL, _st_SessionComCode , 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_COM_CODE", Protocol.WhereSet.OP_HASALL, "KRCOMMG001" , 100));		
	  	} else if("B".equals(_using_catal_type)){	
	  		_whereList.add(new WhereSet("IDX_COM_CODE", Protocol.WhereSet.OP_HASALL, "KRCOMMG001" , 100));	
	  	}
	  	*/
        //사용자카테고리리스트
		boolean s_buyer_gbn = CommonUtil.getSpecialCategUserBoolean(_byca_comorg_code,"","URCT");
		boolean s_buyer_gbn2 = CommonUtil.getSpecialCategUserBoolean(_byca_comorg_code,"","URCT2");
		if(s_buyer_gbn == true){
	        List<Map<String,String>> CategList = CommonUtil.getSpecialCategUserList(_byca_comorg_code,_st_session_user_id,"URCT");
	        
	        LOGGER.debug("CategList.size() : {}", CategList.size());
	        //if(CategList.size() > 0){
	        	_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
	        	_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
	        	for(int k=0; k<CategList.size(); k++){
	        		Map<String,String> mp = (Map<String,String>)CategList.get(k);
	        		String categNo = CommonUtil.nvl(mp.get("STD_CATEG_ID"),"");
	        		LOGGER.debug("categNo : {}", categNo);
	        		if(k > 0){
	        			LOGGER.debug("k : {}", k);
	        			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
	        		}
	        		_whereList.add(new WhereSet("IDX_STD_CATEG_TOP", _whereOption, categNo, 1000));
					
	        	}
	        	_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
	        //}
		}else if(s_buyer_gbn2 == true) {
			List<Map<String,String>> CategList2 = CommonUtil.getSpecialCategUserList(_byca_comorg_code,_st_session_user_id,"URCT2");
	        
	        LOGGER.debug("CategList2.size() : {}", CategList2.size());
	        	_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
	        	_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
	        	for(int k=0; k<CategList2.size(); k++){
	        		Map<String,String> mp = (Map<String,String>)CategList2.get(k);
	        		String categNo = CommonUtil.nvl(mp.get("STD_CATEG_ID"),"");
	        		LOGGER.debug("categNo : {}", categNo);
	        		if(k > 0){
	        			LOGGER.debug("k : {}", k);
	        			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
	        		}
	        		_whereList.add(new WhereSet("IDX_STD_CATEG_TOP", _whereOption, categNo, 1000));
					
	        	}
	        	_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		}
		
        _whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
		boolean p060000066 = CommonUtil.getSpecialCheckReturn(_st_SessionComCode,"P06-0000066");
		
		boolean search_user_yn = CommonUtil.getIcomcod3Boolean(_st_SessionComCode,_st_session_user_id,"URIT");
		LOGGER.debug("p060000066 : {}", p060000066);
		LOGGER.debug("search_user_yn : {}", search_user_yn);
		LOGGER.debug("no_contract_hidden_yn : {}", _st_no_contract_hidden_flag);
		if(p060000066 == false){ // 일반
			if(search_user_yn == true){
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));	
				_whereList.add(new WhereSet("IDX_BUYER", Protocol.WhereSet.OP_HASALL, _byca_comorg_code , 100));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));	
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));	
				_whereList.add(new WhereSet("IDX_COM_CODE", Protocol.WhereSet.OP_HASALL, _st_SessionComCode , 100));		
			 	_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));				
			}else{ // 일반
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));	
				_whereList.add(new WhereSet("IDX_BUYER", Protocol.WhereSet.OP_HASALL, _byca_comorg_code , 100));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				_whereList.add(new WhereSet("IDX_COM_CODE", Protocol.WhereSet.OP_HASALL, _st_SessionComCode , 100));		
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				_whereList.add(new WhereSet("IDX_CONTRACT_NO", _whereOption, "PC", 1000));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));					
			}
		}else{ // 미계약품목 보이기
			if( _st_no_contract_hidden_flag.equals("Y") ) {
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));	
				_whereList.add(new WhereSet("IDX_BUYER", Protocol.WhereSet.OP_HASALL, _byca_comorg_code , 100));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				_whereList.add(new WhereSet("IDX_COM_CODE", Protocol.WhereSet.OP_HASALL, _st_SessionComCode , 100));		
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				_whereList.add(new WhereSet("IDX_CONTRACT_NO", _whereOption, "PC", 1000));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}else {
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				_whereList.add(new WhereSet("IDX_BUYER", Protocol.WhereSet.OP_HASALL, _byca_comorg_code , 100));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				_whereList.add(new WhereSet("IDX_COM_CODE", Protocol.WhereSet.OP_HASALL, _st_SessionComCode , 100));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
						
		}
		
		
		WhereSet[] _whereSet = new WhereSet[_whereList.size()];
		_whereList.toArray(_whereSet);
		
		return _whereSet;		
	}

	}
