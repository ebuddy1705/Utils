
#ifdef test1
#include<iostream>

using namespace std;

class Base

{

int x;

public:

    virtual void setvalue(int i){x=i;cout<<"Lop co so \n";}

    virtual int getvalue(){return x;}

};

class Derived:public Base

{

    int y;

public:

    void setvalue(int i){y=i;cout<<"Lop dan xuat \n";}
    int getvalue(){return y;}

};

int main()

{

    Base*p, o1;

    Derived obj, *p1;

    p=&obj; // con trỏ lớp cơ sở trỏ đến đối tượng của lớp dẫn xuất

    p->setvalue(5); //nhận giá trị của lớp dẫn xuất

    p=&o1; //trỏ đến con trỏ trong cùng lớp cơ sở

    p->setvalue(5); //nhận giá trị của lớp cơ sở

    return 0;

}

#endif



#include<iostream>
using namespace std;
class Base
{
    int x;
public:
    virtual void setvalue(int i)=0;
    virtual int getvalue()=0;
};
class Derived1:public Base{
    int y;
public:
    void setvalue(int i){y=i;cout<<"Lop dan xuat 1 \n";}
    int getvalue(){return y;}
};
class Derived2:public Derived1{
    int z;

public:
    void setvalue(int i){z=i;cout<<"Lop dan xuat 2 \n";}
    int getvalue(){return z;}
};

int main(){
    Base*p;
//    Base o1; //sai vì lớp cơ sở ảo không có đối tượng riêng của nó
    Derived1 obj;
    Derived2 o2;
    p=&obj; //trỏ đến đối tượng của lớp dẫn xuất thứ 1
    p->setvalue(5);
    p=&o2; //trỏ đến đối tượng của lớp dẫn xuất thứ 2
    p->setvalue(6);//kết quả sẽ là: “lớp dẫn xuất 2″ nếu ta không định nghĩa lại ở Derived1
    return 0;
}
