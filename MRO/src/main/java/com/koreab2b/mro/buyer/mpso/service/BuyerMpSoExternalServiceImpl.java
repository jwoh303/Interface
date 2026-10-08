/**
 * 
 */
package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoExternalDao;

/**
 * @author Jinsoo
 *
 */

@Service("buyerMpSoExternalService")
public class BuyerMpSoExternalServiceImpl implements BuyerMpSoExternalService {
	
	@Autowired
	BuyerMpSoExternalDao buyerMpSoExternalDao;

	@Override
	public List<Map<String, String>> getKwangdongGWList(Map<String, String> pMap) {
		return buyerMpSoExternalDao.selectKwangdongGWList(pMap);
	}

	@Override
	public String setKwangdongApproval(Map<String, String> pMap) {
		return buyerMpSoExternalDao.processKwangdongApproval(pMap);
	}

	@Override
	public String setMisumiCheckOut(Map<String, String> pMap) {
		return buyerMpSoExternalDao.saveMisumiCheckOut(pMap);
	}

	@Override
	public String setMisumiBuyerCheckOut(List<Map<String, String>> pMaps) {
		return buyerMpSoExternalDao.saveMisumiBuyerCheckOut(pMaps);
	}

	@Override
	public Map<String, String> getUserInfo(Map<String, String> pMap) {
		return buyerMpSoExternalDao.selectUserInfo(pMap);
	}

	@Override
	public void saveGRCompareEvent(Map<String, String> pMap) {
		buyerMpSoExternalDao.saveGRCompareEvent(pMap);
	}

	@Override
	public void saveYPZincCartEvent(Map<String, String> pMap) {
		buyerMpSoExternalDao.saveYPZincCartEvent(pMap);
	}
	
	@Override
	public Map<String, String> getLoginXmlForSGS(Map<String, String> pMap) {
		return buyerMpSoExternalDao.selectLoginInfoForSGS(pMap);
	}
	
	@Override
	public Map<String, String> getLoginXmlForFAGB(Map<String, String> pMap) {
		return buyerMpSoExternalDao.selectLoginInfoForFAGB(pMap);
	}
	
	@Override
	public Map<String, String> getLoginXmlForPMK(Map<String, String> pMap) {
		return buyerMpSoExternalDao.selectLoginInfoForPMK(pMap);
	}
	
	@Override
	public Map<String, String> getLoginXmlForYHKB(Map<String, String> pMap) {
		return buyerMpSoExternalDao.selectLoginInfoForYHKB(pMap);
	}	
	
	@Override
	public String saveSgsPurchaseOrder(List<Map<String, String>> pMaps) {
		return buyerMpSoExternalDao.saveSgsPurchaseOrder(pMaps);
	}
	
	@Override
	public void saveLog(Map<String, String> pMap) {
		buyerMpSoExternalDao.saveLog(pMap);
	}
	@Override
	public List<Map<String, String>> getWhaninPrList(Map<String, String> pMap) {
		return buyerMpSoExternalDao.selectWhaninPrList(pMap);
	}
	@Override
	public List<Map<String, String>> getNCCHAppReqList(Map<String, String> pMap) {
		return buyerMpSoExternalDao.selectNCCHAppReqList(pMap);
	}
	@Override
	public String setExternNCCHApproval(Map<String, String> pMap) {
		return buyerMpSoExternalDao.processNCCHExternApproval(pMap);
	}
	
	@Override
	public void setQuratisCallbackList(Map<String, String> pMap) {
		 buyerMpSoExternalDao.processQuratisCallbackList(pMap);
	}
	
	
	@Override
	public void setQuratisBizboxCallbackList(Map<String, String> pMap) throws Exception {
		buyerMpSoExternalDao.processQuratisBizboxCallbackList(pMap);
	}

	@Override
	public void setHongIkCallbackList(Map<String, String> pMap) {
		 buyerMpSoExternalDao.processHongIkCallbackList(pMap);
	}
	
	@Override
	public List<Map<String, String>> setLnfAppSendList (Map<String, String> pMap){
		return buyerMpSoExternalDao.processLnfAppSendList(pMap);
	}
	
	@Override
	public void setLnfCallbackList(Map<String, String> pMap) {
		buyerMpSoExternalDao.processLnfCallbackList(pMap);
	}

	@Override
	public Map<String, String> setHanwhaUser(Map<String, String> pMap) {
		return buyerMpSoExternalDao.mergetHanwhaUser(pMap);
	}

	@Override
	public List<Map<String, String>> getHanwhaAppUserList(Map<String, Object> pMap) {
		return buyerMpSoExternalDao.selectHanwhaAppUserList(pMap);
	}
	@Override
	public void setAeKyAppStatus(Map<String, Object> pMap, String type) {
		 buyerMpSoExternalDao.processAeKyAppStatus(pMap, type);
	}

	@Override
	public Map<String, Object> getLotteMpRqAppSend(Map<String, Object> pMap) throws Exception {
		return buyerMpSoExternalDao.processLotteMpRqAppSend(pMap);
	}

	@Override
	public String saveFagbPurchaseOrder(List<Map<String, String>> pMaps) {
		return buyerMpSoExternalDao.saveFagbPurchaseOrder(pMaps);
	}

	@Override
	public String savePMKPurchaseOrder(List<Map<String, String>> pMaps) {
		return buyerMpSoExternalDao.savePMKPurchaseOrder(pMaps);
	}
	
	@Override
	public String saveYHKBPurchaseOrder(List<Map<String, String>> pMaps) {
		return buyerMpSoExternalDao.saveYHKBPurchaseOrder(pMaps);
	}

	@Override
	public void setSoulbrainMsdsStatus(Map<String, String> pMap) {
		buyerMpSoExternalDao.setSoulbrainMsdsStatus(pMap);
		
	}
 
	@Override
	public String saveYhkbSignUp(Map<String, String> pMap) {		
		return buyerMpSoExternalDao.saveYhkbSignUp(pMap);
	}
}
