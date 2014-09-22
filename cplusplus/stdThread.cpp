#include <iostream>       // std::cout
#include <thread>         // std::thread
#include <mutex>          // std::mutex

using namespace std;
using std::mutex;
using std::thread;
using std::system_error;

mutex mtx;           // mutex for critical section

void print_block (int n, char c) {
  // critical section (exclusive access to std::cout signaled by locking mtx):
  mtx.lock();
  for (int i=0; i<n; ++i) { cout << c; }
  cout << '\n';
  mtx.unlock();
}

int main ()
{
  thread th1 (print_block,50,'*');
  //thread th2 (print_block,50,'$');

  th1.join();
  //th2.join();

  return 0;
}
