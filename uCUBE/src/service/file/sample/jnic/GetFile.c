/***********************************************************************/
/* Version       :  1.0                                                */  
/* File NAme     :  GetFile.c                                          */
/* Function      :                                                     */
/***********************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <windows.h>

/*Declare u-CUBE Header*/
#include <jmsjni.h>

int main()
{
    int returnValue = -1;
	int testnum = 0;

	char* recvData = NULL;
	char* ifid = NULL;
    int flag = 1;

	printf ("initialize start...\n");
	/* connect to EAI */
    returnValue = initialize("C:\\uCUBE\\service\\file\\config\\cfg\\RECEIVE_GET.xml");
    if(returnValue == 0)
    {
		printf("u-CUBE Engine과의 연결이 성공했습니다.\n");
    }
    else
	{
		printf("u-CUBE Engine과의 연결을 실패했습니다. 결과=[%d]\n", returnValue);
        return returnValue;
	}

    while(flag)
    {    

		/*Receive Transaction Data from EAI */
	    receiveData(&recvData, &ifid, &returnValue, 180000);
        switch(returnValue) {
            case 0 :
				testnum++;
				printf ("수신 DATA=%d::%d::%s::%.40s\n", strlen(recvData), returnValue, ifid, recvData);
				HandleReturnValue(0, ifid, recvData);
				/* HandleReturnValue(-1, ifid, recvData); */				
                break;         
            case -5 :
                printf ("수신호출 Timeout 발생. 재호출이 필요합니다.\n");
                break;
            case -12 :
                printf ("연결 재시도 중입니다.\n");
                Sleep(10000);
                break;
            default :
                printf ("CFG, IFD 설정 이상이 있습니다. 확인이 필요합니다. 결과=%d\n", returnValue);
				flag = 0;
                break;
        }
		
	}

	/* u-CUBE Engine 과의 연결 종료 */ 
    onClose();

    return returnValue;    
}
