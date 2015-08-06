#include <iostream>
#include <stdio.h>
#include "sigslot.h"


class KeyBoard: :public sigslot::has_slots<>, sigslot::has_signals<KeyBoard>
{
	
	public:
	
	void setNewkey(char key){
		keyCode = key;
		
		char newkey = key;
		sigUpdate.emit(newkey);		
	}
	
	
	
	public __signals:
		sigslot::signal<char> sigUpdate;
	public __slots:
		//virtual void slotUpdate(void * pixels);
		
		
	private:
		char keyCode;		
				
}


class View: :public sigslot::has_slots<>, sigslot::has_signals<View>
{
	
	public:
	
	
	
	
	
	public __signals:
		//sigslot::signal<char> sigUpdate;
	public __slots:
		virtual void slotUpdate(char keyCode);
		
		
	private:
		int var1;		
				
}



int main (void)
{
	
	
	
	
	
		
	
	return 0;	
}
