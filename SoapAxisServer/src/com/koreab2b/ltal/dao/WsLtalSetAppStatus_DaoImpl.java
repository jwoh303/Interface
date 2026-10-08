package com.koreab2b.ltal.dao;

import java.io.Reader;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.ltal.vo.ApprovalStatusVO;
import com.koreab2b.ltal.vo.ReturnVO;

public class WsLtalSetAppStatus_DaoImpl implements WsLtalSetAppStatus_Dao {
	
	private Logger log	= Logger.getLogger(this.getClass().getName());
	private SqlMapClient sqlMapper;

	public WsLtalSetAppStatus_DaoImpl() {
		try {
			Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public ReturnVO saveAppStatus(ApprovalStatusVO[] aprList)  throws Exception{
		ReturnVO ret = new ReturnVO();
		
		try {
			this.sqlMapper.startTransaction();
			
			for(int i=0;i<aprList.length;i++){
				
				if( "1".equals(aprList[i].getDATA01()) ) {

					String keyNo	= aprList[i].getKEY_NO();
					String buyerInfo	= keyNo.substring( keyNo.indexOf("_") + 1 );
					String buyer	= buyerInfo.substring( 1, buyerInfo.indexOf("_") - 1 );
					String doc_no	= buyerInfo.substring( buyerInfo.indexOf("_") + 1 );
					String doc_type	= doc_no.substring(1,2);
					
					Map<String, String> kMap	= new HashMap<String, String>();
					kMap.put("BUYER", buyer);
					kMap.put("DOC_NO", doc_no);
					
					if ("PX".equals(doc_type)) {
						// 주문품의
						// UPDATE ICOMPRDT SET RECV_FLAG = 'GS' WHERE BUYER = AND REF_NO = ##
						sqlMapper.insert("updatePRAppStatus",kMap);
						
					} else if ("RX".equals(doc_type)) {
						// 단가합의품의
						// UPDATE KEPRQDT SET RECV_FLAG = 'GS'
						sqlMapper.insert("updateRQAppStatus",kMap);
					}
				} 
				
				sqlMapper.insert("insertAppStatus",aprList[i]);	
				
			}
			ret.setResult("Y");
			this.sqlMapper.commitTransaction();
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			ret.setResult("E");
		} finally {
			this.sqlMapper.endTransaction();
		}
		
		return ret;
	}

}
