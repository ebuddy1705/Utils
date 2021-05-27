


using namespace System;
using namespace System::Threading;
using namespace ClassLibrary_Csharp;
using namespace System::Net::Sockets;
using namespace System::Net;
using namespace System;
using namespace System::IO;
using namespace System::Net;
using namespace System::Net::Sockets;
using namespace System::Text;
using namespace System::Collections;


using namespace ClassLibraryCLI;

namespace ClassLibraryCLI {
	public ref class Class1
	{
	private :
		static Class1 ^_instance = nullptr;
	public:
		//delegate instance
		static Class1 ^Instance()
		{
			if (_instance == nullptr) {
				_instance = gcnew  Class1();
				Console::WriteLine("Create instance");
			}

			return _instance;
		};

	

		float Add(float a, float b);


		//multi thread
		void StartExecThread();
		void ExecThread();

	};

	public ref class SocketClass
	{

	public:
		SocketClass()
		{

		}

		void createSocketClient() {
			int serverPort = 11111;
			IPAddress^ ipAddr = IPAddress::Parse("127.0.0.1");
			IPEndPoint^ localEndPoint = gcnew IPEndPoint(ipAddr, serverPort);


			//IPHostEntry ^ipHost = Dns::GetHostEntry(Dns::GetHostName());
			//IPAddress ^ipAddr = ipHost->AddressList[0];
			//IPEndPoint ^localEndPoint = gcnew IPEndPoint(ipAddr, 11111);

			Socket ^sender = gcnew Socket(ipAddr->AddressFamily, SocketType::Stream, ProtocolType::Tcp);


			try {
				// Connect Socket to the remote 
				// endpoint using method Connect()
				sender->Connect(localEndPoint);

				// We print EndPoint information 
				// that we are connected
				Console::WriteLine("Socket connected to -> {0} ", sender->RemoteEndPoint->ToString());
				
				// Creation of messagge that
				// we will send to Server
				array<Byte> ^messageSent = Encoding::ASCII->GetBytes("Test Client<EOF>");
				int byteSent = sender->Send(messageSent);

				// Data buffer
				array<Byte> ^ messageReceived = gcnew array< Byte >(1024);

				// We receive the messagge using 
				// the method Receive(). This 
				// method returns number of bytes
				// received, that we'll use to 
				// convert them to string
				int byteRecv = sender->Receive(messageReceived);
				String ^recvmsg = Encoding::ASCII->GetString(messageReceived, 0, byteRecv);

				Console::WriteLine("Message from Server -> {0}", recvmsg);

				// Close Socket using 
				// the method Close()
				sender->Shutdown(SocketShutdown::Both);
				sender->Close();

			}
			catch(Exception ^e){
				Console::WriteLine("Exception !!");
			}
		}


		void createSocketServer() {
			int serverPort = 9999;
			// three possible ways to set the IP address
			// The current IP address of the server computer
			// should be set the same way on the client
			IPAddress^ ipAddress = IPAddress::Parse("127.0.0.1");
			IPEndPoint^ receivePoint = gcnew IPEndPoint(ipAddress, serverPort);

			//Initialize a new instance of the UdpClient class and bind it to the local endpoint.
			UdpClient^ udpClient = gcnew UdpClient(receivePoint);
			//The following IPEndPoint object will allow us to read datagrams sent from any source.
			IPEndPoint^ remoteIpEndPoint = gcnew IPEndPoint(IPAddress::Any, 0);
			while (true)
			{
				Console::WriteLine("Datagram server waiting for packets");
				// Block until a message returns on this socket from a remote host.
				array<Byte>^ receivedBytes = udpClient->Receive(remoteIpEndPoint);
				// receivedData will be input from user example: ( ( 15 / (7 - 
				String^ receivedData = Encoding::ASCII->GetString(receivedBytes);

				Console::WriteLine("Packet received:");
				Console::WriteLine("Length: " + receivedBytes->Length);
				Console::WriteLine("Containing: " + receivedData);

				Console::Write("Echo data back to client...");
				udpClient->Connect(remoteIpEndPoint->Address, remoteIpEndPoint->Port);
				// result 5
				udpClient->Send(receivedBytes, receivedBytes->Length);
				Console::WriteLine("Packet sent.");
			}
		}
	};
}
