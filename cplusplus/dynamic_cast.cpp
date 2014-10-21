#include <iostream>
#include <stdio.h>      /* printf, scanf, puts, NULL */
#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */


using namespace std;

class Base
{
public:
    virtual void DoIt() = 0;    // pure virtual
    virtual ~Base() {};
};

class Foo : public Base
{
public:
    virtual void DoIt() { cout << "Foo \n"; };
    void FooIt() { cout << "Fooing It... \n"; }
};

class Bar : public Base
{
public :
    virtual void DoIt() { cout << "Bar \n"; }
    void BarIt() { cout << "baring It... \n"; }
};

Base* CreateRandom()
{
    if( (rand()%2) == 0 )
        return new Foo;
    else
        return new Bar;
}



//====================main==============================

#define NOMALY 				1
#define DYNAMIC_CAST 		0
#define STATIC_CAST 		0
#define REINTERPRET_CAST	0

#if NOMALY
	int main()
	{
		
		for( int n = 0; n < 10; ++n )
		{
			
			Base* base = CreateRandom();

				base->DoIt();

			Bar* bar = (Bar*)base;
			bar->BarIt();
			
			delete base; base = NULL;  
			printf("--------------NOMALY------------- \n");
		}
	  return 0;
	}

#elif DYNAMIC_CAST

	int main()
	{



		for( int n = 0; n < 10; ++n )
		{
			Base* base = CreateRandom();

			base->DoIt();

			Bar* bar = dynamic_cast<Bar*>(base);
			Foo* foo = dynamic_cast<Foo*>(base);
			if( bar )
				bar->BarIt();
			if( foo )
				foo->FooIt();
			delete base; base = NULL;    
			printf("-------------DYNAMIC_CAST-------------- \n");
		}
	  return 0;

	}
#elif STATIC_CAST

	int main()
	{



		for( int n = 0; n < 10; ++n )
		{
			Base* base = CreateRandom();

			base->DoIt();

			Bar* bar = static_cast<Bar*>(base);
			Foo* foo = static_cast<Foo*>(base);
			if( bar )
				bar->BarIt();
			if( foo )
				foo->FooIt();
			delete base; base = NULL;    
			printf("-------------STATIC_CAST-------------- \n");
		}
	  return 0;

	}
	
#elif REINTERPRET_CAST

	int main()
	{



		for( int n = 0; n < 10; ++n )
		{
			Base* base = CreateRandom();

			base->DoIt();

			Bar* bar = reinterpret_cast<Bar*>(base);
			Foo* foo = reinterpret_cast<Foo*>(base);
			if( bar )
				bar->BarIt();
			if( foo )
				foo->FooIt();
			delete base; base = NULL;    
			printf("-------------REINTERPRET_CAST-------------- \n");
		}
	  return 0;

	}	
	
#endif




/*
 
 Bar 
baring It... 
--------------NOMALY------------- 
Foo 
baring It... 
--------------NOMALY------------- 
Bar 
baring It... 
--------------NOMALY------------- 
Bar 
baring It... 
--------------NOMALY------------- 
Bar 
baring It... 
--------------NOMALY------------- 
Bar 
baring It... 
--------------NOMALY------------- 
Foo 
baring It... 
--------------NOMALY------------- 
Foo 
baring It... 
--------------NOMALY------------- 
Bar 
baring It... 
--------------NOMALY------------- 
Bar 
baring It... 
--------------NOMALY------------- 



Bar 
baring It... 
-------------DYNAMIC_CAST-------------- 
Foo 
Fooing It... 
-------------DYNAMIC_CAST-------------- 
Bar 
baring It... 
-------------DYNAMIC_CAST-------------- 
Bar 
baring It... 
-------------DYNAMIC_CAST-------------- 
Bar 
baring It... 
-------------DYNAMIC_CAST-------------- 
Bar 
baring It... 
-------------DYNAMIC_CAST-------------- 
Foo 
Fooing It... 
-------------DYNAMIC_CAST-------------- 
Foo 
Fooing It... 
-------------DYNAMIC_CAST-------------- 
Bar 
baring It... 
-------------DYNAMIC_CAST-------------- 
Bar 
baring It... 
-------------DYNAMIC_CAST--------------




Bar 
baring It... 
Fooing It... 
-------------STATIC_CAST-------------- 
Foo 
baring It... 
Fooing It... 
-------------STATIC_CAST-------------- 
Bar 
baring It... 
Fooing It... 
-------------STATIC_CAST-------------- 
Bar 
baring It... 
Fooing It... 
-------------STATIC_CAST-------------- 
Bar 
baring It... 
Fooing It... 
-------------STATIC_CAST-------------- 
Bar 
baring It... 
Fooing It... 
-------------STATIC_CAST-------------- 
Foo 
baring It... 
Fooing It... 
-------------STATIC_CAST-------------- 
Foo 
baring It... 
Fooing It... 
-------------STATIC_CAST-------------- 
Bar 
baring It... 
Fooing It... 
-------------STATIC_CAST-------------- 
Bar 
baring It... 
Fooing It... 
-------------STATIC_CAST--------------




Bar 
baring It... 
Fooing It... 
-------------REINTERPRET_CAST-------------- 
Foo 
baring It... 
Fooing It... 
-------------REINTERPRET_CAST-------------- 
Bar 
baring It... 
Fooing It... 
-------------REINTERPRET_CAST-------------- 
Bar 
baring It... 
Fooing It... 
-------------REINTERPRET_CAST-------------- 
Bar 
baring It... 
Fooing It... 
-------------REINTERPRET_CAST-------------- 
Bar 
baring It... 
Fooing It... 
-------------REINTERPRET_CAST-------------- 
Foo 
baring It... 
Fooing It... 
-------------REINTERPRET_CAST-------------- 
Foo 
baring It... 
Fooing It... 
-------------REINTERPRET_CAST-------------- 
Bar 
baring It... 
Fooing It... 
-------------REINTERPRET_CAST-------------- 
Bar 
baring It... 
Fooing It... 
-------------REINTERPRET_CAST-------------- 

*/
