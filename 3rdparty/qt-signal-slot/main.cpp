#include <iostream>
#include "sigslot.h"

using namespace std;


class Button:public sigslot::has_signals<Button>
{
public:
    Button(){  };
    virtual ~Button(){  };

    void onClick(){
        touchEvent.emit((char*)"Hello, I am button");
    }

public __signals:
    sigslot::signal<char*> touchEvent;

};


class View:public sigslot::has_slots<>
{
public:
    View(){  };
    virtual ~View(){  };

public __slots:
    void onUpdate(char *msg){
        cout << "recvmsg: " << msg <<endl;
    }
};

int main(int argc, char **argv){

    Button btn;
    View view;

    btn.touchEvent.connect(&view, &View::onUpdate);
    btn.onClick();
    return 1;
}
