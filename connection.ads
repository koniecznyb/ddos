with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Exceptions; use Ada.Exceptions;

package Connection is

	type Connection is tagged
		record
			address: Sock_Addr_Type;
			client: Socket_Type;
			channel: Stream_Access;
		end record;

	procedure write_to_socket (message: in String);
	procedure initiate_connection (botAddress: in String; portNumber: in Port_Type);

end Connection;