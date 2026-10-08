package com.koreab2b.mro.search.diquest;

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

@Controller("makerSearchController")
public class MakerSearchController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(DiquestController.class);

	@Value("#{diquestProps['diquest.admin.ip']}")
	private String adminIp;

	@Value("#{diquestProps['diquest.dqcat.ip']}")
	private String adminIp2;
	
	@Value("#{diquestProps['diquest.admin.port']}")
	private String adminPort;

	@Value("#{diquestProps['diquest.collection.dev.maker.name']}")
	private String collentionDevName; 
	
	@Value("#{diquestProps['diquest.collection.real.maker.name']}")
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
	 * 제조사(검색엔진) 검색 조회 팝업
	 * 
	 * @param request
	 * @param response
	 * @param pModel
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/common/getAgentRegMakerCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getAgentRegMakerCodePop(HttpServletRequest pRequest, HttpServletResponse response, ModelMap pModel) throws Exception {
		RequestHandler _requestHandler = new RequestHandler(pRequest, pRequest.getSession().getServletContext(),"utf-8");
		String searchTerm = _requestHandler.getParameter("st_del_name", "");
		//collentionName = "ICOMCOD1";
		
		int rowsperPage = Integer.parseInt(_requestHandler.getParameter("onepagerow", "1000"));	//페이지 row
		int currentPage = Integer.parseInt(_requestHandler.getParameter("curPage", "1"));				//현제 페이지
		String searchOption = _requestHandler.getParameter("searchOption", "and");						//검색 카테고리
		int totalSize = 0;
		byte whereOption = searchOption.equals("or") ? Protocol.WhereSet.OP_HASANY : Protocol.WhereSet.OP_HASALL;
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
		List<Map<String, Object>> totalList = new ArrayList<Map<String, Object>>();  	//뉴스소식 결과 List
		
		//Group 결과 Map 초기화
		ResultSet resultSet= null;
		Result[] resultList = null;
		Result result = null;
		
		// 검색어가 있을 경우
		if( !searchTerm.trim().equals("") ) {
			//Query 생성 시작
			SelectSet[] selectSet = new SelectSet[] {
					new SelectSet("TYPE", Protocol.SelectSet.NONE),
					new SelectSet("CODE", Protocol.SelectSet.NONE),
					new SelectSet("TEXT1", Protocol.SelectSet.NONE),
					new SelectSet("TEXT2", Protocol.SelectSet.NONE),
					new SelectSet("TEXT3", Protocol.SelectSet.NONE),
					new SelectSet("TEXT4", Protocol.SelectSet.NONE),
					new SelectSet("TEXT5", Protocol.SelectSet.NONE),
					new SelectSet("TEXT6", Protocol.SelectSet.NONE),
					new SelectSet("FLAG", Protocol.SelectSet.NONE),
					new SelectSet("VALUE1", Protocol.SelectSet.NONE),
					new SelectSet("TEXT1_LIKE", Protocol.SelectSet.HIGHLIGHT)
			}; 
			
			//WhereSet
			whereList.add(new WhereSet("TEXT1_LIKE", whereOption, searchTerm , 1000));
			whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			whereList.add(new WhereSet("TEXT2", whereOption, searchTerm , 1000));
			whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			whereList.add(new WhereSet("TEXT5", whereOption, searchTerm , 1000));
			whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
			whereList.add(new WhereSet("FLAG", whereOption, "Y" , 1000));
			whereSet = new WhereSet[whereList.size()];
			for(int n = 0 ; n < whereList.size() ; n++) {
				whereSet[n] = (WhereSet)whereList.get(n);
			}
			
			//filterSet
			filterSet = new FilterSet[] { new FilterSet(Protocol.FilterSet.OP_MATCH, "FILTER_TYPE", "M104") };
			
			//OrderBySet
			orderByList.add(new OrderBySet(true, "SORT_TEXT1", Protocol.OrderBySet.OP_PREWEIGHT));
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
			query.setFilter(filterSet);
			query.setWhere(whereSet);
			query.setOrderby(orderBySet);
			query.setGroupBy(groupby);
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
				pModel.addAttribute("totalSize", totalSize);
			} else {
				ErrorMessage errorMessage = command.getException();
				String errorMsg = errorMessage.getErrorMessage();
				LOGGER.error("Error Code : " + returnCode);
				LOGGER.error("Error Msg  : " + errorMsg);
			}
		}
		
		return "common/popup/agentRegMakerCodePop";
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
