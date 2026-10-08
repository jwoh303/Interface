package batch;

import org.apache.log4j.Logger;

import client.DAEW_FTP;
import client.IYNG_PARCEL;
import client.LSAT_FTP;
import client.MSMI_CUST;
import client.MSMS_SUPP;
import client.MSMS_SUPP_IP_FIX;
import client.SOIL_FTP;
import client.SYGP_FTP;
import client.YHKB_FTP;
import common.CommonProperty;

public class Batch {

	public static void main(String[] args) {

		Logger log = null;
		log	= Logger.getLogger("main");
		
		MSMI_CUST msmi_cust = new MSMI_CUST();
		MSMS_SUPP msms_supp = new MSMS_SUPP();
		MSMS_SUPP_IP_FIX msms_supp_ip_fix = new MSMS_SUPP_IP_FIX();
		IYNG_PARCEL obj	= new IYNG_PARCEL();
		SYGP_FTP sygp = new SYGP_FTP();

		CommonProperty.setDB_CONN(args[1]);
		
		if(args[0].equals("MSMS")){
			log.info("MSMS_START");
			
			if(args[1].equals("0")){ // 개발
				msms_supp_ip_fix.execute();
			}else if(args[1].equals("2")){	// 운영
				msms_supp_ip_fix.execute();
			}else if(args[1].equals("4")){	// 구운영
				msms_supp.execute();
			}
		}
		else if(args[0].equals("MSMI")){
			log.info("MSMI_START");
			msmi_cust.execute();
		}
		else if(args[0].equals("IYNG")){
			log.info("IYNG_START...!");
			obj.execute();
			log.info("IYNG_END.....!");
		}
		else if(args[0].equals("SYGP")) {
			log.info("SYGP_START...!");
			sygp.execute();
			log.info("SYGP_END.....!");
		}
		else if(args[0].equals("SOIL")) {
			log.info("SOIL_START...!");
			SOIL_FTP soil = new SOIL_FTP();
			soil.execute();
			log.info("SOIL_END.....!");
		}
		else if(args[0].equals("YHKB")) {
			log.info("YHKB_START...!");
			YHKB_FTP yhkb = new YHKB_FTP();
			yhkb.execute();
			log.info("YHKB_END.....!");
		}
		else if(args[0].equals("DAEW")) {
			log.info("DAEW_START...!");
			DAEW_FTP ftp = new DAEW_FTP();
			ftp.execute();
			log.info("DAEW_END.....!");
		}
		else if(args[0].equals("LSAT")) {
			log.info("LSAT_START...!");
			LSAT_FTP lsat = new LSAT_FTP();
			lsat.execute();
			log.info("LSAT_END.....!");
		}
		
	}
}