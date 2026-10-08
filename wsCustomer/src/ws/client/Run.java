package ws.client;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonProperty;
import com.koreab2b.dongwha.service.DongwhaItemService;
import com.koreab2b.dongwha.service.DongwhaPRService;
import com.koreab2b.fiber.service.GRP_MM0710_FBR;
import com.koreab2b.fiber.service.GRP_MM1200_FBR;
import com.koreab2b.fiber.service.INFMPO0030_FBR;
import com.koreab2b.inv.service.GRP_MM0710_PSC;
import com.koreab2b.inv.service.GRP_MM0710_PSI;
import com.koreab2b.po.service.GRP_MM1200_PSC;
import com.koreab2b.po.service.GRP_MM1200_PSI;
import com.koreab2b.rfq.service.INFIPA0110_PSC;
import com.koreab2b.rfq.service.INFIPA0110_PSI;
import com.koreab2b.rfq.service.INFMPO0030_PSC;
import com.koreab2b.rfq.service.INFMPO0030_PSI;

public class Run {
	private static 	Logger	log = Logger.getLogger(Run.class);

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		String DB_CONN	= args[1];	// 0:개발 , 1:QA, 2:운영

		try {
			
			CommonProperty.setDB_CONN(DB_CONN);
			if ("RFQ".equals(args[0])) {
				log.info("INFMPO0030 Start["+DB_CONN+"]....!");
				INFMPO0030_PSI rfq	= new INFMPO0030_PSC();
				rfq.execute(null, null, null);
				log.info("INFMPO0030 End["+DB_CONN+"]....!");
			}
			else if ("INV".equals(args[0])) {
				log.info("GRP_MM0710 Start["+DB_CONN+"]....!");
				GRP_MM0710_PSI	iv	= new GRP_MM0710_PSC();
				iv.execute(null, null, null);
				log.info("GRP_MM0710 End["+DB_CONN+"]....!");
			}
			else if ("DS".equals(args[0])) {
				log.info("GRP_MM1200 Start["+DB_CONN+"]....!");
				GRP_MM1200_PSI	ds	= new GRP_MM1200_PSC();
				ds.execute();
				log.info("GRP_MM1200 End["+DB_CONN+"]....!");
			} else if ("RFQ_FIBER".equals(args[0])) {
				log.info("INFMPO0030_FBR Start["+DB_CONN+"]....!");
				INFMPO0030_FBR rfq	= new INFMPO0030_FBR();
				rfq.execute();
				log.info("INFMPO0030_FBR End["+DB_CONN+"]....!");
			}
			else if ("INV_FIBER".equals(args[0])) {
				log.info("GRP_MM0710_FBR Start["+DB_CONN+"]....!");
				GRP_MM0710_FBR	iv	= new GRP_MM0710_FBR();
				iv.execute();
				log.info("GRP_MM0710_FBR End["+DB_CONN+"]....!");
			}
			else if ("DS_FIBER".equals(args[0])) {
				log.info("GRP_MM1200_FBR Start["+DB_CONN+"]....!");
				GRP_MM1200_FBR	ds	= new GRP_MM1200_FBR();
				ds.execute();
				log.info("GRP_MM1200_FBR End["+DB_CONN+"]....!");
			}
			else if ("IT_DONGWHA".equals(args[0])) {
				log.info("IT_DONGWHA Start["+DB_CONN+"]....!");
				 
				DongwhaItemService	ds	= new DongwhaItemService();
				ds.execute();
				log.info("IT_DONGWHA End["+DB_CONN+"]....!"); 
			}
			else if ("PR_DONGWHA".equals(args[0])) {
				log.info("PR_DONGWHA Start["+DB_CONN+"]....!");
				 
				DongwhaPRService	ds	= new DongwhaPRService();
				ds.execute();
				log.info("PR_DONGWHA End["+DB_CONN+"]....!"); 
			}
			else if ("RFQ_IPA".equals(args[0])) {
				log.info("INFIPA0110 Start["+DB_CONN+"]....!");
				INFIPA0110_PSI rfq	= new INFIPA0110_PSC();
				rfq.execute(null, null, null);
				log.info("INFIPA0110 End["+DB_CONN+"]....!");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}