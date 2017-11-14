//http://www.520fx.com/forum.php?mod=viewthread&tid=51742&extra=page%3D1

extern double step=30;
extern int number=0;
extern double lots=1;
extern double range=5;
extern int secure=10;
extern int stoploss=120;

double net[300];
bool check[300];
double orders[300];
int type[300];
int suc[300];
bool deal[300];
int arrayLong=0;

double max;
double min;
//------------------------------------------------------------------------------------------------------------------------
int start() {

closeFunc();
getMaxAndMin();

return(0);

}
//------------------------------------------------------------------------------------------------------------------------
int init(){
arrayLong=number*2+1;
for(int i=0;i<arrayLong;i++){
orders[i]=-1;
deal[i]=false;
}
getNets();
sendOrder();
for(int j=0;j<arrayLong;j++){
Print(j+"  "+orders[j]);
}

}

//------------------------------------------------------------------------------------------------------------------------
void getNets(){

if(arrayLong>300){
Print("报错");
}

for(int k=0;k<arrayLong;k++){
check[k]=false;
}

double ask=Ask;
double botPrice=ask-number*step*0.0001;

for(int i=0;i<arrayLong;i++){
net[i]=botPrice+i*step*0.0001;
}

}

//------------------------------------------------------------------------------------------------------------------------

void getMaxAndMin(){
if(High[0]>max){
max=High[0];
}
if(Low[0]<min){
min=Low[0];
}
}

//------------------------------------------------------------------------------------------------------------------------
void sendOrder(){
for(int i=0;i<arrayLong;i++){
  if(check[i]==false){
    if(net[i]<Ask){
       orders[i]=OrderSend(Symbol(),OP_SELLSTOP,lots,net[i],2,0,0,"订我的单",20081010,0,Green);
     if(orders[i]!=-1){
       type[i]=-1;
       check[i]=true;   
       suc[i]=0;
       min=Low[0];
      }
    }else{
       orders[i]=OrderSend(Symbol(),OP_BUYSTOP,lots,net[i],2,0,0,"订我的单",20081010,0,Green);
     if(orders[i]!=-1){
       type[i]=1;
       check[i]=true;   
       suc[i]=0;
       max=High[0];
       }
    }
}
}
}

//------------------------------------------------------------------------------------------------------------------------
void closeFunc(){

for(int i=0;i<arrayLong;i++){




OrderSelect(orders[i],SELECT_BY_TICKET);

if(type[i]==1&&Ask>OrderOpenPrice())deal[i]=true;
if(type[i]==-1&&Ask<OrderOpenPrice())deal[i]=true;

if(check[i]==true){

if(Ask>OrderOpenPrice()+secure*0.0001&&(max-Ask)>range*0.0001&&type[i]==1){

if(OrderClose(OrderTicket(),lots,Bid,3,Red)){

check[i]=false;
orders[i]=-1;
deal[i]=false;
}
}
if(Ask<OrderOpenPrice()-secure*0.0001&&(Ask-min)>range*0.0001&&type[i]==-1){

if(OrderClose(OrderTicket(),lots,Ask,3,Red)){

check[i]=false;
orders[i]=-1;
deal[i]=false;
}
}
if(deal[i]&&type[i]==1&&OrderOpenPrice()-Ask>=stoploss*0.0001){

if(OrderClose(OrderTicket(),lots,Bid,3,Red)){;
check[i]=false;
orders[i]=-1;
deal[i]=false;
}
}
if(deal[i]&&type[i]==-1&&Ask-OrderOpenPrice()>=stoploss*0.0001){

if(OrderClose(OrderTicket(),lots,Ask,3,Red)){
check[i]=false;
orders[i]=-1;
deal[i]=false;
}
}
}//check

}//for
sendOrder();
}

//------------------------------------------------------------------------------------------------------------------------
void control(){
int iMax=ArrayMaximum(net);

arrayLong+=1;
net[arrayLong-1]=net[iMax]+step*0.0001;
}