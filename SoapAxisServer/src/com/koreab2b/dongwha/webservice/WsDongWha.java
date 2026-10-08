package com.koreab2b.dongwha.webservice;

import java.util.List;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.ReturnVO;
import com.koreab2b.dongwha.service.WsDongwhaService;
import com.koreab2b.dongwha.vo.AppSendCallVO;
import com.koreab2b.dongwha.vo.AppStatusVO;
import com.koreab2b.dongwha.vo.AssetVO;
import com.koreab2b.dongwha.vo.CostCenterVO;
import com.koreab2b.dongwha.vo.GrVO;
import com.koreab2b.dongwha.vo.ItemVO;
import com.koreab2b.dongwha.vo.PoVO;
import com.koreab2b.dongwha.vo.UserVO;
import com.koreab2b.util.CommonUtil;

@WebService(serviceName="WsDongWha")
public class WsDongWha {

	private Logger log	= Logger.getLogger(this.getClass());
	private WsDongwhaService service = new WsDongwhaService();

	public ReturnVO setPo(List<PoVO> objs) {

		PoVO povo = new PoVO();
		ReturnVO revo = new ReturnVO();
		
			try {
			    service.setPoList(objs);
			    revo.setRESULT_FLAG("S");
				revo.setMESSAGE("SUCCESS");
			} catch (Exception e) {
				log.error(CommonUtil.printStackTraceToString(e));
				revo.setRESULT_FLAG("F");
				revo.setMESSAGE(e.getMessage());
			} finally {
				log.info("DONGWHA setPo : " + revo.getRESULT_FLAG());
				
			}

		return revo;
	}

	public ReturnVO setGr(List<GrVO> objs) {

		GrVO grvo = new GrVO();
		ReturnVO revo = new ReturnVO();
		
		
			try {
			    service.setGrList(objs);
			    revo.setRESULT_FLAG("S");
				revo.setMESSAGE("SUCCESS");
			} catch (Exception e) {
				log.error(CommonUtil.printStackTraceToString(e));
				revo.setRESULT_FLAG("F");
				revo.setMESSAGE(e.getMessage());
			} finally {
	//			service.setSavePoLog(objs);
				log.info("DONGWHA setGr : " + revo.getRESULT_FLAG());
			}

		return revo;
	}
	public ReturnVO setItem(List<ItemVO> objs) {

		ItemVO itemvo = new ItemVO();
		ReturnVO revo = new ReturnVO();

		
			try {
			    service.setItemList(objs);
			    revo.setRESULT_FLAG("S");
				revo.setMESSAGE("SUCCESS");
			} catch (Exception e) {
				log.error(CommonUtil.printStackTraceToString(e));
				revo.setRESULT_FLAG("F");
				revo.setMESSAGE(e.getMessage());
			} finally {
	//			service.setSavePoLog(objs);
				log.info("DONGWHA setItem : " + revo.getRESULT_FLAG());
			}

		return revo;
	}
	public ReturnVO setAppSendCall(List<AppSendCallVO> objs) {

		AppSendCallVO appsendcallvo = new AppSendCallVO();
		ReturnVO revo = new ReturnVO();
		
		
			try {
			    service.setAppSendCallList(objs);
			    revo.setRESULT_FLAG("S");
				revo.setMESSAGE("SUCCESS");
			} catch (Exception e) {
				log.error(CommonUtil.printStackTraceToString(e));
				revo.setRESULT_FLAG("F");
				revo.setMESSAGE(e.getMessage());
			} finally {
	//			service.setSavePoLog(objs);
				log.info("DONGWHA setAppSendCall : " + revo.getRESULT_FLAG());
			}

		return revo;
	}
	public ReturnVO setAppStatus(List<AppStatusVO> objs) {

		AppStatusVO appstatusvo = new AppStatusVO();
		ReturnVO revo = new ReturnVO();
		
		
			try {
			    service.setAppStatusList(objs);
			    revo.setRESULT_FLAG("S");
				revo.setMESSAGE("SUCCESS");
			} catch (Exception e) {
				log.error(CommonUtil.printStackTraceToString(e));
				revo.setRESULT_FLAG("F");
				revo.setMESSAGE(e.getMessage());
			} finally {
				service.setSaveAppLog(objs);   
				log.info("DONGWHA setAppStatus : " + revo.getRESULT_FLAG());
			}

		return revo;
	}
	public ReturnVO setCostCenter(List<CostCenterVO> objs) {

		CostCenterVO costcentervo = new CostCenterVO();
		ReturnVO revo = new ReturnVO();
		
			try {
			    service.setCostCenterList(objs);
			    revo.setRESULT_FLAG("S");
				revo.setMESSAGE("SUCCESS");
			} catch (Exception e) {
				log.error(CommonUtil.printStackTraceToString(e));
				revo.setRESULT_FLAG("F");
				revo.setMESSAGE(e.getMessage());
			} finally {
	//			service.setSavePoLog(objs);
				log.info("DONGWHA setCostCenter : " + revo.getRESULT_FLAG());
			}

		return revo;
	}
	public ReturnVO setAsset(List<AssetVO> objs) {

		AssetVO budgetvo = new AssetVO();
		ReturnVO revo = new ReturnVO();
			try {
			    service.setAssetList(objs);
			    revo.setRESULT_FLAG("S");
				revo.setMESSAGE("SUCCESS");
			} catch (Exception e) {
				log.error(CommonUtil.printStackTraceToString(e));
				revo.setRESULT_FLAG("F");
				revo.setMESSAGE(e.getMessage());
			} finally {
	//			service.setSavePoLog(objs);
				log.info("DONGWHA setAsset : " + revo.getRESULT_FLAG());
			}

		return revo;
	}
	
	public ReturnVO setUser(List<UserVO> objs) {

		UserVO uservo = new UserVO();
		ReturnVO revo = new ReturnVO();
			try {
			    service.setUserList(objs);
			    revo.setRESULT_FLAG("S");
				revo.setMESSAGE("SUCCESS");
			} catch (Exception e) {
				log.error(CommonUtil.printStackTraceToString(e));
				revo.setRESULT_FLAG("F");
				revo.setMESSAGE(e.getMessage());
			} finally {
	//			service.setSavePoLog(objs);
				log.info("DONGWHA setUser : " + revo.getRESULT_FLAG());
			}
			return revo;
	}
}