package com.kep.common.batch;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.apache.log4j.Logger;

import com.aeky.budget.send.service.ZMRO_BD_CREATE;
import com.kep.aeky.service.AekyGetBdgtService;
import com.kep.aeky.service.AekyGetBdgtServiceImpl;
import com.kep.aeky.service.AekySendBdgtService;
import com.kep.aeky.service.AekySendBdgtServiceImpl;
import com.kep.amorepacific.service.AmorepacificFiCheckService;
import com.kep.amorepacific.service.AmorepacificFiCheckServiceImpl;
import com.kep.amorepacific.service.AmorepacificFiOrderService;
import com.kep.amorepacific.service.AmorepacificFiOrderServiceImpl;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.cretec.service.CretecService;
import com.kep.delivery.service.DeliveryService;
import com.kep.delivery.service.DeliveryServiceImpl;
import com.kep.delivery.service.HanjinCancelService;
import com.kep.delivery.service.HanjinCancelServiceImpl;
import com.kep.delivery.service.HanjinOrderService;
import com.kep.delivery.service.HanjinOrderServiceImpl;
import com.kep.delivery.service.HanjinPrintService;
import com.kep.delivery.service.HanjinPrintServiceImpl;
import com.kep.delivery.service.ParcelSearchService;
import com.kep.delivery.service.ParcelSearchServiceImpl;
import com.kep.delivery.service.ParcelTrackingService;
import com.kep.delivery.service.ParcelTrackingServiceImpl;
import com.kep.duzon.service.CreditService;
import com.kep.duzon.service.FiService;
import com.kep.duzon.service.PartnerService;
import com.kep.exchangerate.service.ExchangeRateService;
import com.kep.exchangerate.service.ExchangeRateServiceImpl;
import com.kep.exchangerate.service.ExchangeRateTestService;
import com.kep.exchangerate.service.ExchangeRateTestServiceImpl;
import com.kep.gift.service.GiftService;
import com.kep.gsenc.service.GsencAppService;
import com.kep.hancom.service.HanComService;
import com.kep.hancom.service.HanComServiceImpl;
import com.kep.hans.service.HansGrSubmitService;
import com.kep.hans.service.HansGrSubmitServiceImpl;
import com.kep.hans.service.HansPoStatusService;
import com.kep.hans.service.HansPoStatusServiceImpl;
import com.kep.hans.service.HansPrCheckService;
import com.kep.hans.service.HansPrCheckServiceImpl;
import com.kep.hans.service.HansPrSubmitService;
import com.kep.hans.service.HansPrSubmitServiceImpl;
import com.kep.hanssem.service.HanssemAvailBudgetService;
import com.kep.hanssem.service.HanssemAvailBudgetServiceImpl;
import com.kep.hanssem.service.HanssemBudgetService;
import com.kep.hanssem.service.HanssemBudgetServiceImpl;
import com.kep.hanssem.service.HanssemCloseService;
import com.kep.hanssem.service.HanssemCloseServiceImpl;
import com.kep.hanssem.service.HanssemCostCenterService;
import com.kep.hanssem.service.HanssemCostCenterServiceImpl;
import com.kep.hanssem.service.HanssemGLAccountService;
import com.kep.hanssem.service.HanssemGLAccountServiceImpl;
import com.kep.hanssem.service.HanssemGrService;
import com.kep.hanssem.service.HanssemGrServiceImpl;
import com.kep.hanssem.service.HanssemPoListService;
import com.kep.hanssem.service.HanssemPoListServiceImpl;
import com.kep.hanssem.service.HanssemPoService;
import com.kep.hanssem.service.HanssemPoServiceImpl;
import com.kep.hanssem.service.HanssemUserService;
import com.kep.hanssem.service.HanssemUserServiceImpl;
import com.kep.hanwha.Nego.status.service.HanWhaNegoStatusService;
import com.kep.hanwha.Nego.submit.service.HanWhaNegoSubmitService;
import com.kep.hanwha.RqRequest.status.service.HanWhaRqRequestStatusService;
import com.kep.hanwha.RqRequest.submit.service.HanWhaRqRequestSubmitService;
import com.kep.hanwha.app.status.service.HanWhaAppStatusService;
import com.kep.hanwha.app.status.service.HanWhaAppStatusServiceImpl;
import com.kep.hanwha.app.submit.service.HanWhaAppSubmitService;
import com.kep.hanwha.app.submit.service.HanWhaAppSubmitServiceImpl;
import com.kep.hanwhaaero.app.submit.service.HanWhaAeroAppStatusService;
import com.kep.hanwhaaero.app.submit.service.HanWhaAeroAppStatusServiceImpl;
import com.kep.hanwhaaero.app.submit.service.hanwhaAeroAppSubmitService;
import com.kep.hanwhaaero.app.submit.service.hanwhaAeroAppSubmitServiceImpl;
import com.kep.hkInn.service.HkInnBrandService;
import com.kep.hkInn.service.HkInnBrandServiceImpl;
import com.kep.hkInn.service.HkInnInvoiceService;
import com.kep.hkInn.service.HkInnInvoiceServiceImpl;
import com.kep.hkInn.service.HkInnItemService;
import com.kep.hkInn.service.HkInnItemServiceImpl;
import com.kep.hkInn.service.HkInnPoCancelService;
import com.kep.hkInn.service.HkInnPoCancelServiceImpl;
import com.kep.hkInn.service.HkInnPoStatusService;
import com.kep.hkInn.service.HkInnPoStatusServiceImpl;
import com.kep.hoban.service.HobanGrService;
import com.kep.hoban.service.HobanGrServiceImpl;
import com.kep.hoban.service.HobanPoService;
import com.kep.hoban.service.HobanPoServiceImpl;
import com.kep.hoban.service.HobanRqService;
import com.kep.hoban.service.HobanRqServiceImpl;
import com.kep.hugel.service.HugelService;
import com.kep.hugel.service.HugelServiceImpl;
import com.kep.hwDefense.app.status.service.HWDFAppStatusService;
import com.kep.hwDefense.app.status.service.HWDFAppStatusServiceImpl;
import com.kep.hwDefense.app.submit.service.HWDFAppSubmitService;
import com.kep.hwDefense.app.submit.service.HWDFAppSubmitServiceImpl;
import com.kep.hwDefense.gr.submit.service.HWDFGrSubmitService;
import com.kep.hwDefense.gr.submit.service.HWDFGrSubmitServiceImpl;
import com.kep.hwin.app.send.service.AppSendService;
import com.kep.hwin.app.send.service.AppSendServiceImpl;
import com.kep.hwin.app.status.service.HwinAppStatusService;
import com.kep.hwin.app.status.service.HwinAppStatusServiceImpl;
import com.kep.josu.service.BudgetSendService;
import com.kep.josu.service.BudgetSendServiceImpl;
import com.kep.josu.service.BudgetStatusService;
import com.kep.josu.service.BudgetStatusServiceImpl;
import com.kep.josu.service.BudgetTestService;
import com.kep.josu.service.BudgetTestServiceImpl;
import com.kep.josu.service.FiCloseSendService;
import com.kep.josu.service.FiCloseSendServiceImpl;
import com.kep.jwph.service.JwphItSubmitService;
import com.kep.jwph.service.JwphItSubmitServiceImpl;
import com.kep.jwph.service.JwphPoStatusService;
import com.kep.jwph.service.JwphPoStatusServiceImpl;
import com.kep.kumh.pr.submit.service.KUMHGrLoadService;
import com.kep.kumh.pr.submit.service.KUMHGrLoadServiceImpl;
import com.kep.kumh.pr.submit.service.KUMHPrSubmitService;
import com.kep.kumh.pr.submit.service.KUMHPrSubmitServiceImpl;
import com.kep.mail.service.SendMailService;
import com.kep.mail.service.SendMailServiceImpl;
import com.kep.modusign.service.EcontractModuSignService;
import com.kep.monthclosing.service.MonthClosingService;
import com.kep.nexe.service.NexeBdgtStatusService;
import com.kep.nexe.service.NexeBdgtStatusServiceImpl;
import com.kep.nexe.service.NexeGrSubmitService;
import com.kep.nexe.service.NexeGrSubmitServiceImpl;
import com.kep.nexe.service.NexeInvestStatusService;
import com.kep.nexe.service.NexeInvestStatusServiceImpl;
import com.kep.nexe.service.NexeItSubmitService;
import com.kep.nexe.service.NexeItSubmitServiceImpl;
import com.kep.nexe.service.NexeOfcPrSubmitService;
import com.kep.nexe.service.NexeOfcPrSubmitServiceImpl;
import com.kep.nexe.service.NexePOStatusService;
import com.kep.nexe.service.NexePOStatusServiceImpl;
import com.kep.nexe.service.NexePrSubmitService;
import com.kep.nexe.service.NexePrSubmitServiceImpl;
import com.kep.obBeer.service.ObBeerIvService;
import com.kep.obBeer.service.ObBeerIvServiceImpl;
import com.kep.obBeer.service.ObBeerPoOneService;
import com.kep.obBeer.service.ObBeerPoOneServiceImpl;
import com.kep.obBeer.service.ObBeerPoService;
import com.kep.obBeer.service.ObBeerPoServiceImpl;
import com.kep.obBeer.service.ObBeerPoStatusService;
import com.kep.obBeer.service.ObBeerPoStatusServiceImpl;
import com.kep.quratis.service.QuratisAppStatusService;
import com.kep.quratis.service.QuratisAppStatusServiceImpl;
import com.kep.skmw.service.SkMwItemService;
import com.kep.skmw.service.SkMwItemServiceImpl;
import com.kep.skpc.service.SkPcItService;
import com.kep.skpc.service.SkPcItServiceImpl;
import com.kep.skpc.service.SkPcIvService;
import com.kep.skpc.service.SkPcIvServiceImpl;
import com.kep.skpc.service.SkPcReRtService;
import com.kep.skpc.service.SkPcReRtServiceImpl;
import com.kep.soulbrain.service.soulbrainIvService;
import com.kep.soulbrain.service.soulbrainIvServiceImpl;
import com.kep.soulbrain.service.soulbrainMsdsService;
import com.kep.soulbrain.service.soulbrainMsdsServiceImpl;
import com.kep.supplyon.service.ConvEDIToXMLServiceImpl;
import com.kep.supplyon.service.ParseEDIServiceImpl;
import com.kep.taxbill.service.TaxAccountService;
import com.kep.taxbill.service.TaxAccountServiceImpl;
import com.kep.taxbill.service.TaxBillAuthService;
import com.kep.taxbill.service.TaxBillAuthServiceImpl;
import com.kep.taxbill.service.TaxBillMyListService;
import com.kep.taxbill.service.TaxBillMyListServiceImpl;
import com.kep.taxbill.service.TaxBillStatusService;
import com.kep.taxbill.service.TaxBillStatusServiceImpl;
import com.kep.wonbiz.service.WonbizService;
import com.kep.wonbiz.service.WonbizServiceImpl;
import com.kep.woojin.service.AppStatusService;
import com.kep.woojin.service.AppStatusServiceImpl;


