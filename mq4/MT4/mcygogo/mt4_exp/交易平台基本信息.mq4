#property copyright "Copyright 2012, laoyee"
#property link      "http://www.docin.com/yiwence"

#property indicator_separate_window
int init()
   {
      return(0);
   }
int deinit()
   {
      ObjectsDeleteAll(WindowFind(WindowExpertName()),OBJ_LABEL);
      Comment("");
      return(0);
   }
int start()
   {
      iMain();
      return(0);
   }
void iMain()
   {
      iDisplayInfo("Author","����: ����(QQ:921795)",0,120,5,7,"",SeaGreen);
      //�ʻ���Ϣ
      iDisplayInfo("AccountInfo1","��˾���ƣ�"+AccountCompany(),0,10,20,8,"",SeaGreen);
      iDisplayInfo("AccountInfo2","�ܸ˱�����1:"+AccountLeverage(),0,10,35,8,"",SeaGreen);
      iDisplayInfo("AccountInfo3","�ʻ����ƣ�"+AccountName(),0,10,50,8,"",SeaGreen);
      iDisplayInfo("AccountInfo4","�ʻ���ţ�"+AccountNumber(),0,10,65,8,"",SeaGreen);
      iDisplayInfo("AccountInfo5","����������"+AccountServer(),0,10,80,8,"",SeaGreen);
      if (IsDemo())
         {
            iDisplayInfo("PlatformRule6","�ʻ����ͣ�ģ��",0,10,95,8,"",SeaGreen);
         }
         else iDisplayInfo("PlatformRule6","�ʻ����ͣ���ʵ",0,10,95,8,"",SeaGreen);
      if (MarketInfo(Symbol(),MODE_TRADEALLOWED)==1)
         {
            iDisplayInfo("PlatformRule5","���ܽ��ף�����",0,10,110,8,"",SeaGreen);
         }
         else iDisplayInfo("PlatformRule5","���ܽ��ף���ֹ",0,10,110,8,"",Red);
      //ƽ̨����
      iDisplayInfo("PlatformRule1","���׵�"+DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD),0),0,200,35,8,"",SeaGreen);
      iDisplayInfo("AccountInfo6","ֹͣˮƽ��"+DoubleToStr(MarketInfo(Symbol(),MODE_STOPLEVEL),0),0,200,50,8,"",SeaGreen);
      iDisplayInfo("PlatformRule4","�����ֵ��"+DoubleToStr(MarketInfo(Symbol(),MODE_TICKVALUE),4),0,200,65,8,"",SeaGreen);
      iDisplayInfo("PlatformRule2","��С���֣�"+DoubleToStr(MarketInfo(Symbol(),MODE_MINLOT),2),0,200,80,8,"",SeaGreen);
      iDisplayInfo("PlatformRule3","��󿪲֣�"+DoubleToStr(MarketInfo(Symbol(),MODE_MAXLOT),2),0,200,95,8,"",SeaGreen);
      iDisplayInfo("PlatformRule7","1�ֱ�֤��"+DoubleToStr(MarketInfo(Symbol(),MODE_MARGINREQUIRED),2),0,200,110,8,"",SeaGreen);
   }

/*
��    ��������Ļ����ʾ���ֱ�ǩ
���������string LableName ��ǩ���ƣ������ʾ����ı������Ʋ�����ͬ
          string LableDoc �ı�����
          int Corner �ı���ʾ��
          int LableX ��ǩXλ������
          int LableY ��ǩYλ������
          int DocSize �ı��ֺ�
          string DocStyle �ı�����
          color DocColor �ı���ɫ
�����������ָ����λ�ã�X,Y������ָ�����ֺš����弰��ɫ��ʾָ�����ı�
�㷨˵����
*/
void iDisplayInfo(string LableName,string LableDoc,int Corner,int LableX,int LableY,int DocSize,string DocStyle,color DocColor)
   {
      if (Corner == -1) return(0);
      int myWindowsHandle = WindowFind(WindowExpertName()); //��ȡ��ǰָ���������ڴ������
      LableName=LableName+DoubleToStr(myWindowsHandle,0);
      ObjectCreate(LableName, OBJ_LABEL, myWindowsHandle, 0, 0); //������ǩ����
      ObjectSetText(LableName, LableDoc, DocSize, DocStyle,DocColor); //�����������
      ObjectSet(LableName, OBJPROP_CORNER, Corner); //ȷ������ԭ�㣬0-���Ͻǣ�1-���Ͻǣ�2-���½ǣ�3-���½ǣ�-1-����ʾ
      ObjectSet(LableName, OBJPROP_XDISTANCE, LableX); //��������꣬��λ����
      ObjectSet(LableName, OBJPROP_YDISTANCE, LableY); //���������꣬��λ����
   }

