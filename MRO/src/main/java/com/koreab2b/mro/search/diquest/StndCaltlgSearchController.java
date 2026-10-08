package com.koreab2b.mro.search.diquest;

import java.io.OutputStream;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.util.ArrayList;
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

import com.diquest.ir.client.command.CommandSearchRequest;
import com.diquest.ir.client.util.RequestHandler;
import com.diquest.ir.common.msg.ext.body.common.ErrorMessage;
import com.diquest.ir.common.msg.protocol.Protocol;
import com.diquest.ir.common.msg.protocol.query.FilterSet;
import com.diquest.ir.common.msg.protocol.query.GroupBySet;
import com.diquest.ir.common.msg.protocol.query.OrderBySet;
import com.diquest.ir.common.msg.protocol.query.Query;
import com.diquest.ir.common.msg.protocol.query.QuerySet;
import com.diquest.ir.common.msg.protocol.query.SelectSet;
import com.diquest.ir.common.msg.protocol.query.WhereSet;
import com.diquest.ir.common.msg.protocol.result.Result;
import com.diquest.ir.common.msg.protocol.result.ResultSet;
import com.koreab2b.mro.util.CommonUtil;

@Controller("StndCaltlgSearchController")
public class StndCaltlgSearchController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(StndCaltlgSearchController.class);

	@Value("#{diquestProps['diquest.admin.ip']}")
	private String adminIp;
	
	@Value("#{diquestProps['diquest.dqcat.ip']}")
	private String adminIp2;
	
	@Value("#{diquestProps['diquest.dqcat.port']}")
	private String dqcat;
	
	@Value("#{diquestProps['diquest.admin.port']}")
	private String adminPort;

	@Value("#{diquestProps['diquest.collection.dev.stndctalg.name']}")
	private String collentionDevName; 
	
	@Value("#{diquestProps['diquest.collection.real.stndctalg.name']}")
	private String collentionRealName; 
	 
	public String getCollentionName(HttpServletRequest pRequest) {
		String flag = CommonUtil.getDevRealLocalFlag(pRequest); // 0 로컬 1 개발 2 운영
		
		LOGGER.debug(" getCollentionName 0 로컬 1 개발 2 운영 : {}", flag);
		
		if ("2".equals(flag)){
			return collentionRealName;
		}else{
			return collentionDevName;		
		}
	}
	
	/**
	 * 표준카탈로그 검색 리스트
	 * 
	 * @param request
	 * @param response
	 * @param pModel
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mdcm/getStndCaltlgList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getStndCaltlgList(HttpServletRequest pRequest, HttpServletResponse response, ModelMap pModel) throws Exception {
		RequestHandler _requestHandler = new RequestHandler(pRequest, pRequest.getSession().getServletContext(),"utf-8");
		
			int rowsperPage = Integer.parseInt(_requestHandler.getParameter("onepagerow", "10"));
			int currentPage = Integer.parseInt(_requestHandler.getParameter("curPage", "1"));
			int totalSize = 0;
			String searchOption = _requestHandler.getParameter("searchOption", "and");						//검색 카테고리
			byte whereOption = searchOption.equals("or") ? Protocol.WhereSet.OP_HASANY : Protocol.WhereSet.OP_HASALL;
			String st_maker_nm = _requestHandler.getParameter("st_maker_nm", "");
			String st_categ_id = _requestHandler.getParameter("st_categ_id", "");
			String st_mast_check = _requestHandler.getParameter("st_mast_check", "");
			String st_status = _requestHandler.getParameter("st_status", "");
			String st_categ_name = _requestHandler.getParameter("st_categ_name", "");
			String st_sg_nm = _requestHandler.getParameter("st_sg_nm", "");
			String st_description = _requestHandler.getParameter("st_description", "");
			String st_specification  = _requestHandler.getParameter("st_specification", "");
			String st_stnd_flag  = _requestHandler.getParameter("st_stnd_flag", "");
			String st_model_info  = _requestHandler.getParameter("st_model_info", "");
			String st_remark  = _requestHandler.getParameter("st_remark", "");
			String st_catlg_id  = _requestHandler.getParameter("st_catlg_id", "");
			String st_item_gubun  = _requestHandler.getParameter("st_item_gubun", "");
			String st_gpl_flag  = _requestHandler.getParameter("st_gpl_flag", "");
			
			String selectFieldName = "";
			SelectSet[] getselectSet = null; 		// getSelectSet	
			WhereSet[] whereSet = null;
			FilterSet[] filterSet = null; 
			OrderBySet[] orderBySet = null;
			GroupBySet[] groupby = null;
			Query query = null;
			QuerySet querySet = new QuerySet(1);										// QuerySet
			List<WhereSet> whereList = new ArrayList<WhereSet>();
			List<OrderBySet> orderByList = new ArrayList<OrderBySet>();
			List<Map<String, Object>> totalList = new ArrayList<Map<String, Object>>();  	
			
			
			//Group 결과 Map 초기화
			ResultSet resultSet= null;
			Result[] resultList = null;
			Result result = null;
			//Query 생성 시작
			SelectSet[] selectSet = new SelectSet[] {
					new SelectSet("CATEG_PATH", Protocol.SelectSet.NONE),
					new SelectSet("CMS_CATEG_ID", Protocol.SelectSet.NONE),
					new SelectSet("CMS_CATLG_ID", Protocol.SelectSet.NONE),
					new SelectSet("CMS_USER_NAME", Protocol.SelectSet.NONE),
					new SelectSet("DELIVERY_LT", Protocol.SelectSet.NONE),
					new SelectSet("DESCRIPTION_ENG", Protocol.SelectSet.NONE),
					new SelectSet("DESCRIPTION_LOC", Protocol.SelectSet.NONE),
					new SelectSet("IMAGE_KEY", Protocol.SelectSet.NONE),
					new SelectSet("IMG", Protocol.SelectSet.NONE),
					new SelectSet("IMG_NO", Protocol.SelectSet.NONE),
					new SelectSet("ITEM_GROUP", Protocol.SelectSet.NONE),
					new SelectSet("ITEM_GROUP_TEXT", Protocol.SelectSet.NONE),
					new SelectSet("ITEM_GUBUN", Protocol.SelectSet.NONE),
					new SelectSet("ITEM_GUBUN_TEXT", Protocol.SelectSet.NONE),
					new SelectSet("MAKER_CODE", Protocol.SelectSet.NONE),
					new SelectSet("MAKER_NAME", Protocol.SelectSet.NONE),
					new SelectSet("MAPPING", Protocol.SelectSet.NONE),
					new SelectSet("ORDER_MEASURE", Protocol.SelectSet.NONE),
					new SelectSet("ORIGIN_CODE", Protocol.SelectSet.NONE),
					new SelectSet("ORIGIN_NAME", Protocol.SelectSet.NONE),
					new SelectSet("REMARK", Protocol.SelectSet.NONE),
					new SelectSet("REMARK_IMG", Protocol.SelectSet.NONE),
					new SelectSet("SG_NAME", Protocol.SelectSet.NONE),
					new SelectSet("SPECIFICATION", Protocol.SelectSet.NONE),
					new SelectSet("STD_FLAG", Protocol.SelectSet.NONE),
					new SelectSet("TOT_CNT", Protocol.SelectSet.NONE),
					new SelectSet("STATUS", Protocol.SelectSet.NONE),
					new SelectSet("STATUS_NM", Protocol.SelectSet.NONE),
					new SelectSet("REMARK", Protocol.SelectSet.NONE),
					new SelectSet("MODEL_INFO", Protocol.SelectSet.NONE),
					new SelectSet("IMGFILE_NAME", Protocol.SelectSet.NONE),
					new SelectSet("IMGFILE_DIR", Protocol.SelectSet.NONE),
					new SelectSet("DETAIL_IMGFILE_NAME", Protocol.SelectSet.NONE),
					new SelectSet("DETAIL_IMGFILE_DIR", Protocol.SelectSet.NONE),
					new SelectSet("SPECIFICATION_ENG", Protocol.SelectSet.NONE),
					new SelectSet("GPL_YN", Protocol.SelectSet.NONE)
					
			}; 
			int index = 0;
			if (!st_maker_nm.equals("")) { // 제조사명
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_MAKER_NAME", whereOption, st_maker_nm, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_MAKER_NAME_LIKE", whereOption, st_maker_nm, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_categ_id.equals("")){//표준카테고리
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_CMS_CATEG_ID", whereOption, st_categ_id, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_sg_nm.equals("")){//SG명
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_SG_NAME", whereOption, st_sg_nm, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_SG_NAME_LIKE", whereOption, st_sg_nm, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_status.equals("")){//상태
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_STATUS", whereOption, st_status, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_description.equals("")){//품목명
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_DESCRIPTION_LOC", whereOption, st_description, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_DESCRIPTION_LOC_LIKE", whereOption, st_description, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_specification.equals("")){//규격
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_SPECIFICATION", whereOption, st_specification, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_SPECIFICATION_LIKE", whereOption, st_specification, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_model_info.equals("")){//모델정보
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_MODEL_INFO", whereOption, st_model_info, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_MODEL_INFO_LIKE", whereOption, st_model_info, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_stnd_flag.equals("")){//표준화여부
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_STD_FLAG", whereOption, st_stnd_flag, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_gpl_flag.equals("")){//GPL여부
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_GPL_YN", whereOption, st_gpl_flag, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_catlg_id.equals("")){//표준화카탈로그코드
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_CMS_CATLG_ID", whereOption, st_catlg_id, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_remark.equals("")){//비고
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_REMARK", whereOption, st_remark, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_item_gubun.equals("")){//품목구분
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_ITEM_GUBUN", whereOption, st_item_gubun, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			whereSet = new WhereSet[whereList.size()];
			for(int n = 0 ; n < whereList.size() ; n++) {
				whereSet[n] = (WhereSet)whereList.get(n);
			}
			
			//OrderBySet
			orderByList.add(new OrderBySet(true, "SORT_IDX", Protocol.OrderBySet.OP_PREWEIGHT));
			orderBySet = new OrderBySet[orderByList.size()];
			
			for(int j=0;j<orderByList.size();j++){
				orderBySet[j] = (OrderBySet)orderByList.get(j);
			}
			/////////////////// 쿼리셋 //////////////
			query = new Query("<b>","</b>");
			query.setDebug(true);
			query.setFrom(getCollentionName(pRequest));
			query.setSearchOption(Protocol.SearchOption.CACHE); 
			//동의어 유의어 사용시 아래 추가
			query.setThesaurusOption((byte) (Protocol.ThesaurusOption.EQUIV_SYNONYM | Protocol.ThesaurusOption.QUASI_SYNONYM));
			query.setLoggable(true);
			query.setResult((currentPage - 1) * rowsperPage ,((currentPage - 1) * rowsperPage) + (rowsperPage - 1));
			query.setFaultless(true);
			query.setPrintQuery(true); 
			query.setSelect(selectSet); 
			//query.setFilter(filterSet);
			query.setWhere(whereSet);
			query.setOrderby(orderBySet);
			//query.setGroupBy(groupby);
			querySet.addQuery(query);
			whereList.clear();
			orderByList.clear();
			//Query 생성 종료
			
			CommandSearchRequest command = new CommandSearchRequest(adminIp, Integer.parseInt(adminPort));
			int returnCode = command.request(querySet);
			LOGGER.debug(" returnCode======== {}", returnCode);
			if(returnCode >= 0) {
				resultSet = command.getResultSet();
				resultList = resultSet.getResultList();
				getselectSet = query.getSelectFields();
				LOGGER.debug(" resultList.length======== {}", resultList.length);
				for(int m = 0 ; resultList != null && m < resultList.length ; m++) {
					result = resultList[m];
					//결과 리스트생성
					if(result.getRealSize() != 0) {
						for(int k=0 ;  k < result.getRealSize() ; k++) {
							Map<String, Object> tempMap = new HashMap<String, Object>(); 
							for (int j = 0; j < result.getNumField(); j++) {
								selectFieldName = new String(getselectSet[j].getField());
								String temp = new String(result.getResult(k, j));
								tempMap.put(selectFieldName, temp);
							}
							totalList.add(tempMap);
							totalSize = result.getTotalSize();
						}
					}
				}
				pModel.addAttribute("data", totalList);
				pModel.addAttribute("st_maker_nm", st_maker_nm);
				pModel.addAttribute("st_categ_id", st_categ_id);
				pModel.addAttribute("st_mast_check", st_mast_check);
				pModel.addAttribute("st_status", st_status);
				pModel.addAttribute("st_maker_nm", st_maker_nm);
				pModel.addAttribute("st_categ_name", st_categ_name);
				pModel.addAttribute("st_sg_nm", st_sg_nm);
				pModel.addAttribute("st_description", st_description);
				pModel.addAttribute("st_specification", st_specification);
				pModel.addAttribute("st_stnd_flag", st_stnd_flag);
				pModel.addAttribute("st_model_info", st_model_info);
				pModel.addAttribute("st_stnd_flag", st_stnd_flag);
				pModel.addAttribute("st_remark", st_remark);
				pModel.addAttribute("st_catlg_id", st_catlg_id);
				pModel.addAttribute("totalCnt", String.valueOf(totalSize));
			} else {
				ErrorMessage errorMessage = command.getException();
				String errorMsg = errorMessage.getErrorMessage();
				LOGGER.error("Error Code : " + returnCode);
				LOGGER.error("Error Msg  : " + errorMsg);
			}

			return "master/mdcm/masterMdCmStndCatalogList";
	}
	/**
	 * 표준카탈로그 검색 리스트 팝업
	 * 
	 * @param request
	 * @param response
	 * @param pModel
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mdcm/getStndCaltlgListPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getStndCaltlgListPop(HttpServletRequest pRequest, HttpServletResponse response, ModelMap pModel) throws Exception {
		RequestHandler _requestHandler = new RequestHandler(pRequest, pRequest.getSession().getServletContext(),"utf-8");
		
			int rowsperPage = Integer.parseInt(_requestHandler.getParameter("onepagerow", "10"));
			int currentPage = Integer.parseInt(_requestHandler.getParameter("curPage", "1"));
			int totalSize = 0;
			String searchOption = _requestHandler.getParameter("searchOption", "and");						//검색 카테고리
			byte whereOption = searchOption.equals("or") ? Protocol.WhereSet.OP_HASANY : Protocol.WhereSet.OP_HASALL;
			String st_maker_nm = _requestHandler.getParameter("st_maker_nm", "");
			String st_categ_id = _requestHandler.getParameter("st_categ_id", "");
			String st_mast_check = _requestHandler.getParameter("st_mast_check", "");
			String st_status = _requestHandler.getParameter("st_status", "");
			String st_categ_name = _requestHandler.getParameter("st_categ_name", "");
			String st_sg_nm = _requestHandler.getParameter("st_sg_nm", "");
			String st_description = _requestHandler.getParameter("st_description", "");
			String st_specification  = _requestHandler.getParameter("st_specification", "");
			String st_model_info  = _requestHandler.getParameter("st_model_info", "");
			String st_remark  = _requestHandler.getParameter("st_remark", "");
			String st_stnd_flag  = _requestHandler.getParameter("st_stnd_flag", "");
			String st_catlg_id  = _requestHandler.getParameter("st_catlg_id", "");
			String st_item_gubun  = _requestHandler.getParameter("st_item_gubun", "");
			String st_add_user_id  = _requestHandler.getParameter("st_add_user_id", "");
			
			String selectFieldName = "";
			SelectSet[] getselectSet = null; 		// getSelectSet	
			WhereSet[] whereSet = null;
			OrderBySet[] orderBySet = null;
			Query query = null;
			QuerySet querySet = new QuerySet(1);										// QuerySet
			List<WhereSet> whereList = new ArrayList<WhereSet>();
			List<OrderBySet> orderByList = new ArrayList<OrderBySet>();
			List<Map<String, Object>> totalList = new ArrayList<Map<String, Object>>();  	
			
			
			//Group 결과 Map 초기화
			ResultSet resultSet= null;
			Result[] resultList = null;
			Result result = null;
			//Query 생성 시작
			SelectSet[] selectSet = new SelectSet[] {
					new SelectSet("CATEG_PATH", Protocol.SelectSet.NONE),
					new SelectSet("CMS_CATEG_ID", Protocol.SelectSet.NONE),
					new SelectSet("CMS_CATLG_ID", Protocol.SelectSet.NONE),
					new SelectSet("CMS_USER_NAME", Protocol.SelectSet.NONE),
					new SelectSet("DELIVERY_LT", Protocol.SelectSet.NONE),
					new SelectSet("DESCRIPTION_ENG", Protocol.SelectSet.NONE),
					new SelectSet("DESCRIPTION_LOC", Protocol.SelectSet.NONE),
					new SelectSet("IMAGE_KEY", Protocol.SelectSet.NONE),
					new SelectSet("IMG", Protocol.SelectSet.NONE),
					new SelectSet("IMG_NO", Protocol.SelectSet.NONE),
					new SelectSet("ITEM_GROUP", Protocol.SelectSet.NONE),
					new SelectSet("ITEM_GROUP_TEXT", Protocol.SelectSet.NONE),
					new SelectSet("ITEM_GUBUN", Protocol.SelectSet.NONE),
					new SelectSet("ITEM_GUBUN_TEXT", Protocol.SelectSet.NONE),
					new SelectSet("MAKER_CODE", Protocol.SelectSet.NONE),
					new SelectSet("MAKER_NAME", Protocol.SelectSet.NONE),
					new SelectSet("MAPPING", Protocol.SelectSet.NONE),
					new SelectSet("ORDER_MEASURE", Protocol.SelectSet.NONE),
					new SelectSet("ORIGIN_CODE", Protocol.SelectSet.NONE),
					new SelectSet("ORIGIN_NAME", Protocol.SelectSet.NONE),
					new SelectSet("REMARK", Protocol.SelectSet.NONE),
					new SelectSet("REMARK_IMG", Protocol.SelectSet.NONE),
					new SelectSet("SG_NAME", Protocol.SelectSet.NONE),
					new SelectSet("SPECIFICATION", Protocol.SelectSet.NONE),
					new SelectSet("STD_FLAG", Protocol.SelectSet.NONE),
					new SelectSet("TOT_CNT", Protocol.SelectSet.NONE),
					new SelectSet("STATUS", Protocol.SelectSet.NONE),
					new SelectSet("STATUS_NM", Protocol.SelectSet.NONE),
					new SelectSet("REMARK", Protocol.SelectSet.NONE),
					new SelectSet("MODEL_INFO", Protocol.SelectSet.NONE),
					new SelectSet("IMGFILE_NAME", Protocol.SelectSet.NONE),
					new SelectSet("IMGFILE_DIR", Protocol.SelectSet.NONE),
					new SelectSet("DETAIL_IMGFILE_NAME", Protocol.SelectSet.NONE),
					new SelectSet("DETAIL_IMGFILE_DIR", Protocol.SelectSet.NONE),
					new SelectSet("ADD_USER_NAME", Protocol.SelectSet.NONE)
			}; 
			int index = 0;
			if (!st_maker_nm.equals("")) { // 제조사명
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_MAKER_NAME", whereOption, st_maker_nm, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_MAKER_NAME_LIKE", whereOption, st_maker_nm, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_categ_id.equals("")){//표준카테고리
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_CMS_CATEG_ID", whereOption, st_categ_id, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_sg_nm.equals("")){//SG명
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_SG_NAME", whereOption, st_sg_nm, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_SG_NAME_LIKE", whereOption, st_sg_nm, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_status.equals("")){//상태
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_STATUS", whereOption, st_status, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_description.equals("")){//품목명
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_DESCRIPTION_LOC", whereOption, st_description, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_DESCRIPTION_LOC_LIKE", whereOption, st_description, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_model_info.equals("")){//모델정보
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_MODEL_INFO", whereOption, st_model_info, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_MODEL_INFO_LIKE", whereOption, st_model_info, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_specification.equals("")){//규격
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_SPECIFICATION", whereOption, st_specification, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_SPECIFICATION_LIKE", whereOption, st_specification, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_catlg_id.equals("")){//카탈로그ID
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_CMS_CATLG_ID", whereOption, st_catlg_id, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_stnd_flag.equals("")){//표준화여부
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_STD_FLAG", whereOption, st_stnd_flag, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_remark.equals("")){//비고
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_REMARK", whereOption, st_remark, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_item_gubun.equals("")){//품목구분
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_ITEM_GUBUN", whereOption, st_item_gubun, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_add_user_id.equals("")){//등록자ID
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_ADD_USER_ID", whereOption, st_add_user_id, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			whereSet = new WhereSet[whereList.size()];
			for(int n = 0 ; n < whereList.size() ; n++) {
				whereSet[n] = (WhereSet)whereList.get(n);
			}
			
			//OrderBySet
			orderByList.add(new OrderBySet(true, "SORT_IDX", Protocol.OrderBySet.OP_PREWEIGHT));
			orderBySet = new OrderBySet[orderByList.size()];
			
			for(int j=0;j<orderByList.size();j++){
				orderBySet[j] = (OrderBySet)orderByList.get(j);
			}
			/////////////////// 쿼리셋 //////////////
			query = new Query("<b>","</b>");
			query.setDebug(true);
			query.setFrom(getCollentionName(pRequest));
			query.setSearchOption(Protocol.SearchOption.CACHE); 
			//동의어 유의어 사용시 아래 추가
			query.setThesaurusOption((byte) (Protocol.ThesaurusOption.EQUIV_SYNONYM | Protocol.ThesaurusOption.QUASI_SYNONYM));
			query.setLoggable(true);
			query.setResult((currentPage - 1) * rowsperPage ,((currentPage - 1) * rowsperPage) + (rowsperPage - 1));
			query.setFaultless(true);
			query.setPrintQuery(true); 
			query.setSelect(selectSet); 
			//query.setFilter(filterSet);
			query.setWhere(whereSet);
			query.setOrderby(orderBySet);
			//query.setGroupBy(groupby);
			querySet.addQuery(query);
			whereList.clear();
			orderByList.clear();
			//Query 생성 종료
			//검색엔진 이중화 작업
			String realAdminIp = "";
			if( isConnectAble( adminIp, Integer.parseInt(adminPort), 1000 ) ) {
				realAdminIp = adminIp;
			} else if( isConnectAble( adminIp2, Integer.parseInt(adminPort), 1000 ) ) {
				realAdminIp = adminIp2;
			}
			LOGGER.debug("realAdminIp: {}", realAdminIp);
			CommandSearchRequest command = new CommandSearchRequest(realAdminIp, Integer.parseInt(adminPort));
			int returnCode = command.request(querySet);
			if(returnCode >= 0) {
				resultSet = command.getResultSet();
				resultList = resultSet.getResultList();
				getselectSet = query.getSelectFields();
				for(int m = 0 ; resultList != null && m < resultList.length ; m++) {
					result = resultList[m];
					//결과 리스트생성
					if(result.getRealSize() != 0) {
						for(int k=0 ;  k < result.getRealSize() ; k++) {
							Map<String, Object> tempMap = new HashMap<String, Object>(); 
							for (int j = 0; j < result.getNumField(); j++) {
								selectFieldName = new String(getselectSet[j].getField());
								String temp = new String(result.getResult(k, j));
								tempMap.put(selectFieldName, temp);
							}
							totalList.add(tempMap);
							totalSize = result.getTotalSize();
						}
					}
				}
				pModel.addAttribute("data", totalList);
				pModel.addAttribute("st_maker_nm", st_maker_nm);
				pModel.addAttribute("st_categ_id", st_categ_id);
				pModel.addAttribute("st_mast_check", st_mast_check);
				pModel.addAttribute("st_status", st_status);
				pModel.addAttribute("st_maker_nm", st_maker_nm);
				pModel.addAttribute("st_categ_name", st_categ_name);
				pModel.addAttribute("st_sg_nm", st_sg_nm);
				pModel.addAttribute("st_description", st_description);
				pModel.addAttribute("st_specification", st_specification);
				pModel.addAttribute("st_model_info", st_model_info);
				pModel.addAttribute("st_stnd_flag", st_stnd_flag);
				pModel.addAttribute("st_catlg_id", st_catlg_id);
				pModel.addAttribute("st_remark", st_remark);
				pModel.addAttribute("st_catlg_id", st_catlg_id);
				pModel.addAttribute("totalCnt", String.valueOf(totalSize));
			} else {
				ErrorMessage errorMessage = command.getException();
				String errorMsg = errorMessage.getErrorMessage();
				LOGGER.error("Error Code : " + returnCode);
				LOGGER.error("Error Msg  : " + errorMsg);
			}

			return "common/popup/mprq/masterMpRqStndCatalgListPop";
	}	
	/**
	 * 표준카탈로그 검색 리스트
	 * 
	 * @param request
	 * @param response
	 * @param pModel
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mdcm/excelStndCaltlgList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public void excelStndCaltlgList(HttpServletRequest pRequest, HttpServletResponse response, ModelMap pModel	, OutputStream outputStream ) throws Exception {
		RequestHandler _requestHandler = new RequestHandler(pRequest, pRequest.getSession().getServletContext(),"utf-8");
		
			int rowsperPage = Integer.parseInt(_requestHandler.getParameter("onepagerow", "10"));
			int currentPage = Integer.parseInt(_requestHandler.getParameter("curPage", "1"));
			int totalSize = 0;
			String searchOption = _requestHandler.getParameter("searchOption", "and");						//검색 카테고리
			byte whereOption = searchOption.equals("or") ? Protocol.WhereSet.OP_HASANY : Protocol.WhereSet.OP_HASALL;
			String st_maker_nm = _requestHandler.getParameter("st_maker_nm", "");
			String st_categ_id = _requestHandler.getParameter("st_categ_id", "");
			String st_mast_check = _requestHandler.getParameter("st_mast_check", "");
			String st_status = _requestHandler.getParameter("st_status", "");
			String st_categ_name = _requestHandler.getParameter("st_categ_name", "");
			String st_sg_nm = _requestHandler.getParameter("st_sg_nm", "");
			String st_description = _requestHandler.getParameter("st_description", "");
			String st_specification  = _requestHandler.getParameter("st_specification", "");
			String st_stnd_flag  = _requestHandler.getParameter("st_stnd_flag", "");
			String st_model_info  = _requestHandler.getParameter("st_model_info", "");
			String st_remark  = _requestHandler.getParameter("st_remark", "");
			String st_catlg_id  = _requestHandler.getParameter("st_catlg_id", "");
			LOGGER.debug(" st_stnd_flag {}", st_stnd_flag);
			String selectFieldName = "";
			SelectSet[] getselectSet = null; 		// getSelectSet	
			WhereSet[] whereSet = null;
			FilterSet[] filterSet = null; 
			OrderBySet[] orderBySet = null;
			GroupBySet[] groupby = null;
			Query query = null;
			QuerySet querySet = new QuerySet(1);										// QuerySet
			List<WhereSet> whereList = new ArrayList<WhereSet>();
			List<OrderBySet> orderByList = new ArrayList<OrderBySet>();
			List<Map<String, String>> totalList = new ArrayList<Map<String, String>>();  	
			
			
			//Group 결과 Map 초기화
			ResultSet resultSet= null;
			Result[] resultList = null;
			Result result = null;
			//Query 생성 시작
			SelectSet[] selectSet = new SelectSet[] {
					new SelectSet("CATEG_PATH", Protocol.SelectSet.NONE),
					new SelectSet("CMS_CATEG_ID", Protocol.SelectSet.NONE),
					new SelectSet("CMS_CATLG_ID", Protocol.SelectSet.NONE),
					new SelectSet("CMS_USER_NAME", Protocol.SelectSet.NONE),
					new SelectSet("DELIVERY_LT", Protocol.SelectSet.NONE),
					new SelectSet("DESCRIPTION_ENG", Protocol.SelectSet.NONE),
					new SelectSet("DESCRIPTION_LOC", Protocol.SelectSet.NONE),
					new SelectSet("IMAGE_KEY", Protocol.SelectSet.NONE),
					new SelectSet("IMG", Protocol.SelectSet.NONE),
					new SelectSet("IMG_NO", Protocol.SelectSet.NONE),
					new SelectSet("ITEM_GROUP", Protocol.SelectSet.NONE),
					new SelectSet("ITEM_GROUP_TEXT", Protocol.SelectSet.NONE),
					new SelectSet("ITEM_GUBUN", Protocol.SelectSet.NONE),
					new SelectSet("ITEM_GUBUN_TEXT", Protocol.SelectSet.NONE),
					new SelectSet("MAKER_CODE", Protocol.SelectSet.NONE),
					new SelectSet("MAKER_NAME", Protocol.SelectSet.NONE),
					new SelectSet("MAPPING", Protocol.SelectSet.NONE),
					new SelectSet("ORDER_MEASURE", Protocol.SelectSet.NONE),
					new SelectSet("ORIGIN_CODE", Protocol.SelectSet.NONE),
					new SelectSet("ORIGIN_NAME", Protocol.SelectSet.NONE),
					new SelectSet("REMARK", Protocol.SelectSet.NONE),
					new SelectSet("REMARK_IMG", Protocol.SelectSet.NONE),
					new SelectSet("SG_NAME", Protocol.SelectSet.NONE),
					new SelectSet("SPECIFICATION", Protocol.SelectSet.NONE),
					new SelectSet("STD_FLAG", Protocol.SelectSet.NONE),
					new SelectSet("TOT_CNT", Protocol.SelectSet.NONE),
					new SelectSet("STATUS", Protocol.SelectSet.NONE),
					new SelectSet("STATUS_NM", Protocol.SelectSet.NONE),
					new SelectSet("REMARK", Protocol.SelectSet.NONE),
					new SelectSet("MODEL_INFO", Protocol.SelectSet.NONE),
					new SelectSet("IMGFILE_NAME", Protocol.SelectSet.NONE),
					new SelectSet("IMGFILE_DIR", Protocol.SelectSet.NONE),
					new SelectSet("DETAIL_IMGFILE_NAME", Protocol.SelectSet.NONE),
					new SelectSet("DETAIL_IMGFILE_DIR", Protocol.SelectSet.NONE)
					
			}; 
			int index = 0;
			if (!st_maker_nm.equals("")) { // 제조사명
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_MAKER_NAME", whereOption, st_maker_nm, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_MAKER_NAME_LIKE", whereOption, st_maker_nm, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_categ_id.equals("")){//표준카테고리
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_CMS_CATEG_ID", whereOption, st_categ_id, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_sg_nm.equals("")){//SG명
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_SG_NAME", whereOption, st_sg_nm, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_SG_NAME_LIKE", whereOption, st_sg_nm, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_status.equals("")){//상태
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_STATUS", whereOption, st_status, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_description.equals("")){//품목명
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_DESCRIPTION_LOC", whereOption, st_description, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_DESCRIPTION_LOC_LIKE", whereOption, st_description, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_specification.equals("")){//규격
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_SPECIFICATION", whereOption, st_specification, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				whereList.add(new WhereSet("IDX_SPECIFICATION_LIKE", whereOption, st_specification, 100));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_model_info.equals("")){//모델정보
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_MODEL_INFO", whereOption, st_model_info, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_stnd_flag.equals("")){//표준화여부
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_STD_FLAG", whereOption, st_stnd_flag, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_catlg_id.equals("")){//표준화카탈로그코드
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_CMS_CATLG_ID", whereOption, st_catlg_id, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			if(!st_remark.equals("")){//비고
				if(index > 0){
					whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
				}
				index++;
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				whereList.add(new WhereSet("IDX_REMARK", whereOption, st_remark, 1000));
				whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
			}
			whereSet = new WhereSet[whereList.size()];
			for(int n = 0 ; n < whereList.size() ; n++) {
				whereSet[n] = (WhereSet)whereList.get(n);
			}
			
			//OrderBySet
			orderByList.add(new OrderBySet(true, "SORT_IDX", Protocol.OrderBySet.OP_PREWEIGHT));
			orderBySet = new OrderBySet[orderByList.size()];
			
			for(int j=0;j<orderByList.size();j++){
				orderBySet[j] = (OrderBySet)orderByList.get(j);
			}
			/////////////////// 쿼리셋 //////////////
			query = new Query("<b>","</b>");
			query.setDebug(true);
			query.setFrom(getCollentionName(pRequest));
			query.setSearchOption(Protocol.SearchOption.CACHE); 
			//동의어 유의어 사용시 아래 추가
			query.setThesaurusOption((byte) (Protocol.ThesaurusOption.EQUIV_SYNONYM | Protocol.ThesaurusOption.QUASI_SYNONYM));
			query.setLoggable(true);
			query.setResult((currentPage - 1) * rowsperPage ,((currentPage - 1) * rowsperPage) + (rowsperPage - 1));
			query.setFaultless(true);
			query.setPrintQuery(true); 
			query.setSelect(selectSet); 
			//query.setFilter(filterSet);
			query.setWhere(whereSet);
			query.setOrderby(orderBySet);
			//query.setGroupBy(groupby);
			querySet.addQuery(query);
			whereList.clear();
			orderByList.clear();
			//Query 생성 종료
			
			CommandSearchRequest command = new CommandSearchRequest(adminIp, Integer.parseInt(adminPort));
			int returnCode = command.request(querySet);
			if(returnCode >= 0) {
				resultSet = command.getResultSet();
				resultList = resultSet.getResultList();
				getselectSet = query.getSelectFields();
				for(int m = 0 ; resultList != null && m < resultList.length ; m++) {
					result = resultList[m];
					//결과 리스트생성
					if(result.getRealSize() != 0) {
						for(int k=0 ;  k < result.getRealSize() ; k++) {
							Map<String, String> tempMap = new HashMap<String, String>(); 
							for (int j = 0; j < result.getNumField(); j++) {
								selectFieldName = new String(getselectSet[j].getField());
								String temp = new String(result.getResult(k, j));
								tempMap.put(selectFieldName, temp);
							}
							totalList.add(tempMap);
							totalSize = result.getTotalSize();
						}
					}
				}
				String title = "";
				String headers = "";
				title = "표준카탈로그코드|";
				headers = "CMS_CATEG_ID|";
				String excelHeader = title +"@@"+headers;
				CommonUtil.downloadExcel(totalList, response, outputStream, excelHeader ,"표준카탈로그조회.xls");
			} else {
				ErrorMessage errorMessage = command.getException();
				String errorMsg = errorMessage.getErrorMessage();
				LOGGER.error("Error Code : " + returnCode);
				LOGGER.error("Error Msg  : " + errorMsg);
			}

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