public class BatchClient {
	private static 	Logger	log = Logger.getLogger(BatchClient.class);

	public static void main(String[] args) {
		
		try {
			if(args.length >= 2) {
				String DB_CONN	= args[1];
				
				CommonProperty.setDB_CONN(DB_CONN);
				if ("TAX_BILL_STATUS".equals(args[0])) {
					log.info("TAX_BILL_STATUS["+DB_CONN+"] Start.....");
					TaxBillStatusService obj	= new TaxBillStatusServiceImpl();
					obj.executeBatch();
					log.info("TAX_BILL_STATUS["+DB_CONN+"] Stop.....");
					
				} else if ("AUTH".equals(args[0])) {
					log.info("AUTH["+DB_CONN+"] Start.....");
					TaxBillAuthService obj	= new TaxBillAuthServiceImpl();
					obj.executeBatch();
					log.info("AUTH["+DB_CONN+"] Stop.....");
					
				} else if ("TACCOUNT".equals(args[0])) {
					log.info("TACCOUNT["+DB_CONN+"] Start.....");
					TaxAccountService obj	= new TaxAccountServiceImpl();
					obj.executeBatch();
					log.info("TACCOUNT["+DB_CONN+"] Stop.....");
					
				} else if ("MY_LIST".equals(args[0])) {
					log.info("MY_LIST["+DB_CONN+"] Start.....");
					TaxBillMyListService obj	= new TaxBillMyListServiceImpl();
					obj.execute();
					log.info("MY_LIST["+DB_CONN+"] Stop.....");
					
				} else if ("EXCHANGE_OLD".equals(args[0])) {
					ExchangeRateService service = new ExchangeRateServiceImpl();
					service.executeBatch();
					
				} else if ("EXCHANGE".equals(args[0])) {
					ExchangeRateTestService service = new ExchangeRateTestServiceImpl();
					service.executeBatch();
					
				} else if ("SUPPLYON".equals(args[0])) {
					log.info("SUPPLYON["+DB_CONN+"] Start.....");
					ConvEDIToXMLServiceImpl obj1 = new ConvEDIToXMLServiceImpl();
					obj1.execute();
					ParseEDIServiceImpl obj2 = new ParseEDIServiceImpl();
					obj2.execute();
					log.info("SUPPLYON["+DB_CONN+"] Stop.....");
					
				} else if ("AREX".equals(args[0])) {
					log.info("AREX["+DB_CONN+"] Start.....");
					SendMailService mailObj	= new SendMailServiceImpl();
					mailObj.execute();
					log.info("AREX["+DB_CONN+"] Stop.....");
					
				} else if ("COWAY_SCRAP".equals(args[0])) {
					log.info("COWAY_SCRAP["+DB_CONN+"] Start.....");
					SendMailService mailObj	= new SendMailServiceImpl();
					
					Calendar cal = Calendar.getInstance();
					SimpleDateFormat dtf = new SimpleDateFormat("yyyyMMdd");
					String TO_DT = dtf.format(cal.getTime());
					cal.add(Calendar.DATE, -7);
					String FROM_DT = dtf.format(cal.getTime());
					
					mailObj.executeCowayScrapMail(FROM_DT, TO_DT);
					log.info("COWAY_SCRAP["+DB_CONN+"] Stop.....");
					
				} else if ("CRETEC_PO".equals(args[0])) {
					log.info("CRETEC_PO["+DB_CONN+"] Start.....");
					CretecService obj = new CretecService();
					obj.execute("PO");
					log.info("CRETEC_PO["+DB_CONN+"] Stop.....");
					
				} else if ("CRETEC_ITEM".equals(args[0])) {
					log.info("CRETEC_ITEM["+DB_CONN+"] Start.....");
					CretecService obj = new CretecService();
					obj.execute("ITEM");
					log.info("CRETEC_ITEM["+DB_CONN+"] Stop.....");
					
				}else if ("CRETEC_IV".equals(args[0])) {
					log.info("CRETEC_IV["+DB_CONN+"] Start.....");
					CretecService obj = new CretecService();
					obj.execute(args[2]);
					log.info("CRETEC_IV["+DB_CONN+"] Stop.....");
					
				} else if ("KHRM_AR_CREATE".equals(args[0])) {
					log.info("KHRM_AR_CREATE["+DB_CONN+"] Start.....");
					MonthClosingService obj	= new MonthClosingService();
					obj.arCreate();
					log.info("KHRM_AR_CREATE["+DB_CONN+"] Stop.....");
					
				} else if ("KHRM_AP_CREATE".equals(args[0])) {
					log.info("KHRM_AP_CREATE["+DB_CONN+"] Start.....");
					MonthClosingService obj	= new MonthClosingService();
					obj.apCreate();
					log.info("KHRM_AP_CREATE["+DB_CONN+"] Stop.....");
					
				} else if ("KHRM_AR_CANCEL".equals(args[0])) {
					log.info("KHRM_AR_CANCEL["+DB_CONN+"] Start.....");
					MonthClosingService obj	= new MonthClosingService();
					obj.arCancel();
					log.info("KHRM_AR_CANCEL["+DB_CONN+"] Stop.....");
					
				} else if ("KHRM_AP_CANCEL".equals(args[0])) {
					log.info("KHRM_AP_CANCEL["+DB_CONN+"] Start.....");
					MonthClosingService obj	= new MonthClosingService();
					obj.apCancel();
					log.info("KHRM_AP_CANCEL["+DB_CONN+"] Stop.....");
					
				} else if ("KHRM_TACCOUNT".equals(args[0])) {
					log.info("KHRM_TACCOUNT["+DB_CONN+"] Start.....");
					MonthClosingService obj	= new MonthClosingService();
					obj.sendTaccount();
					log.info("KHRM_TACCOUNT["+DB_CONN+"] Stop.....");
					
				} else if ("KHRM_TBILL".equals(args[0])) {
					log.info("KHRM_TBILL["+DB_CONN+"] Start.....");
					MonthClosingService obj	= new MonthClosingService();
					obj.sendTbill();
					log.info("KHRM_TBILL["+DB_CONN+"] Stop.....");
					
				} else if ("KHRM_CODE".equals(args[0])) {
					log.info("KHRM_CODE["+DB_CONN+"] Start.....");
					MonthClosingService obj	= new MonthClosingService();
					obj.sendCode();
					log.info("KHRM_CODE["+DB_CONN+"] Stop.....");

				} else if ("WJ_APP_STATUS".equals(args[0])) {
					log.info("WJ_APP_STATUS["+DB_CONN+"] Start.....");
					AppStatusService obj	= new AppStatusServiceImpl();
					obj.executeBatch();
					log.info("WJ_APP_STATUS["+DB_CONN+"] Stop.....");
					
				} else if ("HW_APP_SEND".equals(args[0])) {
					log.info("HW_APP_SEND["+DB_CONN+"] Start.....");
					CommonProperty.setDB_CONN(DB_CONN);
					AppSendService service	= new AppSendServiceImpl();
					service.execute();
					log.info("HW_APP_SEND["+DB_CONN+"] Stop.....");
					
				} else if ("HW_APP_STATUS".equals(args[0])) {
					log.info("HW_APP_STATUS["+DB_CONN+"] Start.....");
					CommonProperty.setDB_CONN(DB_CONN);
					HwinAppStatusService service	= new HwinAppStatusServiceImpl(DB_CONN);
					service.execute();
					log.info("HW_APP_STATUS["+DB_CONN+"] Stop.....");
					
				} else if ("HWDF_APP_STATUS".equals(args[0])) {
					log.info("HWDF_APP_STATUS["+DB_CONN+"] Start.....");
					CommonProperty.setDB_CONN(DB_CONN);
					HWDFAppStatusService service	= new HWDFAppStatusServiceImpl();
					service.execute();
					log.info("HWDF_APP_STATUS["+DB_CONN+"] Stop.....");
					
				} else if ("HWDF_GR_SEND".equals(args[0])) {
					log.info("HWDF_GR_SEND["+DB_CONN+"] Start.....");
					CommonProperty.setDB_CONN(DB_CONN);
					HWDFGrSubmitService service	= new HWDFGrSubmitServiceImpl();
					service.execute();
					log.info("HWDF_GR_SEND["+DB_CONN+"] Stop.....");
					
				} else if ("HWDF_APP_SUBMIT".equals(args[0])) {
					log.info("HWDF_APP_SUBMIT["+DB_CONN+"] Start.....");
					CommonProperty.setDB_CONN(DB_CONN);
					HWDFAppSubmitService service	= new HWDFAppSubmitServiceImpl();
					service.execute();
					log.info("HWDF_APP_SUBMIT["+DB_CONN+"] Stop.....");
					
				} else if ("GS_IF".equals(args[0])) {
					log.info("GS_IF["+DB_CONN+"] Start.....");
					CommonProperty.setDB_CONN(DB_CONN);
					GsencAppService service	= new GsencAppService();
					service.execute();
					log.info("GS_IF["+DB_CONN+"] Stop.....");
					
				} else if ("DUZON_FI".equals(args[0])) {
					log.info("DUZON_FI["+DB_CONN+"] Start.....");
					FiService service = new FiService();
					service.sendFiDocu();
					service.recvFiDocu();
					service.recvNoDocu();	// 판촉몰 전표 회신 요청건.
					log.info("DUZON_FI["+DB_CONN+"] Stop.....");
					
				} else if ("DUZON_PARTNER".equals(args[0])) {
					log.info("DUZON_PARTNER["+DB_CONN+"] Start.....");   
					PartnerService service = new PartnerService();
					service.sendPartnerTemp();
					service.sendPartnerDeposit();
					service.recvPartnerDepositR();
					log.info("DUZON_PARTNER["+DB_CONN+"] Stop.....");
					
				} else if ("KEPMP_FI".equals(args[0])) {
					log.info("KEPMP_FI["+DB_CONN+"] Start.....");
					FiService service = new FiService();
					service.createArKepmp();
					service.cancelArKepmp();
					service.createApKepmp();
					service.cancelApKepmp();
					log.info("KEPMP_FI["+DB_CONN+"] Stop.....");
					
				} else if ("KEPMP_PARTNER".equals(args[0])) {
					log.info("KEPMP_PARTNER["+DB_CONN+"] Start.....");
					PartnerService service = new PartnerService();
					service.createPartnerTempKepmp();
					service.createPartnerDepositKepmp();
					log.info("KEPMP_PARTNER["+DB_CONN+"] Stop.....");
					
				} else if ("KEPMP_PARTNER_R".equals(args[0])) {
					log.info("KEPMP_PARTNER_R["+DB_CONN+"] Start.....");
					PartnerService service = new PartnerService();
					service.setPartnerDepositR();
					log.info("KEPMP_PARTNER_R["+DB_CONN+"] Stop.....");
					
				} else if ("KEPCON_PARTNER".equals(args[0])) {
					log.info("KEPCON_PARTNER["+DB_CONN+"] Start.....");
					PartnerService service = new PartnerService();
					service.createPartnerTempKepcon();
					log.info("KEPCON_PARTNER["+DB_CONN+"] Stop.....");
					
				} else if ("KEPCON_FI".equals(args[0])) {
					log.info("KEPCON_FI["+DB_CONN+"] Start.....");
					FiService service = new FiService();
					service.createArKepcon();
					service.cancelArKepcon();
					service.createApKepcon();
					service.cancelApKepcon();
					log.info("KEPCON_FI["+DB_CONN+"] Stop.....");
					
				} else if ("KEPCON_SALES".equals(args[0])) {
					log.info("KEPCON_SALES["+DB_CONN+"] Start.....");
					FiService service = new FiService();
					service.createSaleCostKepcon();
					log.info("KEPCON_SALES["+DB_CONN+"] Stop.....");
					
				} else if ("KEPMP_SALES".equals(args[0])) {
					log.info("KEPMP_SALES["+DB_CONN+"] Start.....");
					FiService service = new FiService();
					service.createSaleCostKepmp();
					log.info("KEPMP_SALES["+DB_CONN+"] Stop.....");
					
				} else if ("FI_CREDIT".equals(args[0])) {
					log.info("FI_CREDIT["+DB_CONN+"] Start.....");
					CreditService service = new CreditService();
					service.getCredit();
					service.getCreditAging();
					log.info("FI_CREDIT["+DB_CONN+"] Stop.....");
					
				} else if ("QURA_APPSTATUS".equals(args[0])) {
					log.info("QURA_APPSTATUS["+DB_CONN+"] Start.....");
					QuratisAppStatusService service = new QuratisAppStatusServiceImpl();
					service.execute();
					log.info("QURA_APPSTATUS["+DB_CONN+"] Stop.....");
					
				} else if ("PRMT_FI".equals(args[0])) {
					log.info("PRMT_FI["+DB_CONN+"] Start.....");
					FiService service = new FiService();
					service.createArPromotion();
					service.cancelArPromotion();
					service.createApPromotion();
					service.cancelApPromotion();
					service.savePromotionNoDocu();

					log.info("PRMT_FI["+DB_CONN+"] Stop.....");
					
				} else if ("PG_CREDIT".equals(args[0])) {
					log.info("PG_CREDIT["+DB_CONN+"] Start.....");
					FiService service = new FiService();
					service.createPgCreditInfo();
					service.cancelPgCreditInfo();
					log.info("PG_CREDIT["+DB_CONN+"] Stop.....");
					
				} else if ("HANWHA_APP_SUBMIT".equals(args[0])) {
					log.info("HANWHA_APP_SUBMIT["+DB_CONN+"] Start.....");
					HanWhaAppSubmitService service = new HanWhaAppSubmitServiceImpl();
					service.execute();
					log.info("HANWHA_APP_SUBMIT["+DB_CONN+"] Stop.....");
					
				} else if ("HANWHA_APP_STATUS".equals(args[0])) {
					log.info("HANWHA_APP_STATUS["+DB_CONN+"] Start.....");
					HanWhaAppStatusService service = new HanWhaAppStatusServiceImpl();
					service.execute();
					log.info("HANWHA_APP_STATUS["+DB_CONN+"] Stop.....");
					
				} else if ("HANWHA_RQ_APP_SUBMIT".equals(args[0])) {
					log.info("HANWHA_RQ_APP_SUBMIT["+DB_CONN+"] Start.....");
					HanWhaRqRequestSubmitService service = new HanWhaRqRequestSubmitService();
					service.execute();
					log.info("HANWHA_RQ_APP_SUBMIT["+DB_CONN+"] Stop.....");
					
				}else if ("HANWHA_RQ_APP_STATUS".equals(args[0])) {
					log.info("HANWHA_RQ_APP_STATUS["+DB_CONN+"] Start.....");
					HanWhaRqRequestStatusService service = new HanWhaRqRequestStatusService();
					service.execute();
					log.info("HANWHA_RQ_APP_STATUS["+DB_CONN+"] Stop.....");
					
				}else if ("HANWHA_NEGO_APP_SUBMIT".equals(args[0])) {
					log.info("HANWHA_NEGO_APP_SUBMIT["+DB_CONN+"] Start.....");
					HanWhaNegoSubmitService service = new HanWhaNegoSubmitService();
					service.execute();
					log.info("HANWHA_NEGO_APP_SUBMIT["+DB_CONN+"] Stop.....");
					
				}else if ("HANWHA_NEGO_APP_STATUS".equals(args[0])) {
					log.info("HANWHA_NEGO_APP_STATUS["+DB_CONN+"] Start.....");
					HanWhaNegoStatusService service = new HanWhaNegoStatusService();
					service.execute();
					log.info("HANWHA_NEGO_APP_STATUS["+DB_CONN+"] Stop.....");
					
				}else if ("HANWHA_HR".equals(args[0])) {
					log.info("HANWHA_HR["+DB_CONN+"] Start.....");
					com.kep.hanwha.org.service.HanwhaOrgService service = new com.kep.hanwha.org.service.HanwhaOrgService();
					service.getHanwhaOrg();
					
					com.kep.hanwha.org.service.HanwhaOrgUserService uService = new com.kep.hanwha.org.service.HanwhaOrgUserService();
					uService.getHanwhaUser();
					log.info("HANWHA_HR["+DB_CONN+"] Stop.....");
				} else if ("ECONT_SEND".equals(args[0]) ) {
					log.info("ECONT_SEND["+DB_CONN+"] Start.....");
					EcontractModuSignService service = new EcontractModuSignService();
					service.sendEcont();
					log.info("ECONT_SEND["+DB_CONN+"] Stop.....");
				} else if ("ECONT_STATUS".equals(args[0]) ) {
					log.info("ECONT_STATUS["+DB_CONN+"] Start.....");
					EcontractModuSignService service = new EcontractModuSignService();
					service.chkEcontStatus();
					log.info("ECONT_STATUS["+DB_CONN+"] Stop.....");
				} else if ("AEKY_AR_SEND".equals(args[0]) ) {
					log.info("AEKY_AR_SEND["+DB_CONN+"] Start.....");
					ZMRO_BD_CREATE obj = new ZMRO_BD_CREATE();
					obj.execute();
					log.info("AEKY_AR_SEND["+DB_CONN+"] Stop.....");
				}else if ("LINK_TO_GIFT".equals(args[0]) ) {
					log.info("LINK_TO_GIFT["+DB_CONN+"] Start.....");
					GiftService service = new GiftService();
					service.createGift();
					log.info("LINK_TO_GIFT["+DB_CONN+"] Stop.....");
				}else if ("JOSU_BUDGET_STATUS".equals(args[0]) ) {
					log.info("JOSU_BUDGET_STATUS["+DB_CONN+"] Start.....");
					BudgetStatusService service = new BudgetStatusServiceImpl();
					service.execute();
					log.info("JOSU_BUDGET_STATUS["+DB_CONN+"] Stop.....");
				}else if ("JOSU_BUDGET_SEND".equals(args[0]) ) {
					log.info("JOSU_BUDGET_SEND["+DB_CONN+"] Start.....");
					BudgetSendService service = new BudgetSendServiceImpl();
					service.execute();
					log.info("JOSU_BUDGET_SEND["+DB_CONN+"] Stop.....");
				}else if ("JOSU_DB_CHK".equals(args[0]) ) {
					log.info("JOSU_DB_CHK["+DB_CONN+"] Start.....");
					BudgetTestService service = new BudgetTestServiceImpl();
					service.execute();
					log.info("JOSU_DB_CHK["+DB_CONN+"] Stop.....");
				}else if ("JOSU_FICLOSE".equals(args[0]) ) {
					log.info("JOSU_FICLOSE["+DB_CONN+"] Start.....");
					FiCloseSendService service = new FiCloseSendServiceImpl();
					service.execute(args[2], args[3]);
					log.info("JOSU_FICLOSE["+DB_CONN+"] Stop.....");
				}else if ("HANCOM_CODE_SELECT".equals(args[0]) ) {
					log.info("HANCOM_CODE_SELECT["+DB_CONN+"] Start.....");
					HanComService service = new HanComServiceImpl(); 			
					service.execute();
					log.info("HANCOM_CODE_SELECT["+DB_CONN+"] Stop.....");
				}else if ("HUGEL_PO".equals(args[0])) {
					log.info("AUTH["+DB_CONN+"] Start.....");
					HugelService obj	= new HugelServiceImpl();
					obj.execute();
					log.info("AUTH["+DB_CONN+"] Stop.....");
				}else if ("HOBAN_RQ".equals(args[0])) {
					log.info("AUTH["+DB_CONN+"] Start.....");
					HobanRqService obj	= new HobanRqServiceImpl();
					obj.execute(args[1]);
					log.info("AUTH["+DB_CONN+"] Stop.....");
				}else if ("HOBAN_PO".equals(args[0])) {
					log.info("AUTH["+DB_CONN+"] Start.....");
					HobanPoService obj	= new HobanPoServiceImpl();
					obj.execute(args[1], args[2], args[3]);
					log.info("AUTH["+DB_CONN+"] Stop.....");
				}else if ("HOBAN_GR".equals(args[0])) {
					log.info("AUTH["+DB_CONN+"] Start.....");
					HobanGrService obj	= new HobanGrServiceImpl();
					obj.execute(args[1], args[2], args[3]);
					log.info("AUTH["+DB_CONN+"] Stop.....");
				}else if ("AEKY_BD_SEND".equals(args[0])) {
					log.info("AUTH["+DB_CONN+"] Start.....");
					AekySendBdgtService obj	= new AekySendBdgtServiceImpl();
					obj.execute();
					log.info("AUTH["+DB_CONN+"] Stop.....");
				}else if ("AEKY_BD_GET".equals(args[0])) {
					log.info("AUTH["+DB_CONN+"] Start.....");
					AekyGetBdgtService obj	= new AekyGetBdgtServiceImpl();
					obj.execute();
					log.info("AUTH["+DB_CONN+"] Stop.....");
				}else if ("KUMH_PR".equals(args[0])) {
					log.info("KUMH_PR["+DB_CONN+"] Start.....");
					KUMHPrSubmitService obj	= new KUMHPrSubmitServiceImpl();
					obj.execute();
					log.info("KUMH_PR["+DB_CONN+"] Stop.....");
				}else if ("KUMH_GR".equals(args[0])) {
					log.info("KUMH_GR["+DB_CONN+"] Start.....");
					KUMHGrLoadService obj = new KUMHGrLoadServiceImpl();
					obj.execute(args[2]);
					log.info("KUMH_GR["+DB_CONN+"] Stop.....");
				}else if ("HKINN_BRAND".equals(args[0])) {
					log.info("HKINN_BRAND["+DB_CONN+"] Start.....");
					HkInnBrandService obj	= new HkInnBrandServiceImpl();
					obj.execute();
					log.info("HKINN_BRAND["+DB_CONN+"] Stop.....");
				}else if ("HKINN_ITEM".equals(args[0])) {
					log.info("HKINN_ITEM["+DB_CONN+"] Start.....");
					HkInnItemService obj	= new HkInnItemServiceImpl();
					obj.execute();
					log.info("HKINN_ITEM["+DB_CONN+"] Stop.....");
				}else if ("HKINN_PO_CANCEL".equals(args[0])) {
					log.info("HKINN_PO_CANCEL["+DB_CONN+"] Start.....");
					HkInnPoCancelService obj	= new HkInnPoCancelServiceImpl();
					obj.execute();
					log.info("HKINN_PO_CANCEL["+DB_CONN+"] Stop.....");
				}else if ("HKINN_PO_STATUS".equals(args[0])) {
					log.info("HKINN_PO_STATUS["+DB_CONN+"] Start.....");
					HkInnPoStatusService obj	= new HkInnPoStatusServiceImpl();
					obj.execute();
					log.info("HKINN_PO_STATUS["+DB_CONN+"] Stop.....");
				}else if ("HKINN_IV".equals(args[0])) {
					log.info("HKINN_IV["+DB_CONN+"] Start.....");
					HkInnInvoiceService obj	= new HkInnInvoiceServiceImpl();
					obj.execute();
					log.info("HKINN_IV["+DB_CONN+"] Stop.....");
				}else if ("SKMW_ITEM".equals(args[0])) {
					log.info("SKMW_ITEM["+DB_CONN+"] Start.....");
					SkMwItemService obj	= new SkMwItemServiceImpl();
					obj.execute();
					log.info("SKMW_ITEM["+DB_CONN+"] Stop.....");
				}else if ("OB_PO".equals(args[0])) {
					log.info("OB_PO["+DB_CONN+"] Start.....");
					ObBeerPoService obj	= new ObBeerPoServiceImpl();
					obj.execute();
					log.info("OB_PO["+DB_CONN+"] Stop.....");
				}else if ("OB_PO_ONE".equals(args[0])) {
					log.info("OB_PO_ONE["+DB_CONN+"] Start.....");
					ObBeerPoOneService obj	= new ObBeerPoOneServiceImpl();
					obj.execute(args[2]);
					log.info("OB_PO_ONE["+DB_CONN+"] Stop.....");
				}else if ("OB_PO_STATUS".equals(args[0])) {
					log.info("OB_PO_STATUS["+DB_CONN+"] Start.....");
					ObBeerPoStatusService obj	= new ObBeerPoStatusServiceImpl();
					obj.execute();
					log.info("OB_PO_STATUS["+DB_CONN+"] Stop.....");
				}else if ("OB_IV".equals(args[0])) {
					log.info("OB_IV["+DB_CONN+"] Start.....");
					ObBeerIvService obj	= new ObBeerIvServiceImpl();
					obj.execute();
					log.info("OB_IV["+DB_CONN+"] Stop.....");
				}else if ("SOUL_MSDS".equals(args[0])) {
					log.info("SOUL_MSDS["+DB_CONN+"] Start.....");
					soulbrainMsdsService obj	= new soulbrainMsdsServiceImpl();
					obj.execute();
					log.info("SOUL_MSDS["+DB_CONN+"] Stop.....");
				}else if ("SOUL_IV".equals(args[0])) {
					log.info("SOUL_IV["+DB_CONN+"] Start.....");
					soulbrainIvService obj	= new soulbrainIvServiceImpl();
					obj.execute();
					log.info("SOUL_IV["+DB_CONN+"] Stop.....");
				}else if ("SKPC_IT".equals(args[0])) {
					log.info("SKPC_IT["+DB_CONN+"] Start.....");
					SkPcItService obj	= new SkPcItServiceImpl();
					obj.execute();
					log.info("SKPC_IT["+DB_CONN+"] Stop.....");
				}else if ("SKPC_RERT".equals(args[0])) {
					log.info("SKPC_RERT["+DB_CONN+"] Start.....");
					SkPcReRtService obj	= new SkPcReRtServiceImpl();
					obj.execute();
					log.info("SKPC_RERT["+DB_CONN+"] Stop.....");
				}else if ("SKPC_IV".equals(args[0])) {
					log.info("SKPC_IV["+DB_CONN+"] Start.....");
					SkPcIvService obj	= new SkPcIvServiceImpl();
					obj.execute();
					log.info("SKPC_IV["+DB_CONN+"] Stop.....");
				}else if ("NEXE_SEND_PR".equals(args[0])) {
					log.info("NEXE_SEND_PR["+DB_CONN+"] Start.....");
					NexePrSubmitService obj	= new NexePrSubmitServiceImpl();
					obj.execute();
					log.info("NEXE_SEND_PR["+DB_CONN+"] Stop.....");
				}else if ("NEXE_OFC_SEND_PR".equals(args[0])) {
					log.info("NEXE_OFC_SEND_PR["+DB_CONN+"] Start.....");
					NexeOfcPrSubmitService obj	= new NexeOfcPrSubmitServiceImpl();
					obj.execute();
					log.info("NEXE_OFC_SEND_PR["+DB_CONN+"] Stop.....");
				}else if ("NEXE_SEND_IT".equals(args[0])) {
					log.info("NEXE_SEND_IT["+DB_CONN+"] Start.....");
					NexeItSubmitService obj	= new NexeItSubmitServiceImpl();
					obj.execute();
					log.info("NEXE_SEND_IT["+DB_CONN+"] Stop.....");
				}else if ("NEXE_SEND_GR".equals(args[0])) {
					log.info("NEXE_SEND_GR["+DB_CONN+"] Start.....");
					NexeGrSubmitService obj	= new NexeGrSubmitServiceImpl();
					obj.execute();
					log.info("NEXE_SEND_GR["+DB_CONN+"] Stop.....");
				}else if ("NEXE_PO_STATUS".equals(args[0])) {
					log.info("NEXE_PO_STATUS["+DB_CONN+"] Start.....");
					NexePOStatusService obj	= new NexePOStatusServiceImpl();
					obj.execute();
					log.info("NEXE_PO_STATUS["+DB_CONN+"] Stop.....");
				}else if ("NEXE_BDGT_STATUS".equals(args[0])) {
					log.info("NEXE_BDGT_STATUS["+DB_CONN+"] Start.....");
					NexeBdgtStatusService obj	= new NexeBdgtStatusServiceImpl();
					obj.execute();
					log.info("NEXE_BDGT_STATUS["+DB_CONN+"] Stop.....");
				}else if ("NEXE_INVEST_STATUS".equals(args[0])) {
					log.info("NEXE_INVEST_STATUS["+DB_CONN+"] Start.....");
					NexeInvestStatusService obj	= new NexeInvestStatusServiceImpl();
					obj.execute();
					log.info("NEXE_INVEST_STATUS["+DB_CONN+"] Stop.....");	
				}else if ("HANWHAAERO_SUBMIT".equals(args[0])) {
					log.info("HANWHAAERO_SUBMIT["+DB_CONN+"] Start.....");
					hanwhaAeroAppSubmitService obj	= new hanwhaAeroAppSubmitServiceImpl();
					obj.execute();
					log.info("HANWHAAERO_SUBMIT["+DB_CONN+"] Stop.....");
				}else if ("HANWHAAERO_STATUS".equals(args[0])) {
					log.info("HANWHAAERO_STATUS["+DB_CONN+"] Start.....");
					HanWhaAeroAppStatusService obj	= new HanWhaAeroAppStatusServiceImpl();
					obj.execute();
					log.info("HANWHAAERO_STATUS["+DB_CONN+"] Stop.....");
				}else if ("HANSSEM_CC".equals(args[0])) {
					log.info("HANSSEM_CC["+DB_CONN+"] Start.....");
					HanssemCostCenterService obj	= new HanssemCostCenterServiceImpl();
					obj.execute();
					log.info("HANSSEM_CC["+DB_CONN+"] Stop.....");
				}else if ("HANSSEM_GLACCT".equals(args[0])) {
					log.info("HANSSEM_GLACCT["+DB_CONN+"] Start.....");
					HanssemGLAccountService obj	= new HanssemGLAccountServiceImpl();
					obj.execute();
					log.info("HANSSEM_GLACCT["+DB_CONN+"] Stop.....");
				}else if ("HANSSEM_AVAILBDGT".equals(args[0])) {
					log.info("HANSSEM_AVAILBDGT["+DB_CONN+"] Start.....");
					HanssemAvailBudgetService obj	= new HanssemAvailBudgetServiceImpl();
					obj.execute();
					log.info("HANSSEM_AVAILBDGT["+DB_CONN+"] Stop.....");
				}else if ("HANSSEM_BDGT".equals(args[0])) {
					log.info("HANSSEM_BDGT["+DB_CONN+"] Start.....");
					HanssemBudgetService obj	= new HanssemBudgetServiceImpl();
					obj.execute();
					log.info("HANSSEM_BDGT["+DB_CONN+"] Stop.....");
				}else if ("HANSSEM_USER".equals(args[0])) {
					log.info("HANSSEM_USER["+DB_CONN+"] Start.....");
					HanssemUserService obj	= new HanssemUserServiceImpl();
					obj.execute();
					log.info("HANSSEM_USER["+DB_CONN+"] Stop.....");
				}else if ("HANSSEM_CLOSE".equals(args[0])) {
					log.info("HANSSEM_CLOSE["+DB_CONN+"] Start.....");
					HanssemCloseService obj	= new HanssemCloseServiceImpl();
					obj.execute();
					log.info("HANSSEM_CLOSE["+DB_CONN+"] Stop.....");
				}else if ("HANSSEM_PO".equals(args[0])) {
					log.info("HANSSEM_PO["+DB_CONN+"] Start.....");
					HanssemPoService obj	= new HanssemPoServiceImpl();
					obj.execute();
					log.info("HANSSEM_PO["+DB_CONN+"] Stop.....");
				}else if ("HANSSEM_POLIST".equals(args[0])) {
					log.info("HANSSEM_POLIST["+DB_CONN+"] Start.....");
					HanssemPoListService obj	= new HanssemPoListServiceImpl();
					obj.execute();
					log.info("HANSSEM_POLIST["+DB_CONN+"] Stop.....");
				}else if ("HANSSEM_GR".equals(args[0])) {
					log.info("HANSSEM_GR["+DB_CONN+"] Start.....");
					HanssemGrService obj	= new HanssemGrServiceImpl();
					obj.execute();
					log.info("HANSSEM_GR["+DB_CONN+"] Stop.....");
				}else if ("AMORE_CHECK".equals(args[0])) {
					log.info("AMORE_CHECK["+DB_CONN+"] Start.....");
					AmorepacificFiCheckService obj	= new AmorepacificFiCheckServiceImpl();
					obj.execute();
					log.info("AMORE_CHECK["+DB_CONN+"] Stop.....");
				}else if ("AMORE_ORDER".equals(args[0])) {
					log.info("AMORE_ORDER["+DB_CONN+"] Start.....");
					AmorepacificFiOrderService obj	= new AmorepacificFiOrderServiceImpl();
					obj.execute();
					log.info("AMORE_ORDER["+DB_CONN+"] Stop.....");
				}else if ("DELI_CHASE".equals(args[0])) {
					log.info("DELI_CHASE["+DB_CONN+"] Start.....");
					DeliveryService obj	= new DeliveryServiceImpl();
					obj.execute(); 
					log.info("DELI_CHASE["+DB_CONN+"] Stop.....");
				}else if ("PARCEL_SRCH".equals(args[0])) {
					log.info("PARCEL_SRCH["+DB_CONN+"] Start.....");
					ParcelSearchService obj	= new ParcelSearchServiceImpl();
					obj.execute(); 
					log.info("PARCEL_SRCH["+DB_CONN+"] Stop.....");
				}else if ("PARCEL_TRKG".equals(args[0])) {
					log.info("PARCEL_TRKG["+DB_CONN+"] Start.....");
					ParcelTrackingService obj	= new ParcelTrackingServiceImpl();
					obj.execute(); 
					log.info("PARCEL_TRKG["+DB_CONN+"] Stop.....");
				}else if ("HANJIN_ORDER".equals(args[0])) {
					log.info("HANJIN_ORDER["+DB_CONN+"] Start.....");
					HanjinOrderService obj	= new HanjinOrderServiceImpl();
					obj.execute(); 
					log.info("HANJIN_ORDER["+DB_CONN+"] Stop.....");
				}else if ("HANJIN_CANCEL".equals(args[0])) {
					log.info("HANJIN_CANCEL["+DB_CONN+"] Start.....");
					HanjinCancelService obj	= new HanjinCancelServiceImpl();
					obj.execute(); 
					log.info("HANJIN_CANCEL["+DB_CONN+"] Stop.....");
				}else if ("HANJIN_PRINT".equals(args[0])) {
					log.info("HANJIN_PRINT["+DB_CONN+"] Start.....");
					HanjinPrintService obj	= new HanjinPrintServiceImpl();
					obj.execute(); 
					log.info("HANJIN_PRINT["+DB_CONN+"] Stop.....");
				}else if ("JWPH_PO_STATUS".equals(args[0])) {
					log.info("JWPH_PO_STATUS["+DB_CONN+"] Start.....");
					JwphPoStatusService obj	= new JwphPoStatusServiceImpl();
					obj.execute(); 
					log.info("JWPH_PO_STATUS["+DB_CONN+"] Stop.....");
				}else if ("JWPH_IT".equals(args[0])) {
					log.info("JWPH_IT["+DB_CONN+"] Start.....");
					JwphItSubmitService obj	= new JwphItSubmitServiceImpl();
					obj.execute(); 
					log.info("JWPH_IT["+DB_CONN+"] Stop.....");
				}else if ("WORI".equals(args[0])) {
					log.info("WORI["+DB_CONN+"] Start.....");
					WonbizService obj	= new WonbizServiceImpl();
					obj.execute(); 
					log.info("WORI["+DB_CONN+"] Stop.....");
				}else if ("HANS_PR_SEND".equals(args[0])) {
					log.info("HANS_PR_SEND["+DB_CONN+"] Start.....");
					HansPrSubmitService obj	= new HansPrSubmitServiceImpl();
					obj.execute(); 
					log.info("HANS_PR_SEND["+DB_CONN+"] Stop.....");
				}else if ("HANS_PR_CHK".equals(args[0])) {
					log.info("HANS_PR_CHK["+DB_CONN+"] Start.....");
					HansPrCheckService obj	= new HansPrCheckServiceImpl();
					obj.execute(); 
					log.info("HANS_PR_CHK["+DB_CONN+"] Stop.....");
				}else if ("HANS_PO_STATUS".equals(args[0])) {
					log.info("HANS_PO_STATUS["+DB_CONN+"] Start.....");
					HansPoStatusService obj	= new HansPoStatusServiceImpl();
					obj.execute(); 
					log.info("HANS_PO_STATUS["+DB_CONN+"] Stop.....");
				}else if ("HANS_GR_SEND".equals(args[0])) {
					log.info("HANS_GR_SEND["+DB_CONN+"] Start.....");
					HansGrSubmitService obj	= new HansGrSubmitServiceImpl();
					obj.execute(); 
					log.info("HANS_GR_SEND["+DB_CONN+"] Stop.....");
				}else {
					System.out.println("Check Operation Paramenter : STATUS/AUTH/TACCOUNT/EXCHANGE/SUPPLYON/AREX/YP_RFC_TEST ");
					System.out.println("args[0] " + args[0]);
					System.out.println("DB_CONN " + DB_CONN);			
					
				}
			} else {
				System.out.println("Please Operation Paramenter : STATUS/AUTH/TACCOUNT/EXCHANGE/AREX/YP_RFC_TEST 0:Dev, 2:Live");
			}
		} catch (Exception e) {
			log.error("BatchClient Error : " + CommonUtil.printStackTraceToString(e));
			e.printStackTrace();
		}
	}
}