package com.koreab2b.ltal.dao;

import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.ltal.vo.InvoiceHeaderVO;
import com.koreab2b.ltal.vo.InvoiceVO;
import com.koreab2b.ltal.vo.RequestVO;

@SuppressWarnings("unchecked")
public class WsLtalGetINVInfo_DaoImpl implements WsLtalGetINVInfo_Dao {

	private Logger log	= Logger.getLogger(this.getClass().getName());
	private SqlMapClient sqlMapper;
	
	public WsLtalGetINVInfo_DaoImpl() {
		try {
			Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	@Override
	public List<InvoiceVO> getInvInfo(RequestVO requestVO) throws Exception{
		List<InvoiceVO> retList = new ArrayList<InvoiceVO>();
		
		List<String> sendList = new ArrayList<String>();
		
		try {
			this.sqlMapper.startTransaction();
			
			/*전송 대상건 select max 30*/
			sendList = this.sqlMapper.queryForList("getInvoiceList");
			
			for (int i = 0; i < sendList.size(); i++) {
				
				InvoiceVO vo = new InvoiceVO(); 
				
				vo.setInvHeader((InvoiceHeaderVO)this.sqlMapper.queryForObject("getInvoiceHeader",sendList.get(i)));
				vo.setInvItemList(this.sqlMapper.queryForList("getInvoiceDataList",sendList.get(i)));
				retList.add(vo);
				this.sqlMapper.update("updateInvoiceList",sendList.get(i));
			}
			
			this.sqlMapper.commitTransaction();
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
		} finally {
			this.sqlMapper.endTransaction();
		}
		
		return retList;
	}
}
